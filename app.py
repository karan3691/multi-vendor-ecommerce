from flask import Flask, render_template, request, redirect, url_for, session, flash
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
import secrets

app = Flask(__name__)
app.secret_key = 'ad351deaeff2b58a5ff1b61c9dc6d795'  # Necessary for session management

# Database connection function
def get_db_connection():
    connection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="Kirito@213",
        database="multi_vendor_ecommerce"
    )
    return connection


# Home page route
@app.route('/')
def home():
    username = session.get('username')  # Get the username from the session
    if not username:
        return redirect(url_for('login'))  # Redirect to login if not logged in
    return render_template('index.html', username=username)  # Render homepage

# Products page route
@app.route('/products')
def products():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Fetch filter parameters from query string (optional)
    category = request.args.get('category')
    price_min = request.args.get('price_min')
    price_max = request.args.get('price_max')
    vendor = request.args.get('vendor')

    query = "SELECT * FROM Products WHERE 1=1"
    filters = []

    if category:
        query += " AND product_category = %s"
        filters.append(category)
    if price_min:
        query += " AND product_price >= %s"
        filters.append(price_min)
    if price_max:
        query += " AND product_price <= %s"
        filters.append(price_max)
    if vendor:
        query += " AND vendor_id = (SELECT vendor_id FROM Vendors WHERE vendor_name = %s)"
        filters.append(vendor)

    cursor.execute(query, tuple(filters))
    products = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('products.html', products=products)

# Vendors page route
@app.route('/vendors')
def vendors():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT vendor_name, vendor_email, vendor_address, vendor_phone, vendor_image FROM Vendors")
    vendors = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('vendors.html', vendors=vendors)

# About Us page route
@app.route('/about')
def about():
    return render_template('about.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        try:
            # Get form data
            username = request.form['username']
            password = request.form['password']
            confirm_password = request.form['confirm_password']

            # Validate the passwords match
            if password != confirm_password:
                flash('Passwords do not match', 'danger')
                return render_template('register.html')

            # Hash the password
            hashed_password = generate_password_hash(password)

            # Check if the username already exists
            conn = get_db_connection()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM Users WHERE username = %s", (username,))
            existing_user = cursor.fetchone()

            if existing_user:
                flash('Username already exists', 'danger')
                return render_template('register.html')

            # Insert the new user into the database
            cursor.execute("INSERT INTO Users (username, password) VALUES (%s, %s)", (username, hashed_password))
            conn.commit()
            cursor.close()
            conn.close()

            flash('Registration successful! You can now log in.', 'success')
            return redirect(url_for('login'))  # Redirect to login page

        except KeyError as e:
            flash(f'Missing field: {str(e)}', 'danger')
            return render_template('register.html')

    return render_template('register.html')


# Login route
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        # Validate the form input
        if not username or not password:
            flash('Please fill out both fields', 'danger')
            return render_template('login.html')

        try:
            # Check if the user exists in the database
            conn = get_db_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute("SELECT * FROM Users WHERE username = %s", (username,))
            user = cursor.fetchone()

            # If user exists and password is correct
            if user and check_password_hash(user['password'], password):
                # Successful login, store user info in session
                session['user_id'] = user['user_id']
                session['username'] = user['username']
                flash('Login successful', 'success')
                return redirect(url_for('home'))  # Redirect to home page or dashboard
            else:
                flash('Invalid username or password', 'danger')

            cursor.close()
            conn.close()

        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

    return render_template('login.html')


# User logout route
@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('username', None)
    flash('You have been logged out.', 'info')
    return redirect(url_for('login'))


# Add to cart route
@app.route('/add_to_cart/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    if 'user_id' not in session:
        flash('Please log in to add items to your cart.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']
    quantity = request.form.get('quantity', 1)

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute('SELECT * FROM Cart WHERE user_id = %s AND product_id = %s', (user_id, product_id))
    cart_item = cursor.fetchone()

    if cart_item:
        cursor.execute('UPDATE Cart SET quantity = quantity + %s WHERE user_id = %s AND product_id = %s',
                       (quantity, user_id, product_id))
    else:
        cursor.execute('INSERT INTO Cart (user_id, product_id, quantity) VALUES (%s, %s, %s)',
                       (user_id, product_id, quantity))

    conn.commit()
    cursor.close()
    conn.close()

    flash('Item added to cart!', 'success')
    return redirect(url_for('products'))


# View cart route
@app.route('/cart')
def cart():
    if 'user_id' not in session:
        flash('Please log in to view your cart.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('''
        SELECT p.product_name, p.product_price, c.quantity
        FROM Cart c
        JOIN Products p ON c.product_id = p.product_id
        WHERE c.user_id = %s
    ''', (user_id,))
    cart_items = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('cart.html', cart_items=cart_items)


# Remove from cart route
@app.route('/remove_from_cart/<int:product_id>')
def remove_from_cart(product_id):
    if 'user_id' not in session:
        flash('Please log in to remove items from your cart.', 'danger')
        return redirect(url_for('login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('DELETE FROM Cart WHERE user_id = %s AND product_id = %s', (user_id, product_id))
    conn.commit()
    cursor.close()
    conn.close()

    flash('Item removed from cart!', 'info')
    return redirect(url_for('cart'))


if __name__ == '__main__':
    app.run(debug=True)
