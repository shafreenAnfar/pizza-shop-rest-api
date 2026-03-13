import ballerina/time;

public type PizzaSize "small"|"medium"|"large";

public type OrderStatus "pending"|"preparing"|"ready"|"delivered"|"cancelled";

public type Pizza record {|
    string id;
    string name;
    string description;
    decimal price;
    PizzaSize size;
    string[] toppings?;
|};

public type NewPizza record {|
    string name;
    string description;
    decimal price;
    PizzaSize size;
    string[] toppings?;
|};

public type OrderItem record {|
    string pizzaId;
    int quantity;
|};

public type Order record {|
    string id;
    string customerName;
    string customerPhone?;
    OrderItem[] items;
    decimal totalPrice;
    OrderStatus status;
    time:Utc createdAt;
|};

public type NewOrder record {|
    string customerName;
    string customerPhone?;
    OrderItem[] items;
|};

public type OrderStatusUpdate record {|
    OrderStatus status;
|};

public type ErrorResponse record {|
    string message;
|};
