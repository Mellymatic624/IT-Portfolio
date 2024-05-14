-- Data Exploration

SELECT *
FROM menu_items;

SELECT *
FROM order_details;

-- The number of items on menu
SELECT COUNT(*) as number_of_items
FROM menu_items;

-- The least and most expensive items on the menu
SELECT item_name, price
FROM menu_items
ORDER BY price ASC
LIMIT 1;

SELECT item_name, price
FROM menu_items
ORDER BY price DESC
LIMIT 1;

-- The amount of Italian dishes on the menu
SELECT COUNT(category)
FROM menu_items
WHERE category ='Italian';

-- The least and most expensive Italian dishes on the menu
SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price ASC
LIMIT 1;

SELECT item_name, price
FROM menu_items
WHERE category = 'Italian'
ORDER BY price DESC
LIMIT 1;

-- The amount of dishes in each category and the average dish price for each category

SELECT category, COUNT(*), AVG(price)
FROM menu_items
GROUP BY category;

SELECT *
FROM order_details;

-- The data range of the order table
SELECT MIN(order_date) as first_order_date,
		MAX(order_date) as recent_order_date
FROM order_details; 

-- The amount of orders made and amount of items ordered withing this date range
SELECT COUNT(distinct order_id) as amount_of_orders,
		COUNT(*) as amount_of_items_ordered
FROM order_details
WHERE order_date BETWEEN (SELECT MIN(order_date)
						  FROM order_details)
				  AND (SELECT MAX(order_date)
						FROM order_details);

-- The orders that had the most number of items

SELECT order_id, COUNT(*)
FROM order_details
GROUP BY order_id
ORDER BY COUNT(*) DESC;

-- The amount of orders that had more than 12 items

SELECT order_id, COUNT(*)
FROM order_details
GROUP BY order_id
HAVING COUNT(*) > 12
ORDER BY COUNT(*) DESC;

-- Combining both menu_items and order_details tables
SELECT *
FROM menu_items as m
LEFT JOIN order_details as o
ON m.menu_item_id = o.item_id;

-- Analyzing customer behavior

-- The least and most ordered items by category

SELECT m.item_name, m.category, COUNT(*) as amount_ordered
FROM menu_items as m
	LEFT JOIN order_details as o
	ON m.menu_item_id = o.item_id
GROUP BY m.item_name, m.category
ORDER BY COUNT(*) ASC
LIMIT 1;

SELECT m.item_name, m.category, COUNT(*) as amount_ordered
FROM menu_items as m
	LEFT JOIN order_details as o
	ON m.menu_item_id = o.item_id
GROUP BY m.item_name, m.category
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Top 5 orders that spend the most money

SELECT o.order_id, SUM(m.price) as price_of_order
FROM menu_items as m
	LEFT JOIN order_details as o
	ON m.menu_item_id = o.item_id
GROUP BY o.order_id
ORDER BY price_of_order DESC
LIMIT 5;

-- The details of the highest spend order
SELECT *
FROM menu_items as m
	LEFT JOIN order_details as o
	ON m.menu_item_id = o.item_id
WHERE o.order_id = 440;

-- The details of the top 5 highest spend orders
SELECT *
FROM menu_items as m
	LEFT JOIN order_details as o
	ON m.menu_item_id = o.item_id
WHERE o.order_id IN (440, 2075, 1957, 330, 2675);

    