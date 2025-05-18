-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: datawarehouse
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `metadata`
--

DROP TABLE IF EXISTS `metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `metadata` (
  `TableName` varchar(50) NOT NULL,
  `ColumnName` varchar(50) NOT NULL,
  `DataType` varchar(50) DEFAULT NULL,
  `IsPrimaryKey` tinyint(1) DEFAULT NULL,
  `IsForeignKey` tinyint(1) DEFAULT NULL,
  `ReferencesTable` varchar(50) DEFAULT NULL,
  `ReferencesColumn` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`TableName`,`ColumnName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metadata`
--

LOCK TABLES `metadata` WRITE;
/*!40000 ALTER TABLE `metadata` DISABLE KEYS */;
INSERT INTO `metadata` VALUES ('Dim_Date','DateID','INT',1,0,NULL,NULL),('Dim_Date','Day','INT',0,0,NULL,NULL),('Dim_Date','DayOfWeek','VARCHAR(10)',0,0,NULL,NULL),('Dim_Date','FullDate','DATE',0,0,NULL,NULL),('Dim_Date','Month','INT',0,0,NULL,NULL),('Dim_Date','Quarter','INT',0,0,NULL,NULL),('Dim_Date','Year','INT',0,0,NULL,NULL),('Dim_Store','CityID','INT',0,0,NULL,NULL),('Dim_Store','CityName','VARCHAR(100)',0,0,NULL,NULL),('Dim_Store','OfficeAddress','VARCHAR(200)',0,0,NULL,NULL),('Dim_Store','Phone','VARCHAR(20)',0,0,NULL,NULL),('Dim_Store','State','VARCHAR(100)',0,0,NULL,NULL),('Dim_Store','StoreID','INT',1,0,NULL,NULL),('Fact_Inventory','DateID','INT',1,1,'Dim_Date','DateID'),('Fact_Inventory','ProductID','INT',1,1,'Dim_Product','ProductID'),('Fact_Inventory','QuantityInStock','INT',0,0,NULL,NULL),('Fact_Inventory','StoreID','INT',1,1,'Dim_Store','StoreID'),('InventoryCube','CityName','VARCHAR(100)',1,0,NULL,NULL),('InventoryCube','Month','INT',1,0,NULL,NULL),('InventoryCube','ProductDescription','VARCHAR(200)',1,0,NULL,NULL),('InventoryCube','Quarter','INT',1,0,NULL,NULL),('InventoryCube','TotalStock','INT',0,0,NULL,NULL),('InventoryCube','Year','INT',1,0,NULL,NULL);
/*!40000 ALTER TABLE `metadata` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-18 15:37:05
