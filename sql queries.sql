USE google_play_store;

-- DATA CLEANING

-- 1. Clean Installs (remove '+' and commas, convert to INT)
UPDATE apps
SET Installs = REPLACE(REPLACE(Installs, '+', ''), ',', '');
ALTER TABLE apps
MODIFY Installs INT;

-- 2. Cleaning Last_Updated Column
SET SQL_SAFE_UPDATES = 0;
-- Convert Last_Updated from '7-Jan-18' style into DATE
UPDATE apps
SET Last_Updated = STR_TO_DATE(Last_Updated, '%d-%b-%y')
WHERE Last_Updated IS NOT NULL;
SET SQL_SAFE_UPDATES = 1;

-- 3. Cleaning Rating Column
SET SQL_SAFE_UPDATES = 0;
-- Replace invalid Rating values with NULL
UPDATE apps
SET Rating = NULL
WHERE Rating IN ('NaN','nan','NULL','');
SET SQL_SAFE_UPDATES = 1;
SET SQL_SAFE_UPDATES = 0;
UPDATE apps
SET Rating = 0
WHERE Rating IS NULL;

-- 4. Cleaning Price Column
-- Remove $ symbol and convert 'Free'/'NaN' to 0.00 or NULL
UPDATE apps
SET Price = REPLACE(Price, '$', '');
UPDATE apps
SET Price = '0.00'
WHERE Price IN ('Free','free','NaN','nan','');

-- 5. Final Schema Update (Evaluator‑friendly datatypes)
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

-- 6. Clean Size (handle 'Varies with device', convert MB to numeric)
UPDATE apps
SET Size = NULL
WHERE Size = 'Varies with device';

-- Remove 'M' and convert to numeric MB
UPDATE apps
SET Size = REPLACE(Size, 'M', '');

-- Handle 'Varies with device' and blanks
UPDATE apps
SET Size = NULL
WHERE Size IN ('Varies with device', '', 'NaN', 'nan');

-- Remove 'M' (megabytes) and convert to numeric
UPDATE apps
SET Size = REPLACE(Size, 'M', '')
WHERE Size LIKE '%M%';

-- Remove 'k' or other non-numeric suffixes if present
UPDATE apps
SET Size = REPLACE(Size, 'k', '')
WHERE Size LIKE '%k%';

-- Now safely convert column to FLOAT
ALTER TABLE apps
MODIFY Size FLOAT;

-- 7. Replace Blank Values with NULL
UPDATE user_reviews
SET Sentiment_Polarity = NULL
WHERE Sentiment_Polarity = '';

UPDATE user_reviews
SET Sentiment_Subjectivity = NULL
WHERE Sentiment_Subjectivity = '';

-- 8. Handle Non-Numeric Values
UPDATE user_reviews
SET Sentiment_Polarity = NULL
WHERE Sentiment_Polarity REGEXP '^[0-9.-]+$' = 0;

UPDATE user_reviews
SET Sentiment_Subjectivity = NULL
WHERE Sentiment_Subjectivity REGEXP '^[0-9.-]+$' = 0;

-- 9. Normalize Sentiment values
UPDATE user_reviews
SET Sentiment = CASE
    WHEN LOWER(Sentiment) LIKE 'pos%' THEN 'Positive'
    WHEN LOWER(Sentiment) LIKE 'neg%' THEN 'Negative'
    WHEN LOWER(Sentiment) LIKE 'neu%' THEN 'Neutral'
    ELSE 'Neutral'
END;

-- 10. Update Table Schema
ALTER TABLE user_reviews 
MODIFY Translated_Review TEXT,
MODIFY Sentiment VARCHAR(20),
MODIFY Sentiment_Polarity FLOAT,
MODIFY Sentiment_Subjectivity FLOAT;

-- 11. Remove duplicates (keep lowest App_ID)
DELETE a1
FROM apps a1
JOIN apps a2
ON a1.App = a2.App AND a1.App_ID > a2.App_ID;

-- CATEGORY EXPLORATION

-- 1. Category wise app count + review count
SELECT a.Category,
       COUNT(DISTINCT a.App_ID) AS App_Count,
       COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category
ORDER BY App_Count DESC;

