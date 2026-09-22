-- Create a dw schema and write the star schema DDL:
-- a central FactTicketSales at your declared grain plus the dimensions it needs (date, passenger, flight, 
-- airport, aircraft). Use surrogate keys on the dimensions and foreign keys on the fact, and keep 
-- only additive measures on the fact. Acceptance criteria: fact at the declared grain with 
-- surrogate-key foreign keys; each dimension has a surrogate primary key and keeps its business key.
CREATE SCHEMA dw;
GO CREATE TABLE dw.DimDate (
        date_key INT PRIMARY KEY,
        calendar_date DATE NOT NULL UNIQUE,
        year INT NOT NULL,
        month INT NOT NULL,
        day INT NOT NULL
    );
CREATE TABLE dw.DimPassenger (
    passenger_key INT IDENTITY(1, 1) PRIMARY KEY,
    passenger_id INT NOT NULL,
    passenger_name VARCHAR(200) NOT NULL,
    home_airport_code VARCHAR(3),
    frequent_flyer_tier VARCHAR(40),
    signup_date DATE,
    CONSTRAINT UQ_DimPassenger_passenger_id UNIQUE(passenger_id)
);
CREATE TABLE dw.DimFlight (
    flight_key INT IDENTITY(1, 1) PRIMARY KEY,
    flight_id INT NOT NULL,
    flight_number VARCHAR(20) NOT NULL,
    origin_airport_code CHAR(3) NOT NULL,
    dest_airport_code CHAR(3) NOT NULL,
    aircraft_code VARCHAR(20) NOT NULL,
    flight_date DATE NOT NULL CONSTRAINT UQ_DimFlight_flight_id UNIQUE(flight_id)
);
CREATE TABLE dw.DimAirport (
    airport_key INT IDENTITY(1, 1) PRIMARY KEY,
    airport_code CHAR(3) NOT NULL,
    airport_name VARCHAR(200) NOT NULL,
    city VARCHAR(100),
    country VARCHAR(100),
    region VARCHAR(100),
    CONSTRAINT UQ_DimAirport_airport_code UNIQUE (airport_code)
);
CREATE TABLE dw.DimAircraft (
    aircraft_key INT IDENTITY(1, 1) PRIMARY KEY,
    aircraft_code VARCHAR(50) NOT NULL,
    model VARCHAR(100),
    manufacturer VARCHAR(100),
    seat_capacity INT,
    CONSTRAINT UQ_DimAircraft_aircraft_code UNIQUE(aircraft_code)
);
CREATE TABLE dw.FactTicketSales (
    ticket_sales_key BIGINT IDENTITY(1, 1) PRIMARY KEY,
    booking_id INT NOT NULL,
    booking_date_key INT NOT NULL,
    travel_date_key INT NOT NULL,
    passenger_key INT NOT NULL,
    flight_key INT NOT NULL,
    origin_airport_key INT NOT NULL,
    destination_airport_key INT NOT NULL,
    aircraft_key INT NOT NULL,
    fare_amount DECIMAL(18, 2) NOT NULL,
    tax_amount DECIMAL(18, 2) NOT NULL,
    miles_earned INT NOT NULL,
    CONSTRAINT UQ_FactTicketSales_booking_id UNIQUE (booking_id),
    CONSTRAINT FK_FactTicketSales_BookingDate FOREIGN KEY (booking_date_key) REFERENCES dw.DimDate(date_key),
    CONSTRAINT FK_FactTicketSales_TravelDate FOREIGN KEY (travel_date_key) REFERENCES dw.DimDate(date_key),
    CONSTRAINT FK_FactTicketSales_Passenger FOREIGN KEY (passenger_key) REFERENCES dw.DimPassenger(passenger_key),
    CONSTRAINT FK_FactTicketSales_Flight FOREIGN KEY (flight_key) REFERENCES dw.DimFlight(flight_key),
    CONSTRAINT FK_FactTicketSales_OriginAirport FOREIGN KEY(origin_airport_key) REFERENCES dw.DimAirport(airport_key),
    CONSTRAINT FK_FactTicketSales_DestinationAirport FOREIGN KEY (destination_airport_key) REFERENCES dw.DimAirport(airport_key),
    CONSTRAINT FK_FactTicketSales_Aircraft FOREIGN KEY (aircraft_key) REFERENCES dw.DimAircraft(aircraft_key),
);