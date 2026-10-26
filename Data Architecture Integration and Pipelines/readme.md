# Data Architecture: Integration and Pipelines

This repository contains all the course files needed for the Pluralsight course *Data Architecture: Integration and Pipelines*.

The Github repo can be found at 

# Pre-course Configuration

All of the pre-config files can be found in the **00_Course_Setup** folder. To set up the demo environment, you'll need the following:

 - Local SQL Server installation - SQL Server Express is fine. Any version from 2016 onwards
 - SQL Server Management Studio installation
 - Local PostgreSQL installation
 - An Azure Databricks environment

## SQL Server Setup

SQL Server is used to host the legacy ERP database.

Open SQL Server Mangement Studio. In the folder **00_Course_Setup/LegacyERP**, open up and execute the script **LegacyErp_CreateDb.sql**. This will create the database structure.

Next, open up the script **LegacyErp_LoadData.sql**. On line 12, set the correct path to the folder you downloaded the files to. E.g. if you downloaded the files to c:\temp, you should change the line as follows:

    :SETVAR Path C:\temp\

Make sure you keep the end backslash!
With this done, click on the **Query** menu, then **SQLCMD Mode**. Then execute the script. This will populate the database.

## PostgreSQL Setup

PostgreSQL is used to host the new ERP database. There are three databases you need to create:

 - NewErpUK
 - NewErpUS
 - NewErpNL

Open up a command prompt and navigate to the folder **00_Course_Setup/NewERP/NL**. Type this command (assuming you have saved the course files to C:\coursefiles):

    psql -U postgres -f "C:\coursefiles\00_Course_Setup\NewERP\NL\NewErpNl_CreateDb.sql"

Replace the *postgres* user with your user name. After entering your password, the database will be created.
Once the database has been created, in the same folder, open up the file **NewErpNL_Import_Script.sql**. Follow the instructions at the top of this file and then execute it to populate the database. Essentially, you need to execute this statement from the command line:

    psql -U postgres -d newerpus -f "C:\coursefiles\00_Course_Setup\NewERP\NL\NewErpNl_Import_Script.sql"

Repeat this process for the NewERP_UK and NewERP_US databases.

# Azure Setup

If you wish to set up a replica of the environment used by the course, you'll need to create the following on Azure:

 - An event hub, with three event hub entities. Name the entities:
    - globo-cloud-erp
    - globo-cloud-fsm
    - globo-wms

    Create a SAS policy for each event hub entity:
    - Name: databricks-access
    - Permissions: Send & Listen

 - A storage account
    - Create a container called uploads, then the following folder structure:
        - globoerp
          - customer
          - product
          - purchaseorder
          - purchaseorderline
          - salesorder
          - salesorderline
          - stocklevel
          - supplier
          - warehouse
        - Legacyerp
        
- A Databricks environment (only needed for module 3)

# Module 1

## Cloud ERP Simulation

