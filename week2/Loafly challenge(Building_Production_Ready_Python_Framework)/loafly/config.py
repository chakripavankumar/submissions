import os
import logging
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler("pipeline.log", encoding="utf-8"),
        logging.StreamHandler()
    ]
)

# Read secrets and settings from environment variables with safe defaults
API_KEY = os.getenv("API_KEY", "default-fallback-key")
FILE_PATH = os.getenv("FILE_PATH", "raw_orders.csv")
DISCOUNT_PERCENT = int(os.getenv("DISCOUNT_PERCENT", "10"))
CURRENCY = os.getenv("CURRENCY", "USD")
RETRY_COUNT = int(os.getenv("RETRY_COUNT", "3"))
RETRY_DELAY = float(os.getenv("RETRY_DELAY", "1.0"))