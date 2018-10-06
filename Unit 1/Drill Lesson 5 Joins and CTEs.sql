-- Comments: On weather table each day has 5 temperature readings
-- Therefore joining on trips.start_date = weather.date may result
-- one trip many times as long as rain forecast was read.
-- SELECT * FROM weather WHERE date = '2016-04-22';
-- A trip_id uniquely identifies rows in trips table
--SELECT * FROM trips WHERE trip_id = '1173890';

--Q1 What are the three longest trips on rainy days?
SELECT DISTINCT trips.trip_id, trips.duration, trips.zip_code, weather.date FROM trips JOIN weather ON DATE(trips.start_date) = DATE(weather.date) WHERE weather.events = 'Rain' ORDER BY trips.duration DESC LIMIT 3;
-- Comment: Notice that 
-- status.bikes_available + docks_available = stations.no_of_docks
-- A station is full when docks_available = 0

-- Q2 Which station is full most often?
SELECT stations.station_id, COUNT(*) count_full FROM stations JOIN status ON stations.station_id = status.station_id WHERE status.docks_available = 0 GROUP BY stations.station_id ORDER BY count_full DESC LIMIT 1;

-- Comment How many stations are there?
-- There are 67 stations
-- SELECT name FROM stations;
-- Only 63 of them have had trips before.
-- SELECT COUNT(DISTINCT stations.name) FROM stations JOIN trips -- on stations.name = trips.start_station;

-- Q3 Return a list of stations with a count of number of trips
-- starting at that station but ordered by dock count.
-- Comment I included only the 63 stations who have had at least
-- one trip
SELECT stations.name, stations.city, stations.dockcount, COUNT(*) total_duration FROM stations JOIN trips ON stations.name = trips.start_station GROUP BY stations.name, stations.city, stations.dockcount ORDER BY stations.dockcount DESC;

--(Challenge) What's the length of the longest trip for each day -- it rains anywhere?



-- How many times did it rain on specific day ? it cannot be more -- than 5 times because we take 5 measurements per day
-- 5 times
--SELECT events FROM weather WHERE date = '2016-04-22';
-- only once
--SELECT events FROM weather WHERE date = '2015-09-02';
-- 4 times
--SELECT events FROM weather WHERE date = '2015-12-18';

-- On the date 2015-09-02, trip_id 915296 happened.
-- since we make 5 measurements per day, joining weather
-- table with a single trip row results in 5 rows. Specifically, 
-- for this scenario: on the date that this trip happened
-- it rained 4 of the measurements and didn't rain in
-- one of them. Check the two queries below.
-- rained
-- SELECT weather.date, trips.trip_id, trips.duration FROM trips -- JOIN weather ON DATE(trips.start_date) = DATE(weather.date) -- -- WHERE weather.events = 'Rain' AND weather.date = '2015-09-02' -- AND trips.trip_id = '915296' ORDER BY weather.date;
-- didn't rain
-- SELECT weather.date, trips.trip_id, trips.duration FROM trips -- JOIN weather ON DATE(trips.start_date) = DATE(weather.date) -- -- WHERE weather.events <> 'Rain' AND weather.date = '2015-09-02' -- AND trips.trip_id = '915296' ORDER BY weather.date;

--Answer to the question
WITH

date_duration

AS
(
	SELECT DISTINCT weather.date, trips.trip_id, trips.duration FROM
	trips JOIN weather ON DATE(trips.start_date) = DATE(weather.date)
	WHERE weather.events = 'Rain'
)

SELECT date, max(duration) FROM date_duration GROUP BY date ORDER BY max DESC;