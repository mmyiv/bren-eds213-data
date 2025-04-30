CREATE TABLE Snow_cover (
    SITE VARCHAR NOT NULL,
    Year INTEGER NOT NULL CHECK (Year BETWEEN 1990 AND 2018),
    Date DATE NOT NULL,
    Plot VARCHAR NOT NULL,
    Location VARCHAR NOT NULL,
    Snow_cover REAL CHECK (Snow_cover BETWEEN 0 AND 130),
    Water_cover REAL CHECK (Water_cover BETWEEN 0 AND 130),
    Land_cover REAL CHECK (Land_cover BETWEEN 0 AND 130),
    Observer VARCHAR,
    Notes VARCHAR,
    PRIMARY KEY (Site, Date, Plot, Location),
    FOREIGN KEY (Site) REFERENCES Site (Code)
);

SELECT * FROM Snow_cover; --empyty table, now load into CSV
DROP TABLE Snow_cover;


COPY Snow_cover FROM read_csv("../ASDN_csv/snow_survey_fixed.csv", header=true);

COPY Snow_cover FROM 'C:/Users/yivmi/Desktop/meds_spring/eds213/bren-eds213-data-1/ASDN_csv/snow_survey_fixed.csv' (header TRUE, nullstr "NA", delim ',');

COPY Snow_cover from '..\ASDN_csv\snow_survey_fixed2.csv' (header TRUE, nullstr 'NA', delim ',');

SELECT * FROM Snow_cover LIMIT 10;

-- Ask 1L What is the average sow cover at each site?
SELECT Site, AVG(Snow_cover) FROM Snow_cover
    GROUP BY Site;

-- Ask 2: Top 5 most snowy sites
SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snowcover
    Limit 5;

-- Ask 3: Save this as a VIEW
CREATE VIEW Site_avg_snowcover AS (
    SELECT Site, AVG(Snow_cover) AS Avg_snowcover FROM Snow_cover
    GROUP BY Site
    ORDER BY Avg_snowcover DESC
    LIMIT 5
);

-- danger zone
-- we found that 0s at Plot = 'brw0' with snow cover ==0 are actually no data (NULL)

-- Lets try first on a backup
CREATE TEMP TABLE Snow_cover_backup AS (SELECT * FROM Snow_cover);
UPDATE Snow_cover_backup SET Snow_cover = NULL WHERE PLOT = 'brw0' AND Snow_cover = 0;

-- it worked! Now let's try it on a real table
UPDATE Snow_cover SET Snow_cover = NULL WHERE PLOT = 'brw0' AND Snow_cover = 0;

-- Will view or temp table change after updating data?
SELECT * FROM Site_avg_snowcover;
SELECT * FROM Site_avg_snowcover_table;