import csv
import logging
from loafly.config import FILE_PATH

logger = logging.getLogger("loafly.extract")

def extract_orders(file_path=FILE_PATH):
    logger.info(f"Extracting raw orders from file: {file_path}")
    rows = []
    try:
        with open(file_path, newline="", encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                rows.append(row)
        logger.info(f"Successfully extracted {len(rows)} raw rows.")
    except FileNotFoundError:
        logger.error(f"The file {file_path} was not found.")
        raise
    return rows