create database if not exists salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL, 
customer_type VARCHAR(30) NOT NULL, 
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL (10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT (6, 4) NOT NULL, 
total DECIMAL (12, 4) NOT NULL, 
date DATETIME NOT NULL, 
time TIME NOT NULL, 
payment_method VARCHAR (15) NOT NULL, 
cogs DECIMAL (10, 2) NOT NULL, 
gross_margin_pct FLOAT (11, 9),
gross_income DECIMAL (12, 4) NOT NULL, 
rating FLOAT (2, 1)
);



-- add time_of_day
select time,
case when time>='00:00:00' and time <= '12:00:00' then 'morning'
	 when time>='12:01:00' and time <= '16:00:00' then 'afternoon'
	 else "evening"
end as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);
update sales
set time_of_day = (
case when time>='00:00:00' and time <= '12:00:00' then 'morning'
	 when time>='12:01:00' and time <= '16:00:00' then 'afternoon'
	 else "evening"
end
);
-- add day_name
select date,
dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(10);
update sales 
set day_name = dayname(date);

-- add month_name

select date,
monthname(date) as day_name
from sales;

alter table sales add column month_name varchar(10);
update sales 
set month_name = monthname(date);

-- How many unique cities does the data have?
select 
distinct city
from sales;
 
 -- In which city is each branch?
 select 
distinct branch, city
from sales;

-- How many unique product lines does the data have?
select 
count(distinct product_line)
from sales;

-- What is the most common payment method?

select 
payment_method,
count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc
limit 1;

-- What is the most selling product line?
select 
product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt desc
limit 1;

-- What is the total revenue by month?
select 
month_name as month,
sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?

select 
month_name as month,
sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;

-- What product line had the largest revenue?
SELECT
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue;


-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;


-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;


-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;



-- Number of sales made in each time of the day per weekday

select 
time_of_day,
count(*) as total_sales
from sales
where day_name = "monday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?

select 
customer_type,
sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc
limit 1;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

select city,
avg(vat) as vat 
from sales
group by city
order by vat desc
limit 1;

-- Which customer type pays the most in VAT?


select customer_type,
avg(vat) as vat 
from sales
group by customer_type
order by vat desc
limit 1;

-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?
SELECT
	day_name,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name 
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT 
	day_name,
	COUNT(day_name) total_sales
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;

-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
	SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue;

-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;




