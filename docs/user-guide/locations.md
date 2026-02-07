# Managing Locations

Locations represent physical places where inventory is stored. This includes warehouses, supplier facilities, client yachts, and items in transit.

## Understanding Locations

Locations are categorized by type:

| Type | Description | Use Case |
|------|-------------|----------|
| **WAREHOUSE** | Your storage facilities | Main inventory storage |
| **SUPPLIER** | Vendor storage locations | Track supplier stock |
| **CLIENT** | Yacht or client premises | Items delivered to clients |
| **IN_TRANSIT** | Items being transported | Track shipments |

## Viewing Locations

Navigate to the **Locations** section from the sidebar to see all locations.

The location list displays:

- **Name** - Location identifier
- **Type** - Category of location
- **Address** - Physical address
- **Contact** - Primary contact person
- **Status** - Active or inactive

!!! tip "Filtering Locations"
    Use the type filter to show only warehouses, suppliers, or other location types.

## Creating a Location

1. Click the **Create Location** button
2. Fill in the required fields:
   - **Name** - Location name (e.g., "Miami Warehouse")
   - **Type** - Select location type
   - **Address** - Physical address (optional)

### Location Fields

| Field | Required | Description |
|-------|----------|-------------|
| Name | Yes | Location display name |
| Type | Yes | WAREHOUSE, SUPPLIER, CLIENT, or IN_TRANSIT |
| Address | No | Physical address |
| Contact Person | No | Primary contact name |
| Phone | No | Contact phone number |
| Is Active | Yes | Location availability |

## Editing Locations

1. Click on a location row to open the edit form
2. Modify the fields as needed
3. Click **Save** to apply changes

!!! warning "Deleting Locations"
    Deleting a location will also delete all areas within it (cascade delete). Inventory records will have their location reference cleared.

## Location Hierarchy

Locations can contain **Areas** for more granular placement tracking:

```
Miami Warehouse (Location)
├── Zone A (Area)
│   ├── Shelf A1 (Area)
│   └── Shelf A2 (Area)
├── Zone B (Area)
└── Cold Storage (Area)
```

See [Managing Areas](areas.md) for details on creating areas within locations.

## Best Practices

1. **Use descriptive names** - Include city or purpose (e.g., "Monaco Supplier - Linens")
2. **Keep contact info updated** - Helps with quick reordering
3. **Create areas for large locations** - Track exact placement within warehouses
4. **Use IN_TRANSIT for shipments** - Track items moving between locations
