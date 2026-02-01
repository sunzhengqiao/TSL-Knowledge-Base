#!/usr/bin/env python3
"""
TSL Documentation Generator - Main Entry Point

Usage:
    python main.py                    # Process all scripts
    python main.py --test             # Test with 3 scripts
    python main.py --count 10         # Process first 10 scripts
    python main.py --file GA.mcr      # Process specific file
    python main.py --resume           # Resume from last checkpoint
    python main.py --retry            # Retry failed scripts
    python main.py --status           # Show processing status
    python main.py --category Hardware  # Process by category
    python main.py --concurrent 3     # Process 3 scripts concurrently (default)
"""
import argparse
import json
import sys
import os
from pathlib import Path

# Fix Windows console encoding
if sys.platform == 'win32':
    os.environ['PYTHONIOENCODING'] = 'utf-8'
    try:
        sys.stdout.reconfigure(encoding='utf-8', errors='replace')
        sys.stderr.reconfigure(encoding='utf-8', errors='replace')
    except:
        pass

# Add current directory to path for imports
sys.path.insert(0, str(Path(__file__).parent))

from config import TSL_DIR, OUTPUT_DIR, PASS_RESULTS_DIR, DOCS_DIR, CHECKPOINT_FILE, CONCURRENT_SCRIPTS
from processor import TSLProcessor


def load_script_classification() -> dict:
    """Load script classification if available"""
    class_file = Path(__file__).parent.parent / "script_classification.json"
    if class_file.exists():
        with open(class_file, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}


def get_scripts_by_category(category: str, classification: dict) -> list:
    """Get scripts belonging to a specific category"""
    scripts = []
    categories = classification.get("categories", {})

    if category in categories:
        files = categories[category].get("files", [])
        for f in files:
            script_path = TSL_DIR / f
            if script_path.exists():
                scripts.append(script_path)

    return scripts


def get_processed_scripts() -> set:
    """Get set of already processed script names"""
    processed = set()
    for json_file in PASS_RESULTS_DIR.glob("*_passes.json"):
        # Extract original filename from passes json
        with open(json_file, "r", encoding="utf-8") as f:
            data = json.load(f)
            if data.get("status") == "completed":
                processed.add(data.get("filename", ""))
    return processed


def show_status():
    """Show current processing status"""
    print("\n" + "=" * 50)
    print("TSL Documentation Generator - Status")
    print("=" * 50)

    # Load checkpoint
    if CHECKPOINT_FILE.exists():
        with open(CHECKPOINT_FILE, "r", encoding="utf-8") as f:
            checkpoint = json.load(f)

        completed = len(checkpoint.get("completed_scripts", []))
        failed = len(checkpoint.get("failed_scripts", []))
        total_tokens = checkpoint.get("total_tokens_used", 0)
        last_update = checkpoint.get("last_update", "Never")

        print(f"\nCheckpoint: {CHECKPOINT_FILE}")
        print(f"Last update: {last_update}")
        print(f"\nCompleted scripts: {completed}")
        print(f"Failed scripts: {failed}")
        print(f"Total tokens used: {total_tokens:,}")

        if checkpoint.get("failed_scripts"):
            print(f"\nFailed scripts:")
            for script in checkpoint["failed_scripts"][:10]:
                print(f"  - {script}")
            if len(checkpoint["failed_scripts"]) > 10:
                print(f"  ... and {len(checkpoint['failed_scripts']) - 10} more")
    else:
        print("\nNo checkpoint found. Processing has not started.")

    # Count total scripts
    total_scripts = len(list(TSL_DIR.glob("*.mcr")))
    print(f"\nTotal TSL scripts: {total_scripts}")

    # Count generated docs
    generated_docs = len(list(DOCS_DIR.glob("*.md")))
    print(f"Generated docs: {generated_docs}")

    print("=" * 50 + "\n")


