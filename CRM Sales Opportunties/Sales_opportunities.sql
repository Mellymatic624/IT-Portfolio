-- DATA CLEANING

SELECT * FROM accounts;

-- A mispelling found in the sector column
SELECT distinct sector
FROM accounts;

-- We update the mispelled sector with the correct spelling
UPDATE accounts
SET sector = 'technology'
WHERE sector = 'technolgy';

-- An error found in the product column where the words should be separated
SELECT distinct product
FROM sales_pipeline;

-- We update the product value where the words should be separated
UPDATE sales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';

-- EXPLORATORY DATA ANALYSIS

-- Which product sold the most? Sold the least?
SELECT product, 
		COUNT(*) as sales_num
FROM sales_pipeline
WHERE deal_stage = 'WON'
GROUP BY product
ORDER BY sales_num DESC;

-- Which sector had the most sales? How many sales were won?
SELECT a.sector, 
	   COUNT(opportunity_id) as sales,
       SUM(CASE
			 WHEN sp.deal_stage = 'won' THEN 1
			 ELSE 0
		   END) as sales_won
FROM accounts as a
	LEFT JOIN sales_pipeline as sp
    ON a.account = sp.account
GROUP BY a.sector
ORDER BY sales DESC;

-- What is the percentage of sales won by sector?
WITH sales_won_sector as (SELECT a.sector, 
	   COUNT(opportunity_id) as sales,
       SUM(CASE
			 WHEN sp.deal_stage = 'won' THEN 1
			 ELSE 0
		   END) as sales_won
FROM accounts as a
	LEFT JOIN sales_pipeline as sp
    ON a.account = sp.account
GROUP BY a.sector)

SELECT sector, 
		ROUND((sales_won / sales) * 100, 2) as won_percentage
FROM sales_won_sector
ORDER BY won_percentage DESC;

-- How many products were sold in each country?
SELECT a.office_location, COUNT(*) as num_of_sales
FROM accounts as a
	INNER JOIN sales_pipeline as sp
    ON a.account = sp.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.office_location
ORDER BY num_of_sales DESC;

-- Which product sold the most in each country?
WITH products_country_sold as (
SELECT a.office_location, 
		sp.product, COUNT(*) as num_of_sales,
        RANK() OVER(PARTITION BY a.office_location ORDER BY COUNT(*) DESC) as rank_num
FROM accounts as a
	INNER JOIN sales_pipeline as sp
    ON a.account = sp.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.office_location, sp.product
)

SELECT office_location, 
		product, 
        num_of_sales
FROM products_country_sold
WHERE rank_num = 1
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Which product made the most money? Which made the least?
SELECT product, 
	   SUM(close_value) as product_revenue
FROM sales_pipeline
WHERE deal_stage = 'Won'
GROUP BY product
ORDER BY product_revenue DESC;

-- Which account spent the most money on products?
SELECT account,
       SUM(close_value) as money_spent
FROM sales_pipeline as sp
WHERE sp.deal_stage = 'Won'
GROUP BY account
ORDER BY money_spent DESC
LIMIT 1;

-- How many products were sold for each month of the year 2017?
SELECT MONTH(close_date) as month,
		COUNT(*) as num_of_sales_won
FROM sales_pipeline
WHERE deal_stage = 'WON'
GROUP BY 1
ORDER BY 1;

-- Which regional_office made the most money?
SELECT st.regional_office as region, 
	   SUM(sp.close_value) as sales_revenue
FROM sales_teams as st
	LEFT JOIN sales_pipeline as sp
    ON st.sales_agent = sp.sales_agent
GROUP BY 1
ORDER BY 2 DESC;

-- Who are the top sales agents in each region?

WITH sales_ranked_region as (
SELECT st.sales_agent, 
		st.regional_office as region, 
        SUM(sp.close_value) as sales_revenue,
        RANK() OVER(PARTITION BY st.regional_office ORDER BY SUM(sp.close_value) DESC) as rank_num
FROM sales_teams as st
	LEFT JOIN sales_pipeline as sp
    ON st.sales_agent = sp.sales_agent
GROUP BY 1, 2
)

SELECT sales_agent,
		region,
        sales_revenue
FROM sales_ranked_region
WHERE rank_num = 1;


