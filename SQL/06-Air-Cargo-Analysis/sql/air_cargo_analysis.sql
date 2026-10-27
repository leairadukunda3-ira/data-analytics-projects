-- create database
CREATE DATABASE air_cargo;

-- use database
USE air_cargo;

-- Q1. Create an ER diagram for the given airlines database.
-- ER Diagram was created in word file .i will share it as a seperate document

-- Q2. Write a query to create route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport,
--  destination_airport, aircraft_id, and distance_miles. Implement the check constraint for the flight number and unique constraint for 
-- the route_id fields. Also, make sure that the distance miles field is greater than 0.

CREATE TABLE route_details(
route_id INT ,
flight_num INT ,
origin_airport VARCHAR(10) ,
destination_airport VARCHAR(10) ,
aircraft_id VARCHAR(20) ,
distance_miles INT ,


CONSTRAINT uq_route_id UNIQUE (route_id),
CONSTRAINT chk_flight_num CHECK (flight_num BETWEEN 1000 AND 9999),
CONSTRAINT chk_distance_miles CHECK (distance_miles >0)

);


-- Q3 Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data  from 
-- the passengers_on_flights table.
SELECT *
FROM passengers_on_flights
WHERE route_id BETWEEN 01 AND 25
ORDER BY route_id, customer_id;



-- Q4 Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
SELECT class_id,COUNT(*) as number_of_passengers,
SUM(Price_per_ticket* no_of_tickets) AS Total_revenue
FROM ticket_details
WHERE class_id ='Bussiness';


-- Q5 Write a query to display the full name of the customer by extracting the first name and last name from the customer table.


SELECT customer_id,
CONCAT(first_name,' ',last_name) AS Full_name
FROM customer;



-- Q6 Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.

SELECT c.customer_id,
c.first_name,
c.last_name
FROM customer c
INNER JOIN  ticket_details t
ON c.customer_id = t.customer_id
ORDER BY c.customer_id;


-- Q7 Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
SELECT 
    t.customer_id,
    c.first_name,
    c.last_name,
    t.brand
FROM ticket_details t
INNER JOIN customer c
    ON t.customer_id = c.customer_id
WHERE t.brand = 'Emirates'
ORDER BY t.customer_id;


-- Q8 Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause 
-- on the passengers_on_flights table.

SELECT customer_id
FROM passengers_on_flights
GROUP BY customer_id
HAVING SUM(class_id = 'Economy Plus') > 0;



-- Q9 Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
SELECT 
IF(SUM(Price_per_ticket * no_of_tickets ) > 10000,
   'Revenue crossed 10000',
   'Revenue did not cross 10000') AS Revenue_Status
FROM ticket_details;

-- Q10 Write a query to create and grant access to a new user to perform operations on a database.


CREATE USER 'student2'@'localhost'IDENTIFIED BY 'AirCargo@456';

GRANT  ALL PRIVILEGES
ON air_cargo.*
TO 'student2'@'localhost';

FLUSH PRIVILEGES;


-- Q11 Write a query to find the maximum ticket price for each class using window functions on the ticket_details table.


SELECT 
    class_id,
    price_per_ticket,
    MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_price_in_class
FROM ticket_details;

-- Q12 Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.

-- First create an index
CREATE INDEX idx_passengers_route_id
ON passengers_on_flights(route_id);

-- Then query
SELECT *
FROM passengers_on_flights
WHERE route_id = 4;


-- Q13 For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.

EXPLAIN ANALYZE
SELECT *
FROM passengers_on_flights
WHERE route_id = 4;


-- Q14 Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function.

SELECT
customer_id,
aircraft_id,
SUM(no_of_tickets * Price_per_ticket ) AS Total_price_tickects
FROM ticket_details
GROUP BY customer_id,aircraft_id WITH ROLLUP;




-- Q15 Write a query to create a view with only business class customers along with the brand of airlines.

CREATE VIEW BUSSINESS_CLASS AS
SELECT c.customer_id,
c.first_name,
c.last_name,
t.class_id,
t.brand
FROM customer c
JOIN ticket_details t
ON c.customer_id = t.customer_id
WHERE t.class_id ='Bussiness';

