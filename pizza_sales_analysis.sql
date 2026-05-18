create database pizzahut;
use pizzahut;

create table orders (
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id) 
);

create table orders_details (
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quanitity int not null,
primary key(order_details_id) ,
foreign key (order_id) references orders(order_id)
);

CREATE TABLE pizzas (
    pizza_id      VARCHAR(50)  NOT NULL PRIMARY KEY,
    pizza_type_id VARCHAR(50)  NOT NULL,
    size          VARCHAR(10)  NOT NULL,
    price         DECIMAL(6,2) NOT NULL
);

CREATE TABLE pizza_types (
    pizza_type_id VARCHAR(50)  NOT NULL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    category      VARCHAR(50)  NOT NULL,
    ingredients   TEXT
);


-- Queries


-- Q1. Total number of orders placed
SELECT COUNT(order_id) AS total_orders
FROM orders;

-- Q2. Total revenue generated from pizza sales
SELECT
    ROUND(SUM(od.quanitity * p.price), 2) AS total_revenue
FROM orders_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id;

-- Q3. Highest-priced pizza
SELECT pt.name AS pizza_name, p.price
FROM pizzas p
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

-- Q4. Most common pizza size ordered
SELECT
    p.size,
    SUM(od.quanitity) AS total_ordered
FROM orders_details od
JOIN pizzas p ON p.pizza_id = od.pizza_id
GROUP BY p.size
ORDER BY total_ordered DESC
LIMIT 1;

-- Q5. Top 5 most ordered pizza types with their quantities
SELECT
    pt.name          AS pizza_name,
    SUM(od.quanitity) AS total_quantity
FROM orders_details od
JOIN pizzas      p  ON p.pizza_id       = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.pizza_type_id, pt.name
ORDER BY total_quantity DESC
LIMIT 5;


-- Intermediate Queries

-- Q6. Total quantity of each pizza category ordered
SELECT
    pt.category,
    SUM(od.quanitity) AS total_quantity
FROM orders_details od
JOIN pizzas      p  ON p.pizza_id       = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity DESC;

-- Q7. Distribution of orders by hour of the day
SELECT
    HOUR(o.order_time) AS hour_of_day,
    COUNT(o.order_id)  AS order_count
FROM orders o
GROUP BY hour_of_day
ORDER BY hour_of_day;

-- Q8. Category-wise distribution of pizzas
SELECT
    category,
    COUNT(DISTINCT pizza_type_id) AS number_of_pizzas
FROM pizza_types
GROUP BY category
ORDER BY number_of_pizzas DESC;

-- Q9. Average number of pizzas ordered per day
SELECT
    ROUND(AVG(daily_qty), 0) AS avg_pizzas_per_day
FROM (
    SELECT
        o.order_date,
        SUM(od.quanitity) AS daily_qty
    FROM orders o
    JOIN orders_details od ON od.order_id = o.order_id
    GROUP BY o.order_date
) AS daily_summary;

-- Q10. Top 3 most ordered pizza types based on revenue
SELECT
    pt.name AS pizza_name,
    ROUND(SUM(od.quanitity * p.price), 2) AS revenue
FROM orders_details od
JOIN pizzas      p  ON p.pizza_id       = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.pizza_type_id, pt.name
ORDER BY revenue DESC
LIMIT 3;


-- Advanced Queries 

-- Q11. Percentage contribution of each pizza type to total revenue
SELECT
    pt.name AS pizza_name,
    ROUND(SUM(od.quanitity * p.price), 2) AS revenue,
    ROUND(
        SUM(od.quanitity * p.price) * 100.0 /
        (SELECT SUM(od2.quanitity * p2.price)
         FROM orders_details od2
         JOIN pizzas p2 ON p2.pizza_id = od2.pizza_id),
    2) AS revenue_percentage
FROM orders_details od
JOIN pizzas      p  ON p.pizza_id       = od.pizza_id
JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
GROUP BY pt.pizza_type_id, pt.name
ORDER BY revenue DESC;

-- Q12. Cumulative revenue generated over time
SELECT
    order_date,
    ROUND(daily_revenue, 2) AS daily_revenue,
    ROUND(SUM(daily_revenue) OVER (ORDER BY order_date), 2) AS cumulative_revenue
FROM (
    SELECT
        o.order_date,
        SUM(od.quanitity * p.price) AS daily_revenue
    FROM orders o
    JOIN orders_details od ON od.order_id  = o.order_id
    JOIN pizzas         p  ON p.pizza_id   = od.pizza_id
    GROUP BY o.order_date
) AS daily_rev
ORDER BY order_date;

-- Q13. Top 3 pizza types by revenue for each category
SELECT category, pizza_name, revenue, rnk
FROM (
    SELECT
        pt.category,
        pt.name AS pizza_name,
        ROUND(SUM(od.quanitity * p.price), 2) AS revenue,
        RANK() OVER (
            PARTITION BY pt.category
            ORDER BY SUM(od.quanitity * p.price) DESC
        ) AS rnk
    FROM orders_details od
    JOIN pizzas      p  ON p.pizza_id       = od.pizza_id
    JOIN pizza_types pt ON pt.pizza_type_id = p.pizza_type_id
    GROUP BY pt.category, pt.pizza_type_id, pt.name
) AS ranked
WHERE rnk <= 3
ORDER BY category, rnk;