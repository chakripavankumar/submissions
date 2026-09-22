-- Rebuild the passenger dimension as Slowly Changing Dimension Type 2 
-- (a new surrogate key per version, the stable business key, is_current, effective_from, effective_to). 
-- Apply stg_passenger_updates so that a changed tier or home airport expires the old version and opens a new one, 
-- and brand-new passengers are inserted
CREATE TABLE dw.DimPassenger (
    passenger_key INT IDENTITY(1, 1) PRIMARY KEY,
    -- surrogate key
    passenger_id INT NOT NULL,
    -- business key
    passenger_name VARCHAR(200),
    home_airport_code CHAR(3),
    frequent_flyer_tier VARCHAR(20),
    signup_date DATE,
    is_current BIT NOT NULL,
    effective_from DATE NOT NULL,
    effective_to DATE NOT NULL
);
INSERT INTO dw.DimPassenger (
        passenger_id,
        passenger_name,
        home_airport_code,
        frequent_flyer_tier,
        signup_date,
        is_current,
        effective_from,
        effective_to
    )
SELECT passenger_id,
    passenger_name,
    home_airport_code,
    frequent_flyer_tier,
    signup_date,
    1,
    signup_date,
    '9999-12-31'
FROM bronze_passengers;
DECLARE @load_date DATE = CAST(GETDATE() AS DATE);
UPDATE d
SET d.is_current = 0,
    d.effective_to = DATEADD(DAY, -1, @load_date)
FROM dw.DimPassenger d
    JOIN stg_passenger_updates s ON d.passenger_id = s.passenger_id
WHERE d.is_current = 1
    AND (
        d.frequent_flyer_tier <> s.frequent_flyer_tier
        OR d.home_airport_code <> s.home_airport_code
    );
INSERT INTO dw.DimPassenger (
        passenger_id,
        passenger_name,
        home_airport_code,
        frequent_flyer_tier,
        signup_date,
        is_current,
        effective_from,
        effective_to
    )
SELECT s.passenger_id,
    s.passenger_name,
    s.home_airport_code,
    s.frequent_flyer_tier,
    NULL,
    1,
    @load_date,
    '9999-12-31'
FROM stg_passenger_updates s
WHERE NOT EXISTS (
        SELECT 1
        FROM dw.DimPassenger d
        WHERE d.passenger_id = s.passenger_id
    );