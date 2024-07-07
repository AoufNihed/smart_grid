--cleaning data 
SELECT * FROM electricitydata;

--1.remove duplicated

--1.1 create row_num to know how many times is duplicated
SELECT *, 
       ROW_NUMBER() OVER (PARTITION BY tau1, tau2, tau3, tau4, p1, p2, p3, p4, g1, g2, g3, g4, stab, stabf ) as row_num
FROM electricitydata;

WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY tau1, tau2, tau3, tau4, p1, p2, p3, p4, g1, g2, g3, g4, stab, stabf ) as row_num
    FROM electricitydata
)
SELECT *
FROM CTE
WHERE row_num >1;

--1.2create a new table to insert not duplacted values in :
CREATE TABLE new_data
(
    tau1 FLOAT NOT NULL,
    tau2 FLOAT NOT NULL,
    tau3 FLOAT NOT NULL,
    tau4 FLOAT NOT NULL,
    p1 FLOAT NOT NULL,
    p2 FLOAT NOT NULL,
    p3 FLOAT NOT NULL,
    p4 FLOAT NOT NULL,
    g1 FLOAT NOT NULL,
    g2 FLOAT NOT NULL,
    g3 FLOAT NOT NULL,
    g4 FLOAT NOT NULL,
    stab FLOAT NOT NULL,
    stabf character varying(10) COLLATE pg_catalog."default" NOT NULL,
	row_num INT NOT NULL
);

SELECT *
FROM new_data

--1.3insert data from basic table and delete the duplicated:

INSERT INTO new_data
SELECT *, 
       ROW_NUMBER() OVER (PARTITION BY tau1, tau2, tau3, tau4, p1, p2, p3, p4, g1, g2, g3, g4, stab, stabf ) as row_num
FROM electricitydata;

SELECT *
FROM new_data
WHERE row_num>1;

DELETE 
FROM new_data
WHERE row_num>1;

SELECT *
FROM new_data


--2.Standardizing Data: i don't have cz all data is float type

--3.NULL values or blank values

SELECT *,
       CASE 
           WHEN tau1 IS NULL AND tau2 IS NULL AND tau3 IS NULL AND tau4 IS NULL 
                AND p1 IS NULL AND p2 IS NULL AND p3 IS NULL AND p4 IS NULL 
                AND g1 IS NULL AND g2 IS NULL AND g3 IS NULL AND g4 IS NULL 
                AND stab IS NULL AND stabf IS NULL 
           THEN 'All columns are NULL' 
           ELSE 'Not all columns are NULL'
       END AS null_status
FROM new_data;


--4.save the clean data:
CREATE TABLE cleaned_electricitydata AS
SELECT *
FROM new_data;

SELECT *
FROM cleaned_electricitydata;


