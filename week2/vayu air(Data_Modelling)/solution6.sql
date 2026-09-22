-- The sales fact is the biggest table in the warehouse. Partition it by date using a partition function and a partition scheme. 
-- Then run two queries: one that filters on the partition key, and one that filters on a non-partition column. 
-- Acceptance criteria: a partition function and scheme exist and the fact sits on the scheme; you show, using the actual 
--execution plan, that the first query prunes to a small number of partitions and the second does  not, and you explain why.
CREATE PARTITION FUNCTION pf_FactTicketSales_DateKey (INT) AS RANGE RIGHT FOR
VALUES (
        20260101,
        20260201,
        20260301,
        20260401,
        20260501,
        20260601,
        20260701,
        20260801,
        20260901,
        20261001,
        20261101,
        20261201,
        20270101
    );
CREATE PARTITION SCHEME ps_FactTicketSales_DateKey AS PARTITION pf_FactTicketSales_DateKey ALL TO ([PRIMARY]);


CREATE TABLE dw.FactTicketSales (
    booking_id INT NOT NULL,
    booking_date_key INT NOT NULL,
    travel_date_key INT NOT NULL,
    passenger_key INT NOT NULL,
    flight_key INT NOT NULL,
    origin_airport_key INT NOT NULL,
    destination_airport_key INT NOT NULL,
    aircraft_key INT NOT NULL,
    fare_amount DECIMAL(12, 2) NOT NULL,
    tax_amount DECIMAL(12, 2) NOT NULL,
    miles_earned INT NOT NULL
) ON ps_FactTicketSales_DateKey(booking_date_key);



SELECT *
FROM dw.FactTicketSales
WHERE passenger_key = 101;

