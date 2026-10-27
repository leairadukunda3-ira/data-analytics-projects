# 🛒 E-Commerce Sales & Profit Dashboard (Excel)

![Excel](https://img.shields.io/badge/Excel-217346?style=flat-square&logo=microsoftexcel&logoColor=white)
![SUMIFS](https://img.shields.io/badge/Formulas-SUMIFS%20%7C%20INDEX-blue?style=flat-square)
![Form Controls](https://img.shields.io/badge/Form%20Controls-Combo%20Box-orange?style=flat-square)
![Pivot Tables](https://img.shields.io/badge/Pivot%20Tables-informational?style=flat-square)

[← Back to portfolio](../../README.md)

![E-Commerce Dashboard](screenshots/01-dashboard.png)

---

## 📌 Project Overview

I built an **interactive sales and profit dashboard entirely in Microsoft Excel**, using no add-ins and no VBA. It turns **51,290 e-commerce orders from 2015** into a one-page view of monthly trends, regional performance and profitability.

A **combo box** drives the whole dashboard. When the user picks a product category, every KPI, table and chart recalculates instantly through `INDEX` and `SUMIFS` formulas.

## 🎯 Project Objectives

- Monitor **sales and profit month by month**
- Compare **sales performance across regions**
- Let users **filter by product category** without editing any formulas
- Build a dashboard that is **scalable**: new rows added to the data flow into every calculation automatically

## 🧰 Tech Stack

| Tool | Used for |
|------|----------|
| **Excel Tables** (`Ctrl + T`) | Structured, auto-expanding data source |
| **`SUMIFS`** | Totals for each month and region, filtered by category |
| **`INDEX`** | Converts the combo box selection into a category name |
| **Form Controls (Combo Box)** | Interactive category filter (Developer tab) |
| **Pivot Tables** | Supporting summary tables |
| **Combo & clustered column charts** | Visualizations |

## 📂 Dataset

**51,290 orders** (January–December 2015), **21 columns**, **147 countries**, **42 products** in 4 categories.

![Sales data table](screenshots/02-sales-data-table.png)

| Category | Fields |
|----------|--------|
| **Order** | Order ID, Order Date, Ship Date, Aging, Ship Mode, Order Priority, Months |
| **Product** | Product Category, Product |
| **Financials** | Sales, Quantity, Discount, Profit, Shipping Cost |
| **Customer** | Customer ID, Customer Name, Segment |
| **Geography** | City, State, Country, Region |

---

## 🔧 How It Was Built

| Step | What was done |
|------|---------------|
| **1. Prepare the data** | Converted the raw data into an **Excel Table**, so new rows automatically flow into every formula and chart |
| **2. Month-wise table** | Calculated total **Sales** and **Profit** for each month with `SUMIFS` (criteria: month + selected category) |
| **3. Region-wise table** | Calculated **Sales** for each of 13 regions with `SUMIFS` (criteria: region + selected category) |
| **4. Combo box** | Added a Form Control combo box. Its input range is the category list and its linked cell returns the index of the selection |
| **5. Link the selection** | `=INDEX(Category_List, LinkedCell)` turns the index into a category name, which every `SUMIFS` uses |
| **6. Dynamic charts** | A **combo chart** (sales as columns, profit as a line) and a **clustered column chart** for regions |
| **7. Layout** | One clean *Dashboard* sheet with consistent colors and fonts, KPI cards and hidden gridlines |

### Core Formulas

```excel
Selected Category  =INDEX(Category_List, B1)

Monthly Sales      =SUMIFS(SalesData[Sales],  SalesData[Months], [@Months], SalesData[Product Category], SelectedCategory)
Monthly Profit     =SUMIFS(SalesData[Profit], SalesData[Months], [@Months], SalesData[Product Category], SelectedCategory)
Regional Sales     =SUMIFS(SalesData[Sales],  SalesData[Region], [@Region], SalesData[Product Category], SelectedCategory)
```

---

## 📊 Dashboard Walkthrough

![E-Commerce Dashboard](screenshots/01-dashboard.png)

| Section | What it shows |
|---------|---------------|
| **Explore panel** | Combo box for choosing a category (Auto & Accessories, Electronic, Home & Furniture, Fashion) and the reference formulas behind it |
| **KPI cards** | Total Sales, Total Profit, Profit Margin % for the selected category |
| **Month-wise Sales & Profit table** | 12-month breakdown that feeds the trend chart |
| **Monthly Sales and Profit (combo chart)** | Sales as columns and profit as a line on a secondary axis |
| **Region-wise Sales table + Regional Sales Overview** | Sales for 13 regions (Central, South, EMEA, North, Africa, Oceania, and others) |

*In the screenshot the **Electronic** category is selected: $0.4M sales, $0.2M profit, a 44.12% margin, Central as the top region ($82.8K) and October as the peak month ($39.2K sales).*

---

## 💡 Key Insights

1. **The business is highly profitable overall**, with **$8.02M sales** and **$3.73M profit**, a **46.5% margin**.
2. **Fashion is the main revenue driver** at **65% of sales** ($5.21M). It is followed by Home & Furniture (16%), Auto & Accessories (14%) and Electronic (5%).
3. **Central is the largest region** ($1.74M), followed by South ($1.03M) and EMEA ($0.79M).
4. **Sales are spread evenly across the year**, with a small peak in **Q4 (October)**. That timing suits holiday-season campaigns.
5. **Consumer customers account for 52% of orders**, Corporate 30% and Home Office 18%.
6. Electronic has the smallest share of sales but still earns a **44% margin**, so it may be worth investing to grow it.

## 📁 Files

| File | Description |
|------|-------------|
| [`workbook/E-Commerce_Dashboard.xlsx`](workbook/E-Commerce_Dashboard.xlsx) | Finished interactive dashboard workbook |
| [`data/E-Commerce_Sales_Data_raw.xlsx`](data/E-Commerce_Sales_Data_raw.xlsx) | Original raw dataset |
| [`docs/E-Commerce_Dashboard_Report.pdf`](docs/E-Commerce_Dashboard_Report.pdf) | Step-by-step project report (PDF, viewable on GitHub) |
| [`docs/E-Commerce_Dashboard_Report.docx`](docs/E-Commerce_Dashboard_Report.docx) | Project report (Word) |
| [`screenshots/`](screenshots/) | Dashboard and data table |

> 💡 Download the workbook and open it in desktop Excel to use the combo box. Form controls don't work in Excel Online or in GitHub's preview.

[← Back to portfolio](../../README.md)
