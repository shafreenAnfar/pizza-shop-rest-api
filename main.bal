import ballerina/http;

listener http:Listener httpListener = new (8081);

service / on httpListener {

    function init() {
        initializeMockData();
    }

    // Get all pizzas
    resource function get pizzas() returns Pizza[] {
        return getAllPizzas();
    }

    // Add a new pizza
    resource function post pizzas(@http:Payload NewPizza newPizza) returns Pizza|http:Created|http:BadRequest {
        Pizza pizza = addPizza(newPizza);
        http:Created created = {
            body: pizza
        };
        return created;
    }

    // Get pizza by ID
    resource function get pizzas/[string pizzaId]() returns Pizza|http:NotFound {
        Pizza? pizza = getPizzaById(pizzaId);
        if pizza is () {
            http:NotFound notFound = {
                body: {message: string `Pizza with ID ${pizzaId} not found`}
            };
            return notFound;
        }
        return pizza;
    }

    // Update a pizza
    resource function put pizzas/[string pizzaId](@http:Payload NewPizza updatedPizza) returns Pizza|http:NotFound {
        Pizza? pizza = updatePizza(pizzaId, updatedPizza);
        if pizza is () {
            http:NotFound notFound = {
                body: {message: string `Pizza with ID ${pizzaId} not found`}
            };
            return notFound;
        }
        return pizza;
    }

    // Delete a pizza
    resource function delete pizzas/[string pizzaId]() returns http:NoContent|http:NotFound {
        boolean deleted = deletePizza(pizzaId);
        if !deleted {
            http:NotFound notFound = {
                body: {message: string `Pizza with ID ${pizzaId} not found`}
            };
            return notFound;
        }
        return http:NO_CONTENT;
    }

    // Get all orders
    resource function get orders() returns Order[] {
        return getAllOrders();
    }

    // Create a new order
    resource function post orders(@http:Payload NewOrder newOrder) returns Order|http:Created|http:BadRequest {
        Order|error 'order = createOrder(newOrder);
        if 'order is error {
            http:BadRequest badRequest = {
                body: {message: 'order.message()}
            };
            return badRequest;
        }
        http:Created created = {
            body: 'order
        };
        return created;
    }

    // Get order by ID
    resource function get orders/[string orderId]() returns Order|http:NotFound {
        Order? 'order = getOrderById(orderId);
        if 'order is () {
            http:NotFound notFound = {
                body: {message: string `Order with ID ${orderId} not found`}
            };
            return notFound;
        }
        return 'order;
    }

    // Update order status
    resource function patch orders/[string orderId](@http:Payload OrderStatusUpdate statusUpdate) returns Order|http:NotFound {
        Order? 'order = updateOrderStatus(orderId, statusUpdate.status);
        if 'order is () {
            http:NotFound notFound = {
                body: {message: string `Order with ID ${orderId} not found`}
            };
            return notFound;
        }
        return 'order;
    }
}
