# StayNest — Azure Data Factory Challenge

Session 9 — Azure Data Factory and Data Orchestration

This project demonstrates a simple data movement and orchestration workflow using Azure Data Factory (ADF).

The objective was to automate the movement of StayNest’s hotel booking files from a raw folder into a bronze folder in Azure Storage instead of copying the files manually.

The assignment also demonstrates how Azure Data Factory can inspect a folder using the Get Metadata activity.

⸻

1. Problem Statement

StayNest receives daily CSV files from its operational systems:

- hotels.csv
- customers.csv
- bookings.csv

Initially, these files were being copied manually into the data lake.

The goal of this challenge was to create an Azure Data Factory solution that can:

1. Connect Azure Data Factory to Azure Storage.
2. Create reusable datasets for the source and destination.
3. Copy hotels.csv from the raw folder to the bronze folder.
4. Inspect the raw folder and return the files present in it.
5. Understand the basic building blocks of Azure Data Factory orchestration.

⸻

2. Technologies Used

- Azure Data Factory
- Azure Storage Account
- Azure Blob Storage
- CSV / Delimited Text
- Azure Data Factory Studio

⸻

3. Azure Data Factory Concepts

Before creating the pipeline, I learned the difference between three important Azure Data Factory concepts.

Linked Service

A Linked Service defines how Azure Data Factory connects to an external service.

In this assignment, the Linked Service connects Azure Data Factory to the Azure Storage Account.

Azure Data Factory
|
| Linked Service
v
Azure Storage Account

I created the following Linked Service:

LS_StayNest_Storage

Dataset

A Dataset represents the data or location that an activity works with.

For example:

Linked Service
|
v
Azure Storage
|
+---- raw/hotels.csv
|
+---- bronze/

The Linked Service tells ADF how to connect, while the Dataset tells ADF what data or location to use.

Activity

An Activity is the actual operation performed by Azure Data Factory.

In this challenge, I used:

- Copy Data
- Get Metadata

The Copy Data activity copies data from a source to a destination, while Get Metadata reads information about a file or folder.

⸻

4. Storage Structure

The Azure Storage Account was organized into two folders:

Storage Account
│
├── raw/
│ ├── hotels.csv
│ ├── customers.csv
│ └── bookings.csv
│
└── bronze/

The objective of the Copy activity was to copy:

raw/hotels.csv

to:

bronze/hotels.csv

The original file remains in the raw folder because the ADF Copy activity copies the data rather than deleting the source.

⸻

5. Task 1 — Create a Linked Service

Objective

Create a reusable connection between Azure Data Factory and the Azure Storage Account.

Steps

I opened Azure Data Factory Studio and navigated to:

Manage
→ Linked services
→ New

I selected:

Azure Blob Storage

as the connector.

I configured the connection using the authentication method available in my Azure environment.

The Linked Service was named:

LS_StayNest_Storage

I then used Test connection to verify that Azure Data Factory could successfully connect to the Storage Account.

The connection test was successful.

Screenshot

Result

The Linked Service provides a reusable connection that can be used by multiple datasets.

LS_StayNest_Storage
|
+---- ds_source
|
+---- ds_sink
|
+---- ds_raw_folder

This means I did not have to create a separate storage connection for every dataset.

⸻

6. Task 2 — Create Datasets

The second task was to create two Delimited Text datasets.

The datasets were:

ds_source
ds_sink

Both datasets use the same Linked Service:

LS_StayNest_Storage

⸻

6.1 Create ds_source

Objective

Create a dataset pointing specifically to:

raw/hotels.csv

Steps

I navigated to:

Author
→ Datasets
→ New dataset

I selected:

Azure Blob Storage

and then:

DelimitedText

I named the dataset:

ds_source

I selected:

LS_StayNest_Storage

as the Linked Service.

The file location was configured as:

Directory: raw
File: hotels.csv

I also enabled:

First row as header

This tells ADF that the first row of the CSV contains column names rather than actual data.

Screenshot

⸻

6.2 Create ds_sink

Objective

Create a dataset pointing to the destination bronze folder.

I created another:

Azure Blob Storage → DelimitedText

dataset.

The dataset name was:

ds_sink

I again selected:

LS_StayNest_Storage

as the Linked Service.

The location was configured as:

Directory: bronze
File: empty

The file name was intentionally left blank because this dataset represents the destination folder.

I also enabled:

First row as header

Screenshot

⸻

7. Dataset Structure

After completing Task 2, the setup looked like this:

                    Azure Storage
                         |
              LS_StayNest_Storage
                         |
              +----------+----------+
              |                     |
              v                     v
         ds_source              ds_sink
              |                     |
              v                     v
       raw/hotels.csv            bronze/

The important difference is:

ds_source → specific file
ds_sink → destination folder

⸻

8. Task 3 — Copy the File

Objective

Create an Azure Data Factory pipeline that copies:

raw/hotels.csv

into:

bronze/

⸻

Step 1 — Create the Pipeline

I navigated to:

Author
→ Pipelines
→ New

I created a new pipeline.

I added a:

Copy data

activity from the Activities panel.

The pipeline was named:

PL_Copy_Hotels

Screenshot

⸻

9. Configure the Copy Activity

Source

I selected the Copy Data activity and opened the Source section.

For the source dataset, I selected:

ds_source

