# Managing Categories

Categories help organize your products into a hierarchical structure for easy navigation and filtering.

## Category Hierarchy

Categories can be nested to create a tree structure:

```
Galley Supplies
├── Food & Beverages
│   ├── Fresh Produce
│   └── Dry Goods
├── Cookware
└── Utensils

Engine Room
├── Spare Parts
├── Lubricants
└── Tools
```

## Viewing Categories

The category tree is displayed in the sidebar when viewing products. Click on a category to:

- View products in that category
- See products in all subcategories
- Expand/collapse child categories

## Creating a Category

1. Navigate to **Categories** or click **Manage Categories**
2. Click **Create Category**
3. Fill in the fields:
   - **Name** - Category name (required)
   - **Description** - Optional description
   - **Parent Category** - Select to create a subcategory
4. Click **Save**

!!! tip "Category Names"
    Use clear, descriptive names. Category names must be unique within the same parent level.

## Editing Categories

1. Click the edit button on a category
2. Modify the name, description, or parent
3. Click **Save**

!!! warning "Changing Parents"
    Moving a category to a new parent will also move all its subcategories. The system prevents circular references (a category cannot be its own ancestor).

## Deleting Categories

When you delete a category:

- Products in that category are **not** deleted
- Products are moved to the parent category (or become uncategorized)
- Subcategories become children of the parent

!!! danger "Category Deletion"
    Deleting a category cannot be undone. Consider moving products first if needed.

## Best Practices

### Organizing Categories

1. **Keep it shallow** - Aim for 2-3 levels of nesting
2. **Be consistent** - Use similar naming patterns
3. **Plan ahead** - Consider future growth

### Example Structure

For a yacht provisioning inventory:

- **Galley** - Kitchen and dining supplies
- **Housekeeping** - Linens, cleaning supplies
- **Safety** - Safety equipment, first aid
- **Engine Room** - Technical supplies
- **Guest Amenities** - Toiletries, luxury items
- **Deck** - Outdoor equipment
