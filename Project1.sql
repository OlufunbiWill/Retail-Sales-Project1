-- The Database that is being uses is the Retail_Sales_Analysis.alter
-- The table's name is retail sales. 
-- The goal of this project is to set up retail sales database perform Exploratory data analysis 
-- Answer business specific questions

-- THIS IS THE DATA CLEANING PROCESS
select *
from retailsales;

-- we create an duplicate of the original data in case of a mistake. 
create table retailsales_copy
like retailsales ; 


insert retailsales_copy
select * from retailsales;

-- displays the total amount of data in the retailsales_copy table.
 
select count(*)
from retailsales_copy;

select * from retailsales_copy;

-- we are checking for null values
select * from retailsales_copy
where 
transactions_id is null or transactions_id = '' or  transactions_id = 0
or sale_date is null or sale_date = '' or sale_date = 0
or sale_time is null or sale_time = '' or sale_time = 0
or customer_id is null or customer_id = '' or customer_id = 0
or gender is null or gender = '' or gender = 0
or age is null or age = '' or age = 0
or category is null or category = '' or  category = 0
or quantiy is null or quantiy = '' or quantiy = 0
or price_per_unit is null or price_per_unit = '' or price_per_unit = 0
or cogs is null or cogs = '' or cogs = 0
or total_sale is null or total_sale = '' or total_sale = 0;

-- replacing empty strings with null
UPDATE retailsales_copy
SET quantiy = NULL
WHERE quantiy = '';

UPDATE retailsales_copy
SET price_per_unit = NULL
WHERE price_per_unit = '';

UPDATE retailsales_copy
SET cogs = NULL
WHERE cogs = '';

UPDATE retailsales_copy
SET total_sale = NULL
WHERE total_sale = '';


select * from retailsales_copy
where 
transactions_id is null 
or sale_date is null 
or sale_time is null 
or customer_id is null 
or gender is null 
or age is null 
or category is null 
or quantiy is null
or price_per_unit is null 
or cogs is null 
or total_sale is null;

-- Deleting null values 
delete from retailsales_copy
where 
transactions_id is null 
or sale_date is null 
or sale_time is null 
or customer_id is null 
or gender is null 
or age is null 
or category is null 
or quantiy is null
or price_per_unit is null 
or cogs is null 
or total_sale is null;


-- DATA EXPLORATION

select * from retailsales_copy;

-- check how many sales we have ?
Select count(*) total_sale from retailsales_copy;

-- how many unique customers do we have?
-- we use distinct just in case a customer purchased twice it only counts the customer once
select count(Distinct customer_id) as unique_customer from retailsales_copy;

select distinct category from retailsales_copy;


-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS

-- My Analysis and Findings

#1. write a sql query to retrieve all column for sales made on '2022-11-05

select *  from retailsales_copy
where sale_date = '2022-11-05';


#2. Write a SQL query to retrieve all transactions where the category is
-- 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retailsales_copy
where category = 'clothing'
and quantiy >= 4
and sale_date >= '2022-11-01'
and sale_date <  '2022-12-01';   

#3. Write a SQL query to calculate the total sales (total_sale) for each category.:

select distinct category,  sum(total_sale) as totalsales
from retailsales_copy
group by 1;

-- What is the total sales and the number of orders for each product category

select distinct category,  sum(total_sale) as totalsales,
count(*) as totalorders
from retailsales_copy
group by 1;


#Q4. Write a SQL query to find the average age of customers who 
-- purchased items from the 'Beauty' category.:

select round(avg(age),2) as avg_age
from retailsales_copy
where category = 'Beauty';


#Q5. Write a SQL query to find all transactions 
-- where the total_sale is greater than 1000.

select * from retailsales_copy
where total_sale > 1000;

#Q6. Write a SQL query to find the total number of transactions (transaction_id)
--  made by each gender in each category.:

select distinct category, gender, count(transactions_id) as totalnum
from retailsales_copy
group by category, gender
order by 1;

#Q7.Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year: 


select * from
(
select year(sale_date) as year,     #this extracts year from sale_date
month(sale_date) as month,        #this extracts month from sale_date
avg(total_sale) as avg_totalsale,
rank() over
(partition by year(sale_date)      #Groups the data by year. This means the ranking will be done separately for each year.
order by avg(total_sale) desc) as therank   #Orders the months within each year by their average sales
from retailsales_copy
group by 1, 2
)
as ti -- is the alias for the subquery
where therank = 1;
-- order by 1, 2


#Q8. Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id, sum(total_sale) as top_sales
from retailsales_copy
group by 1
order by 2 desc
limit 5;


#Q9. Write a SQL query to find the number of unique customers
-- who purchased items from each category.:

select count(distinct customer_id) as uniquescustomers, category
from retailsales_copy
group by 2;


#Q10. Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17):


with hourly_sale
as
(
select *,
case
	when hour(sale_time) < 12
then 'Morning'
	when hour(sale_time) between 12 and 17 
then 'Afternoon'
else 'Evening'
end as shift
from retailsales_copy
)
select count(*) as totalorders, shift
 from hourly_sale
group by shift;



















