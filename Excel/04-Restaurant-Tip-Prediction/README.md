# 💵 Restaurant Tip Prediction (Excel Regression Analysis)

![Excel](https://img.shields.io/badge/Excel-217346?style=flat-square&logo=microsoftexcel&logoColor=white)
![Pivot Tables](https://img.shields.io/badge/Pivot%20Tables-EDA-orange?style=flat-square)
![Analysis ToolPak](https://img.shields.io/badge/Analysis%20ToolPak-Regression-blue?style=flat-square)
![Statistics](https://img.shields.io/badge/Statistics-Correlation%20%7C%20RMSE-informational?style=flat-square)

[← Back to portfolio](../../README.md)

![Final model and predictions](screenshots/05-final-model-prediction-rmse.png)

---

## 📌 Project Overview

Restaurants want to understand **what drives tipping behavior**. In this project I analyzed 244 restaurant transactions and built a **multiple linear regression model in Microsoft Excel** that predicts the tip amount from customer and visit characteristics.

The project covers the full predictive-analytics workflow inside Excel: data validation, exploratory analysis with pivot tables, encoding categorical variables, correlation-based feature selection, model building, prediction, and evaluating model error with RMSE.

## 🎯 Project Objectives

- Explore how tips vary by **gender, smoking status, time of day, party size and bill amount**
- Find which variables are most strongly related to tip size
- Build and compare regression models that **predict the tip**
- Measure prediction accuracy using **RMSE**

## 🧰 Tech Stack

| Tool | Used for |
|------|----------|
| **Excel Pivot Tables & Charts** | Exploratory data analysis |
| **Excel formulas** (`IF`, `POWER`, `SQRT`, `SUM`, `COUNT`) | Encoding variables, calculating errors and RMSE |
| **Analysis ToolPak** | Correlation matrix and regression |
| **Calculated fields** | Tip % within pivot tables |

## 📂 Dataset

**244 observations** with 7 variables:

| Variable | Type | Description |
|----------|------|-------------|
| `sex` | Categorical | Gender of the bill payer |
| `smoker` | Categorical | Whether the party included smokers |
| `day` | Categorical | Thur, Fri, Sat or Sun |
| `time` | Categorical | Lunch or Dinner |
| `size` | Numeric | Number of people at the table |
| `total_bill` | Numeric | Bill amount (USD) |
| `tip` | Numeric | Tip amount (USD), the **target variable** |

---

## 🔍 Workflow

### 1. Data Validation & Encoding
![Dataset and encoding](screenshots/01-dataset-and-encoding.png)

- I checked for missing values (*Go To Special → Blanks*) and found none.
- I converted the categorical variables to numbers with `IF` formulas so they could be used in the regression:
  - `Gender = IF(sex="Male",1,0)`, `Smoker = IF(smoker="Yes",1,0)`, `Dinner = IF(time="Dinner",1,0)`
  - **Dummy variables** for each day: `Thur`, `Fri`, `Sat`, `Sun`

### 2. Exploratory Data Analysis (Pivot Tables & Charts)
![EDA pivot tables and charts](screenshots/02-eda-pivot-tables-charts.png)

| Analysis | Visual | Finding |
|----------|--------|---------|
| Tip by Gender | 2-D pie | Male payers account for **66%** of all tips ($485.07 vs $246.51) |
| Tip by Smoker | 3-D pie | Non-smoking parties account for **62%** of tips |
| Lunch vs Dinner by Gender | Stacked bar | **Dinner** brings in about 3× more tips than lunch ($546.07 vs $185.51) |
| Total Bill vs Tip (calculated field) | Pivot table | Overall tip rate is **15.15%** ($731.58 tips on $4,827.77 in bills) |
| Total Bill vs Tip | Scatter + linear trendline | A clear positive linear relationship |
| Party Size vs Tip | Scatter + linear trendline | Tips rise with party size |

### 3. Correlation Analysis (Feature Selection)
![Correlation matrix](screenshots/03-correlation-matrix.png)

| Variable | Correlation with Tip |
|----------|---------------------|
| **total_bill** | **0.676** |
| **size** | **0.489** |
| All other variables (sex, smoker, day, time) | below 0.13 |

**Decision:** I chose `total_bill` and `size` as the main predictors.

### 4. Model 1: Full Regression (All 9 Predictors)
![Full regression model](screenshots/04-full-regression-model.png)

| Metric | Value |
|--------|-------|
| R² | 0.470 |
| Adjusted R² | 0.448 |
| Significant predictors (p < 0.05) | **Only `Bill_Amount`**. `Table_Size` was borderline (p = 0.051) |

**Lesson learned:** The full model returned a coefficient of `0` and `#NUM!` errors for `Sun`. Because every row belongs to exactly one of the four days, the four day dummies always add up to 1 and duplicate the intercept. This is the **dummy variable trap** (perfect multicollinearity). It confirmed that a simpler model was the right choice.

### 5. Model 2: Final Multiple Regression (Size + Total Bill)
![Final model, predictions and RMSE](screenshots/05-final-model-prediction-rmse.png)

```
Predicted Tip = 0.6689 + 0.1926 × size + 0.0927 × total_bill
```

| Metric | Value |
|--------|-------|
| R² | 0.468 |
| **Adjusted R²** | **0.463** (higher than Model 1's 0.448) |
| F-statistic | 105.9 (Significance F ≈ 9.7 × 10⁻³⁴) |
| `total_bill` p-value | 1.9 × 10⁻²⁰ |
| `size` p-value | 0.025 |
| **RMSE** | **$1.007** |

How I evaluated the predictions:
- **Predicted tip** for each of the 244 rows, calculated from the regression equation
- **Squared error:** `=POWER(Actual - Predicted, 2)`
- **RMSE:** `=SQRT(SUM(squared_errors)/COUNT(squared_errors))`

---

## 💡 Key Insights

1. **The bill amount is the strongest driver of tips.** Each extra **$10** on the bill adds about **$0.93** to the tip, close to the 15% average tip rate.
2. **Each extra guest adds about $0.19** to the tip, after accounting for the bill.
3. **Gender, smoking status, day and time have no significant effect** once the bill and party size are known. The differences seen in the EDA (for example, men giving 66% of tips) come from **who pays and how much they spend**, not from different tipping habits.
4. **The simpler 2-variable model is better than the 9-variable model.** It has a higher adjusted R², every predictor is significant, and the multicollinearity problem is gone.
5. With an **RMSE of about $1.01**, the model can be used to forecast expected tips, for example to estimate staff earnings for each shift.

## 📁 Files

| File | Description |
|------|-------------|
| [`data/Restaurant_Tips_Dataset.xlsx`](data/Restaurant_Tips_Dataset.xlsx) | Source dataset (244 rows) |
| [`docs/Restaurant_Tip_Project_Report.pdf`](docs/Restaurant_Tip_Project_Report.pdf) | Full project report (PDF, viewable on GitHub) |
| [`docs/Restaurant_Tip_Project_Report.docx`](docs/Restaurant_Tip_Project_Report.docx) | Full project report (Word) |
| [`screenshots/`](screenshots/) | Encoding, EDA, correlation, regression and prediction sheets |

[← Back to portfolio](../../README.md)
