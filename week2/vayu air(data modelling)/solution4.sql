-- Snowflake the geography. 
-- Normalise the airport dimension into three linkedtables: 
-- airport, city, and country. Load them, and write one sentence on the trade-off you are making. 
-- Acceptance criteria: three linked tables with foreign keys; a query can resolve an airport all the way up to its country.
CREATE TABLE dw.DimCountry(
    country_key INT IDENTITY(1, 1) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    CONSTRAINT UQ_DimCountry_country_name UNIQUE(country_name)
);
CREATE TABLE dw.DimCity(
    city_key INT IDENTITY(1, 1) PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    country_key INT NOT NULL,
    CONSTRAINT FK_DimCity_Country FOREIGN KEY (country_key) REFERENCES dw.DimCountry(country_key)
);
CREATE TABLE dw.DimAirport (
    airport_key INT IDENTITY(1, 1) PRIMARY KEY,
    airport_code CHAR(3) NOT NULL,
    airport_name VARCHAR(200) NOT NULL,
    city_key INT NOT NULL,
    CONSTRAINT UQ_DimAirport_airport_code UNIQUE (airport_code),
    CONSTRAINT FK_DimAirport_City FOREIGN KEY (city_key) REFERENCES dw.DimCity(city_key)
);
INSERT INTO dw.DimCountry (country_name)
SELECT DISTINCT country
FROM bronze_airports;
INSERT INTO dw.DimCity (city_name, country_key)
SELECT DISTINCT a.city,
    c.country_key
FROM bronze_airports a
    JOIN dw.DimCountry c ON a.country = c.country_name;
INSERT INTO dw.DimAirport (
        airport_code,
        airport_name,
        city_key
    )
SELECT a.airport_code,
    a.airport_name,
    c.city_key
FROM bronze_airports a
    JOIN dw.DimCity c ON a.city = c.city_name;
SELECT a.airport_code,
    a.airport_name,
    c.city_name,
    co.country_name
FROM dw.DimAirport a
    JOIN dw.DimCity c ON a.city_key = c.city_key
    JOIN dw.DimCountry co ON c.country_key = co.country_key;
-- Snowflaking reduces repeated geography values and improves normalization, 
-- but it requires additional joins when querying from an airport to its city and country.