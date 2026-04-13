# Managing Suppliers

Suppliers are the vendors who provide products for your inventory. Each supplier record stores contact information and can be linked to specific products with pricing and lead time details.

## Viewing Suppliers

Navigate to **Suppliers** from the sidebar to see all supplier records.

The supplier list displays:

- **Name** - Supplier company name
- **Contact Person** - Primary contact
- **Email** - Contact email
- **Phone** - Contact phone number
- **Status** - Active or inactive

!!! tip "Searching Suppliers"
    Use the search bar to find suppliers by name, contact person, or email.

## Creating a Supplier

1. Click the **Create Supplier** button
2. Fill in the supplier details
3. Click **Save**

### Supplier Fields

| Field | Required | Description |
|-------|----------|-------------|
| Name | Yes | Supplier company name |
| Contact Person | No | Primary point of contact |
| Email | No | Contact email address |
| Phone | No | Contact phone number |
| Address | No | Physical address |
| Website | No | Supplier website URL |
| Notes | No | Additional notes (e.g., speciality, payment terms) |
| Is Active | No | Whether the supplier is currently active (defaults to true) |

## Editing Suppliers

1. Click on a supplier row to open the edit form
2. Modify the fields as needed
3. Click **Save** to apply changes

!!! warning "Deleting Suppliers"
    Deleting a supplier will **fail** if products reference it as their primary supplier. Reassign or remove the supplier link from all products before deleting.

## Supplier-Product Linking

Products can be linked to one or more suppliers via the **supplier products** relationship. This tracks supplier-specific details for each product:

| Field | Description |
|-------|-------------|
| Supplier SKU | The supplier's own SKU for the product |
| Cost Per Unit | Purchase price from this supplier |
| Lead Time (Days) | Expected delivery time |
| Minimum Order Quantity | Minimum units per order |
| Is Preferred | Whether this is the preferred supplier for the product |

### Primary Supplier

Each product can designate one **primary supplier** — used as the default for reordering. This is set on the product record itself, not on the supplier-product link.

## Best Practices

1. **Keep contact info current** - Enables quick reordering during urgent provisions
2. **Track lead times** - Critical for planning yacht provisioning with tight deadlines
3. **Use the preferred flag** - Marks the go-to supplier when multiple options exist
4. **Set minimum order quantities** - Prevents under-ordering and rejected purchase orders
5. **Deactivate rather than delete** - Keep historical supplier data for audit purposes
