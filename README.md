# 🚀 Data Warehouse & Analytics Project

Welcome to the **Data Warehouse and Analytics Project!** This repository showcases a modern, end-to-end data warehousing solution—spanning from raw data ingestion and ETL processing to the generation of actionable business intelligence.

This project serves as a portfolio piece to demonstrate industry-standard best practices in **Data Engineering** and **SQL-based Analytics**.

---

## 🏗️ Project Architecture & Workstreams

The project is structured into two primary pillars to ensure a robust foundation and meaningful insights.

### 1. Data Engineering: The Foundation
**Objective:** Develop a centralized SQL Server data warehouse to consolidate siloed sales data into a "Single Source of Truth."

* **Data Integration**: Successfully merged disparate datasets from **ERP** and **CRM** systems (ingested via CSV).
* **ETL & Data Quality**: Implemented advanced cleansing logic to resolve data inconsistencies, handle missing values, and standardize formats during the transformation phase.
* **Data Modeling**: Designed a user-friendly **Star Schema** optimized for high-performance analytical queries and business-ready reporting.
* **Storage Efficiency**: Focused on current-state reporting to maintain a lean, efficient, and performant storage model.
* **Documentation**: Built a comprehensive **Data Catalog** mapping the data model to support both technical maintenance and stakeholder self-service.

### 2. Data Analytics: BI & Reporting
**Objective:** Leverage the structured **Gold Layer** to answer critical business questions using advanced SQL.

* **Customer Behavior**: Segmenting the customer base and identifying Lifetime Value (LTV).
* **Product Performance**: Analyzing category-level margins and volume to identify top drivers.
* **Sales Trends**: Pinpointing seasonal patterns and calculating period-over-period (PoP) growth.

---

## 📊 Data Layers (Medallion Architecture)

The warehouse follows a logical progression to ensure data integrity:

| Layer | Description |
| :--- | :--- |
| **🟫 Bronze** | Raw data ingestion from source systems (ERP/CRM). |
| **🥈 Silver** | Cleansed and standardized data (handled NULLs, types, and formatting). |
| **🥇 Gold** | Business-ready views and tables (Star Schema) used for final reporting. |

---

## 🛠️ Tech Stack & Resources

### Core Technologies
- **Database:** SQL Server
- **Language:** T-SQL (Advanced Joins, Window Functions, CASE Logic, DDL/DML)
- **Architecture:** Medallion Architecture (Bronze → Silver → Gold)
- **Modeling:** Dimensional Modeling (Star Schema)

### Tools Used
- **Management:** SQL Server Management Studio (SSMS)
- **Version Control:** Git & GitHub
- **Design:** Draw.io (Architecture Diagrams)
- **Planning:** Notion (Project Tracking)

---
## 📂 Repository Structure
```text
sql-data-warehouse-project/
├── datasets/                 # Raw datasets (ERP and CRM CSV files)
├── docs/                     # Documentation & Architecture
│   ├── data_architecture.drawio   # High-level system architecture
│   ├── data_catalog.md            # Metadata & field descriptions
│   ├── data_flow.drawio           # ETL pipeline flow diagram
│   └── data_model_star.drawio     # Dimensional model (Star Schema)
├── scripts/                  # SQL ETL & Transformation Logic
│   ├── bronze/               # Data ingestion & raw loading
│   ├── silver/               # Cleaning & standardization
│   └── gold/                 # Analytical views & Star Schema
├── tests/                    # Data validation & quality scripts
├── .gitignore                # Excluded files
├── LICENSE                   # Repository licensing
├── README.md                 # Project overview
└── requirements.txt          # Project dependencies
``` 

## 🔗 Project Resources
- [Datasets (CSV)](https://github.com/dataenginewitharyan/sql-data-warehouse-project/tree/main/datasets) 
- [SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- [Project Documentation (Notion)](https://github.com/dataenginewitharyan/sql-data-warehouse-project/tree/main/docs)

---
