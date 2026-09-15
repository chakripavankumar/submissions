import csv
from loafly.config import FILE_PATH

def extract_orders(file_path=FILE_PATH):
    rows = []
    with open(file_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append(row)
    return rows