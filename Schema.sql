USE google_play_store;

CREATE TABLE apps (
    App_ID INT AUTO_INCREMENT PRIMARY KEY,  
    App VARCHAR(255) NOT NULL,
    Category VARCHAR(100),
    Rating varchar(20),
    Reviews VARCHAR(20),
    Size VARCHAR(50),  
    Installs VARCHAR(50), 
    Type VARCHAR(10), 
    Price VARCHAR(10),
    Content_Rating VARCHAR(50),
    Genres VARCHAR(100),
    Last_Updated VARCHAR(20),
    Current_Ver VARCHAR(50),
    Android_Ver VARCHAR(50)
);


CREATE TABLE user_reviews (
    Review_ID INT AUTO_INCREMENT PRIMARY KEY,
    App VARCHAR(255) NOT NULL,
    Translated_Review TEXT,
    Sentiment VARCHAR(20),
    Sentiment_Polarity VARCHAR(50), 
    Sentiment_Subjectivity VARCHAR(50)
);

