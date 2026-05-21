SELECT * FROM super_store_sales.global_superstore2;

SELECT 
    SUM(CASE WHEN `Order ID` IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN `Order Date` IS NULL THEN 1 ELSE 0 END) AS order_date_nulls,
    SUM(CASE WHEN `Ship Date` IS NULL THEN 1 ELSE 0 END) AS ship_date_nulls,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS sales_nulls,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS profit_nulls,
    SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN `Customer ID` IS NULL THEN 1 ELSE 0 END) AS customer_nulls,
    SUM(CASE WHEN `Product Name` IS NULL THEN 1 ELSE 0 END) AS product_nulls,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS region_nulls
FROM super_store_sales.global_superstore2;

select count(*) 
from super_store_sales.global_superstore2
where `Order Date` > `Ship Date`;

SELECT `Order Date`, `Ship Date`
FROM super_store_sales.global_superstore2
LIMIT 10;

select `Order ID` , count(*)
from super_store_sales.global_superstore2
group by `Order ID`
having count(*) > 1;

select * from super_store_sales.global_superstore2
where `Order Date` > `Ship Date`;

alter table super_store_sales.global_superstore2
drop column Shipping_days,
drop column ShippingDays;

SELECT * FROM super_store_sales.global_superstore2;

describe super_store_sales.global_superstore2;

set sql_safe_updates = 0;

UPDATE super_store_sales.global_superstore2
SET 
  `Order Date` = STR_TO_DATE(`Order Date`, '%d-%m-%Y'),
  `Ship Date` = STR_TO_DATE(`Ship Date`, '%d-%m-%Y');

describe super_store_sales.global_superstore2;

ALTER TABLE super_store_sales.global_superstore2
MODIFY `Order Date` DATE,
MODIFY `Ship Date` DATE;

describe super_store_sales.global_superstore2;

alter table super_store_sales.global_superstore2
drop column order_date,
drop column ship_date;

alter table super_store_sales.global_superstore2
add shipping_days int;

update super_store_sales.global_superstore2
set shipping_days = datediff(`Ship Date`,`Order Date`);

describe super_store_sales.global_superstore2;p[

select count(*)
from super_store_sales.global_superstore2
where shipping_days = 0;

/* profit leakage */
select `Sub-Category` , sum(Profit) as total_profit
from super_store_sales.global_superstore2
group by `Sub-Category`
order by total_profit asc;

/* Discount impact */
select `Discount` , avg(Profit) as avg_profit
from super_store_sales.global_superstore2
group by `Discount`
order by `Discount`;

/* outlier check */
select count(*) 
from super_store_sales.global_superstore2
where Profit < -1000 or profit > 1000;

/* Data consistency check  */

/*Negative Sales*/
select count(*) 
from super_store_sales.global_superstore2
where Sales < 0;

/*profit margin check*/
select count(*) 
from super_store_sales.global_superstore2
where profit_margin > 1 or profit_margin < -1;

select 
	count(*) as total,
    sum(case when profit_margin > 1 then 1 else 0 end) as above_100_percent,
    sum(case when profit_margin < -1 then 1 else 0 end) as below_minus_100_percent 	 
from super_store_sales.global_superstore2;

select `Sub-Category` , count(*) as bad_orders
from super_store_sales.global_superstore2
where profit_margin < -1 
group by `Sub-Category`
order by bad_orders desc;

/* Check Discount in Bad Orders */
select 
    `Discount`,
    count(*) as bad_orders
from super_store_sales.global_superstore2
where profit_margin < -1 
group by `Discount`
order by `Discount`;

/* sales vs profit in bad orders */
select 
    avg(sales) as avg_Sales,
    avg(Profit) as avg_profit 
from super_store_sales.global_superstore2
where Profit_margin < -1;    

/* compare with normal orders */
select 
     avg(sales) as avg_sales,
     avg(Profit) as avg_profit
from super_store_sales.global_superstore2
where Profit_margin between 0 and 0.5;

/* Category + Discount Together */
select
    `Sub-Category`,
     `Discount`,
     count(*) as bad_orders
from super_store_sales.global_superstore2
where Profit_margin < -1
group by `Sub-Category` , `Discount`
order by bad_orders desc;    
