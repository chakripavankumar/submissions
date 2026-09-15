import csv

def extract_orders(file_path):
    rows = []
    with open(file_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Clean spaces from dictionary keys and values
            cleaned_row = {k.strip(): v.strip() for k, v in row.items() if k and v}
            rows.append(cleaned_row)
    return rows

