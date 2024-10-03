from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

app = Flask(__name__)
def get_db_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Kirito@213", 
        database="multi_vendor_ecommerce"
    )
    return connection

@app.route('/')
def index():
    return render_template('index.html')

# Vendors Page
@app.route('/vendors')
def vendors():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT vendor_name, vendor_email, vendor_address, vendor_phone, vendor_image FROM Vendors")
    vendors = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('vendors.html', vendors=vendors)


# About Us Page
@app.route('/about')
def about():
    return render_template('about.html')

# Products Page to Display All Products
@app.route('/products')
def products():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM Products")
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('products.html', products=products)

if __name__ == '__main__':
    app.run(debug=True)
