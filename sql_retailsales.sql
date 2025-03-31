Create Database SQl_project1;

USE SQl_project1;

CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT 
    *
FROM
    retail_sales;

-- TO CHECK FOR THE NULL VALUES IN ALL THE COLUMNS
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Data Exploration --
#**Customer Count**: Find out how many unique customers are in the dataset.
SELECT 
    COUNT(DISTINCT customer_id)
FROM
    retail_sales;
    
#**Category Count**: Identify all unique product categories in the dataset.
SELECT 
    COUNT(DISTINCT CATEGORY)
FROM
    RETAIL_SALES;
    
-- Data Analysis & Findings --
#The following SQL queries were developed to answer specific business questions:

# 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';
    

#2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
#the quantity sold is more than 4 in the month of Nov-2022**:
SELECT 
    *
FROM
    retail_sales
WHERE
    category = 'Clothing' AND quantity >= 4
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';


#3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
SELECT 
    Category, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY category;


#4. **Write a SQL query to find the average age
#of customers who purchased items from the 'Beauty' category.**
SELECT 
    Category, ROUND(AVG(age)) AS 'Avg Age'
FROM
    retail_sales
WHERE
    category = 'Beauty';

#5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
select * from retail_sales
where total_sale > 1000
order by total_sale;


#6. **Write a SQL query to find the total number of transactions (transaction_id) made 
#by each gender in each category.**
SELECT 
     category, gender, COUNT(*) AS total_trans
FROM
    retail_sales
GROUP BY category, gender
ORDER BY category;


#** Write a SQL query to calculate the average sale for each month.
# Find out best selling month in each year**
SELECT year , month, avg_sale FROM
(
SELECT YEAR(sale_date) as year , MONTH(sale_date) as month, ROUND(AVG(total_sale), 2) AS avg_sale,
RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale)DESC) AS ranks
FROM retail_sales
GROUP BY YEAR(sale_date) , MONTH(sale_date)
) AS t1
WHERE Ranks = 1;


#8. **Write a SQL query to find the top 5 customers based on the highest total sales **
SELECT 
    customer_id, SUM(total_sale) AS total_sales
FROM
    retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


#9. **Write a SQL query to find the number of unique customers who purchased items from each category.**
SELECT 
    COUNT(DISTINCT customer_id) AS Customers, Category
FROM
    retail_sales
GROUP BY category;


#10. **Write a SQL query to create each shift and number of orders 
#(Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
WITH Hourly_shift AS (
SELECT * ,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift ,
count(*) AS 'number of orders'
FROM Hourly_shift
GROUP BY shift;

