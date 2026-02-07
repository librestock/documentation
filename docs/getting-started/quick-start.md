# Quick Start

This guide will walk you through creating your first products in LibreStock Inventory.

## 1. Sign In

Navigate to http://localhost:3000 and sign in with your Clerk account.

## 2. Seed Sample Data (Optional)

To populate the database with sample data for testing:

```bash
cd modules/api
pnpm seed
```

This creates:

- 10 root categories with 3 subcategories each
- 20 sample suppliers
- 100 sample products

## 3. Create a Category

1. Navigate to **Products** in the sidebar
2. Click on **Manage Categories**
3. Click **Create Category**
4. Enter a name (e.g., "Galley Supplies")
5. Optionally select a parent category
6. Click **Save**

## 4. Create a Product

1. Navigate to **Products**
2. Click **Create Product**
3. Fill in the required fields:
   - **SKU** - Enter manually or scan a barcode
   - **Name** - Product name
   - **Category** - Select from the category tree
   - **Reorder Point** - Minimum stock level
4. Click **Save**

## 5. View Audit Logs

All changes are tracked automatically:

1. Navigate to **Audit Logs**
2. View the history of all changes
3. Filter by entity type, user, or date

## Next Steps

- [Products](../user-guide/products.md) - Learn more about product management
- [Categories](../user-guide/categories.md) - Organize your inventory
- [Configuration](configuration.md) - Customize your setup
