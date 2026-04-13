# Stock Movements

Stock movements provide a complete audit trail of how inventory moves through the system — transfers between locations, purchase receipts, sales, waste, and corrections.

## Understanding Stock Movements

Every change to inventory quantity is recorded as a stock movement. This gives you full traceability of where stock came from, where it went, and why.

### Movement Reasons

| Reason | Description |
|--------|-------------|
| **PURCHASE_RECEIVE** | Stock received from a supplier purchase |
| **SALE** | Stock sold or shipped to a client |
| **WASTE** | Stock disposed of due to waste |
| **DAMAGED** | Stock written off as damaged |
| **EXPIRED** | Stock removed due to expiry |
| **COUNT_CORRECTION** | Adjustment after a stock count or audit |
| **RETURN_FROM_CLIENT** | Stock returned by a client |
| **RETURN_TO_SUPPLIER** | Stock returned to a supplier |
| **INTERNAL_TRANSFER** | Stock moved between locations |

## Viewing Stock Movements

Navigate to **Stock Movements** to see the movement history.

Each movement record includes:

- **Product** - The product that was moved
- **From Location** - Source location (if applicable)
- **To Location** - Destination location (if applicable)
- **Quantity** - Number of units moved
- **Reason** - Why the movement occurred
- **Reference Number** - External reference (e.g., PO number, invoice)
- **User** - Who recorded the movement
- **Date** - When the movement was recorded

### Filtering Movements

Filter stock movements by:

- **Reason** - Show only transfers, sales, waste, etc.
- **Product** - All movements for a specific product
- **Location** - All movements in or out of a location

## Creating a Manual Movement

For movements not triggered automatically (e.g., recording a received shipment):

1. Click **Create Movement**
2. Select the **Product**
3. Set **From Location** and/or **To Location**
4. Enter the **Quantity**
5. Select the **Reason**
6. Optionally add a **Reference Number** and **Notes**
7. Click **Save**

### Movement Fields

| Field | Required | Description |
|-------|----------|-------------|
| Product | Yes | The product being moved |
| From Location | No | Source location (null for incoming stock) |
| To Location | No | Destination location (null for outgoing stock) |
| Quantity | Yes | Number of units |
| Reason | Yes | Movement reason (see table above) |
| Reference Number | No | External reference (PO number, invoice, etc.) |
| Cost Per Unit | No | Unit cost at time of movement |
| Order | No | Associated order (for sales/returns) |
| Notes | No | Additional context |

!!! info "Automatic Movements"
    When you adjust inventory quantity via the **Adjust Quantity** action on an inventory record, a stock movement is automatically created with the reason you specify. You don't need to create a separate movement manually.

## Movement Directions

Stock movements use **from** and **to** locations to represent direction:

| Scenario | From | To |
|----------|------|-----|
| Receive from supplier | — | Warehouse |
| Ship to client | Warehouse | Client |
| Internal transfer | Warehouse A | Warehouse B |
| Write off waste | Warehouse | — |
| Return from client | Client | Warehouse |

!!! tip "One-Sided Movements"
    Not all movements have both a from and to location. Receiving stock only needs a destination. Writing off stock only needs a source.

## Stock Movement Reports

Use the filtering capabilities to generate ad-hoc reports:

- **Waste tracking** — Filter by WASTE + DAMAGED + EXPIRED to review losses
- **Supplier receipts** — Filter by PURCHASE_RECEIVE to see incoming stock
- **Transfer history** — Filter by INTERNAL_TRANSFER to audit location movements
- **Product history** — Filter by product to see its full movement trail

## Best Practices

1. **Always provide a reason** - Enables accurate reporting on stock gains and losses
2. **Use reference numbers** - Link movements to POs, invoices, or delivery notes
3. **Add notes for corrections** - Explain why a count correction was needed
4. **Review waste regularly** - Track patterns in damaged/expired stock to reduce losses