-- TO VIEW
SELECT * FROM BUSSINESS_CLASS;



-- Q16 Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. Also, return 
-- an error message if the table doesn't exist.


DELIMITER //
CREATE PROCEDURE get_passengers_by_route_range (
    IN p_start_route INT,
    IN p_end_route INT
)
BEGIN
    IF EXISTS (
        SELECT 1
        FROM information_schema.tables
        WHERE table_schema = DATABASE()
          AND table_name = 'passengers_on_flights'
    ) THEN
        SELECT *
        FROM passengers_on_flights
        WHERE route_id BETWEEN p_start_route AND p_end_route
        ORDER BY route_id, customer_id;
    ELSE
        SELECT 'Table passengers_on_flights does not exist' AS message;
    END IF;

    
END //

DELIMITER ;

-- To run procedure
CALL get_passengers_by_route_range(1, 25);

     

-- Q17 Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.

DELIMITER //

CREATE PROCEDURE travel_distance()

BEGIN
 SELECT * 
 FROM routes
 WHERE distance_miles >2000
 ORDER BY distance_miles DESC;
 END//
 
 DELIMITER ;
 
 -- TO RUN IT
 CALL travel_distance();


-- Q18 Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, 
-- short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.


DELIMITER //

CREATE PROCEDURE distance_categories()

BEGIN
SELECT 
route_id,
flight_num,
destination_airport,
aircraft_id,
distance_miles,
     
CASE 
    WHEN distance_miles >=0 AND distance_miles<=2000 THEN 'SDT'
    WHEN distance_miles > 2000 AND distance_miles<= 6500 THEN 'IDT'
	WHEN distance_miles > 6500 THEN 'LDT'
	ELSE ' UNKNOWN'
 
 END AS category
 FROM routes
 ORDER BY route_id; 

END //

DELIMITER ;

-- to run prosedure

CALL distance_categories();

-- Q19 Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided 
-- for the specific class using a stored function in stored procedure on the ticket_details table.Condition:
-- If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No


-- CREATE STORED FUNCTION

DELIMITER //

CREATE FUNCTION get_check_serives1(p_class_id VARCHAR(30))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
RETURN IF (p_class_id IN ('Bussiness','Economy Plus'),'Yes','No');
   
END //

DELIMITER ;

--  PROCEDURE USING FUNCTION

DELIMITER //

CREATE PROCEDURE  get_ticket_extra_service()

BEGIN 

SELECT p_date,
customer_id,
class_id,
get_check_serives1(class_id) AS complimemtary_service
FROM  ticket_details
ORDER BY p_date,customer_id;

END //

DELIMITER ;


-- TO RUN STORED PROCEDURE
CALL get_ticket_extra_service();


-- Q20. Write a query to extract the first record of the customer whose last name ends with Scott using a cursor from the customer table.


DELIMITER //

CREATE PROCEDURE get_customer_name()

BEGIN 
DECLARE v_customer_id INT;
DECLARE v_first_name VARCHAR(50);
DECLARE v_last_name VARCHAR(50);
DECLARE v_dob VARCHAR(20);
DECLARE v_gender CHAR(1);
DECLARE done INT DEFAULT 0;

DECLARE cur CURSOR FOR
    SELECT customer_id, first_name, last_name, date_of_birth, gender
        FROM customer
        WHERE last_name LIKE '%Scott'
        ORDER BY customer_id;


DECLARE CONTINUE HANDLER FOR NOT FOUND SET done =1;

OPEN cur;
FETCH cur INTO v_customer_id, v_first_name, v_last_name, v_dob, v_gender;

IF done = 0 THEN
      SELECT
			v_customer_id AS customer_id,
            v_first_name AS first_name,
            v_last_name AS last_name,
            v_dob AS date_of_birth,
            v_gender AS gender;
   
ELSE
   SELECT " Sorry no customer found" AS message;

END IF;

CLOSE cur;

END //

DELIMITER ;


-- TO run procedure
CALL get_customer_name();


























