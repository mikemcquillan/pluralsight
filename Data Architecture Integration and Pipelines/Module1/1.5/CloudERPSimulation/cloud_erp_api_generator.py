import json
import random
from decimal import Decimal
from datetime import datetime, timedelta
from wsgiref.simple_server import make_server


CALLS = [
    "GetSalesOrder",
    "GetPurchaseOrder",
    "GetCustomer",
    "GetSupplier",
]

ACTIONS = [
    "Insert",
    "Update",
    "Delete",
]

USERS = [
    "Bertie",
    "Dolly",
    "Jo",
    "Grace",
]

TITLES_AND_GENDERS = {
    "Mr": "Male",
    "Mrs": "Female",
    "Miss": "Female",
    "Ms": "Female",
    "Sir": "Male",
    "Mx": "Not Specified",
    "They": "Non-Binary"
}

COMPANY_NAMES = [
    "Acme Corporation", 
    "Global Solutions", 
    "Innovative Enterprises",
    "Alpha Industries", 
    "Dynamic Systems", 
    "Precision Solutions",
    "Silverline Corporation", 
    "Prime Manufacturing", 
    "Strategic Consultants",
    "Optimal Solutions", 
    "ProTech Corporation", 
    "NexGen Innovations", 
    "Alpha Omega Solutions"
    "Excel Manufacturing", 
    "Peak Performance", 
    "Swift Industries", 
    "GlobalTech Solutions",
    "Vertex Enterprises", 
    "Pinnacle Manufacturing", 
    "Advanced Systems", 
    "Innovative Solutions",
    "Paragon Consulting", 
    "SilverTech Corporation", 
    "Alpha Manufacturing", 
    "Strategic Solutions",
    "Optimum Systems", 
    "TechPro Corporation", 
    "Innovate IT", 
    "Alpha Beta Solutions", 
    "Excel Tech",
    "Peak Solutions", 
    "Swift Manufacturing", 
    "Global Solutions 2.0", 
    "Vertex Technologies",
    "Pinnacle Innovations", 
    "Advanced Enterprises", 
    "Innovative Systems", 
    "Paragon Solutions",
    "SilverCorp", 
    "AlphaTech", 
    "Strategic Technologies", 
    "Optima Solutions", 
    "TechCorp",
    "Innovation Inc.", 
    "Alpha Gamma Consulting", 
    "Excel Solutions", 
    "Peak Manufacturing",
    "Swift Solutions"
]

CUSTOMER_NAMES = [
    "John Doe",
    "Jane Smith",
    "Michael Johnson",
    "Sarah Williams",
    "David Brown",
    "Jessica Lee",
    "Christopher Taylor",
    "Amy Anderson",
    "Matthew Clark",
    "Emily Hall",
    "Andrew Young",
    "Amanda Martin",
    "Jonathan Ross",
    "Olivia Turner",
    "Nathan Roberts",
    "Lauren Clark",
    "James White",
    "Sophia Morgan",
    "William Anderson",
    "Grace Hughes",
    "Ethan Reed",
    "Abigail Hall",
    "Noah Morris",
    "Chloe Cook",
    "Daniel Evans",
    "Ella Collins",
    "Aiden Murphy",
    "Lily Rogers",
    "Lucas Cooper",
    "Mia Richardson",
    "Alexander Martin",
    "Sofia Anderson",
    "Logan Turner",
    "Ava Taylor",
    "Liam Harris",
    "Charlotte Young",
    "Mason Ross",
    "Amelia Turner",
    "Henry Roberts",
    "Elizabeth Clark",
    "Alexander Smith",
    "Victoria Morgan",
    "Emily Hughes",
    "James Reed",
    "Sophia Hall",
    "Benjamin Morris",
    "Mia Cook",
    "Ethan Evans",
    "Olivia Collins",
    "Liam Murphy",
    "Isabella Rogers",
    "Aiden Cooper",
    "Sophia Richardson",
    "Jacob Martin",
    "Olivia Anderson",
    "Ethan Turner",
    "Logan Harris",
    "Isabella Young",
    "Noah Ross",
    "Sophia Turner",
    "Liam Roberts",
    "Charlotte Clark",
    "Ethan Smith",
    "Olivia Morgan",
    "Isabella Rogers"
]

# Generate 100 random addresses
ADDRESSES = [
    f"{number} Address Street, Address Town {number}, AT{number} {number:02d}AT"
    for number in range(1, 101)
]

