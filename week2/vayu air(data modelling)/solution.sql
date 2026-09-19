CREATE DATABASE VayuAir;

-- Write the grain as a comment first, the way the session showed. One booking is one ticket on one flight. 
-- Everything describing the who, what, where and when is a dimension key; the numbers you would SUM are measures

-- Grain:
-- One row represents one ticket/booking sold to one passenger for one flight.

-- Dimension keys / descriptive attributes:
-- booking_id
-- passenger_id
-- flight_id
-- booking_date
-- travel_date
-- fare_class
-- booking_status
-- flight_number
-- origin_airport_code
-- dest_airport_code
-- aircraft_code
-- flight_date

-- Measures:
-- fare_amount
-- tax_amount
-- miles_earned

-- Additive measures:
-- fare_amount, tax_amount, and miles_earned are additive and can be SUMmed
-- across the appropriate dimensions. An average fare is an example of a
-- non-additive value because averages should not simply be added together.

--                  FACT SALES
--                     |
--        ┌────────────┼────────────┐
--        ↓            ↓            ↓
--   WHO/WHAT       WHEN          HOW MUCH
--        |            |              |
--    Passenger    Date Keys       Measures
--    Flight       Booking Date    Fare
--    Aircraft     Travel Date     Tax
--    Airport                     Miles
--    Fare Class
--    Status