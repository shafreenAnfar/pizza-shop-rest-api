import ballerina/time;
import ballerina/uuid;

map<Pizza> pizzasTable = {};
map<Order> ordersTable = {};

public function initializeMockData() {
    pizzasTable = {
        "1": {
            id: "1",
            name: "Margherita",
            description: "Classic pizza with tomato sauce, mozzarella, and basil",
            price: 12.99,
            size: "medium",
            toppings: ["mozzarella", "basil", "tomato sauce"]
        },
        "2": {
            id: "2",
            name: "Pepperoni",
            description: "Pepperoni with mozzarella and tomato sauce",
            price: 14.99,
            size: "large",
            toppings: ["pepperoni", "mozzarella", "tomato sauce"]
        },
        "3": {
            id: "3",
            name: "Vegetarian",
            description: "Fresh vegetables with mozzarella",
            price: 13.99,
            size: "medium",
            toppings: ["bell peppers", "mushrooms", "onions", "olives", "mozzarella"]
        }
    };

    ordersTable = {
        "1": {
            id: "1",
            customerName: "John Doe",
            customerPhone: "555-0100",
            items: [{pizzaId: "1", quantity: 2}],
            totalPrice: 25.98,
            status: "delivered",
            createdAt: [1704067200, 0.0]
        }
    };
}

public function getAllPizzas() returns Pizza[] {
    return pizzasTable.toArray();
}

public function getPizzaById(string pizzaId) returns Pizza? {
    return pizzasTable[pizzaId];
}

public function addPizza(NewPizza newPizza) returns Pizza {
    string pizzaId = uuid:createType1AsString();
    Pizza pizza = {
        id: pizzaId,
        name: newPizza.name,
        description: newPizza.description,
        price: newPizza.price,
        size: newPizza.size,
        toppings: newPizza.toppings
    };
    pizzasTable[pizzaId] = pizza;
    return pizza;
}

public function updatePizza(string pizzaId, NewPizza updatedPizza) returns Pizza? {
    if !pizzasTable.hasKey(pizzaId) {
        return ();
    }
    Pizza pizza = {
        id: pizzaId,
        name: updatedPizza.name,
        description: updatedPizza.description,
        price: updatedPizza.price,
        size: updatedPizza.size,
        toppings: updatedPizza.toppings
    };
    pizzasTable[pizzaId] = pizza;
    return pizza;
}

public function deletePizza(string pizzaId) returns boolean {
    if pizzasTable.hasKey(pizzaId) {
        _ = pizzasTable.remove(pizzaId);
        return true;
    }
    return false;
}

public function getAllOrders() returns Order[] {
    return ordersTable.toArray();
}

public function getOrderById(string orderId) returns Order? {
    return ordersTable[orderId];
}

public function createOrder(NewOrder newOrder) returns Order|error {
    decimal totalPrice = 0.0;
    
    foreach OrderItem item in newOrder.items {
        Pizza? pizza = pizzasTable[item.pizzaId];
        if pizza is () {
            return error(string `Pizza with ID ${item.pizzaId} not found`);
        }
        totalPrice += pizza.price * item.quantity;
    }

    string orderId = uuid:createType1AsString();
    time:Utc currentTime = time:utcNow();
    
    Order 'order = {
        id: orderId,
        customerName: newOrder.customerName,
        customerPhone: newOrder.customerPhone,
        items: newOrder.items,
        totalPrice: totalPrice,
        status: "pending",
        createdAt: currentTime
    };
    
    ordersTable[orderId] = 'order;
    return 'order;
}

public function updateOrderStatus(string orderId, OrderStatus status) returns Order? {
    Order? existingOrder = ordersTable[orderId];
    if existingOrder is () {
        return ();
    }
    
    Order updatedOrder = {
        id: existingOrder.id,
        customerName: existingOrder.customerName,
        customerPhone: existingOrder.customerPhone,
        items: existingOrder.items,
        totalPrice: existingOrder.totalPrice,
        status: status,
        createdAt: existingOrder.createdAt
    };
    
    ordersTable[orderId] = updatedOrder;
    return updatedOrder;
}
