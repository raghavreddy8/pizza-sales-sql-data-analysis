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
