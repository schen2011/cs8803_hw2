-- ***************************************************************************
-- Loading Data:
-- create external table mapping for events.csv and mortality_events.csv

-- IMPORTANT NOTES:
-- You need to put events.csv and mortality.csv under hdfs directory 
-- '/input/events/events.csv' and '/input/mortality/mortality.csv'
-- 
-- To do this, run the following commands for events.csv, 
-- 1. sudo su - hdfs
-- 2. hdfs dfs -mkdir -p /input/events
-- 3. hdfs dfs -chown -R vagrant /input
-- 4. exit 
-- 5. hdfs dfs -put /path/to/events.csv /input/events/
-- Follow the same steps 1 - 5 for mortality.csv, except that the path should be 
-- '/input/mortality'
-- ***************************************************************************
-- create events table 
DROP TABLE IF EXISTS events;
CREATE EXTERNAL TABLE events (
  patient_id STRING,
  event_id STRING,
  event_description STRING,
  time DATE,
  value DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/events';

-- create mortality events table 
DROP TABLE IF EXISTS mortality;
CREATE EXTERNAL TABLE mortality (
  patient_id STRING,
  time DATE,
  label INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/mortality';

-- ******************************************************
-- Task 1:
-- By manipulating the above two tables, 
-- generate two views for alive and dead patients' events
-- ******************************************************
-- find events for alive patients
DROP VIEW IF EXISTS alive_events;
CREATE VIEW alive_events 
AS
SELECT e.patient_id, e.event_id, e.time
FROM events e LEFT OUTER JOIN mortality m
ON (e.patient_id = m.patient_id)
WHERE m.patient_id IS NULL;
-- ***** your code below *****


-- find events for dead patients
DROP VIEW IF EXISTS dead_events;
CREATE VIEW dead_events 
AS
SELECT e.patient_id, e.event_id, e.time
FROM events e LEFT OUTER JOIN mortality m
ON (e.patient_id = m.patient_id);
-- ***** your code below *****



-- ************************************************
-- Task 2: Event count metrics
-- Compute average, min and max of event counts 
-- for alive and dead patients respectively  
-- ************************************************
-- alive patients
SELECT avg(event_count), min(event_count), max(event_count)
FROM (
    SELECT COUNT(*) AS event_count
    FROM alive_events
    GROUP BY alive_events.patient_id
) test;



-- dead patients
SELECT avg(event_count), min(event_count), max(event_count)
-- ***** your code below *****
FROM (
    SELECT COUNT(*) AS event_count
    FROM dead_events
    GROUP BY dead_events.patient_id
) test;



-- ************************************************
-- Task 3: Encounter count metrics 
-- Compute average, min and max of encounter counts 
-- for alive and dead patients respectively
-- ************************************************
-- alive
SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
FROM (
    SELECT COUNT(DISTINCT alive_events.time) AS encounter_count
    FROM alive_events
    GROUP BY alive_events.patient_id
) test;


-- dead
SELECT avg(encounter_count), min(encounter_count), max(encounter_count)
FROM (
    SELECT COUNT(DISTINCT dead_events.time) AS encounter_count
    FROM dead_events
    GROUP BY dead_events.patient_id
) test;




-- ************************************************
-- Task 4: Record length metrics
-- Compute average, min and max of record lengths
-- for alive and dead patients respectively
-- ************************************************
-- alive 
SELECT avg(record_length), min(record_length), max(record_length)
FROM (
    SELECT DATEDIFF(max(alive_events.time), min(alive_events.time)) AS record_length
    FROM alive_events
    GROUP BY alive_events.patient_id
) test;



-- dead
SELECT avg(record_length), min(record_length), max(record_length)
FROM (
    SELECT DATEDIFF(max(dead_events.time), min(dead_events.time)) AS record_length
    FROM dead_events
    GROUP BY dead_events.patient_id
) test;




-- ******************************************* 
-- Task 5: Common diag/lab/med
-- Compute the 5 most frequently occurring diag/lab/med
-- for alive and dead patients respectively
-- *******************************************
-- alive patients
---- diag
SELECT event_id, count(*) AS diag_count
FROM alive_events
-- ***** your code below *****


---- lab
SELECT event_id, count(*) AS lab_count
FROM alive_events
-- ***** your code below *****


---- med
SELECT event_id, count(*) AS med_count
FROM alive_events
-- ***** your code below *****




-- dead patients
---- diag
SELECT event_id, count(*) AS diag_count
FROM dead_events
-- ***** your code below *****


---- lab
SELECT event_id, count(*) AS lab_count
FROM dead_events
-- ***** your code below *****


---- med
SELECT event_id, count(*) AS med_count
FROM dead_events
-- ***** your code below *****









