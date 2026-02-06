"""
Configuration for TSL Documentation Generator
"""
import os
from pathlib import Path

# API Configuration
GLM_API_KEY = "6f053aa60b574090973b0ef5490d0d48.esrgVEOkEE05N9Kg"
GLM_API_URL = "https://open.bigmodel.cn/api/paas/v4/chat/completions"
GLM_CODING_URL = "https://open.bigmodel.cn/api/coding/paas/v4/chat/completions"  # For Coding Plan
GLM_MODEL = "glm-4.7"
USE_CODING_ENDPOINT = True  # Using Coding Plan endpoint

# Paths
BASE_DIR = Path(__file__).parent.parent
TSL_DIR = BASE_DIR / "TSL"
SETTINGS_DIR = TSL_DIR / "Settings"
OUTPUT_DIR = BASE_DIR / "output"
PASS_RESULTS_DIR = OUTPUT_DIR / "pass_results"
DOCS_DIR = OUTPUT_DIR / "docs"

# Optional per-process overrides (useful for parallel agents)
_checkpoint_env = os.getenv("TSL_CHECKPOINT_FILE")
_log_env = os.getenv("TSL_LOG_FILE")

# Ensure output directories exist
OUTPUT_DIR.mkdir(exist_ok=True)
PASS_RESULTS_DIR.mkdir(exist_ok=True)
DOCS_DIR.mkdir(exist_ok=True)

# Processing Configuration
MAX_RETRIES = 3
RETRY_DELAY = 2  # seconds

# GLM-4.7 Limits: 200K context, 128K max output
# Conservative settings for reliable processing
MAX_OUTPUT_TOKENS = 8192         # Output tokens per pass (GLM-4.7 supports up to 128K)
MAX_OUTPUT_TOKENS_FINAL = 16384  # Higher for final documentation pass (Pass 6)
TEMPERATURE = 0.3                # Lower for more consistent output

# Code Processing Limits
# GLM-4.7 has 200K token context (~600K chars for code)
# After compression, we can safely handle ~100K chars per chunk
MAX_CODE_CHARS = 100000          # Max chars after compression (was 15,000)
MAX_CODE_CHARS_UNCOMPRESSED = 200000  # Max before compression triggers
CHUNK_THRESHOLD = 120000         # Files larger than this get chunked by #region

# Compression Settings
ENABLE_COMPRESSION = True        # Enable TSL code compression
COMPRESSION_AGGRESSIVE = True    # Remove dead code, collapse patterns

# Batch Processing
BATCH_SIZE = 10
SAVE_INTERVAL = 1  # Save progress after every script for better resume
CONCURRENT_SCRIPTS = 3  # Number of scripts to process concurrently

# Rate Limiting
REQUEST_DELAY = 2  # Seconds between API calls to avoid rate limits
RATE_LIMIT_WAIT = 300  # 5 minutes wait when rate limited (429 error)
MAX_HOURLY_TOKENS = 500000  # Estimated hourly token limit (adjust based on your plan)

# Checkpoint file for resume functionality
CHECKPOINT_FILE = Path(_checkpoint_env) if _checkpoint_env else OUTPUT_DIR / "checkpoint.json"

# Logging
LOG_FILE = Path(_log_env) if _log_env else OUTPUT_DIR / "processing.log"