The **cloud_erp_api_generator.py** file simulates API calls. You can run this directly from your IDE (e.g. Visual Studio Code, it will be accessible at http://localhost:8000), or you can visit https://mcqtech.com/python. Every time you refresh the page, it will generate a new "API" response.

You can find this code in **Module1/1.5/CloudERPSimulation**. This folder also contains JSON documents, which provide examples of the "API" responses.

## Cloud Field Service Management Simulation

The **fsm_webhook_event_generator.py** file simulates Webhook outputs. This can also be run directly from your IDE. It requires an Azure event hub to store the output, change the connection string to point at your event hub before running the script (or comment out the event hub code if you want to just view the JSON).

You can find this code in **Module1/1.5/CloudFSMSimulation/fsm_webhook_event_generator.py**. This folder also contains an example JSON document, which provides an example of the generated JSON.

## IoT Handheld Wireless Scanner Simulation

The **iot_event_generator.py** file simulates IoT outputs. This can also be run directly from your IDE, and also requires an Azure event hub for output. Ensure you change the connection stirng to point at your event hub before running the script (or comment out the event hub code if you want to just view the JSON).

You can find this code in **Module1/1.5/IoTSimulation/iot_event_generator.py**. This folder also contains an example JSON document, which provides an example of the generated JSON.

# Module 2

## Legacy ERP Extraction Scripts

The folder **Module2/2.3/legacyerp** folder contains a set of scripts which extract data from the SQL Server legacy ERP database. These all rely on the file *sql_server_csv_extract.py*.
Each script specifies the export path near the top of the code, change this to your target output folder. You will also need to change the connection string in the *sql_server_csv_extract.py* file.

## New ERP Extraction Scripts

The folder **Module2/2.3/newerp** folder contains a set of scripts which extract data from the PostgreSQL ERP databases. These all rely on the file *postgresql_csv_file_extract.py*.
Each script specifies the export path near the top of the code, change this to your target output folder. You will also need to change the connection string in each script, as the script changes the database name dynamically.

## Data Contracts

The folder **Module2/2.3/newerpdatacontract** contains the data contract demo files.
The **beforecolumnnamechange** folder houses the scripts to demonstrate how the data contract enforces column checks. Run the script *postgresql_new_erp_customer_extract_with_contract.py* and the data contract will capture the *addresline2* problem.

To fix the column name, open the script in the folder **renamecolumn** and execute it against the three PostgreSQL databases:

- newerpnl
- newerpuk
- newerpus

Open the script *postgresql_new_erp_customer_extract_with_contract.py* in the **aftercolumnnamechange** folder. This has the correct *addressline2* column name. Run this, and the data contract will pass and create the extract files.

# Module 3

## Databricks Configuration

In Databricks, click on Catalog. Click the +, then Create a catalog. Add a new catalog called Globodata. Type = Standard. Choose the storage location and click Create.

In the Workspace, create the following folder structure in Shared: 
    - schemas
    - silvertablescripts
    - silvermergescripts
      - globoerp
    
Upload the scripts (drag and drop) to Databricks, as follows:

- schemas - upload from Module3/3.1/databricks/schemas
- silvertablescripts - upload from Module3/3.1/databricks/silvertablescripts
- silvermergescripts/erp - upload from Module3/3.1/databricks/silvermergescripts

In Databricks, open the newly-created schemas folder, and execute these scripts to create the schemas:

- 01_create_bronze_schema.sql
- 02_create_silver_schema.sql
- 03_create_gold_schema.sql

Still in Databricks, open the newly-created silvertablescripts, and execute these scripts to create the tables:

- 01_create_table_silver_customer.sql
- 02_create_table_silver_product.sql
- 03_create_table_silver_supplier.sql
- 04_create_table_silver_warehouse.sql
- 05_create_table_silver_stocklevel.sql
- 06_create_table_silver_purchaseorder.sql
- 07_create_table_silver_purchaseorderline.sql
- 08_create_table_silver_salesorder.sql
- 09_create_table_silver_salesorderline.sql
- 10_create_table_silver_engineervisit.sql
- 11_create_table_silver_wmsevent.sql

# Creating the Pipelines

In Databricks, click on Jobs & Pipelines.

**NOTE: These pipelines are structured separately. You can chain them if you want to import everything in one hit.**

Generate a SAS token for the Azure Blob Storage instance. Ensure the token has Read and List permissions.

For the New ERP, create the ETL pipelines below.

Open the folder Module3/3.1/databrickspipelines/globoerp/bronzepipelines. This contains all of the Python scripts needed for the New ERP pipelines.

In each Python script in this folder, change the following:

- Line 17 - set the name of your Azure Blob storage account
- Line 18 - set the name of your storage container
- Line 19 - set the path to your storage folder for the relevant files
- Line 20 - set the SAS token used to access Azure Blob storage

- GloboERP Customer Bronze Pipeline
  - On the Transformations folder, click on the dots icon and choose Import. Drag and drop the file 01_globoerp_customer_databricks_pipeline.py.
  - Move the my_transformation.py file to the trash.
- GloboERP Product Bronze Pipeline
  - As above, but use the 02_globoerp_product_databricks_pipeline.py file.
- GloboERP Supplier Bronze Pipeline
  - As above, but use the 03_globoerp_supplier_databricks_pipeline.py file.
- GloboERP Warehouse Bronze Pipeline
  - As above, but use the 04_globoerp_warehouse_databricks_pipeline.py file.
- GloboERP StockLevel Bronze Pipeline
  - As above, but use the 05_globoerp_stocklevel_databricks_pipeline.py file.
- GloboERP PurchaseOrder Bronze Pipeline
  - As above, but use the 06_globoerp_purchaseorder_databricks_pipeline.py file.
- GloboERP PurchaseOrderLine Bronze Pipeline
  - As above, but use the 07_globoerp_purchaseorderline_databricks_pipeline.py file.
- GloboERP SalesOrder Bronze Pipeline
  - As above, but use the 08_globoerp_salesorder_databricks_pipeline.py file.
- GloboERP SalesOrderLine Bronze Pipeline
  - As above, but use the 09_globoerp_salesorderline_databricks_pipeline.py file.

For the Cloud FSM, create the ETL pipeline below.

Open the folder Module3/3.1/databrickspipelines/fsm. This folder contains one file.

Change the following in the Python script:

- Line 17 - set the namespace of your Azure Event Hub container/namespace
- Line 18 - set the name of the event hub you want to deliver events to
- Line 19 - set the name of the SAS key
- Line 20 - set the SAS token used to access Azure Event Hubs

- CloudFSM Event Bronze Pipeline
  - Create the pipeline as per previous pipelines, but use the 01_cloudfsm_databricks_pipeline.py file.

For the WMS, create the ETL pipeline below.

Open the folder Module3/3.1/databrickspipelines/wms. This folder contains one file.

Make the same changes to lines 17-20, ensuring you choose the correct event hub.

- GloboWMS IoT Event Bronze Pipeline
  - Create the pipeline as per previous pipelines, but use the 01_globowms_databricks_pipeline.py file.

For the Cloud ERP, create the ETL pipelines below.

Open the folder Module3/3.1/databrickspipelines/clouderp. For each file in this folder, make the same changes to lines 17-20, ensuring you choose the correct event hub.

- CloudERP SalesOrder Bronze Pipeline
  - Create the pipeline as per previous pipelines, but use the 01_clouderp_salesorder_databricks_pipeline.py file.
- CloudERP PurchaseOrder Bronze Pipeline
  - Create the pipeline as per previous pipelines, but use the 02_clouderp_purchaseorder_databricks_pipeline.py file.
- CloudERP Contact Bronze Pipeline
  - Create the pipeline as per previous pipelines, but use the 03_clouderp_contact_databricks_pipeline.py file.

Next, create the following jobs (optionally, set a trigger/schedule for the task if you want to import files automatically):

- GloboERP Customer Import
  - Add an ETL pipeline task, called Customer_Bronze_Pipeline
    - In the pipeline list, choose GloboERP Customer Bronze Pipeline
  - Add a SQL File task, called Customer_Silver_Merge
    - Point the file to Shared/silvermergescripts/01_globoerp_customer_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Customer_Bronze_Pipeline

- GloboERP Product Import
  - Add an ETL pipeline task, called Product_Bronze_Pipeline
    - In the pipeline list, choose GloboERP Product Bronze Pipeline
  - Add a SQL File task, called Product_Silver_Merge
    - Point the file to Shared/silvermergescripts/02_globoerp_product_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Product_Bronze_Pipeline

- GloboERP Supplier Import
  - Add an ETL pipeline task, called Supplier_Bronze_Pipeline
    - In the pipeline list, choose GloboERP Supplier Bronze Pipeline
  - Add a SQL File task, called Supplier_Silver_Merge
    - Point the file to Shared/silvermergescripts/03_globoerp_supplier_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Supplier_Bronze_Pipeline

- GloboERP Warehouse Import
  - Add an ETL pipeline task, called Warehouse_Bronze_Pipeline
    - In the pipeline list, choose GloboERP Warehouse Bronze Pipeline
  - Add a SQL File task, called Warehouse_Silver_Merge
    - Point the file to Shared/silvermergescripts/04_globoerp_warehouse_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Warehouse_Bronze_Pipeline

- GloboERP StockLevel Import
  - Add an ETL pipeline task, called StockLevel_Bronze_Pipeline
    - In the pipeline list, choose GloboERP StockLevel Bronze Pipeline
  - Add a SQL File task, called StockLevel_Silver_Merge
    - Point the file to Shared/silvermergescripts/05_globoerp_stocklevel_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Warehouse_Bronze_Pipeline

- GloboERP PurchaseOrder Import
  - Add an ETL pipeline task, called PurchaseOrder_Bronze_Pipeline
    - In the pipeline list, choose GloboERP PurchaseOrder Bronze Pipeline
  - Add a SQL File task, called PurchaseOrder_Silver_Merge
    - Point the file to Shared/silvermergescripts/06_globoerp_purchaseorder_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to PurchaseOrder_Bronze_Pipeline

- GloboERP PurchaseOrderLine Import
  - Add an ETL pipeline task, called PurchaseOrderLine_Bronze_Pipeline
    - In the pipeline list, choose GloboERP PurchaseOrderLine Bronze Pipeline
  - Add a SQL File task, called PurchaseOrderLine_Silver_Merge
    - Point the file to Shared/silvermergescripts/07_globoerp_purchaseorderline_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to PurchaseOrderLine_Bronze_Pipeline

- GloboERP SalesOrder Import
  - Add an ETL pipeline task, called SalesOrder_Bronze_Pipeline
    - In the pipeline list, choose GloboERP SalesOrder Bronze Pipeline
  - Add a SQL File task, called SalesOrder_Silver_Merge
    - Point the file to Shared/silvermergescripts/08_globoerp_salesorder_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to SalesOrder_Bronze_Pipeline

- GloboERP SalesOrderLine Import
  - Add an ETL pipeline task, called SalesOrderLine_Bronze_Pipeline
    - In the pipeline list, choose GloboERP SalesOrderLine Bronze Pipeline
  - Add a SQL File task, called SalesOrderLine_Silver_Merge
    - Point the file to Shared/silvermergescripts/09_globoerp_salesorderline_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to SalesOrderLine_Bronze_Pipeline

- CloudFSM Event Import
  - Add an ETL pipeline task, called EngineerVisit_Bronze_Pipeline
    - In the pipeline list, choose CloudFSM Event Bronze Pipeline
  - Add a SQL File task, called EngineerVisit_Silver_Merge
    - Point the file to Shared/silvermergescripts/10_cloudfsm_engineervisit_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to EngineerVisit_Bronze_Pipeline

- GloboWMS IoT Event Import
  - Add an ETL pipeline task, called GloboWmsIot_Bronze_Pipeline
    - In the pipeline list, choose GloboWMS IoT Bronze Pipeline
  - Add a SQL File task, called GloboWmsIot_Silver_Insert
    - Point the file to Shared/silvermergescripts/11_globowms_silver_sql_insert.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to GloboWmsIot_Bronze_Pipeline

- CloudERP SalesOrder Import
  - Add an ETL pipeline task, called SalesOrder_Bronze_Pipeline
    - In the pipeline list, choose CloudERP SalesOrder Bronze Pipeline
  - Add a SQL File task, called SalesOrder_Silver_Merge
    - Point the file to Shared/silvermergescripts/12_clouderp_salesorder_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to SalesOrder_Bronze_Pipeline

- CloudERP PurchaseOrder Import
  - Add an ETL pipeline task, called PurchaseOrder_Bronze_Pipeline
    - In the pipeline list, choose CloudERP PurchaseOrder Bronze Pipeline
  - Add a SQL File task, called PurchaseOrderLine_Silver_Merge
    - Point the file to Shared/silvermergescripts/13_clouderp_purchaseorder_databricks_pipeline.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to PurchaseOrder_Bronze_Pipeline

- CloudERP Contact Import
  - Add an ETL pipeline task, called Contact_Bronze_Pipeline
    - In the pipeline list, choose CloudERP Contact Bronze Pipeline
  - Add a SQL File task, called Contact_Silver_Merge
    - Point the file to Shared/silvermergescripts/14_clouderp_contact_silver_sql_merge.sql
    - Set the appropriate SQL warehouse
    - Ensure Depends on is set to Contact_Bronze_Pipeline

## Azure Simulations

If you want to recreate the event streaming demos, ensure you have set up appropriate Azure Event Hubs and SAS keys. Use these files:

- Module3/3.1/CloudFSMSimulation/fsm_webhook_event_generator_wth_encryption.py
- Module3/3.1/IoTSimulation/iot_event_generator_with_encryption.py
- Module3/3.1/NewERP/postgresql_new_erp_customer_extract.py
