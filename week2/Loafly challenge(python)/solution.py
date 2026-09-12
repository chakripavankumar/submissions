import csv


class Order:

    def __init__(self, order_id: str, customer: str):
        self.order_id = order_id
        self.customer = customer
        self.items = []

    def add_item(self, item_name: str, item_price: str):
        """Adds an item to the order list."""
        if item_name:  
            self.items.append((item_name, item_price))

    def total(self, discount_percent: float = 10.0) -> float:
        """Calculates subtotal, cleans price strings, and applies discount."""
        subtotal = 0.0
        for name, raw_price in self.items:
            if not raw_price:
                continue

            clean_price = raw_price.strip().replace(",", "")
            try:
                subtotal += float(clean_price)
            except ValueError:
                continue

        discount_amount = subtotal * (discount_percent / 100.0)
        return subtotal - discount_amount


# --- Execution Script ---

orders = {}

with open("raw_orders.csv", newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for row in reader:
        oid = row.get("order_id", "").strip()
        customer = row.get("customer", "").strip()

        # Skip trailing empty CSV rows (like ',,,')
        if not oid:
            continue

        # Instantiate Order if it doesn't exist
        if oid not in orders:
            orders[oid] = Order(order_id=oid, customer=customer)

        # Encapsulate item addition
        orders[oid].add_item(row["item_name"], row["item_price"])

# Process orders by querying each Order object directly
for oid, order in orders.items():
    order_total = order.total()  
    print(
        f"saving order {order.order_id} for {order.customer} | total: ${order_total:.2f}"
    )