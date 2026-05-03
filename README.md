# 📱 Unveiling the Android App Market: Google Play Store Analysis

**OIBSIP Internship – Level 2 Data Analytics | Project 3**

A comprehensive data analytics project analyzing the Google Play Store app ecosystem through data cleaning, visualization, and sentiment analysis. This project leverages advanced analytics techniques to understand app market dynamics and user sentiments.


## 📋 Project Overview

**Project Title**: Unveiling the Android App Market: Analyzing Google Play Store Data   
**Database**: `google_play_store`

This repository contains an in-depth analysis of Android apps on the Google Play Store, exploring app distribution, ratings, pricing trends, and user sentiments. The project demonstrates end-to-end data analytics workflow including:

- **Data Cleaning & Preparation**: Correcting data types and handling missing values
- **Category Exploration**: Analyzing app distribution across different categories
- **Metrics Analysis**: Examining ratings, size, popularity, and pricing trends
- **Sentiment Analysis**: Assessing user sentiments through review data
- **Interactive Visualizations**: Creating compelling visual representations of insights


## 📁 Repository Structure

```
OIBSIP_Data-Analytics_3/
├── README.md                                # Project documentation
├── Schema.sql                               # Database schema definition
├── sql queries.sql                          # Analytics queries
├── processed apps dataset.csv               # Cleaned apps data
├── processed user_reviews dataset.csv       # Cleaned user reviews data
├── unprocessed apps dataset.csv             # Raw apps data
├── unprocessed user_reviews dataset.csv     # Raw user reviews data
└── Visualization/                           # Visualization outputs
```


## 🗄️ Database Schema

### Apps Table
Stores metadata about Google Play Store applications:

| Column | Type | Description |
|--------|------|-------------|
| App_ID | INT (PK) | Unique identifier for each app |
| App | VARCHAR(255) | Application name |
| Category | VARCHAR(100) | App category (e.g., Games, Social, etc.) |
| Rating | FLOAT | User rating (0-5 scale) |
| Reviews | INT | Number of user reviews |
| Size | FLOAT | App size in MB |
| Installs | INT | Number of installations |
| Type | ENUM('Free','Paid') | Whether app is free or paid |
| Price | DECIMAL(10,2) | Price of the app (for paid apps) |
| Content_Rating | VARCHAR(50) | Age appropriateness rating |
| Genres | VARCHAR(100) | App genres |
| Last_Updated | DATE | Last update date |
| Current_Ver | VARCHAR(50) | Current app version |
| Android_Ver | VARCHAR(50) | Required Android version |

### User Reviews Table
Contains sentiment analysis of user reviews:

| Column | Type | Description |
|--------|------|-------------|
| Review_ID | INT (PK) | Unique identifier for each review |
| App | VARCHAR(255) | Application name (FK) |
| Translated_Review | TEXT | User review text |
| Sentiment | VARCHAR(20) | Sentiment classification (Positive/Negative/Neutral) |
| Sentiment_Polarity | FLOAT | Polarity score (-1 to 1) |
| Sentiment_Subjectivity | FLOAT | Subjectivity score (0 to 1) |


## 🧹 Data Cleaning Process

The project includes comprehensive data cleaning operations:

### Numeric Conversions
- **Installs**: Removed '+' symbols and commas, converted to INT
- **Price**: Removed '$' symbols, standardized 'Free' and 'NaN' values to 0.00
- **Size**: Converted MB values to FLOAT, handled 'Varies with device' entries

### Date Standardization
- Converted Last_Updated from format 'DD-Mon-YY' to DATE type

### Rating Validation
- Replaced invalid values ('NaN', 'nan', 'NULL', '') with 0

### Sentiment Normalization
- Standardized sentiment values: 'Positive', 'Negative', 'Neutral'
- Validated polarity and subjectivity as numeric floats

### Duplicate Removal
- Eliminated duplicate app entries, retaining the lowest App_ID


## 📊 Analytics & Queries

### Category Exploration
- **Category Distribution**: App count and review count per category
- **Category Performance**: Average rating and sentiment polarity by category
- **Type Distribution**: Free vs Paid apps with sentiment breakdown

### Metrics Analysis
- **Popularity Metrics**: 
  - Rating vs Installs correlation
  - Top 10 apps by review count
  - Reviews vs Installs analysis

- **Pricing Trends**:
  - Average price by category for paid apps
  - Paid vs Free app distribution

- **Size Analysis**:
  - App size vs rating relationship
  - Size vs installs correlation

