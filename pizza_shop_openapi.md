# Pizza Shop OpenAPI Specification

Save this content as `pizza_shop_openapi.yaml`:

```yaml
openapi: 3.0.0
info:
  title: Pizza Shop API
  description: A simple REST API for managing a pizza shop
  version: 1.0.0
servers:
  - url: http://localhost:8080
    description: Local development server

paths:
  /pizzas:
    get:
      summary: Get all pizzas
      description: Retrieve a list of all available pizzas
      operationId: getPizzas
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Pizza'
    post:
      summary: Add a new pizza
      description: Add a new pizza to the menu
      operationId: addPizza
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NewPizza'
      responses:
        '201':
          description: Pizza created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Pizza'
        '400':
          description: Invalid input
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /pizzas/{pizzaId}:
    get:
      summary: Get pizza by ID
      description: Retrieve a specific pizza by its ID
      operationId: getPizzaById
      parameters:
        - name: pizzaId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Pizza'
        '404':
          description: Pizza not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
    put:
      summary: Update a pizza
      description: Update an existing pizza
      operationId: updatePizza
      parameters:
        - name: pizzaId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NewPizza'
      responses:
        '200':
          description: Pizza updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Pizza'
        '404':
          description: Pizza not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
    delete:
      summary: Delete a pizza
      description: Remove a pizza from the menu
      operationId: deletePizza
      parameters:
        - name: pizzaId
          in: path
          required: true
          schema:
            type: string
      responses:
        '204':
          description: Pizza deleted successfully
        '404':
          description: Pizza not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /orders:
    get:
      summary: Get all orders
      description: Retrieve a list of all orders
      operationId: getOrders
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Order'
    post:
      summary: Create a new order
      description: Place a new pizza order
      operationId: createOrder
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/NewOrder'
      responses:
        '201':
          description: Order created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
        '400':
          description: Invalid input
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /orders/{orderId}:
    get:
      summary: Get order by ID
      description: Retrieve a specific order by its ID
      operationId: getOrderById
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
        '404':
          description: Order not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
    patch:
      summary: Update order status
      description: Update the status of an existing order
      operationId: updateOrderStatus
      parameters:
        - name: orderId
          in: path
          required: true
          schema:
            type: string
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/OrderStatusUpdate'
      responses:
        '200':
          description: Order status updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Order'
        '404':
          description: Order not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    Pizza:
      type: object
      required:
        - id
        - name
        - description
        - price
        - size
      properties:
        id:
          type: string
          description: Unique identifier for the pizza
        name:
          type: string
          description: Name of the pizza
        description:
          type: string
          description: Description of the pizza
        price:
          type: number
          format: double
          description: Price of the pizza
        size:
          type: string
          enum: [small, medium, large]
          description: Size of the pizza
        toppings:
          type: array
          items:
            type: string
          description: List of toppings

    NewPizza:
      type: object
      required:
        - name
        - description
        - price
        - size
      properties:
        name:
          type: string
          description: Name of the pizza
        description:
          type: string
          description: Description of the pizza
        price:
          type: number
          format: double
          description: Price of the pizza
        size:
          type: string
          enum: [small, medium, large]
          description: Size of the pizza
        toppings:
          type: array
          items:
            type: string
          description: List of toppings

    Order:
      type: object
      required:
        - id
        - customerName
        - items
        - totalPrice
        - status
        - createdAt
      properties:
        id:
          type: string
          description: Unique identifier for the order
        customerName:
          type: string
          description: Name of the customer
        customerPhone:
          type: string
          description: Phone number of the customer
        items:
          type: array
          items:
            $ref: '#/components/schemas/OrderItem'
          description: List of ordered items
        totalPrice:
          type: number
          format: double
          description: Total price of the order
        status:
          type: string
          enum: [pending, preparing, ready, delivered, cancelled]
          description: Current status of the order
        createdAt:
          type: string
          format: date-time
          description: Timestamp when the order was created

    NewOrder:
      type: object
      required:
        - customerName
        - items
      properties:
        customerName:
          type: string
          description: Name of the customer
        customerPhone:
          type: string
          description: Phone number of the customer
        items:
          type: array
          items:
            $ref: '#/components/schemas/OrderItem'
          description: List of items to order

    OrderItem:
      type: object
      required:
        - pizzaId
        - quantity
      properties:
        pizzaId:
          type: string
          description: ID of the pizza
        quantity:
          type: integer
          minimum: 1
          description: Quantity of the pizza

    OrderStatusUpdate:
      type: object
      required:
        - status
      properties:
        status:
          type: string
          enum: [pending, preparing, ready, delivered, cancelled]
          description: New status for the order

    Error:
      type: object
      required:
        - message
      properties:
        message:
          type: string
          description: Error message
```

## API Endpoints

### Pizzas
- **GET /pizzas** - Get all pizzas
- **POST /pizzas** - Add a new pizza
- **GET /pizzas/{pizzaId}** - Get a specific pizza
- **PUT /pizzas/{pizzaId}** - Update a pizza
- **DELETE /pizzas/{pizzaId}** - Delete a pizza

### Orders
- **GET /orders** - Get all orders
- **POST /orders** - Create a new order
- **GET /orders/{orderId}** - Get a specific order
- **PATCH /orders/{orderId}** - Update order status

## Data Models

- **Pizza**: Represents a pizza with id, name, description, price, size, and toppings
- **Order**: Represents an order with customer details, items, total price, and status
- **OrderItem**: Links pizzas to orders with quantity
