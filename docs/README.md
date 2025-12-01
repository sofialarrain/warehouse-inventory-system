# Warehouse Inventory System - Documentation

## Assumptions and Design Decisions

This section documents the assumptions and technical decisions made during system development, especially those related to model structure and business rules.

### Stock Model

- **Stock Uniqueness per Product-Warehouse**: A product can only have one stock record per warehouse. The combination `warehouse_id + product_id` must be unique. This prevents duplicates and ensures that each product in a warehouse has a single inventory record.

- **Stock cannot be negative**: The quantity (`quantity`) must always be greater than or equal to 0, validated at the model level.

### Warehouse Model

- **Optional Manager**: A warehouse can exist without having a manager (`manager`) assigned initially. The `belongs_to :manager` relationship is `optional: true`, allowing `manager_id` to be `null`.

- **1:N Relationship with Manager**: A warehouse has a single manager, but a manager can manage multiple warehouses.

- **N:N Relationship with Workers**: A warehouse can have multiple warehouse workers assigned, and a warehouse worker can work in multiple warehouses, through the intermediate table `warehouse_assignments`.

### Product Model

- **Global Products**: Products do not belong to a specific user or a specific warehouse. They are global entities of the system that can be present in multiple warehouses through `stocks`.

- **Unique SKU**: The SKU code (`sku`) must be unique across the entire system to uniquely identify each product.

### InventoryMovement Model

- **Conditional validations based on movement type**:
  - **Entry**: Only requires `destination_warehouse_id`. Does not require `source_warehouse_id` since the product comes from outside.
  - **Exit**: Only requires `source_warehouse_id`. Does not require `destination_warehouse_id` since the product leaves the system.
  - **Transfer**: Requires both `source_warehouse_id` and `destination_warehouse_id` since the product moves between warehouses.

- **Quantity always positive**: The quantity (`quantity`) must always be greater than 0 (cannot be 0).

- **Mandatory user record**: All movements must be associated with a user who performs them.

### User Model

- **System roles**:
  - `warehouse_worker` (warehouse worker): Operates in assigned warehouses (N:N relationship with warehouses).
  - `manager` (manager): Manages N assigned warehouses. A warehouse has only 1 manager (1:N relationship).
  - `plant_manager` (plant manager): Full system access, can create/edit/delete warehouses and manage assignments.

### WarehouseAssignment Model

- **Assignment uniqueness**: The combination `user_id + warehouse_id` must be unique.

### Additional Business Rules

- **Stock cannot be negative**: Implemented at the model level and must be validated before registering exits or transfers.

- **Permissions by role**: 
  - Only `plant_manager` can create/edit/delete warehouses and manage manager/warehouse worker assignments.
  - Users can only make movements in warehouses to which they have assignment (except `plant_manager` who has full access).

- **Transfers without approval**: Transfers between warehouses do not require approval, they are executed directly.

---

## Technical Decisions

### API Structure
- **Namespace `/api`**: All resource endpoints are under this namespace to clearly separate the API from the rest of the application.
- **Standard response format**: All responses follow the format `{ message, data }` for success or `{ message, errors }` for errors, ensuring consistency across the entire API.
- **Appropriate HTTP codes**: 200 (success), 201 (created), 422 (validation error), 401 (unauthorized), 403 (forbidden).

### Validations
- **Stock validation**: Implemented at the model level (`quantity >= 0`) and controller (verification before exits/transfers).
- **Warehouse authorization**: Validated through the `check_warehouse_access` method in `InventoryMovementsController`, verifying permissions according to user role.

---

## Endpoints Documentation

### Authentication

#### POST /signup
Register new users.

