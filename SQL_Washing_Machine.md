# 🫧 Washing Machine Market Analysis — SQL Project

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql&logoColor=white)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)
![Dataset](https://img.shields.io/badge/Records-1056-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

> A structured SQL analysis of the Indian washing machine market, exploring pricing, brand performance, product features, and value-for-money across 9 major brands and 1,056 models.

---

## 📁 Project Structure

```
washing-machine-sql-analysis/
│
├── data/
│   └── Washingmachine0.csv          # Raw dataset (1,056 records)
│
├── sql/
│   └── washing_machine_analysis.sql # All DDL + analysis queries
│
└── README.md
```

---

## 🗄️ Database Schema

**Database:** `washing_machine`  
**Primary Table:** `washing`  
*(Loaded from staging table `ws0` via `ws1` intermediate)*

| Column | Type | Description |
|---|---|---|
| `Price_Indian` | INT | Retail price in Indian Rupees (₹) |
| `Ratings` | INT | Customer rating (out of 5) |
| `Brand_Name` | VARCHAR(15) | Manufacturer brand |
| `Model_Name` | VARCHAR(20) | Product model identifier |
| `Washing_Capacity` | VARCHAR(10) | Load capacity (e.g., 7 kg) |
| `Color` | VARCHAR(15) | Product color |
| `Maximum_Spin_Speed` | VARCHAR(30) | Max RPM (e.g., 1400 RPM) |
| `Function_Type` | VARCHAR(30) | Automation type (Fully / Semi Automatic) |
| `Inbuilt_Heater` | VARCHAR(5) | Whether heater is included (Yes/No) |
| `Washing_Method` | VARCHAR(15) | Mechanism (Pulsator, Tumble, Agitator, etc.) |

---

## 📊 Dataset Overview

| Attribute | Detail |
|---|---|
| Total Records | 1,056 models |
| Brands Covered | 9 |
| Price Range | ₹6,790 – ₹31,990 |
| Ratings Range | 4.0 – 4.5 |
| Washing Capacities | 6 kg – 9 kg |
| Function Types | Fully Automatic (Front & Top Load), Semi Automatic Top Load |

**Brands included:** SAMSUNG · LG · IFB · Whirlpool · HAIER · ONIDA · Midea · REALME TechLife · MarQ by Flipkart

---

## 🔍 Analysis Questions & SQL Highlights

### 1. Distinct Brands Available
```sql
SELECT DISTINCT Brand_Name FROM washing;
```

### 2. Average Price by Brand
```sql
SELECT Brand_Name, ROUND(AVG(Price_Indian), 2) AS brands_avg_price
FROM washing
GROUP BY Brand_Name;
```

### 3. Models with Inbuilt Heater
```sql
SELECT COUNT(*) AS Have_inbuilt_heater
FROM washing
WHERE Inbuilt_Heater = 'Yes';
```

### 4. Maximum Spin Speed in Dataset
> Handles string-formatted RPM values using `REPLACE` + `CAST`
```sql
SELECT MAX(CAST(REPLACE(Maximum_Spin_Speed, ' RPM', '') AS UNSIGNED)) AS Max_Spin_Speed
FROM washing;
```

### 5. Average Rating by Brand
```sql
SELECT Brand_Name, ROUND(AVG(Ratings), 2) AS avg_rating
FROM washing
GROUP BY Brand_Name
ORDER BY avg_rating DESC;
```

### 6. Average Price by Washing Capacity
```sql
SELECT Washing_Capacity, ROUND(AVG(Price_Indian), 2) AS avg_price_capacity
FROM washing
GROUP BY Washing_Capacity
ORDER BY Washing_Capacity ASC;
```

### 7. Function Type with Highest Average Price
```sql
SELECT Function_Type, ROUND(AVG(Price_Indian), 2) AS avg_price
FROM washing
GROUP BY Function_Type
ORDER BY avg_price DESC
LIMIT 1;
```

### 8. Top 5 Cheapest Models with Spin Speed > 1200 RPM
```sql
SELECT DISTINCT Model_Name, Price_Indian, Maximum_Spin_Speed
FROM washing
WHERE Maximum_Spin_Speed > 1200
ORDER BY Price_Indian ASC;
```

### 9. Most Frequent Color
```sql
SELECT Color, COUNT(*) AS Color_Count
FROM washing
GROUP BY Color
ORDER BY Color_Count DESC
LIMIT 1;
```

### 10. Best Value for Money (Price per kg Capacity)
```sql
SELECT Brand_Name, Model_Name, Washing_Capacity, Price_Indian,
    ROUND(Price_Indian / Washing_Capacity, 2) AS price_per_kg
FROM washing
ORDER BY price_per_kg ASC
LIMIT 1;
```

### 11. Inbuilt Heater Impact on Price & Ratings
> Uses correlated subqueries to compare two product segments side-by-side
```sql
SELECT
    (SELECT AVG(Price_Indian) FROM washing WHERE Inbuilt_Heater = 'Yes') AS avg_price_with_heater,
    (SELECT AVG(Ratings)     FROM washing WHERE Inbuilt_Heater = 'Yes') AS avg_rating_with_heater,
    (SELECT AVG(Price_Indian) FROM washing WHERE Inbuilt_Heater = 'No')  AS avg_price_without_heater,
    (SELECT AVG(Ratings)     FROM washing WHERE Inbuilt_Heater = 'No')  AS avg_rating_without_heater;
```

### 12. Best Function Type by Average Rating
```sql
SELECT Function_Type, AVG(Ratings) AS avg_rating
FROM washing
GROUP BY Function_Type
ORDER BY avg_rating DESC
LIMIT 1;
```

### 13. Brand with Widest Range of Models Across Capacities
```sql
SELECT DISTINCT Brand_Name, Model_Name, SUM(Washing_Capacity) AS widest_range
FROM washing
GROUP BY Brand_Name, Model_Name
ORDER BY Brand_Name DESC, Model_Name DESC;
```

### 14. Premium vs Budget Brand Ranking (Window Functions)
> Uses `RANK()` over aggregate partitions — no subqueries needed
```sql
SELECT
    Brand_Name,
    AVG(Ratings)     AS avg_rating,
    AVG(Price_Indian) AS avg_price,
    RANK() OVER (ORDER BY AVG(Ratings)     DESC) AS rating_rank,
    RANK() OVER (ORDER BY AVG(Price_Indian) DESC) AS price_rank
FROM washing
GROUP BY Brand_Name
ORDER BY price_rank DESC, avg_rating DESC;
```

---

## 🛠️ Setup & Usage

### Prerequisites
- MySQL 8.0+
- A SQL client (MySQL Workbench, DBeaver, CLI, etc.)

### Steps

```sql
-- 1. Create the database and staging table
CREATE DATABASE washing_machine;
CREATE TABLE washing_machine.ws1 ( ... );

-- 2. Import data from CSV into ws0 using your SQL client's import wizard
--    or via LOAD DATA INFILE:
LOAD DATA INFILE '/path/to/Washingmachine0.csv'
INTO TABLE washing_machine.ws0
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3. Clone to working table
CREATE TABLE washing_machine.washing LIKE washing_machine.ws0;
INSERT INTO washing_machine.washing SELECT * FROM washing_machine.ws0;

-- 4. Run analysis queries
USE washing_machine;
-- (paste queries from sql/washing_machine_analysis.sql)
```

---

## ⚠️ Known Query Notes

| Query | Note |
|---|---|
| Max Spin Speed | `Maximum_Spin_Speed` is stored as VARCHAR (e.g., `"1400 RPM"`). The query strips the unit using `REPLACE()` before casting to numeric for `MAX()`. |
| Price per kg | `Washing_Capacity` is stored as VARCHAR (e.g., `"7 kg"`). Implicit casting works in MySQL but explicit `CAST` is recommended for robustness. |
| Top 5 Cheapest > 1200 RPM | Applies the same string-to-numeric cast caveat as above. |

---

## 💡 Key Insights

- **IFB** dominates the premium segment with the highest average price, driven by its Front Load lineup.
- **Fully Automatic Front Load** machines command the highest average prices overall.
- **White** is the most common appliance color across all brands.
- Models with an **inbuilt heater** are priced significantly higher but don't always yield better ratings.
- **MarQ by Flipkart** and **REALME TechLife** position themselves as budget-friendly options with competitive ratings.

---

## 📌 Future Improvements

- [ ] Normalize `Washing_Capacity` and `Maximum_Spin_Speed` to numeric columns at schema level
- [ ] Add a `reviews_count` column to weight ratings more accurately
- [ ] Build a Tableau / Power BI dashboard on top of this dataset
- [ ] Extend analysis with year-over-year pricing trends

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you'd like to change.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

*Dataset sourced from publicly available Indian e-commerce listings. Analysis performed purely for educational purposes.*
