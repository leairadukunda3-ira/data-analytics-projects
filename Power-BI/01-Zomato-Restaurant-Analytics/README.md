# 🍽️ Zomato Restaurant Analytics Dashboard

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power%20Query-ETL-0078D4?style=flat-square)
![DAX](https://img.shields.io/badge/DAX-5C2D91?style=flat-square)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat-square&logo=microsoftexcel&logoColor=white)

[← Back to portfolio](../../README.md)

![Global Overview](screenshots/01-global-overview.png)

---

## 📌 Project Overview

Zomato is a restaurant aggregation and food delivery platform that operates in many countries. Its restaurant data was split across **eight separate Excel files**: one per continent, plus a fact table and a country-code lookup. Because of this split, nobody could see the business as a whole.

For this project I built a **single, interactive Power BI report**. It consolidates all of the data and lets users explore restaurants by geography, rating, cost, cuisine and service offering.

## 🎯 Project Objectives

The dashboard lets Zomato:

- Analyze the **total number of restaurants** worldwide
- **Drill down** from continent to country to city
- Identify the **highest-rated** and **lowest-cost** restaurants
- Understand **cuisine popularity** and **service offerings** (online delivery and table booking)
- **Filter** everything interactively to support decisions

## 🧰 Tech Stack

| Tool | Used for |
|------|----------|
| **Power BI Desktop** | Report design, visuals, interactivity, navigation |
| **Power Query (M)** | Data import, cleaning, transformation, appending tables |
| **DAX** | Measures and calculated columns |
| **Excel** | Source data (8 workbooks) |

## 📂 Data Sources

| File | Content |
|------|---------|
| `Africa.xlsx`, `Asia.xlsx`, `Europe.xlsx`, `NAM.xlsx`, `SAM.xlsx`, `Oceania.xlsx` | Restaurant-level data for each continent (name, address, city, cuisines, cost, rating, votes, coordinates) |
| `Fact Table.xlsx` | Ratings, cost for two, price range, and online delivery / table booking flags |
| `Country-Code.xlsx` | Lookup table that maps country codes to country names |

---

## 🧹 Data Cleaning & Transformation (Power Query)

![Power Query steps](screenshots/07-power-query-cleaning.png)

| Step | What was done |
|------|---------------|
| **Fixed encoding errors** | Corrected corrupted city names, e.g. `Sí£o Paulo` → **São Paulo**, `ÛÁstanbul` → **Istanbul**, `Cedar Rapids/Iowa City` → **Cedar Rapids** |
| **Removed unused columns** | Reduced model size and simplified the analysis |
| **Split columns** | Split the combined field into separate **Restaurant Name** and **Restaurant Address** columns |
| **Removed blanks** | Removed rows with blank Restaurant Name, Country, City, Cuisine, Rating or Country Code |
| **Removed duplicates** | Removed duplicate rows by **Restaurant ID** |
| **Set data types** | Text for names and locations, Decimal for Rating and Cost, Whole Number for Votes |
| **Trim & Clean** | Removed extra spaces and hidden characters from all text columns |
| **Appended tables** | Combined the 6 continent tables into one **Restaurants** table (*Append Queries as New*) |
| **Built Country Master** | Kept only unique, non-blank countries and added a conditional **Continent** column |
| **Built Cuisine dimension** | **Split and unpivoted** the comma-separated cuisines so that each restaurant–cuisine pair is one row |

---

## 🔗 Data Model

![Data Model](screenshots/06-data-model.png)

A star schema with **Z-Restaurants** as the central table:

- **Country Master → Z-Restaurants** on `Country Code` (one-to-many, single direction)
- **Z-Restaurants → Cuisine** on `Restaurant ID` (one-to-many). Because each cuisine is a separate row, cuisine counts are accurate.
- **KPIs ↔ Z-Restaurants** on `Restaurant ID` (one-to-one). KPIs holds rating, cost, price range and service flags.
- **_Measures**: a dedicated table that keeps all measures in one place

---

## 🧮 DAX

### Calculated Column: Rating Color

This column groups each restaurant into a color band. The same band colors the map, the column chart and the slicer.

| Aggregate Rating | Rating Color |
|------------------|--------------|
| ≥ 4.5 | 🟢 Dark Green |
| 4.0 – 4.4 | 🟩 Green |
| 3.0 – 3.9 | 🟨 Yellow |
| 2.0 – 2.9 | 🟧 Orange |
| < 2.0 | 🟥 Red |

### Measures

```DAX
Restaurant Count = DISTINCTCOUNT ( 'Z-Restaurants'[Restaurant ID] )
Average Rating   = AVERAGE ( KPIs[Aggregate rating] )
Average Cost     = AVERAGE ( KPIs[Average Cost for two] )
Cuisine Count    = DISTINCTCOUNT ( Cuisine[Cuisines] )
```

---

## 📊 Dashboard Walkthrough

### Page 1 — Global Overview
![Global Overview](screenshots/01-global-overview.png)

**Purpose:** An executive summary of the whole restaurant network.

- **KPI cards:** Total Restaurants (**8K**), Average Rating (**2.67**), Average Cost (**1.20K**)
- **Slicers:** Rating Color, Continent, Country, City. Together they let users drill from continent to country to city.
- **Restaurants by City (map):** bubble size shows restaurant count and color shows the rating band
- **Restaurants by Continent (clustered column):** the rating-band mix for each continent
- **Navigation panel:** icon buttons (Performance, Service, Cuisine, Geographic) that use Power BI **Page Navigation actions**

### Page 2 — Performance Analysis
![Performance Analysis](screenshots/02-performance-analysis.png)

**Purpose:** Find the best-performing and the most affordable restaurants.

- **Top Restaurants by Rating:** Top 10 by average aggregate rating (Top N filter)
- **Lowest Cost Restaurants:** Top 10 by lowest average cost for two, sorted ascending
- **Restaurant Performance Table:** name, city, country, address, rating (with data bars), cost and votes, sorted by votes. The most-voted restaurant is *Hauz Khas Social*, New Delhi, with 7,931 votes.

### Page 3 — Service Filtering
![Service Filtering](screenshots/03-service-filtering.png)

**Purpose:** Show whether offering online delivery or table booking relates to customer satisfaction.

- **Slicers:** Has Online Delivery, Has Table Booking
- **Donut charts:** **88.4%** of restaurants don't offer table booking and **75.1%** don't offer online delivery
- **Column charts:** restaurants that **offer** either service have a **higher average rating** than those that don't

### Page 4 — Cuisine Analysis
![Cuisine Analysis](screenshots/04-cuisine-analysis.png)

**Purpose:** Find the most popular cuisines.

- **Cuisine Count card:** **140** distinct cuisines
- **Top 10 cuisines (bar chart):** North Indian leads, followed by Chinese and Fast Food
- **Treemap:** all 140 cuisines in one view, sized by restaurant count

### Page 5 — Geographic Analysis
![Geographic Analysis](screenshots/05-geographic-analysis.png)

**Purpose:** Compare markets by country and city.

- **Top 10 countries by restaurant count:** India, then the United States and the United Kingdom
- **Top 10 cities by restaurant count:** New Delhi, Noida and Faridabad lead
- **Average cost by country** and **Average rating by country (Top 10):** the Philippines, UAE and Turkey have the highest ratings

---

## 💡 Key Insights

1. **Asia, and India in particular, dominates** Zomato's restaurant footprint. The Delhi NCR region (New Delhi, Noida, Faridabad, Ghaziabad) alone accounts for most of the listings.
2. **Most restaurants don't use Zomato's service features.** Those that offer online delivery or table booking are rated higher, which suggests these features are worth promoting to partner restaurants.
3. **North Indian, Chinese and Fast Food** are the most common cuisines, which matches the India-heavy dataset.
4. **Smaller markets (Philippines, UAE, Turkey) have higher average ratings** than the largest markets. Their restaurant samples are smaller and are likely skewed toward premium venues.
5. **Data caveat:** *Average Cost for Two* is recorded in **local currency**, so cost comparisons across countries show price levels, not value. Converting to a single currency would be the next improvement.

## ✅ Testing & Validation

I tested relationships, slicers, measures, visual interactions and navigation buttons to make sure every page filters correctly.

## 📁 Files

| File | Description |
|------|-------------|
| [`report/Zomato_Restaurant_Analytics.pbix`](report/Zomato_Restaurant_Analytics.pbix) | Power BI report |
| [`docs/Zomato_Project_Report.docx`](docs/Zomato_Project_Report.docx) | Full step-by-step documentation |
| [`screenshots/`](screenshots/) | Page screenshots, the data model and the Power Query steps |

[← Back to portfolio](../../README.md)