This dataset points to:

raw/hotels.csv

Sink

I opened the Sink section.

For the sink dataset, I selected:

ds_sink

This dataset points to:

bronze/

Therefore, the Copy activity was configured as:

Source
|
v
ds_source
|
v
raw/hotels.csv
|
| COPY
v
ds_sink
|
v
bronze/

Screenshot

⸻

10. Debug the Copy Pipeline

After configuring the Copy activity, I clicked:

Debug

Azure Data Factory executed the pipeline.

The Copy activity completed successfully and displayed a green check mark.

Screenshot

⸻

11. Verify the Destination

After the pipeline completed successfully, I opened the Azure Storage Account and checked the bronze folder.

The copied file was present:

bronze/
└── hotels.csv

The original file was still present:

raw/
└── hotels.csv

Therefore, the Copy activity successfully copied the data into the bronze layer while keeping the original raw file.

Screenshot

⸻

12. Task 4 — Get Metadata

Objective

The fourth task was to inspect the raw folder and retrieve the list of files inside it.

The expected files were:

hotels.csv
customers.csv
bookings.csv

For this task, I created another dataset called:

ds_raw_folder

Unlike ds_source, this dataset points to the folder only.

⸻

13. Create ds_raw_folder

I created a new dataset using:

Author
→ Datasets
→ New dataset

I selected:

Azure Blob Storage
→ DelimitedText

The dataset was named:

ds_raw_folder

I selected the existing Linked Service:

LS_StayNest_Storage

The location was configured as:

Directory: raw
File: empty

The file name was deliberately left empty because the purpose of this dataset was to represent the entire raw folder.

I also enabled:

First row as header

Screenshot

⸻

14. Add Get Metadata Activity

I returned to the pipeline and opened the Activities panel.

I searched for:

Get Metadata

and dragged the activity onto the pipeline canvas.

The activity was configured to use:

ds_raw_folder

as its dataset.

Screenshot

⸻

15. Configure Child Items

Inside the Get Metadata activity settings, I selected:

Dataset:
ds_raw_folder

Then I went to:

Field list

and added:

Child items

Child items tells Azure Data Factory to return the files and folders contained inside the selected folder.

The configuration was therefore:

Get Metadata
|
v
ds_raw_folder
|
v
raw/
|
v
Child items

Screenshot

⸻

16. Debug Get Metadata

I clicked:

Debug

and waited for the Get Metadata activity to complete.

The activity completed successfully and displayed a green check mark.

Screenshot

⸻

17. Inspect the Output

I opened the Output of the Get Metadata activity.

The output contained the childItems collection.

The result showed the files present in the raw folder:

hotels.csv
customers.csv
bookings.csv

The output was similar to:

{
"childItems": [
{
"name": "hotels.csv",
"type": "File"
},
{
"name": "customers.csv",
"type": "File"
},
{
"name": "bookings.csv",
"type": "File"
}
]
}

The exact order of the files may vary.

Screenshot

⸻

18. Final Architecture

The complete solution created during the challenge can be represented as:

                         Azure Data Factory
                                |
                    LS_StayNest_Storage
                                |
             +------------------+------------------+
             |                  |                  |
             v                  v                  v
        ds_source           ds_sink         ds_raw_folder
             |                  |                  |
             v                  v                  v
     raw/hotels.csv          bronze/              raw/
             |                  |                  |
             |                  |                  |
             +------ Copy ------+                  |
                                                   |
                                                   v
                                             Get Metadata
                                                   |
                                                   v
                                             Child Items
                                                   |
                              +--------------------+--------------------+
                              |                    |                    |
                         hotels.csv          customers.csv        bookings.csv

⸻

19. What I Learned

Through this challenge, I learned the basic building blocks of Azure Data Factory.

1. Linked Service

A Linked Service defines the connection to an external system such as Azure Storage.

Linked Service = How to connect?

2. Dataset

A Dataset identifies the data or location that an activity works with.

Dataset = What data/location?

3. Copy Data

The Copy Data activity is used to copy data between a source and destination.

Source → Copy Data → Sink

4. Get Metadata

Get Metadata can inspect a file or folder and return information about it.

Using:

Child Items

allows ADF to retrieve the contents of a folder.

5. Debug

The Debug option allows a pipeline to be executed manually so that I can verify whether the activities are working correctly before publishing or scheduling the pipeline.

⸻

20. Final Result

The StayNest Azure Data Factory solution successfully:

- Connected ADF to Azure Storage using a Linked Service.
- Created reusable CSV datasets.
- Copied hotels.csv from raw to bronze.
- Verified the Copy activity using Debug.
- Created a dataset representing the raw folder.
- Used Get Metadata to inspect the folder.
- Retrieved the three files using Child Items:
  - hotels.csv
  - customers.csv
  - bookings.csv

The final storage structure was:

Azure Storage
│
├── raw/
│ ├── hotels.csv
│ ├── customers.csv
│ └── bookings.csv
│
└── bronze/
└── hotels.csv

⸻

Conclusion

This exercise provided a practical introduction to:

- Azure Data Factory
- Linked Services
- Datasets
- Copy Data activities
- Get Metadata activities
- Data movement
- Folder metadata inspection
- Basic data orchestration

The challenge helped me understand how Azure Data Factory can automate data movement and inspect data sources without manually copying individual files.
