# 🛡️ Insurance Agency Performance Dashboard

![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power%20Query-ETL-0078D4?style=flat-square)
![DAX](https://img.shields.io/badge/DAX-5C2D91?style=flat-square)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat-square&logo=microsoftexcel&logoColor=white)

[← Back to portfolio](../../README.md)

![Executive Overview](screenshots/01-executive-overview.png)

---

## 📌 Project Overview

An insurance company needs to know which of its independent agencies, products, quoting systems and regions bring in revenue, keep customers and convert quotes into policies.

I built a **6-page interactive Power BI dashboard** from yearly agency-level data covering **2006–2015**. It turns that data into clear answers about **premium, retention, conversion (hit ratio), loss ratio and growth**.

## 🎯 Project Objectives

The dashboard covers:

- Agency performance (premium and retention leaders)
- Retention ratio analysis and segmentation
- Commercial Lines vs Personal Lines comparison
- Quote-system effectiveness (quotes vs bound policies)
- Geographic (state-level) distribution of premium and retention
- Premium growth and loss ratio trends over time

## 🧰 Tech Stack

| Tool | Used for |
|------|----------|
| **Power BI Desktop** | Report design, visuals, interactivity, navigation |
| **Power Query (M)** | Data cleaning and transformation |
| **DAX** | Measures, helper tables, dynamic `SWITCH` logic |
| **Excel** | Source dataset |

## 📂 Dataset

Agency-level insurance data with these fields:

| Category | Fields |
|----------|--------|
| **Identifiers** | `AGENCY_ID`, `PRIMARY_AGENCY_ID`, `STATE_ABBR`, `PROD_ABBR`, `PROD_LINE` (CL / PL) |
| **Time** | `STAT_PROFILE_DATE_YEAR`, plus start/end years for PL, CL, commissions and activity notes |
| **Performance** | `RETENTION_RATIO`, `LOSS_RATIO`, `LOSS_RATIO_3YR`, `PRD_ERND_PREM_AMT`, `PRD_INCRD_LOSSES_AMT` |
| **Sales funnel** | Quote counts and bound counts for each quoting system (MDS, SBZ, eQT, ELINKS, PLRANK, APPLIED, TRANSACTNOW) |

---

## 🧹 Data Cleaning & Transformation (Power Query)

![Power Query steps](screenshots/07-power-query-cleaning.png)

| Step | What was done |
|------|---------------|
| **Removed blanks** | Removed rows with blank values in key fields: `AGENCY_ID`, `STATE_ABBR`, `PROD_LINE`, `RETENTION_RATIO`, `LOSS_RATIO`, `STAT_PROFILE_DATE_YEAR` |
| **Removed duplicates** | Checked on `AGENCY_ID` + `STAT_PROFILE_DATE_YEAR` so that no agency-year is counted twice |
| **Set data types** | **Text** for IDs, state and product line. **Whole Number** for all year columns. **Decimal** for ratios and amounts |
| **Trim & Clean** | Removed extra spaces, hidden characters and inconsistent formatting from text columns |
| **Replaced values** | Standardized placeholder and invalid entries across several columns |
| **Validated ratios** | Confirmed that `RETENTION_RATIO` is already stored as a decimal (1 = 100%), so it was **not** divided by 100. This prevented a common scaling error |

---

## 🔗 Data Model

| Table | Role |
|-------|------|
| **Insurance** | Main fact table (agency × product × state × year) |
| **_ Measures** | Dedicated measures table, created with `DATATABLE`, that keeps all DAX measures in one place |
| **Quote Systems** | Disconnected helper table that lists the 7 quoting systems and drives the dynamic quote measures |

---

## 🧮 DAX Measures

### Core KPIs

```DAX
Total Premium       = SUM ( Insurance[PRD_ERND_PREM_AMT] )
Avg Retention Ratio = AVERAGE ( Insurance[RETENTION_RATIO] )
Avg Loss Ratio      = AVERAGE ( Insurance[LOSS_RATIO] )
```

### Time-Based Growth

```DAX
Premium 2006 = CALCULATE ( [Total Premium], Insurance[STAT_PROFILE_DATE_YEAR] = 2006 )
Premium 2013 = CALCULATE ( [Total Premium], Insurance[STAT_PROFILE_DATE_YEAR] = 2013 )

Premium Growth 2006-2013 =
DIVIDE ( [Premium 2013] - [Premium 2006], [Premium 2006], 0 )
```

### Dynamic Quote-System Analysis

Quote and bound counts are stored in **separate columns for each system**. To compare the systems in one visual, I created a helper table and `SWITCH` measures. These measures return the correct column depending on which system is in the current filter context.

```DAX
_ Measures = DATATABLE ( "Dummy", STRING, {} )

Quote Systems =
DATATABLE (
    "Quote System", STRING,
    { {"MDS"}, {"SBZ"}, {"eQT"}, {"ELINKS"}, {"PLRANK"}, {"APPLIED"}, {"TRANSACTNOW"} }
)

-- Quote System Quotes / Quote System Bounds:
--   SWITCH ( SELECTEDVALUE ( 'Quote Systems'[Quote System] ), "MDS", <MDS quotes>, "SBZ", <SBZ quotes>, ... )

Quote System Hit Ratio =
DIVIDE ( [Quote System Bounds], [Quote System Quotes], 0 )
```

---

## 📊 Dashboard Walkthrough

### Page 1 — Executive Overview
![Executive Overview](screenshots/01-executive-overview.png)

**Purpose:** A high-level view of business health.

- **Slicers:** Year, State, Product Line
- **KPI cards:** Total Agencies (**2K**), Total Premium (**$4.19bn**), New Business Premium (**$478.63M**), Avg Retention Ratio (**77.96%**), Hit Ratio (**13.75%**)
- **Premium Trend by Year (line):** premium stays steady at about $0.4bn per year from 2006 to 2014
- **Navigation panel:** custom icon buttons to Agency, Product Line, Quote System, Geographic and Growth pages, using Power BI **Page Navigation actions**

### Page 2 — Agency Analysis
![Agency Analysis](screenshots/02-agency-analysis.png)

**Purpose:** Find the top agencies.

- **Top 10 Agencies by Retention Ratio:** clustered bar chart, sorted descending
- **Top 10 Agencies by Premium:** clustered bar chart, sorted descending
- **Top 10 Agencies by Premium Table:** Agency ID, State, Total Premium, New Business Premium, Retention and Hit Ratio. The leading agency is **#5468 (OH)** with **$46.0M** in premium.

### Page 3 — Product Line Analysis
![Product Line Analysis](screenshots/03-product-line-analysis.png)

**Purpose:** Compare **Personal Lines (PL)** with **Commercial Lines (CL)**.

- **Total Premium by Product Line:** column chart
- **Premium share (donut):** PL **$2.46bn (58.8%)** vs CL **$1.73bn (41.2%)**
- **Retention Ratio by Product Line:** CL retains slightly better than PL
- **Hit Ratio by Product Line:** PL converts quotes at a higher rate than CL

### Page 4 — Quote System Analysis
![Quote System Analysis](screenshots/04-quote-system-analysis.png)

**Purpose:** Measure how effective each quoting platform is.

- **Hit Ratio by Quote System:** **eQT** (~0.78) and **SBZ** (~0.66) convert best. **ELINKS** and **PLRANK** convert worst
- **Quotes vs Bounds:** **PLRANK** handles by far the most quotes (**24.0M**) but binds only **1.0M**. This is a large conversion gap and an opportunity to improve

### Page 5 — Geographic Analysis
![Geographic Analysis](screenshots/05-geographic-analysis.png)

**Purpose:** Show how business is distributed across states.

- **Premium by State (Top 10):** **Ohio** leads by a wide margin, followed by PA, KY, IN, WV and MI
- **State-wise Retention:** **PA**, OH and WV have the highest retention, all close to 80%
- **Geographic Premium Distribution (map):** bubble size shows premium by state

### Page 6 — Growth & Segmentation
![Growth & Segmentation](screenshots/06-growth-segmentation.png)

**Purpose:** Track long-term growth, risk and customer loyalty.

- **Retention Ratio Distribution (donut):** agencies are segmented into **Low (34.3%)**, **High (34.3%)** and **Medium (31.4%)** retention
- **Loss Ratio Trend (line):** the average loss ratio moves between roughly 10% and 16% and rises sharply in the final year
- **Premium Growth KPIs:** Premium 2006 **$412.88M** → Premium 2013 **$426.54M**, which is **+3.31% growth**

---

## 💡 Key Insights & Recommendations

1. **Revenue is concentrated geographically.** Ohio produces most of the premium, so the business is exposed to risk in a single state. Expanding in the next-largest states (PA, KY, IN) would reduce that dependence.
2. **Personal Lines is the revenue engine** (~59% of premium) and converts better. Commercial Lines retains slightly better, which suggests CL customers are fewer but more loyal.
3. **Quote systems vary widely in effectiveness.** eQT and SBZ convert most of their quotes, while PLRANK's high volume and low conversion show where sales effort is being wasted. Process review or training there would have the biggest payoff.
4. **Growth is flat** (+3.31% over 7 years), which is below typical inflation. New-business acquisition needs attention.
5. **About a third of agencies are in the low-retention segment.** Targeted retention programs for them could protect a large share of recurring premium.
6. **The jump in loss ratio in the most recent year** should be investigated to see whether it reflects a real increase in claims or an incomplete final year of data.

## ✅ Testing & Validation

I tested relationships, measures, filters, slicers, chart interactions, navigation buttons and the mobile layout before submission.

## 🎨 Design Assets

The navigation panel uses custom icons stored in [`assets/navigation-icons/`](assets/navigation-icons/).

## 📁 Files

| File | Description |
|------|-------------|
| [`report/Insurance_Agency_Performance.pbix`](report/Insurance_Agency_Performance.pbix) | Power BI report |
| [`docs/Insurance_Agency_Project_Report.docx`](docs/Insurance_Agency_Project_Report.docx) | Full step-by-step documentation |
| [`screenshots/`](screenshots/) | Page screenshots and Power Query steps |
| [`assets/navigation-icons/`](assets/navigation-icons/) | Icons used for page navigation |

[← Back to portfolio](../../README.md)