**Parameters:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "full_name": "Full Name",
    "role": "warehouse_worker"
  }
}
```

**Success response (200):**
```json
{
  "message": "Signed up successfully.",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "full_name": "Full Name",
    "role": "warehouse_worker"
  }
}
```

#### POST /login
Login. Returns JWT token in `Authorization` header.

**Parameters:**
```json
{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```

**Success response (200):**
```json
{
  "message": "Logged in successfully.",
  "data": {
    "id": 1,
    "email": "user@example.com",
    "full_name": "Full Name",
    "role": "warehouse_worker"
  }
}
```

**Response header:**
```
Authorization: Bearer <jwt_token>
```

#### DELETE /logout
Logout (revokes JWT token).

**Required headers:**
```
Authorization: Bearer <jwt_token>
```

---

### Warehouses

**All endpoints require authentication.**

#### GET /api/warehouses
List all warehouses (paginated, 10 per page).

**Query params:** `?page=1`

#### GET /api/warehouses/:id
Get a specific warehouse.

#### POST /api/warehouses
Create a new warehouse. **Only `plant_manager`.**

**Parameters:**
```json
{
  "warehouse": {
    "name": "North Warehouse",
    "location": "North Industrial Zone"
  }
}
```

#### PUT /api/warehouses/:id
Update a warehouse. **Only `plant_manager`.**

#### DELETE /api/warehouses/:id
Delete a warehouse. **Only `plant_manager`.**

#### POST /api/warehouses/assign_manager/:id
Assign a manager to a warehouse. **Only `plant_manager`.**

**Parameters:**
```json
{
  "manager_id": 2
}
```

#### POST /api/warehouses/unassign_manager/:id
Unassign a manager from a warehouse. **Only `plant_manager`.**

**Parameters:**
```json
{
  "manager_id": 2
}
```

#### POST /api/warehouses/assign_worker/:id
Assign a warehouse worker to a warehouse. **Only `plant_manager`.**

**Parameters:**
```json
{
  "worker_id": 3
}
```

#### POST /api/warehouses/unassign_worker/:id
Unassign a warehouse worker from a warehouse. **Only `plant_manager`.**

**Parameters:**
```json
{
  "worker_id": 3
}
```

---

### Products

**All endpoints require authentication.**

#### GET /api/products
List all products (paginated, 10 per page).

#### GET /api/products/:id
Get a specific product.

#### POST /api/products
Create a new product.

**Parameters:**
```json
{
  "product": {
    "name": "Product 1",
    "description": "Product description",
    "sku": "SKU001"
  }
}
```

#### PUT /api/products/:id
Update a product.

#### DELETE /api/products/:id
Delete a product.

---

### Stock

**All endpoints require authentication.**

#### GET /api/stocks
List all stock (paginated, 10 per page).

#### GET /api/stocks/:id
Get a specific stock record.

#### GET /api/stocks/by_warehouse/:warehouse_id
List stock for a specific warehouse (paginated).

#### GET /api/stocks/by_product/:product_id
List stock for a product across all warehouses (paginated).

---

### Inventory Movements

**All endpoints require authentication and access to the involved warehouse.**

#### GET /api/inventory_movements
List all movements (paginated, 10 per page).

#### GET /api/inventory_movements/:id
Get a specific movement.

#### POST /api/inventory/entry
Register a product entry to a warehouse.

**Parameters:**
```json
{
  "warehouse_id": 1,
  "product_id": 1,
  "quantity": 50
}
```

**Success response (200):**
```json
{
  "message": "Success",
  "data": {
    "id": 1,
    "product_id": 1,
    "quantity": 50,
    "movement_type": "entry",
    "destination_warehouse_id": 1,
    "user_id": 1,
    "created_at": "2025-11-28T20:15:36.237Z"
  }
}
```

#### POST /api/inventory/exit
Register a product exit from a warehouse.

**Parameters:**
```json
{
  "warehouse_id": 1,
  "product_id": 1,
  "quantity": 10
}
```

**Possible errors:**
- `422`: "Stock not found" - Product stock does not exist in the warehouse
- `422`: "Insufficient stock" - Requested quantity exceeds available stock

#### POST /api/inventory/transfer
Transfer products between warehouses.

**Parameters:**
```json
{
  "source_warehouse_id": 1,
  "destination_warehouse_id": 2,
  "product_id": 1,
  "quantity": 20
}
```

**Possible errors:**
- `422`: "Stock not found" - Product stock does not exist in the source warehouse
- `422`: "Insufficient stock" - Requested quantity exceeds available stock

#### GET /api/inventory/history/:product_id
Get movement history for a product (paginated).

**Query params:** `?page=1`

---

## Response Format

### Success Response
```json
{
  "message": "Success",
  "data": { ... }
}
```

### Error Response
```json
{
  "message": "Error",
  "errors": ["Error message 1", "Error message 2"]
}
```

---

## Roles and Permissions

- **plant_manager**: Full system access. Can create/edit/delete warehouses and manage assignments.
- **manager**: Access to managed warehouses. Can perform inventory movements in their warehouses.
- **warehouse_worker**: Access to assigned warehouses. Can perform inventory movements in their assigned warehouses.

**Note**: All authenticated users can create, edit, and delete products.
