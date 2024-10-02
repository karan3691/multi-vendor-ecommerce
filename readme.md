# Multi-Vendor E-commerce Platform (Incomplete)

This is an ongoing project aimed at developing a **multi-vendor e-commerce platform**. The platform will allow vendors to sell their products online, with features for users to browse and purchase products.

## Current Features

- **Home Page**: A static landing page with links to the product listings and vendor information.
- **Products Page**: Displays a list of available products fetched from a MySQL database.
- **Vendors Page**: To be implemented.
- **About Us Page**: To be implemented.
- **Product Details**: Basic product information, including name, price, stock, and description.
  
## Incomplete Sections

### 1. Product Images Not Displaying
- Currently, images for products are not displaying on the **Products Page**. This issue is due to problems with referencing local images from the project directory.
- The plan was to store product images locally within the `/static/images/products/` directory and reference them dynamically in the HTML using Flask's `url_for()` function. However, the images still do not appear on the website.

### 2. Vendors and About Pages
- The **Vendors Page** and **About Us Page** are still under development.
- The **Vendors Page** will display a list of all the registered vendors, including vendor profiles, contact details, and products they offer.
- The **About Us Page** will provide details about the platform, its mission, and team members.

## How to Run the Project

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/ecommerce-platform.git
   ```

2. Install required dependencies
   ```bash
   pip install -r requirements.txt
   ```

3. Set up a MySQL database with the provided schema and connect it to the Flask app.

4. Run the Flask app:
   ```bash
   flask run
   ```

5. Access the application at http://127.0.0.1:5000/.


## Future Work

1. Fixing image issues:

- Investigate and resolve the issue with displaying local images for products.
- Ensure that images are correctly referenced and loaded from the /static/images/ directory.

2. Complete Vendor and About Pages:

- Implement vendor profiles and dynamic fetching of vendor-specific products.
- Add team and mission information to the About Us page.

3. Enhancements:

- Add user login and cart functionality.
- Implement a vendor dashboard for adding and managing products.


## Known Issues

- Product images do not display due to an issue with local file paths.
- Products, Vendors and About Us pages are currently placeholders and need full implementation.

## Contributing
This project is in its early stages, and contributions are welcome. Please feel free to submit issues and pull requests.
