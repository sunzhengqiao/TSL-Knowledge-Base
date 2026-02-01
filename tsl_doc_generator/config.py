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

# Ensure output directories exist
OUTPUT_DIR.mkdir(exist_ok=True)
PASS_RESULTS_DIR.mkdir(exist_ok=True)
DOCS_DIR.mkdir(exist_ok=True)

# Processing Configuration
MAX_RETRIES = 3
RETRY_DELAY = 2  # seconds
MAX_TOKENS = 4096
TEMPERATURE = 0.3  # Lower for more consistent output

# Batch Processing
BATCH_SIZE = 10
SAVE_INTERVAL = 1  # Save progress after every script for better resume
CONCURRENT_SCRIPTS = 3  # Number of scripts to process concurrently

# Rate Limiting
REQUEST_DELAY = 2  # Seconds between API calls to avoid rate limits
RATE_LIMIT_WAIT = 300  # 5 minutes wait when rate limited (429 error)
MAX_HOURLY_TOKENS = 500000  # Estimated hourly token limit (adjust based on your plan)

# Checkpoint file for resume functionality
CHECKPOINT_FILE = OUTPUT_DIR / "checkpoint.json"

# Logging
LOG_FILE = OUTPUT_DIR / "processing.log"