-- 2. Avg rating per category + avg sentiment polarity
SELECT a.Category,
       ROUND(AVG(a.Rating),2) AS Avg_Rating,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL AND ur.Sentiment_Polarity IS NOT NULL
GROUP BY a.Category
ORDER BY Avg_Rating DESC;

-- 3. Free vs Paid apps + sentiment distribution
SELECT a.Type,
       ur.Sentiment,
       COUNT(*) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Type, ur.Sentiment
ORDER BY a.Type, Review_Count DESC;


-- METRICS ANALYSIS

-- 1. Popularity: installs vs reviews vs ratings
-- Scatter plot prep: Rating vs Installs (with review count)
SELECT a.App, a.Rating, a.Installs, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL AND a.Installs IS NOT NULL
GROUP BY a.App, a.Rating, a.Installs;

-- Top 10 apps by number of reviews (Bar Chart)
SELECT a.App, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App
ORDER BY Review_Count DESC
LIMIT 10;

-- 2. Pricing trends: average price per category
SELECT a.Category, ROUND(AVG(a.Price),2) AS Avg_Price
FROM apps a
WHERE a.Type = 'Paid'
GROUP BY a.Category
ORDER BY Avg_Price DESC;

-- 3. Size trends: app size vs rating (Line Chart prep)
SELECT a.App, a.Size, a.Rating
FROM apps a
WHERE a.Size IS NOT NULL AND a.Rating IS NOT NULL;

-- Size vs Installs correlation (optional heatmap prep)
SELECT a.App, a.Size, a.Installs, COUNT(ur.Review_ID) AS Review_Count
FROM apps a
LEFT JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Size IS NOT NULL AND a.Installs IS NOT NULL
GROUP BY a.App, a.Size, a.Installs;

-- 4. Category wise Paid apps ratio (Pie Chart)
SELECT a.Category,
       SUM(CASE WHEN a.Type = 'Paid' THEN 1 ELSE 0 END) AS Paid_Apps,
       SUM(CASE WHEN a.Type = 'Free' THEN 1 ELSE 0 END) AS Free_Apps
FROM apps a
GROUP BY a.Category;


-- SENTIMENT ANALYSIS

-- 1. Sentiment distribution overall (Pie Chart)
SELECT ur.Sentiment, COUNT(*) AS Review_Count
FROM user_reviews ur
GROUP BY ur.Sentiment;

-- Sentiment distribution per category
SELECT a.Category, ur.Sentiment, COUNT(*) AS Review_Count
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category, ur.Sentiment
ORDER BY a.Category, Review_Count DESC;

-- 2. Avg polarity & subjectivity per app (BAR CHART)
SELECT a.App,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity,
       ROUND(AVG(ur.Sentiment_Subjectivity),3) AS Avg_Subjectivity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App
ORDER BY Avg_Polarity DESC;

-- Avg polarity & subjectivity per category (BAR CHART)
SELECT a.Category,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity,
       ROUND(AVG(ur.Sentiment_Subjectivity),3) AS Avg_Subjectivity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.Category
ORDER BY Avg_Polarity DESC;

-- 3. Correlation: High rating apps → more positive reviews? (SCATTER TABLE)
SELECT a.App, a.Rating,
       SUM(CASE WHEN ur.Sentiment = 'Positive' THEN 1 ELSE 0 END) AS Positive_Reviews,
       SUM(CASE WHEN ur.Sentiment = 'Negative' THEN 1 ELSE 0 END) AS Negative_Reviews,
       SUM(CASE WHEN ur.Sentiment = 'Neutral' THEN 1 ELSE 0 END) AS Neutral_Reviews
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
WHERE a.Rating IS NOT NULL
GROUP BY a.App, a.Rating
ORDER BY a.Rating DESC;

-- 4. Reviews vs Installs correlation (Heatmap prep)
SELECT a.App, a.Category, a.Installs,
       COUNT(ur.Review_ID) AS Review_Count,
       ROUND(AVG(ur.Sentiment_Polarity),3) AS Avg_Polarity
FROM apps a
JOIN user_reviews ur ON a.App_ID = ur.App_ID
GROUP BY a.App, a.Category, a.Installs
ORDER BY Review_Count DESC;