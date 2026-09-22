# Vayu Air — Warehouse Design Challenge

Question 7 — Curate

7(a) Medallion Architecture

The Vayu Air data pipeline follows the Medallion Architecture, where data moves through three logical layers:

┌──────────────────────────────┐
│ BRONZE │
│ Raw Source Data │
└──────────────┬───────────────┘
│
│ Cleaning & Transformation
▼
┌──────────────────────────────┐
│ SILVER │
│ Cleaned & Conformed Data │
│ Historical Data │
└──────────────┬───────────────┘
│
│ Dimensional Modeling
▼
┌──────────────────────────────┐
│ GOLD │
│ Analytics-Ready Star Schema │
└──────────────┬───────────────┘
│
▼
Reports / Dashboards

Table-to-Layer Mapping

Layer Table Reason
Bronze bronze_airports Raw airport data landed directly from the source system.
Bronze bronze_aircraft Raw aircraft data from the source system.
Bronze bronze_passengers Raw/current passenger data from the source system.
Bronze bronze_flights Raw flight data from the source system.
Bronze bronze_bookings Raw booking and ticket data from the source system.
Silver stg_passenger_updates Staging data used to process passenger changes.
Silver DimPassenger Cleaned and conformed passenger dimension that maintains historical changes using SCD Type 2.
Gold DimDate Analytics-ready date dimension used for reporting and filtering.
Gold DimFlight Analytics-ready flight dimension used by the star schema.
Gold DimAircraft Analytics-ready aircraft dimension used for analysis.
Gold DimAirport Analytics-ready airport dimension used for analysis.
Gold DimCity Normalized geography dimension supporting airport and city analysis.
Gold DimCountry Normalized geography dimension supporting country-level analysis.
Gold FactTicketSales Central analytics-ready sales fact used for reporting and dashboards.

Summary

Bronze contains the raw source data with minimal transformation.

Silver contains cleaned, staged, and conformed data. The passenger dimension is maintained here with SCD Type 2 to preserve historical passenger changes.

Gold contains the final dimensional model, including the fact and dimensions used by analytics, reporting, and dashboards.

⸻

7(b) Data Contract — bronze_bookings

A data contract defines the expected structure and rules of a data feed between the team producing the data and the team consuming it.

The contract for the bronze_bookings feed is defined below.

Schema

Column Data Type Description Rules / Allowed Values
booking_id INT Unique booking identifier Must be unique
passenger_id INT Passenger business key Valid passenger ID
flight_id INT Flight business key Valid flight ID
booking_date DATE Date the ticket was booked Valid date
travel_date DATE Date of travel Valid date
fare_class VARCHAR Fare category Economy, Premium Economy, Business, First
fare_amount DECIMAL Base fare in INR Non-negative amount
tax_amount DECIMAL Taxes and fees in INR Non-negative amount
booking_status VARCHAR Current booking status Confirmed, Cancelled, NoShow
miles_earned INT Loyalty miles credited Non-negative integer

Allowed Values

fare_class

The feed accepts only the following values:

Economy
Premium Economy
Business
First

booking_status

The feed accepts only:

Confirmed
Cancelled
NoShow

For revenue reporting, only Confirmed bookings are considered revenue according to the warehouse requirements.

Freshness / Delivery SLA

The bronze_bookings feed must be delivered daily by 06:00 IST, containing all booking data available through the previous business day.

Data Owner

Owner: Vayu Air Booking Systems / Booking Data Engineering Team

The owner is responsible for maintaining the feed schema, data quality, and communicating changes to downstream consumers.

Change Management

Breaking Change

Example: Renaming or removing an existing column such as fare_amount.

This is a breaking change because downstream warehouse transformations, queries, and reports depend on the existing column name and structure.

Such changes must be communicated to downstream consumers before implementation, with an agreed migration plan.

Non-Breaking Change

Example: Adding a new optional/nullable column such as:

promotion_code VARCHAR(50)

This is considered non-breaking because existing consumers can continue using the columns they already depend on without modification.

⸻

Assignment Structure

The complete Warehouse Design Challenge is organized as follows:

Vayu Air — Warehouse Design Challenge
│
├── Q1 — Design
│ └── Define fact grain, dimensions, keys, and measures
│
├── Q2 — Star Schema DDL
│ └── Create fact and dimension tables
│
├── Q3 — Load
│ └── Load dimensions and fact with surrogate keys
│
├── Q4 — Geography Snowflake
│ └── Normalize Airport → City → Country
│
├── Q5 — SCD Type 2
│ └── Preserve passenger history
│
├── Q6 — Partitioning
│ └── Partition FactTicketSales by date
│
└── Q7 — Curate
│
├── 7(a) Medallion Architecture
│ └── Map tables to Bronze / Silver / Gold
│
└── 7(b) Data Contract
└── Define the bronze_bookings feed contract

Conclusion

The Vayu Air warehouse follows a clear progression from raw source data in Bronze, through cleaned and historically managed data in Silver, to an analytics-ready dimensional model in Gold. The bronze_bookings data contract establishes the schema, valid values, delivery expectations, ownership, and rules for managing future changes to the source feed.
