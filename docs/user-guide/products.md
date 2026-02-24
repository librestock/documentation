# Managing Products

Products are the core of the LibreStock Inventory system. Each product represents an item in your yacht provisioning inventory.

## Viewing Products

Navigate to the **Products** section from the sidebar to see all products.

<!-- ![Product List](../assets/screenshots/products/product-list.png) -->

The product list displays:

- **SKU** - Unique product identifier
- **Name** - Product name
- **Category** - Product category
- **Price** - Standard selling price
- **Status** - Active or inactive

!!! tip "Filtering Products"
    Use the category sidebar to filter products by category. Click on a category to show only products in that category and its subcategories.

## Creating a Product

1. Click the **Create Product** button
2. Fill in the required fields:
   - **SKU** - Unique identifier (can be scanned via QR code)
   - **Name** - Product name
   - **Category** - Select from the category tree

<!-- ![Product Form](../assets/screenshots/products/product-form.png) -->

### Product Fields

| Field | Required | Description |
|-------|----------|-------------|
| SKU | Yes | Unique stock keeping unit (max 50 chars) |
| Name | Yes | Product display name (max 200 chars) |
| Category | Yes | Product category |
| Description | No | Detailed description |
| Volume (ml) | No | Volume in milliliters |
| Weight (kg) | No | Weight in kilograms |
| Dimensions (cm) | No | Dimensions, e.g., "10x10x5" |
| Standard Cost | No | Purchase cost |
| Standard Price | No | Selling price |
| Markup Percentage | No | Markup percentage |
| Reorder Point | No | Low stock threshold (defaults to 0) |
| Primary Supplier | No | Link to a supplier record |
| Supplier SKU | No | SKU used by the supplier |
| Barcode | No | Barcode value, e.g., "0641628607549" |
| Unit | No | Unit of measure, e.g., "units" |
| Is Active | No | Product availability (defaults to true) |
| Is Perishable | No | Expiration tracking (defaults to false) |
| Notes | No | Additional notes |

### Using the QR Scanner

Click the QR code icon next to the SKU field to scan a barcode:

<!-- ![QR Scanner](../assets/screenshots/products/qr-scanner.png) -->

1. Allow camera access when prompted
2. Point camera at the barcode
3. SKU will be automatically filled

## Editing Products

1. Click on a product row to open the edit form
2. Modify the fields as needed
3. Click **Save** to apply changes

!!! warning "SKU Changes"
    Changing a product's SKU may affect existing orders and inventory records. Use caution when modifying SKUs.

## Bulk Operations

Select multiple products using the checkboxes to perform bulk actions:

- **Bulk Status Update** - Activate or deactivate multiple products
- **Bulk Delete** - Soft delete multiple products
- **Bulk Restore** - Restore deleted products

### Performing Bulk Actions

1. Select products using checkboxes
2. Click the action button in the toolbar
3. Confirm the action
4. View results summary

### Bulk CSV Import

You can import multiple products at once using a CSV file:

1. Click the **Import** button in the toolbar
2. Download the CSV template to see the expected format
3. Fill in the product data in the CSV file
4. Upload the completed CSV file
5. Review the import preview and confirm

!!! tip "CSV Import Tips"
    - Ensure SKUs are unique and not already in the system
    - Category names must match existing categories exactly
    - Leave optional fields empty if not applicable

## Soft Delete and Restore

Products are soft-deleted by default, meaning they can be restored:

1. Delete a product using the delete button
2. View deleted products by toggling the filter
3. Click **Restore** to bring back a deleted product

!!! info "Hard Delete"
    Permanently deleting a product removes it from the database entirely. This action cannot be undone.

## Product Images

Upload images to help identify products:

1. Click the image upload area
2. Select an image file
3. The image will be uploaded and displayed

Supported formats: PNG, JPG, WebP
