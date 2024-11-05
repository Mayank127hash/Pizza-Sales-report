

-- First Question : - Retrieve the total number of orders placed.


select count(order_id) as total_orders from orders; -- this will give the total number of order till placed using count function

-- Second question : - Calculate the total revenue generated from the pizza sales.
-- to solve this question we have to join two tables pizzas as it contain prices and second order_details as it contain quantity

select 
round(sum(order_details.quantity * pizzas.price),2) as total_sales -- round is use use to round it into decimal palces where 2 is value as in 2 decimal places
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id;


-- Third question : - Identify the highest - priced pizza.

select pizza_types.name, pizzas.price 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by price desc limit 1; -- limit clause is used to limit the value till only 1 pizzas


-- Fourth Question : - Identify the most common pizza size we ordered

 select quantity, count(order_details_id)
 from order_details group by quantity;
 
 select pizzas.size, count(order_details.order_details_id) as order_count
 from pizzas join order_details
 on pizzas.pizza_id = order_details.pizza_id
 group by size order by order_count desc;
 
 -- Question 5 : - List the top 5 pizza types along with the quantities
 
 
 select pizza_types.name, sum(order_details.quantity) as order_quantity
 from pizza_types join pizzas
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details 
 on pizzas.pizza_id = order_details.pizza_id
 group by name order by order_quantity desc limit 5;
 
 
-- Question 6 : - Join the necessary tables to find the total quantity of each pizz category ordered

select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.Pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by category order by quantity desc;

-- Question 7 :- Dtermine the order of the distribution by hour of the day

select hour(order_time) as hour ,count(order_id) as order_count from orders -- in this the hour clause ios used as we only want hours from the order time
group by hour(order_time);


-- Question 8 :- Join relevant tables to find the category wise distribution of pizzas

select category, count(name) from pizza_types
group by category;

-- Question 9 :- Group the order by date and calculate the average number of pizza order per day

select round(avg(quantity),2) from
(select orders.order_date, sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by order_date) as total_quantity;    -- it is the total number od order per day to find the avg we make this query as sub query



-- Question 10 :- Determine the top 3 most ordered pizza type based on revenue

select pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name order by revenue desc limit 3;


-- Question 11 : - Determine the percentage contribution of each pizza type to total revenue

select pizza_types.category,
(sum(order_details.quantity * pizzas.price) / (select  round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id) ) * 100 as revenue 
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.category order by revenue desc;


-- Question 12 : - Analyze the comulative revenue generated over time
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from
(select orders.order_date, 
sum(order_details.quantity * pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;


-- Question 13 :- Determine the top 3 most ordered pizza type basedon revenue for each pizza category

WITH RankedPizzas AS (
    SELECT 
        pizza_types.category,
        pizza_types.name,
        SUM(order_details.quantity * pizzas.price) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY pizza_types.category ORDER BY SUM(order_details.quantity * pizzas.price) DESC) 
    FROM 
        pizza_types 
    JOIN 
        pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN 
        order_details ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY 
        pizza_types.category, pizza_types.name
)

SELECT 
    category,
    name,
    revenue
FROM 
    RankedPizzas
    
ORDER BY 
    category,revenue DESC;  -- Order the results by category and revenue

    
    -- Till date total revenue generated :- 
    SELECT 
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM 
    order_details 
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Total revenue generatedon the basis of pizzas type :-
SELECT 
    pizza_types.name AS pizza_type,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM 
    order_details 
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN 
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizza_types.name
ORDER BY 
    total_revenue DESC;
    
    
    
    
    -- Total revenue generated on the basis of pizzas categories
    SELECT 
    pizza_types.category AS pizza_category,
    SUM(order_details.quantity * pizzas.price) AS total_revenue
FROM 
    order_details 
JOIN 
    pizzas ON order_details.pizza_id = pizzas.pizza_id
JOIN 
    pizza_types ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY 
    pizza_types.category
ORDER BY 
    total_revenue DESC;





