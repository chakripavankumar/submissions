# Functions. Replace the copy-pasted inline price cleaning with a single
# clean_price(text) function, and add an apply_discount(price, percent) function so the 
# discount is no longer a magic number inside the loop. Acceptance criteria: one clean_price is 
# used for every price; apply_discount takes the percent as an argument; both work on the sample values.

import csv

def clean_price(text):
    return float(text.strip().replace(",", ""))

def apply_discount(price,percent):
    return price - price * percent / 100

rows = []

with open("raw_orders.csv",newline="",encoding="utf-8") as f:
    for row in csv.DictReader(f):
        rows.append(row)


orders = {}
for row in rows:
    oid = row["order_id"]
    if oid not in orders:
        orders[oid] = {"customer": row["customer"], "items": []}
    orders[oid]["items"].append((row["item_name"], row["item_price"]))
    
    
for oid, o in orders.items():
    total = 0
    for name, price in o["items"]:
        total = total + clean_price(price)
    
        total = apply_discount(total,10)
        api_key="loafly-prod-key-9f3a21"
        print("saving order", oid, "for", o["customer"], "total", total)
        