def generate_products():
    """
    Generates a collection of products with random prices
    """
    products = set()

    for product_id in range(100, 401):
        product_code = f"BATT{product_id}"
        product_name = f"Battery {product_id}"
        price = Decimal(str(round(random.uniform(2.00, 650.00), 2)))

        products.add((
            product_id,
            product_code,
            product_name,
            price,
        ))

    return products

def get_random_product():
    """Obtains one of the products at random"""
    products = generate_products()
    return random.choice(tuple(products))


def generate_customer_data():
    """Generate random customer data for the JSON output"""
    customer_id = random.randint(812, 7048)

    title, gender = random.choice(list(TITLES_AND_GENDERS.items()))

    return {
        "Id": customer_id,
        "OurRef": f"Cust{customer_id}",
        "Title": title,
        "Gender": gender,
        "CompanyName": random.choice(COMPANY_NAMES),
        "Name": random.choice(CUSTOMER_NAMES),
        "Address": random.choice(ADDRESSES)
    }

def generate_supplier_data():
    """Generate random supplier data for the JSON output"""
    supplier_id = random.randint(397, 15983)

    title, gender = random.choice(list(TITLES_AND_GENDERS.items()))

    return {
        "Id": supplier_id,
        "OurRef": f"Supp{supplier_id}",
        "Title": title,
        "Gender": gender,
        "CompanyName": random.choice(COMPANY_NAMES),
        "Name": random.choice(CUSTOMER_NAMES),
        "Address": random.choice(ADDRESSES)
    }

def generate_sales_order_data():
    """Generate random sales order data for the JSON output"""
    sales_order_id = random.randint(1964, 40691)

    return {
        "SalesOrderId": sales_order_id,
        "OurRef": f"SO{sales_order_id}",
        "CustomerRef": f"Cust{sales_order_id}",
        "OrderDate": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "ConfirmedDate": (datetime.now() + timedelta(days=2)).strftime("%Y-%m-%d %H:%M:%S"),
        "LastUpdatedBy": random.choice(USERS),
        "SalesOrderLines": generate_order_lines()
    }

def generate_purchase_order_data():
    """Generate random purchase order data for the JSON output"""
    purchase_order_id = random.randint(1964, 40691)

    return {
        "PurchaseOrderId": purchase_order_id,
        "OurRef": f"PO{purchase_order_id}",
        "SupplierRef": f"Supp{purchase_order_id}",
        "OrderDate": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "ConfirmedDate": (datetime.now() + timedelta(days=2)).strftime("%Y-%m-%d %H:%M:%S"),
        "LastUpdatedBy": random.choice(USERS),
        "PurchaseOrderLines": generate_order_lines()
    }

def generate_order_lines():
    """Generates order lines for purchase and sales orders"""
    number_of_lines = random.randint(1, 40)
    product_collection = tuple(generate_products())
    order_lines = []

    for line_number in range(1, number_of_lines + 1):
        product_id, product_code, product_name, price = random.choice(
            product_collection
        )

        order_lines.append({
            "LineNumber": line_number,
            "ProductCode": product_code,
            "ProductName": product_name,
            "Quantity": random.randint(1, 793),
            "UnitPrice": float(price),
        })

    return order_lines

def generate_response():
    """Generates the complete JSON output"""
    call = random.choice(CALLS)
    data = ""

    match call:
        case "GetSalesOrder":
            data = generate_sales_order_data()
        case "GetPurchaseOrder":
            data = generate_purchase_order_data()
        case "GetCustomer":
            data = generate_customer_data()
        case "GetSupplier":
            data = generate_supplier_data()

    return {
        "Call": call,
        "DateTime": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "Action": random.choice(ACTIONS),
        "User": random.choice(USERS),
        "Data": data
    }

def app(environ, start_response):
    """Web entry point"""
    response_object = generate_response()
    response_body = json.dumps(response_object, indent=4).encode("utf-8")

    status = "200 OK"
    headers = [
        ("Content-Type", "application/json; charset=utf-8"),
        ("Content-Length", str(len(response_body))),
    ]

    start_response(status, headers)
    return [response_body]

# Program execution starts here, will run locally if not deployed
if __name__ == "__main__":
    with make_server("", 8000, app) as server:
        print("Serving on http://localhost:8000")
        server.serve_forever()
