-- I used Los Angeles Airbnb Dataset

-- Q1. What's the most expensive listing? What else can you tell me about the listing?

SELECT name, neighbourhood,minimum_nights FROM listings WHERE price = -(SELECT MAX(price) FROM listings);

--Q2. What neighborhoods seem to be the most popular?
-- Based on number of listings and total reviews 

SELECT neighbourhood, COUNT(*) ncount, SUM(number_of_reviews) total_reviews  FROM listings GROUP BY neighbourhood ORDER BY ncount DESC, total_reviews DESC;

-- Hollywood, Veince, Downtown, Long Beach, Holywood Hills

--Q3. What time of year is the cheapest time to go to your city? What about the busiest?

-- find the date duration

SELECT MIN(date) FROM calendar;

-- convert varchar to date

-- ALTER TABLE calendar ALTER COLUMN date TYPE DATE USING date::DATE;
-- conversion doesn't work because illegal entry
-- listing_id 2432755 is the one which contains illegal entry: 201
-- SELECT listing_id FROM calendar WHERE date = '201';
-- check how many times listing 2432755 is entered in calender
-- it is only 197 times as opposed to 365 times
-- SELECT COUNT(*) FROM calendar WHERE listing_id = (SELECT listing_id -- FROM calendar WHERE date = '201');
-- See how many times each listing is in the calendar
-- WITH days
-- AS
-- (SELECT listing_id, COUNT(*) FROM calendar GROUP BY listing_id)
-- most are 365, find out those which are not 365
-- SELECT * FROM days WHERE count <> 365;
-- listing id 2432755  count is only 197
-- listing id 2615178  count is only 199
-- all others are 365

-- Remove the illegal date entry and try converting again
-- DELETE FROM calendar WHERE date = '201';
-- ALTER TABLE calendar ALTER COLUMN date TYPE DATE USING date::DATE;
-- Conversion is done successfully
-- find minimum and maximum
-- SELECT MIN(date), MAX(date) FROM calendar;
-- min = 2018-09-08 and max = 2019-09-08

-- Convert price into float, there can not be round off errors
-- because all prices are only 2 precision 
-- first remove $ and , sign
-- UPDATE calendar
-- SET price = REPLACE(price, '$', '')
-- WHERE available = 't';
-- UPDATE calendar
-- SET price = REPLACE(price, ',', '')
-- WHERE available = 't';

-- change type 
-- ALTER TABLE calendar ALTER COLUMN price TYPE FLOAT USING price::FLOAT;

-- create 12 categories based on dates
WITH date_categories AS
(SELECT *, 
CASE
  WHEN date <= DATE('2018-10-08') THEN 'SEP-OCT'
	WHEN date <= DATE('2018-11-08') THEN 'OCT-NOV'
  WHEN date <= DATE('2018-12-08') THEN 'NOV-DEC'
  WHEN date <= DATE('2019-01-08') THEN 'DEC-JAN'
  WHEN date <= DATE('2019-02-08') THEN 'JAN-FEB'
  WHEN date <= DATE('2019-03-08') THEN 'FEB-MAR'
  WHEN date <= DATE('2019-04-08') THEN 'MAR-APR'
	WHEN date <= DATE('2019-05-08') THEN 'APR-MAY'
  WHEN date <= DATE('2019-06-08') THEN 'MAY-JUNE'
  WHEN date <= DATE('2019-07-08') THEN 'JUNE-JULY'
  WHEN date <= DATE('2019-08-08') THEN 'JULY-AUG'
  WHEN date <= DATE('2019-09-08') THEN 'AUG-SEP'
	ELSE 'UNKNOWN'
END
AS
date_cat
FROM
calendar
)

-- find average prices and number of listings for each month range
SELECT date_cat, AVG(price) average, COUNT(*) free_listings FROM date_categories WHERE available = 't' GROUP BY date_cat;

-- the result shows SEP 8 -> OCT 8 is costly with few listings
-- the result shows JAN 8 -> FEB 8 is cheapest with small average price
-- and many listings
