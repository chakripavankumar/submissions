-- Build DateKey as YEAR(d)*10000 + MONTH(d)*100 + DAY(d). To load the fact, 
-- join bronze_bookings to each dimension on the business key and select the dimension's surrogate key
-- till now we created empty warehouse tables. Q3 fills those tables with data.
INSERT INTO dw.DimAirport (
        airport_code,
        airport_name,
        city,
        country,
        region
    )
SELECT airport_code,
    airport_name,
    city,
    country,
    region
FROM bronze_airports;
INSERT INTO dw.DimAircraft (
        aircraft_code,
        model,
        manufacturer,
        seat_capacity
    )
SELECT aircraft_code,
    model,
    manufacturer,
    seat_capacity
FROM bronze_aircraft;
INSERT INTO dw.DimPassenger(
        passenger_id,
        passenger_name,
        home_airport_code,
        frequent_flyer_tier,
        signup_date
    )
SELECT passenger_id,
    passenger_name,
    home_airport_code,
    frequent_flyer_tier,
    signup_date
from bronze_passengers;
INSERT INTO dw.DimFlight (
        flight_id,
        flight_number,
        origin_airport_code,
        dest_airport_code,
        aircraft_code,
        flight_date
    )
SELECT flight_id,
    flight_number,
    origin_airport_code,
    dest_airport_code,
    aircraft_code,
    flight_date
FROM bronze_flights;
INSERT INTO dw.DimDate (
        date_key,
        calendar_date,
        year,
        month,
        day
    )
SELECT DISTINCT year(d) * 10000 + month(d) * 100 + day(d) as date_key,
    d AS calendar_date,
    YEAR(d),
    MONTH(d),
    DAY(d)
FROM(
        SELECT booking_date AS d
        FROM bronze_bookings
        UNION
        SELECT travel_date AS d
        FROM bronze_bookings
        UNION
        SELECT flight_date AS d
        FROM bronze_flights
    ) dates;
INSERT INTO dw.FactTicketSales (
        booking_id,
        booking_date_key,
        travel_date_key,
        passenger_key,
        flight_key,
        origin_airport_key,
        destination_airport_key,
        aircraft_key,
        fare_amount,
        tax_amount,
        miles_earned
    )
SELECT b.booking_id,
    bd.date_key,
    td.date_key,
    p.passenger_key,
    f.flight_key,
    origin_airport.airport_key,
    destination_airport.airport_key,
    aircraft.aircraft_key,
    b.fare_amount,
    b.tax_amount,
    b.miles_earned
FROM bronze_bookings b
    JOIN dw.DimPassenger p ON b.passenger_id = p.passenger_id
    JOIN dw.DimFlight f ON b.flight_id = f.flight_id
    JOIN dw.DimDate bd ON b.booking_date = bd.calendar_date
    JOIN dw.DimDate td ON b.travel_date = td.calendar_date
    JOIN dw.DimAirport origin_airport ON f.origin_airport_code = origin_airport.airport_code
    JOIN dw.DimAirport destination_airport ON f.dest_airport_code = destination_airport.airport_code
    JOIN dw.DimAircraft aircraft ON f.aircraft_code = aircraft.aircraft_code;


