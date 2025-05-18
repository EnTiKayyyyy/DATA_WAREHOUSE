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
-- Temporary view structure for view `customertypeview`
--

DROP TABLE IF EXISTS `customertypeview`;
/*!50001 DROP VIEW IF EXISTS `customertypeview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customertypeview` AS SELECT 
 1 AS `CustomerName`,
 1 AS `Tourist`,
 1 AS `Regular`,
 1 AS `Both`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `ordercustomerview`
--

DROP TABLE IF EXISTS `ordercustomerview`;
/*!50001 DROP VIEW IF EXISTS `ordercustomerview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ordercustomerview` AS SELECT 
 1 AS `OrderID`,
 1 AS `CustomerName`,
 1 AS `OrderDate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `inventoryvalidation`
--

DROP TABLE IF EXISTS `inventoryvalidation`;
/*!50001 DROP VIEW IF EXISTS `inventoryvalidation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `inventoryvalidation` AS SELECT 
 1 AS `StoreID`,
 1 AS `ProductID`,
 1 AS `QuantityInStock`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `storeorderedproductview`
--

DROP TABLE IF EXISTS `storeorderedproductview`;
/*!50001 DROP VIEW IF EXISTS `storeorderedproductview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `storeorderedproductview` AS SELECT 
 1 AS `StoreID`,
 1 AS `CityName`,
 1 AS `Phone`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `storeproductview`
--

DROP TABLE IF EXISTS `storeproductview`;
/*!50001 DROP VIEW IF EXISTS `storeproductview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `storeproductview` AS SELECT 
 1 AS `StoreID`,
 1 AS `CityName`,
 1 AS `State`,
 1 AS `Phone`,
 1 AS `Description`,
 1 AS `Size`,
 1 AS `Weight`,
 1 AS `Price`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `orderdetailsview`
--

DROP TABLE IF EXISTS `orderdetailsview`;
/*!50001 DROP VIEW IF EXISTS `orderdetailsview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `orderdetailsview` AS SELECT 
 1 AS `OrderID`,
 1 AS `Description`,
 1 AS `StoreID`,
 1 AS `CityName`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `ordervalidation`
--

DROP TABLE IF EXISTS `ordervalidation`;
/*!50001 DROP VIEW IF EXISTS `ordervalidation`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `ordervalidation` AS SELECT 
 1 AS `OrderID`,
 1 AS `DetailCount`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `fullorderdetailsview`
--

DROP TABLE IF EXISTS `fullorderdetailsview`;
/*!50001 DROP VIEW IF EXISTS `fullorderdetailsview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `fullorderdetailsview` AS SELECT 
 1 AS `OrderID`,
 1 AS `QuantityOrdered`,
 1 AS `CustomerName`,
 1 AS `StoreID`,
 1 AS `CityName`,
 1 AS `Description`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `customerlocationview`
--

DROP TABLE IF EXISTS `customerlocationview`;
/*!50001 DROP VIEW IF EXISTS `customerlocationview`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `customerlocationview` AS SELECT 
 1 AS `CustomerName`,
 1 AS `CityName`,
 1 AS `State`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `customertypeview`
--

/*!50001 DROP VIEW IF EXISTS `customertypeview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customertypeview` AS select `dim_customer`.`CustomerName` AS `CustomerName`,(case when (`dim_customer`.`IsTourist` = 1) then 'Tourist' else '' end) AS `Tourist`,(case when (`dim_customer`.`IsRegular` = 1) then 'Regular' else '' end) AS `Regular`,(case when ((`dim_customer`.`IsTourist` = 1) and (`dim_customer`.`IsRegular` = 1)) then 'Both' else '' end) AS `Both` from `dim_customer` where ((`dim_customer`.`IsTourist` = 1) or (`dim_customer`.`IsRegular` = 1)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ordercustomerview`
--

/*!50001 DROP VIEW IF EXISTS `ordercustomerview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ordercustomerview` AS select `o`.`OrderID` AS `OrderID`,`c`.`CustomerName` AS `CustomerName`,`o`.`OrderDate` AS `OrderDate` from (`fact_order` `o` join `dim_customer` `c` on((`o`.`CustomerID` = `c`.`CustomerID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `inventoryvalidation`
--

/*!50001 DROP VIEW IF EXISTS `inventoryvalidation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `inventoryvalidation` AS select `fact_inventory`.`StoreID` AS `StoreID`,`fact_inventory`.`ProductID` AS `ProductID`,`fact_inventory`.`QuantityInStock` AS `QuantityInStock` from `fact_inventory` where (`fact_inventory`.`QuantityInStock` < 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `storeorderedproductview`
--

/*!50001 DROP VIEW IF EXISTS `storeorderedproductview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `storeorderedproductview` AS select distinct `s`.`StoreID` AS `StoreID`,`s`.`CityName` AS `CityName`,`s`.`Phone` AS `Phone` from ((`dim_store` `s` join `fact_inventory` `i` on((`s`.`StoreID` = `i`.`StoreID`))) join `fact_orderdetail` `od` on((`i`.`ProductID` = `od`.`ProductID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `storeproductview`
--

/*!50001 DROP VIEW IF EXISTS `storeproductview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `storeproductview` AS select `s`.`StoreID` AS `StoreID`,`s`.`CityName` AS `CityName`,`s`.`State` AS `State`,`s`.`Phone` AS `Phone`,`p`.`Description` AS `Description`,`p`.`Size` AS `Size`,`p`.`Weight` AS `Weight`,`p`.`Price` AS `Price` from ((`dim_store` `s` join `fact_inventory` `i` on((`s`.`StoreID` = `i`.`StoreID`))) join `dim_product` `p` on((`i`.`ProductID` = `p`.`ProductID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `orderdetailsview`
--

/*!50001 DROP VIEW IF EXISTS `orderdetailsview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `orderdetailsview` AS select `o`.`OrderID` AS `OrderID`,`p`.`Description` AS `Description`,`s`.`StoreID` AS `StoreID`,`s`.`CityName` AS `CityName` from ((((`fact_order` `o` join `fact_orderdetail` `od` on((`o`.`OrderID` = `od`.`OrderID`))) join `dim_product` `p` on((`od`.`ProductID` = `p`.`ProductID`))) join `fact_inventory` `i` on((`p`.`ProductID` = `i`.`ProductID`))) join `dim_store` `s` on((`i`.`StoreID` = `s`.`StoreID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ordervalidation`
--

/*!50001 DROP VIEW IF EXISTS `ordervalidation`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ordervalidation` AS select `o`.`OrderID` AS `OrderID`,count(`od`.`OrderID`) AS `DetailCount` from (`fact_order` `o` left join `fact_orderdetail` `od` on((`o`.`OrderID` = `od`.`OrderID`))) group by `o`.`OrderID` having (count(`od`.`OrderID`) = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `fullorderdetailsview`
--

/*!50001 DROP VIEW IF EXISTS `fullorderdetailsview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `fullorderdetailsview` AS select `o`.`OrderID` AS `OrderID`,`od`.`QuantityOrdered` AS `QuantityOrdered`,`c`.`CustomerName` AS `CustomerName`,`s`.`StoreID` AS `StoreID`,`s`.`CityName` AS `CityName`,`p`.`Description` AS `Description` from (((((`fact_order` `o` join `fact_orderdetail` `od` on((`o`.`OrderID` = `od`.`OrderID`))) join `dim_customer` `c` on((`o`.`CustomerID` = `c`.`CustomerID`))) join `dim_product` `p` on((`od`.`ProductID` = `p`.`ProductID`))) join `fact_inventory` `i` on((`p`.`ProductID` = `p`.`ProductID`))) join `dim_store` `s` on((`i`.`StoreID` = `s`.`StoreID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `customerlocationview`
--

/*!50001 DROP VIEW IF EXISTS `customerlocationview`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `customerlocationview` AS select `dim_customer`.`CustomerName` AS `CustomerName`,`dim_customer`.`CityName` AS `CityName`,`dim_customer`.`State` AS `State` from `dim_customer` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Dumping events for database 'datawarehouse'
--

--
-- Dumping routines for database 'datawarehouse'
--
/*!50003 DROP PROCEDURE IF EXISTS `GetProductInventoryByCity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductInventoryByCity`(IN ProductID INT, IN CityName VARCHAR(100))
BEGIN
    SELECT 
        s.StoreID,
        s.CityName,
        i.QuantityInStock
    FROM Fact_Inventory i
    JOIN Dim_Store s ON i.StoreID = s.StoreID
    WHERE i.ProductID = ProductID 
    AND s.CityName = CityName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetStoresWithHighInventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStoresWithHighInventory`(IN Threshold INT)
BEGIN
    SELECT 
        s.OfficeAddress,
        s.CityName,
        s.State,
        i.ProductID,
        i.QuantityInStock
    FROM Dim_Store s
    JOIN Fact_Inventory i ON s.StoreID = i.StoreID
    WHERE i.QuantityInStock > Threshold;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RefreshMaterializedTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `RefreshMaterializedTables`()
BEGIN
    -- Refresh InventoryCube
    TRUNCATE TABLE InventoryCube;
    INSERT INTO InventoryCube (StoreID, State, CityName, ProductID, Year, Quarter, Month, TotalStock)
    SELECT 
        s.StoreID,
        s.State,
        s.CityName,
        p.ProductID,
        d.Year,
        d.Quarter,
        d.Month,
        SUM(f.QuantityInStock) AS TotalStock
    FROM Fact_Inventory f
    JOIN Dim_Store s ON f.StoreID = s.StoreID
    JOIN Dim_Product p ON f.ProductID = p.ProductID
    JOIN Dim_Date d ON f.DateID = d.DateID
    GROUP BY s.StoreID, s.State, s.CityName, p.ProductID, d.Year, d.Quarter, d.Month;

    -- Refresh OrderCube (unchanged)
    TRUNCATE TABLE OrderCube;
    INSERT INTO OrderCube (CustomerName, CityName, Year, Quarter, Month, TotalAmount)
    SELECT 
        c.CustomerName,
        c.CityName,
        d.Year,
        d.Quarter,
        d.Month,
        SUM(f.TotalAmount) AS TotalAmount
    FROM Fact_Order f
    JOIN Dim_Customer c ON f.CustomerID = c.CustomerID
    JOIN Dim_Date d ON f.DateID = d.DateID
    GROUP BY c.CustomerName, c.CityName, d.Year, d.Quarter, d.Month;

    -- Refresh OrderDetailCube
    TRUNCATE TABLE OrderDetailCube;
    INSERT INTO OrderDetailCube (ProductID, CustomerName, Year, Quarter, Month, TotalQuantityOrdered, TotalRevenue)
    SELECT 
        p.ProductID,
        c.CustomerName,
        d.Year,
        d.Quarter,
        d.Month,
        SUM(od.QuantityOrdered) AS TotalQuantityOrdered,
        SUM(od.QuantityOrdered * COALESCE(od.UnitPrice, 0)) AS TotalRevenue
    FROM Fact_OrderDetail od
    JOIN Fact_Order o ON od.OrderID = o.OrderID
    JOIN Dim_Product p ON od.ProductID = p.ProductID
    JOIN Dim_Customer c ON o.CustomerID = c.CustomerID
    JOIN Dim_Date d ON o.DateID = d.DateID
    WHERE od.OrderTime IS NOT NULL
    GROUP BY p.ProductID, c.CustomerName, d.Year, d.Quarter, d.Month;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-18 15:37:05