### Sentiment Analysis
- **Overall Sentiment Distribution**: Pie chart of sentiment breakdown
- **Category-wise Sentiment**: Sentiment distribution per app category
- **Polarity & Subjectivity Analysis**:
  - Average sentiment metrics per app
  - Category-level sentiment trends
  
- **Correlation Analysis**:
  - High ratings → More positive reviews relationship
  - App popularity vs user sentiment


## 🔍 Key Insights & Metrics

### Data Statistics
- **Total Apps Analyzed**: ~10,000+ applications
- **Total User Reviews**: ~100,000+ reviews
- **Categories Covered**: 33+ different app categories
- **Rating Range**: 0-5.0 scale
- **Sentiment Classification**: Positive, Negative, Neutral

### Analysis Focus Areas

#### 1. **App Distribution**
   - Category-wise app count
   - Free vs Paid distribution
   - Content rating breakdown

#### 2. **Performance Indicators**
   - Average ratings per category
   - Installation trends
   - User engagement through reviews

#### 3. **Market Dynamics**
   - Pricing strategies by category
   - App size trends
   - Update frequency

#### 4. **User Sentiment**
   - Review sentiment distribution
   - Polarity trends across categories
   - Subjectivity analysis


## 📈 Visualization Types

The project includes preparation for multiple visualization types:

- **Bar Charts**: Top apps by reviews, Average metrics by category
- **Pie Charts**: Sentiment distribution, Paid/Free ratio
- **Scatter Plots**: Rating vs Installs, Size vs Performance
- **Line Charts**: App size vs rating trends
- **Heatmaps**: Correlation analysis for multiple dimensions

## Tools Used

| Tool | Purpose |
|---|---|
| **MySQL 8.0** | Database creation, data cleaning, EDA queries |
| **MySQL Workbench** | SQL execution and schema management |
| **Excel / Charting** | Visualization of query outputs |


## 📝 SQL Query Categories

### Data Cleaning (10+ operations)
- Type conversions and standardization
- Missing value handling
- Data validation

### Category Exploration (3 main queries)
- Category statistics
- Performance metrics
- Distribution analysis

### Metrics Analysis (4 main queries)
- Popularity analysis
- Pricing trends
- Size correlations
- Category ratios

### Sentiment Analysis (4 main queries)
- Overall sentiment distribution
- Category-wise sentiment
- Polarity and subjectivity analysis
- Correlation studies


## 🚀 Getting Started

### Prerequisites
- MySQL Server (v5.7 or higher)
- Database client (MySQL Workbench, command line, etc.)

### Setup Instructions

1. **Create the database**:
   ```sql
   CREATE DATABASE google_play_store;
   ```

2. **Create schema**:
   ```sql
   SOURCE Schema.sql;
   ```

3. **Import data**:
   ```sql
   SOURCE import\ data.sql;
   ```

4. **Run analytics queries**:
   ```sql
   SOURCE sql\ queries.sql;
   ```


## 🎯 Project Objectives

✅ **Data Preparation**: Clean and standardize data types for accuracy  
✅ **Category Analysis**: Investigate app distribution across categories  
✅ **Metrics Examination**: Analyze ratings, size, popularity, and pricing  
✅ **Sentiment Assessment**: Evaluate user sentiments through reviews  
✅ **Visualization**: Create compelling visual representations  
✅ **Skills Integration**: Apply data visualization best practices  


## 📊 Sample Query Example

### Final Schema Update (Evaluator-friendly datatypes)
```sql
ALTER TABLE apps
MODIFY App VARCHAR(255) NOT NULL,
MODIFY Category VARCHAR(100),
MODIFY Rating FLOAT,
MODIFY Reviews INT,
MODIFY Size VARCHAR(50),
MODIFY Installs VARCHAR(50),
MODIFY Type ENUM('Free','Paid'),
MODIFY Price DECIMAL(10,2),
MODIFY Content_Rating VARCHAR(50),
MODIFY Genres VARCHAR(100),
MODIFY Last_Updated DATE,
MODIFY Current_Ver VARCHAR(50),
MODIFY Android_Ver VARCHAR(50);
```

```sql
ALTER TABLE user_reviews 
MODIFY Translated_Review TEXT,
MODIFY Sentiment VARCHAR(20),
MODIFY Sentiment_Polarity FLOAT,
MODIFY Sentiment_Subjectivity FLOAT;
```

### Category wise app count + review count
```sql
SELECT a.Category,
       COUNT(DISTINCT a.App_ID) AS App_Count,
       COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category
ORDER BY App_Count DESC;
```


