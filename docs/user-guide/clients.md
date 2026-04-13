# Managing Clients

Clients represent the customers you provision for — typically yacht owners, management companies, or charter operators.

## Understanding Clients

Each client record stores contact details, billing information, and delivery preferences. Clients are linked to orders, allowing you to track provisioning history per customer.

### Client Statuses

| Status | Description |
|--------|-------------|
| **ACTIVE** | Client is in good standing and can place orders |
| **SUSPENDED** | Client is temporarily suspended (e.g., overdue payments) |
| **INACTIVE** | Client is no longer active |

## Viewing Clients

Navigate to **Clients** from the sidebar to see all client records.

The client list displays:

- **Company Name** - Client organization
- **Yacht Name** - Associated yacht
- **Contact Person** - Primary contact
- **Email** - Contact email address
- **Status** - Account status (Active, Suspended, Inactive)

!!! tip "Filtering Clients"
    Use the search bar to find clients by name, yacht, or email. Filter by status to show only active or suspended clients.

## Creating a Client

1. Click the **Create Client** button
2. Fill in the client details
3. Click **Save**

### Client Fields

| Field | Required | Description |
|-------|----------|-------------|
| Company Name | Yes | Client company or organization name |
| Yacht Name | No | Name of the yacht being provisioned |
| Contact Person | No | Primary point of contact |
| Email | No | Contact email (must be unique) |
| Phone | No | Contact phone number |
| Billing Address | No | Address for invoicing |
| Default Delivery Address | No | Default shipping destination |
| Account Status | No | ACTIVE, SUSPENDED, or INACTIVE (defaults to ACTIVE) |
| Payment Terms | No | Payment terms (e.g., "Net 30") |
| Credit Limit | No | Maximum credit allowed |
| Notes | No | Additional notes about the client |

## Editing Clients

1. Click on a client row to open the edit form
2. Modify the fields as needed
3. Click **Save** to apply changes

!!! warning "Deleting Clients"
    Deleting a client will **fail** if they have associated orders. You must cancel or complete all orders before deleting a client record.

## Linking Clients to Orders

When creating an order, you select a client from the client list. This links the order to the client and auto-populates the delivery address and yacht name from the client record.

See [Order Processing](orders.md) for details on creating orders.

## Best Practices

1. **Keep yacht names updated** - Yachts may change names between seasons
2. **Use status fields** - Suspend clients with payment issues rather than deleting them
3. **Set default delivery addresses** - Saves time when creating repeat orders
4. **Add payment terms** - Helps track credit and billing expectations
