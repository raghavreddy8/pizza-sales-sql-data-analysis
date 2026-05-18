# 🍕 Pizza Sales — SQL Data Analysis Project

**Database:** `pizzahut` | **Tool:** MySQL 8.0+ / MySQL Workbench  
**Author:** Raghav Reddy  
**Dataset:** Real-world pizza restaurant sales data (2015)

---

## Project Overview

This project performs end-to-end SQL data analysis on a pizza restaurant's sales data. It covers a complete range of SQL skills — from basic aggregations to advanced window functions — answering 13 business questions across three difficulty levels.

---

##  Database Schema

The database `pizzahut` contains **4 tables** with the following structure:

### Table 1: `orders`
Stores one record per customer order.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `order_id` | INT | PRIMARY KEY, NOT NULL | Unique identifier for each order |
| `order_date` | DATE | NOT NULL | Date the order was placed |
| `order_time` | TIME | NOT NULL | Time the order was placed |

---

### Table 2: `orders_details`
Stores the individual pizza items within each order.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `order_details_id` | INT | PRIMARY KEY, NOT NULL | Unique identifier for each order line |
| `order_id` | INT | FOREIGN KEY → `orders.order_id` | Links to the parent order |
| `pizza_id` | TEXT | NOT NULL | Identifier of the pizza ordered (e.g., `bbq_ckn_l`) |
| `quanitity` | INT | NOT NULL | Number of that pizza in the order |


---

### Table 3: `pizzas`
Stores each unique pizza variant (type + size combination) and its price.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `pizza_id` | VARCHAR(50) | PRIMARY KEY, NOT NULL | Unique pizza variant ID (e.g., `bbq_ckn_l`) |
| `pizza_type_id` | VARCHAR(50) | NOT NULL | Links to pizza type (e.g., `bbq_ckn`) |
| `size` | VARCHAR(10) | NOT NULL | Size: S, M, L, XL, XXL |
| `price` | DECIMAL(6,2) | NOT NULL | Price of the pizza variant in USD |

---

### Table 4: `pizza_types`
Stores the master list of pizza types with their category and ingredients.

| Column | Data Type | Constraint | Description |
|---|---|---|---|
| `pizza_type_id` | VARCHAR(50) | PRIMARY KEY, NOT NULL | Unique type identifier (e.g., `bbq_ckn`) |
| `name` | VARCHAR(100) | NOT NULL | Full pizza name (e.g., "The Barbecue Chicken Pizza") |
| `category` | VARCHAR(50) | NOT NULL | Category: Chicken, Classic, Supreme, Veggie |
| `ingredients` | TEXT | — | Comma-separated list of ingredients |

---


---

##  Data Analysis Questions & SQL Concepts

### Basic Level

| # | Question | SQL Concepts Used |
|---|---|---|
| Q1 | Retrieve the total number of orders placed | `COUNT()` |
| Q2 | Calculate the total revenue generated from pizza sales | `SUM()`, `JOIN`, `ROUND()` |
| Q3 | Identify the highest-priced pizza | `JOIN`, `ORDER BY DESC`, `LIMIT` |
| Q4 | Identify the most common pizza size ordered | `JOIN`, `GROUP BY`, `SUM()`, `ORDER BY DESC`, `LIMIT` |
| Q5 | List the top 5 most ordered pizza types along with their quantities | Multi-table `JOIN`, `GROUP BY`, `ORDER BY`, `LIMIT` |

---

### Intermediate Level

| # | Question | SQL Concepts Used |
|---|---|---|
| Q6 | Total quantity of each pizza category ordered | 3-table `JOIN`, `GROUP BY`, `SUM()` |
| Q7 | Distribution of orders by hour of the day | `HOUR()` function, `GROUP BY`, `COUNT()` |
| Q8 | Category-wise distribution of pizzas | `COUNT(DISTINCT)`, `GROUP BY` |
| Q9 | Average number of pizzas ordered per day | Subquery, `AVG()`, `ROUND()`, `GROUP BY` |
| Q10 | Top 3 most ordered pizza types based on revenue | Multi-table `JOIN`, `SUM()`, `ORDER BY`, `LIMIT` |

---

###  Advanced Level

| # | Question | SQL Concepts Used |
|---|---|---|
| Q11 | Percentage contribution of each pizza type to total revenue | Correlated Subquery, `ROUND()`, arithmetic operators |
| Q12 | Cumulative revenue generated over time | Subquery, **Window Function** — `SUM() OVER (ORDER BY)` |
| Q13 | Top 3 most ordered pizza types by revenue for each category | Subquery, **Window Function** — `RANK() OVER (PARTITION BY)` |

---



##  Setup Instructions

### Step 1 — Create Database & Tables
```sql
CREATE DATABASE IF NOT EXISTS pizzahut;
USE pizzahut;
-- Then run all CREATE TABLE statements
```

### Step 2 — Import CSV Data
In MySQL Workbench:
1. Right-click each table in the left panel → **Table Data Import Wizard**
2. Browse to your CSV file → click **Next** through all steps
3. Import in this order to respect foreign keys:
   - `pizza_types.csv` first
   - `pizzas.csv`
   - `orders.csv`
   - `order_details.csv` (maps to `orders_details` table)

### Step 3 — Run Analysis Queries
Open `pizza_sales_analysis.sql` and run each query section by section using **Ctrl + Enter**.

---

##  Repository Structure

```
pizza-sales-sql/
├── README.md                        ← This file
├── pizza_sales_analysis.sql         ← All 13 queries with comments
└── datasets/
    ├── orders.csv
    ├── order_details.csv
    ├── pizzas.csv
    └── pizza_types.csv
```


*Dataset source: Maven Analytics — Pizza Place Sales*
