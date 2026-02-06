# Audit Logs

The audit log tracks all changes made to the system, providing a complete history for accountability and troubleshooting.

## Viewing Audit Logs

Navigate to **Audit Logs** to see the complete change history.

Each log entry includes:

- **Timestamp** - When the change occurred
- **User** - Who made the change
- **Action** - Type of action (Create, Update, Delete, Restore)
- **Entity Type** - What was changed (Product, Category, etc.)
- **Entity ID** - The specific item changed
- **Changes** - Before/after values

## Filtering Logs

Filter audit logs by:

- **Entity Type** - Products, Categories, Orders, etc.
- **Action** - Create, Update, Delete, Restore
- **User** - Specific user
- **Date Range** - Time period
- **Entity ID** - Specific item

## Understanding Changes

For update actions, the log shows:

```json
{
  "before": {
    "name": "Old Product Name",
    "price": 100
  },
  "after": {
    "name": "New Product Name",
    "price": 150
  }
}
```

## Action Types

| Action | Description |
|--------|-------------|
| CREATE | New item created |
| UPDATE | Existing item modified |
| DELETE | Item soft-deleted |
| RESTORE | Deleted item restored |
| ADJUST_QUANTITY | Inventory quantity changed |
| ADD_PHOTO | Photo added to item |
| STATUS_CHANGE | Status field changed |

## Entity Types

| Entity | Description |
|--------|-------------|
| PRODUCT | Inventory products |
| CATEGORY | Product categories |
| SUPPLIER | Supplier records |
| ORDER | Customer orders |
| ORDER_ITEM | Order line items |
| INVENTORY | Stock quantities |
| LOCATION | Storage locations |
| STOCK_MOVEMENT | Inventory transactions |
| PHOTO | Product images |

## Context Information

Each audit log includes context:

- **IP Address** - Origin of the request
- **User Agent** - Browser/client information
- **User ID** - Authenticated user

## Use Cases

### Troubleshooting

1. Find when a product was last modified
2. See who changed a price
3. Track inventory adjustments

### Compliance

1. Demonstrate change tracking
2. Provide audit trail for auditors
3. Meet regulatory requirements

### Recovery

1. Identify accidental changes
2. Understand what was changed
3. Restore previous values manually if needed
