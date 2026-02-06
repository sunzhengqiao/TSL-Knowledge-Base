# Repository Guidelines

## Project Structure & Module Organization
- `TSL/` holds the Timber Script Language (`.mcr`) source files used by hsbCAD.
- `TSL/Settings/` contains XML configuration and hardware catalogs.
- `TSL/Trusses/` contains truss-focused scripts.
- `tsl_doc_generator/` is the Python tool that generates documentation from `.mcr` files.
- `output/docs/` contains generated Markdown docs; treat as build output unless explicitly editing.
- `output/pass_results/` and `output/checkpoint.json` store generation state.

## Build, Test, and Development Commands
- `python tsl_doc_generator/main.py --status` shows how many scripts are documented and failed.
- `python tsl_doc_generator/main.py --test` generates docs for a small sample (3 scripts).
- `python tsl_doc_generator/main.py --count 10` processes the first N scripts.
- `python tsl_doc_generator/main.py --file GA.mcr` targets a single script by filename.
- `python tsl_doc_generator/main.py --resume` continues from `output/checkpoint.json`.
- `powershell -File .\monitor_progress.ps1` prints a progress summary and recent agent output.
- `pip install -r tsl_doc_generator/requirements.txt` installs Python dependencies (requests only).

## Coding Style & Naming Conventions
- TSL scripts use a C-like syntax and structured headers; preserve existing header blocks and formatting.
- Python files follow conventional 4-space indentation; no formatter or linter is configured, so match surrounding style.
- Script filenames are descriptive and often prefixed (for example, `hsb*`, `HSB_*`, `FLR_*`, `GE_*`). Keep the prefix pattern when adding new scripts.

## Testing Guidelines
- No automated test framework is present. Use generator dry-runs (`--test`, `--file`) and `--status` to validate changes.

## Commit & Pull Request Guidelines
- The Git history is minimal and uses concise, present-tense subjects with optional type prefixes (for example, `docs: Generate TSL documentation ...`). Follow this style.
- PRs should describe what changed, note whether output was regenerated, and include examples of updated docs when relevant.

## Security & Configuration Tips
- API settings live in `tsl_doc_generator/config.py`. Treat API keys as secrets; avoid committing real credentials and rotate if exposed.
