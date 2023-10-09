-- Create the table: 
-- Create the NYC data
create table nycdata.bookings (
	booking_id INT primary key,
	listing_name VARCHAR,
	host_id INT,
	host_name VARCHAR(50),
	neighbourhood_group VARCHAR(30),
	neighbourhood VARCHAR(30),
	latitude DECIMAL(11,8),
	longitude DECIMAL(11,8),
	room_type VARCHAR(30),
	price INT,
	minimum_nights INT,
	num_of_reviews INT,
	last_review DATE,
	reviews_per_month DECIMAL(4,2),
	calculated_host_listings_count INT,
	availability_365 INT
);

-- View the table
select * from nycdata.bookings;

-- Upload the CSV data from https://www.kaggle.com/code/dgomonov/data-exploration-on-nyc-airbnb to the database using psql tool
>  \COPY nycdata.bookings FROM '/home/billy/Documents/SQL_Learning/AB_NYC_2019.csv' DELIMITER ',' CSV HEADER ENCODING 'utf-8'


-- Average price with over
select booking_id, listing_name, neighbourhood_group,
AVG(price) OVER() from nycdata.bookings;

--Average, minimum and mximum with over 
select b.booking_id, 
b.listing_name, b.neighbourhood_group, AVG(b.price) over(), 
MIN(b.price) over(),
MAX(b.price) over()
from nycdata.bookings b; 

-- dIFFERENCE from average price with OVER
select b.booking_id, b.listing_name, b.neighbourhood_group,
b.price, ROUND(AVG(b.price) over() ,2),
ROUND((b.price- AVG(b.price) OVER()),2) as DIFF_PRICE
from nycdata.bookings b;

-- pERCENT AVERAGE PRICE WITH OVER()
select b.booking_id, b.listing_name, 
b.neighbourhood_group,
b.price,
ROUND(AVG(b.price) OVER(),2) as average_price,
ROUND((b.price / AVG(b.price) OVER() *100),2) as percent_of_avg_price
from nycdata.bookings b; 

-- Percentage difference from average price
select b.booking_id, b.listing_name, b.neighbourhood_group,
b.price,
ROUND(AVG(b.price) OVER(),2) as avg_price,
ROUND((b.price / AVG(price) OVER() - 1) * 100,2) as percentage_price_diff
from nycdata.bookings b; 

--NEIGHBOURHOOD GROUPS
select distinct(b.neighbourhood_group) from nycdata.bookings b;

-- Average price within each  neighbourhood group
select b.booking_id, b.listing_name, b.neighbourhood_group, 
b.price, 
AVG(b.price) OVER(partition by b.neighbourhood_group) as avg_price_neigh_group from nycdata.bookings b ;



-- Average price by neighbourhood_group and neighbourhood
select b.booking_id, b.listing_name,b.neighbourhood , b.neighbourhood_group, b.price,
AVG(b.price) over (partition by b.neighbourhood_group) as avg_price_neigh_group,
AVG(b.price) over(partition by b.neighbourhood_group, b.neighbourhood) as avg_price_neigh from nycdata.bookings b;


-- Compute the difference between average price in the specific neighborhood and neighborhood group 
select b.booking_id, b.listing_name, b.neighbourhood_group, b.neighbourhood,  b.price,
ROUND(AVG(b.price) OVER(partition by b.neighbourhood_group),2) as avg_price_neigh,
ROUND(AVG(b.price) over(partition by b.neighbourhood_group , b.neighbourhood),2)  as avg_price_neighgroup_neigh,
ROUND(b.price - AVG(b.price) OVER(partition by b.neighbourhood_group),2) as price_diff_neigh_group,
ROUND(b.price - AVG(b.price) over(partition by b.neighbourhood_group , b.neighbourhood),2) as price_diff_neighgroup_neigh
from nycdata.bookings b; 


-- RANKING VALUES 
select b.booking_id, b.listing_name, b.price,
b.neighbourhood_group,
b.neighbourhood,
row_number () over(order by PRICE desc) as OVERALL_PRICE_RANK
from nycdata.bookings b; 


---- NEIGHBORHOOD PRICE rank
select b.booking_id, b.listing_name, b.neighbourhood, b.neighbourhood_group,
b.price,
ROW_NUMBER() over(order by b.price desc) as OVERALL_PRICE_RANK,
row_NUMBER() OVER(PARTITION by b.neighbourhood_group order by b.price DESC) as neigh_group_price_rank
from nycdata.bookings b where b.neighbourhood_group ='Bronx'; 


-- Get the top 3 prices in each nneighborhood group
select b.booking_id, b.listing_name, b.neighbourhood, b.neighbourhood_group,
b.price,
ROW_NUMBER() over(order by b.price desc) as OVERALL_PRICE_RANK,
row_NUMBER() OVER(PARTITION by b.neighbourhood_group order by b.price DESC) as neigh_group_price_rank,
case 
	when ROW_NUMBER() OVER(partition by b.neighbourhood_group order by b.price DESC) <= 3 then 'YES'
	else 'NO'
end as top_3_flag
from nycdata.bookings b;

-- RANKING USING RANK
select b.booking_id, b.listing_name, b.neighbourhood, b.neighbourhood_group,
b.price,
ROW_NUMBER() over(order by b.price DESC) as OVERALL_PRICE_RANK,
RANK() over(order BY b.price DESC) as overall_price_rank_with_rank,
ROW_NUMBER() OVER(PARTITION BY b.neighbourhood_group order by b.price DESC) as neigh_group_price_rank,
RANK() over(partition by b.neighbourhood_group order by b.price DESC) as neigh_rank_with_rank
from nycdata.bookings b; 

-- ranking WITH dense ranK
select b.booking_id, b.listing_name, b.neighbourhood, b.neighbourhood_group,
b.price,
ROW_NUMBER() over(order by b.price DESC) as OVERALL_PRICE_RANK,
RANK() over(order BY b.price DESC) as overall_price_rank_with_rank,
DENSE_RANK() over(order by b.price DESC) as overall_rank_with_dense_rank
from nycdata.bookings b;