def main():
    parser = argparse.ArgumentParser(
        description="TSL Documentation Generator using GLM-4.7"
    )
    parser.add_argument(
        "--test", action="store_true",
        help="Test mode - process only 3 scripts"
    )
    parser.add_argument(
        "--count", type=int, default=0,
        help="Number of scripts to process (0 = all)"
    )
    parser.add_argument(
        "--file", type=str,
        help="Process specific file by name"
    )
    parser.add_argument(
        "--category", type=str,
        help="Process scripts in specific category"
    )
    parser.add_argument(
        "--resume", action="store_true",
        help="Resume processing, skip already completed scripts"
    )
    parser.add_argument(
        "--list-categories", action="store_true",
        help="List available categories and exit"
    )
    parser.add_argument(
        "--retry", action="store_true",
        help="Retry processing failed scripts"
    )
    parser.add_argument(
        "--status", action="store_true",
        help="Show current processing status"
    )
    parser.add_argument(
        "--clear-checkpoint", action="store_true",
        help="Clear checkpoint and start fresh"
    )
    parser.add_argument(
        "--yes", "-y", action="store_true",
        help="Skip confirmation prompt (auto-confirm)"
    )
    parser.add_argument(
        "--concurrent", type=int, default=CONCURRENT_SCRIPTS,
        help=f"Number of scripts to process concurrently (default: {CONCURRENT_SCRIPTS})"
    )

    args = parser.parse_args()

    # Load classification
    classification = load_script_classification()

    # Show status and exit
    if args.status:
        show_status()
        return

    # List categories and exit
    if args.list_categories:
        print("\nAvailable categories:")
        for cat, data in classification.get("categories", {}).items():
            print(f"  {cat}: {data.get('count', 0)} scripts")
        return

    # Clear checkpoint
    if args.clear_checkpoint:
        if CHECKPOINT_FILE.exists():
            CHECKPOINT_FILE.unlink()
            print("Checkpoint cleared.")
        else:
            print("No checkpoint to clear.")
        return

    # Determine which scripts to process
    if args.file:
        # Single file mode
        script_path = TSL_DIR / args.file
        if not script_path.exists():
            print(f"Error: File not found: {script_path}")
            return
        scripts = [script_path]
    elif args.category:
        # Category mode
        scripts = get_scripts_by_category(args.category, classification)
        if not scripts:
            print(f"Error: No scripts found in category '{args.category}'")
            return
        print(f"Found {len(scripts)} scripts in category '{args.category}'")
    else:
        # All scripts mode
        scripts = sorted(TSL_DIR.glob("*.mcr"))

    # Apply count limit
    if args.test:
        scripts = scripts[:3]
        print("Test mode: processing 3 scripts")
    elif args.count > 0:
        scripts = scripts[:args.count]
        print(f"Processing {args.count} scripts")

    # Resume mode - skip completed
    if args.resume:
        processed = get_processed_scripts()
        scripts = [s for s in scripts if s.name not in processed]
        print(f"Resume mode: {len(processed)} already processed, {len(scripts)} remaining")

    if not scripts:
        print("No scripts to process")
        return

    # Print summary
    print(f"\n{'='*50}")
    print(f"TSL Documentation Generator")
    print(f"{'='*50}")
    print(f"Model: GLM-4.7")
    print(f"Concurrent scripts: {args.concurrent}")
    print(f"Scripts to process: {len(scripts)}")
    print(f"Output directory: {OUTPUT_DIR}")
    print(f"{'='*50}\n")

    # Confirm before processing many scripts
    if len(scripts) > 10 and not args.test and not args.yes:
        confirm = input(f"Process {len(scripts)} scripts? (y/n): ")
        if confirm.lower() != 'y':
            print("Cancelled")
            return

    # Process
    processor = TSLProcessor(concurrent_scripts=args.concurrent)
    try:
        if args.retry:
            # Retry failed scripts
            all_scripts = sorted(TSL_DIR.glob("*.mcr"))
            processor.retry_failed(all_scripts)
        else:
            processor.process_batch(scripts)
    except KeyboardInterrupt:
        print("\nInterrupted by user")
    finally:
        processor.close()

    # Print final summary
    print(f"\n{'='*50}")
    print("Processing Complete!")
    print(f"Results saved to: {PASS_RESULTS_DIR}")
    print(f"Documentation saved to: {DOCS_DIR}")
    print(f"{'='*50}")


if __name__ == "__main__":
    main()
