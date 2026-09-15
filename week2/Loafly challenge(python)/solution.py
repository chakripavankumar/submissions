import csv

def clean_price(text):
    return float(text.strip().replace(",", ""))

def apply_discount(price, percent):
    return price - price * percent / 100
class Order:
    def __init__(self,order_id,customer):
        self.order_id = order_id
        self.customer = customer
        self.items = []
    
    def add_item(self,name,price):
        cleaned_price = clean_price(price)
        self.items.append((name,clean_price))
    
    def total(self,discount_percent=10):
        subtotal=sum(price for name, price in self.items)    
        return apply_discount(subtotal,discount_percent)
rows = []
with open("raw_orders.csv", newline="", encoding="utf-8") as f:
     for row in csv.DictReader(f):
        rows.append(row)
        
orders = {}
for row in rows:
      oid = row["order_id"]
      if oid not in orders:
       orders[oid] = Order(oid, row["customer"])
       orders[oid].add_item(row["item_name"], row["item_price"])


for oid, order_obj in orders.items():
    order_total = order_obj.total(10)  
    api_key = "loafly-prod-key-9f3a21"   
    print("saving order", order_obj.order_id, "for", order_obj.customer, "total", order_total)
            