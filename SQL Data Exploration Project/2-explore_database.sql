/*=====================================================================
DATABASE EXPLORAIONS 
=======================================================================
Objective:
To explore the sturcture of the database and tables and their schemas.
=======================================================================
*/

--Retreive all tables in the database.
SELECT
TABLE_CATALOG,
TABLE_SCHEMA,
TABLE_TYPE,
TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
--==========================================
--RETREIVE ALL COLUMNS IN ONE TABLE.
SELECT 
COLUMN_NAME,
DATA_TYPE,
IS_NULLABLE,
CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Customers'