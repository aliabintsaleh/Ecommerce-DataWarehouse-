/*================================================
 Create Database and Schema
 =================================================
 This script recreates the 
 **'E-commerce-Warehouse'** database and creates three schemas: 
 **staging**, **core**, and **analytics**.
 ===================================================================
 */
 USE MASTER;
 ------Droped and recreate the 'E-commerc-Wharehouse'database-----

 GO

 IF EXISTS(SELECT 1 FROM SYS.DATABASES WHERE NAME='E_commerc_Wharehouse')
 BEGIN
 ALTER DATABASE E_commerc_Wharehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
 DROP DATABASE E_commerc_Wharehouse;
 END;
 ---------Create database E-commerc-Wharehouse------
 GO
 CREATE DATABASE E_commerc_Wharehouse;
 GO
 USE E_commerc_Wharehouse;
 ----------CREATE SCHEMAS----------
 GO
CREATE SCHEMA staging;
GO
CREATE SCHEMA core;
GO
CREATE SCHEMA analytics;

