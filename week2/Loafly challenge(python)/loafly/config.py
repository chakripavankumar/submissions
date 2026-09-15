import logging


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
    handlers=[
        logging.FileHandler("pipleline.log",encoding="utf-8"),
        logging.StreamHandler()
    ]
)

API_KEY = "loafly-prod-key-9f3a21"
FILE_PATH = "raw_orders.csv"
DISCOUNT_PERCENT = 10
CURRENCY = "USD"
RETRY_COUNT = 3