### Free vs Paid apps + sentiment distribution
```sql
SELECT a.Type,
       ur.Sentiment,
       COUNT(*) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Type, ur.Sentiment
ORDER BY a.Type, Review_Count DESC;
```

### Get Top 10 Apps by Review Count
```sql
SELECT a.App, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App
ORDER BY Review_Count DESC
LIMIT 10;
```


### Pricing trends: average price per category
```sql
SELECT a.Category, ROUND(AVG(a.Price),2) AS Avg_Price
FROM apps a
WHERE a.Type = 'Paid'
GROUP BY a.Category
ORDER BY Avg_Price DESC;
```

### Category Performance Analysis
```sql
SELECT a.Category,
       ROUND(AVG(a.Rating),2) AS Avg_Rating,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL AND ur.Sentiment_Polarity IS NOT NULL
GROUP BY a.Category
ORDER BY Avg_Rating DESC;
```


## 📝 Exploratory Data Analysis (EDA) Report

- *Introduction:-*
This report presents a structured analysis of Google Play Store data. 
The aim is to clean, categorize, and interpret app and user review information 
to uncover market dynamics, user engagement patterns, pricing strategies, and sentiment trends. 
The findings provide actionable insights for developers, businesses, and evaluators.

- *Category Exploration*
  - FAMILY has the largest app count (1827), but GAME dominates reviews (10,640). 
  - Medical and Health apps show high engagement relative to app count. 
  - AUTO_AND_VEHICLES and EDUCATION categories lead with strong ratings (~4.4+) and balanced sentiment. 
  - Free apps dominate sentiment volume (31,504 Neutral, 23,671 Positive), while Paid apps are fewer but generally positive.  

- *Metrics Analysis*
  - Popular creative apps like "Sketch - Draw & Paint" (50M installs, rating 4.5) and "Ibis Paint X" (10M installs, rating 4.6) dominate installs. 
  - Top reviewed apps include "Photo Editor & Candy Camera" (400 reviews), "CBS Sports App", and "Angry Birds Classic". 
  - Finance (140.39) and Lifestyle (124.26) categories have the highest average prices, while Tools and Communication remain low-cost. 
  - Larger creative apps maintain strong ratings, but smaller apps can also achieve high satisfaction (Photo Designer, 5.5 MB, rating 4.7). 
  - FAMILY and MEDICAL categories show significant paid app presence, while Games remain predominantly free.  

- *Sentiment Analysis*
  - Overall sentiment: Neutral reviews dominate (32,030), but positives (23,996) outweigh negatives (8,269). 
  - Games attract the most reviews but also high negativity (2408). Health & Fitness apps show strong positivity (1754 Positive vs 257 Negative). 
  - Educational and productivity apps trend towards higher polarity (Homework, Google Slides), while entertainment apps show mixed tone. 
  - COMICS and EVENTS categories are perceived positively, while Games are polarizing. 
  - High ratings generally align with positive reviews (e.g., Down Dog Yoga, rating 4.9, 40 Positive, 0 Negative). Popular games show polarity between user groups. 
  - High installs do not guarantee high review counts; engagement varies by app type (Duolingo vs Google Photos).  

- *Recommendations*
  - Focus on categories with high ratings and balanced sentiment (Education, Health & Fitness, Auto). 
  - Address negativity in Games by improving stability, user experience, and support. 
  - Explore monetization opportunities in Finance and Lifestyle categories where users accept higher pricing. 
  - Encourage lightweight apps with strong ratings as they show high satisfaction despite smaller size. 
  - Leverage sentiment polarity insights to design better user engagement strategies.  

- *Conclusion:-*
The analysis reveals that while Games dominate in volume and reviews, they face sentiment challenges. 
Education, Health & Fitness, and niche categories show strong positivity and user satisfaction. 
Finance and Lifestyle categories present monetization opportunities. 
Overall, the Android app market is diverse, with clear signals for developers and businesses to align product strategies with user expectations.



## 📄 License

This project is part of the OIBSIP (Oasis Infobyte Summer Internship Program) Data Analytics curriculum.


## 👨‍💻 Author

**Aman-raj048**


## 🔗 References

- **Course**: Understanding Data Visualization & Data Analytics
- **Project Type**: Academic Research & Data Analytics
- **Dataset Source**: Google Play Store Public Data


## 📞 Support

For questions or issues related to this project, please refer to the query files and schema documentation provided in the repository.


**Last Updated**: 2026-05-03  
**Status**: Active Development
