CREATE DATABASE  IF NOT EXISTS `cpen410` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `cpen410`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: cpen410
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `bid`
--

DROP TABLE IF EXISTS `bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bid` (
  `BidId` int unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(255) NOT NULL,
  `BidValue` decimal(10,2) NOT NULL,
  `ProductId` int unsigned NOT NULL,
  `BidTime` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`BidId`),
  KEY `bids_username_index` (`UserName`),
  KEY `bids_productid_foreign` (`ProductId`),
  CONSTRAINT `bids_productid_foreign` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bids_username_foreign` FOREIGN KEY (`UserName`) REFERENCES `user` (`UserName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bid`
--

LOCK TABLES `bid` WRITE;
/*!40000 ALTER TABLE `bid` DISABLE KEYS */;
INSERT INTO `bid` VALUES (12,'wmorales',40.00,23,'2024-03-31');
/*!40000 ALTER TABLE `bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `DeptName` varchar(20) NOT NULL,
  PRIMARY KEY (`DeptName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES ('Books'),('Clothes'),('Computers'),('Electronics'),('Phones');
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image` (
  `imageId` int unsigned NOT NULL AUTO_INCREMENT,
  `path` varchar(255) NOT NULL,
  `ProductId` int unsigned NOT NULL,
  PRIMARY KEY (`imageId`),
  KEY `fk_image_product1_idx` (`ProductId`),
  CONSTRAINT `fk_image_product1` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
INSERT INTO `image` VALUES (13,'macbook.jpeg',22),(14,'1137215.jpg',23),(15,'iphonex.jpg',24),(16,'pavilion.jpg',25),(17,'galaxy.jpg',26),(18,'bg-upper.png',27),(19,'anubis-games.jpg',28);
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `menuelement`
--

DROP TABLE IF EXISTS `menuelement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `menuelement` (
  `menuID` int unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(40) NOT NULL,
  `Description` mediumtext NOT NULL,
  PRIMARY KEY (`menuID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `menuelement`
--

LOCK TABLES `menuelement` WRITE;
/*!40000 ALTER TABLE `menuelement` DISABLE KEYS */;
INSERT INTO `menuelement` VALUES (1,'Nav Bar','Nav Bar elements'),(2,'User','user only'),(3,'Admin','admin tools');
/*!40000 ALTER TABLE `menuelement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `ProductId` int unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(255) NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Description` mediumtext NOT NULL,
  `StartingBid` decimal(10,2) NOT NULL,
  `DueDate` date NOT NULL,
  `DeptName` varchar(20) NOT NULL,
  PRIMARY KEY (`ProductId`),
  KEY `products_username_index` (`UserName`),
  KEY `fk_product_department1_idx` (`DeptName`),
  CONSTRAINT `fk_product_department1` FOREIGN KEY (`DeptName`) REFERENCES `department` (`DeptName`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `products_username_foreign` FOREIGN KEY (`UserName`) REFERENCES `user` (`UserName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (22,'admin','Macboook 2015','macbook good condition',400.00,'2024-04-21','Computers'),(23,'louiz','Boneshaker','In the early days of the Civil War, rumors of gold in the frozen Klondike brought hordes of newcomers to the Pacific Northwest. Anxious to compete, Russian prospectors commissioned inventor Leviticus Blue to create a great machine that could mine through Alaska’s ice. Thus was Dr. Blue’s Incredible Bone-Shaking Drill Engine born.  But on its first test run the Boneshaker went terribly awry, destroying several blocks of downtown Seattle and unearthing a subterranean vein of blight gas that turned anyone who breathed it into the living dead.  Now it is sixteen years later, and a wall has been built to enclose the devastated and toxic city. Just beyond it lives Blue’s widow, Briar Wilkes. Life is hard with a ruined reputation and a teenaged boy to support, but she and Ezekiel are managing. Until Ezekiel undertakes a secret crusade to rewrite history.  His quest will take him under the wall and into a city teeming with ravenous undead, air pirates, criminal overlords, and heavily armed refugees. And only Briar can bring him out alive.',30.00,'2024-04-21','Books'),(24,'wmorales','iPhone X','used iphone x with 256gb.',400.00,'2024-04-21','Phones'),(25,'louiz22','Pavilion','hp pavillion laptop',250.00,'2024-04-21','Computers'),(26,'louiz22','Galaxy A15','galaxy A15 new box sealed',500.00,'2024-04-21','Phones'),(27,'louiz22','Arduino ','arduino device, work perfectly',10.00,'2024-04-21','Electronics'),(28,'wmorales','The Anubis Games','Brendan Doyle, a specialist in the work of the early-nineteenth century poet William Ashbless, reluctantly accepts an invitation from a millionaire to act as a guide to time-travelling tourists. But while attending a lecture given by Samuel Taylor Coleridge in 1810, he becomes marooned in Regency London, where dark and dangerous forces know about the gates in time.  Caught up in the intrigue between rival bands of beggars, pursued by Egyptian sorcerers, and befriended by Coleridge, Doyle somehow survives and learns more about the mysterious Ashbless than he could ever have imagined possible...',35.00,'2024-04-21','Books');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `RoleId` int unsigned NOT NULL AUTO_INCREMENT,
  `Name` varchar(20) NOT NULL,
  `Description` varchar(20) NOT NULL,
  PRIMARY KEY (`RoleId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'all','no perms content'),(2,'user','normal user'),(3,'admin','admin content');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roleuser`
--

DROP TABLE IF EXISTS `roleuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roleuser` (
  `roleuserId` int unsigned NOT NULL AUTO_INCREMENT,
  `UserName` varchar(20) NOT NULL,
  `RoleId` int unsigned NOT NULL,
  `dateAssign` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`roleuserId`),
  KEY `roleuser_roleid_index` (`RoleId`),
  KEY `roleuser_username_foreign` (`UserName`),
  CONSTRAINT `roleuser_roleid_foreign` FOREIGN KEY (`RoleId`) REFERENCES `role` (`RoleId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `roleuser_username_foreign` FOREIGN KEY (`UserName`) REFERENCES `user` (`UserName`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roleuser`
--

LOCK TABLES `roleuser` WRITE;
/*!40000 ALTER TABLE `roleuser` DISABLE KEYS */;
INSERT INTO `roleuser` VALUES (18,'admin',3,'2024-03-31 06:42:05'),(22,'wmorales76',2,'2024-03-31 19:23:35'),(23,'louiz',3,'2024-03-31 19:37:11'),(24,'wmorales',3,'2024-03-31 21:10:40'),(25,'admin3',3,'2024-03-31 21:13:56'),(26,'louiz22',2,'2024-03-31 21:58:34'),(27,'wmorales22',2,'2024-03-31 22:03:00');
/*!40000 ALTER TABLE `roleuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolewebpage`
--

DROP TABLE IF EXISTS `rolewebpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolewebpage` (
  `rolewebpageId` int unsigned NOT NULL AUTO_INCREMENT,
  `RoleId` int unsigned NOT NULL,
  `pageURL` varchar(40) NOT NULL,
  `dateAssign` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`rolewebpageId`),
  KEY `rolewebpage_roleid_index` (`RoleId`),
  KEY `rolewebpage_pageurl_foreign` (`pageURL`),
  CONSTRAINT `rolewebpage_pageurl_foreign` FOREIGN KEY (`pageURL`) REFERENCES `webpage` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rolewebpage_roleid_foreign` FOREIGN KEY (`RoleId`) REFERENCES `role` (`RoleId`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolewebpage`
--

LOCK TABLES `rolewebpage` WRITE;
/*!40000 ALTER TABLE `rolewebpage` DISABLE KEYS */;
INSERT INTO `rolewebpage` VALUES (1,1,'ebaywelcomeMenu.jsp','2024-03-11 00:23:01'),(9,2,'ebaywelcomeMenu.jsp','2024-03-14 17:21:41'),(10,2,'ebayshowProduct.jsp','2024-03-14 17:26:00'),(14,2,'ebayaddProduct.jsp','2024-03-17 21:51:14'),(15,2,'ebayprocessBid.jsp','2024-03-18 05:25:09'),(16,1,'ebaysearch.jsp','2024-03-20 18:33:35'),(17,2,'ebaysearch.jsp','2024-03-20 18:33:35'),(18,1,'ebayshowProduct.jsp','2024-03-23 05:00:59'),(19,3,'ebaywelcomeMenu.jsp','2024-03-23 22:52:39'),(20,3,'ebayshowProduct.jsp','2024-03-23 22:52:39'),(21,3,'ebayaddProduct.jsp','2024-03-23 22:52:39'),(22,3,'ebayprocessBid.jsp','2024-03-23 22:52:39'),(23,3,'ebaysearch.jsp','2024-03-23 22:52:39'),(24,3,'ebayadminTools.jsp','2024-03-25 16:08:07'),(26,3,'ebaymanageProducts.jsp','2024-03-26 01:28:49'),(27,3,'ebaymanageDepartments.jsp','2024-03-26 01:28:49'),(28,3,'ebaymanageUsers.jsp','2024-03-26 01:28:49'),(29,3,'ebayaddDepartment.jsp','2024-03-26 02:54:55'),(30,3,'ebaymodifyDepartment.jsp','2024-03-27 01:45:05'),(31,3,'ebaydeleteDepartment.jsp','2024-03-27 04:26:15'),(32,3,'ebaymodifyUser.jsp','2024-03-28 15:56:24'),(33,3,'ebaydeleteUser.jsp','2024-03-28 15:56:24'),(34,3,'ebaydeleteProduct.jsp','2024-03-29 00:03:07'),(35,3,'ebaymodifyProduct.jsp','2024-03-29 00:03:07'),(36,3,'ebaycreateuser.jsp','2024-03-31 06:25:30');
/*!40000 ALTER TABLE `rolewebpage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `UserName` varchar(20) NOT NULL,
  `hashing` mediumtext NOT NULL,
  `Name` varchar(20) NOT NULL,
  `Telephone` varchar(20) NOT NULL,
  PRIMARY KEY (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('admin','d82494f05d6917ba02f7aaa29689ccb444bb73f20380876cb05d1f37537b7892','Wilfredo','7871234567'),('admin3','e4b6c1e0fba93bf864cfe00b105fea48cb0d15609d6065ad80d5c83d11ecea11','admin','12132144'),('louiz','5be18a582b46692ded11a04f5416f48f39b075b255cb785198bbd43966cbd358','Louiz Inostroza','787 555 5555'),('louiz22','bbf6134f6dfd929cc06ac7bc7f9a285dae3c19e5c589feaddc1f6dd1aaa1101c','Louiz Inostroza','1234567899'),('wmorales','f6fc8725e6a622cfbf437a8d773c6df4e92d8630ea78fe254eea73be1db4aae3','Wilfredo Morales','12132144'),('wmorales22','03505109ae3ef295e259e24ff7e62b33878babd805ef6c52cdf819428af3ebb0','wmorales2','11111'),('wmorales76','21f99c7e48d61d1ab4b17865105eba794c05acf19ea1fed938c0a6e1d85d506c','Wilfredo Morales','787 312 3232');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpage`
--

DROP TABLE IF EXISTS `webpage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpage` (
  `pageURL` varchar(40) NOT NULL,
  `pageTitle` varchar(40) NOT NULL,
  `Description` mediumtext NOT NULL,
  `menuID` int unsigned DEFAULT NULL,
  PRIMARY KEY (`pageURL`),
  KEY `webpage_menuid_foreign` (`menuID`),
  CONSTRAINT `webpage_menuid_foreign` FOREIGN KEY (`menuID`) REFERENCES `menuelement` (`menuID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpage`
--

LOCK TABLES `webpage` WRITE;
/*!40000 ALTER TABLE `webpage` DISABLE KEYS */;
INSERT INTO `webpage` VALUES ('ebayaddDepartment.jsp','Add Department','add department',2),('ebayaddProduct.jsp','Add Product','add products users',1),('ebayaddUser.jsp','Register User','register new users',2),('ebayadminTools.jsp','Ebay Admin Tools','functionality for admins',1),('ebaycreateUser.jsp','Admin Create User','admins can create users',2),('ebaydeleteDepartment.jsp','Delete Department','deleete department',2),('ebaydeleteProduct.jsp','Delete Product','delete products admin',2),('ebaydeleteUser.jsp','Delete User','delete user',2),('ebaymanageDepartments.jsp','Manage Departments','manage department',3),('ebaymanageProducts.jsp','Manage Products','manage products',3),('ebaymanageUsers.jsp','Manage Users','manage users',3),('ebaymodifyDepartment.jsp','Modify Department','modify departments',2),('ebaymodifyProduct.jsp','Modify Product','modify products admin',2),('ebaymodifyUser.jsp','Modify User','modify user',2),('ebayprocessBid.jsp','Processing Bid...','process users bids',2),('ebayprocessProduct.jsp','Process Product','add product info to database',2),('ebaysearch.jsp','Search Results','shows search results',2),('ebayshowProduct.jsp','Show Products','page to show product details',2),('ebayvalidationHashing.jsp','Mini Ebay Validation','mini ebay validation page',2),('ebaywelcomeMenu.jsp','Mini Ebay Welcome','mini ebay welcome page',1);
/*!40000 ALTER TABLE `webpage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `webpageprevious`
--

DROP TABLE IF EXISTS `webpageprevious`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webpageprevious` (
  `webpagepreviousId` int NOT NULL AUTO_INCREMENT,
  `previouspageURL` varchar(40) NOT NULL,
  `currentpageURL` varchar(40) NOT NULL,
  PRIMARY KEY (`webpagepreviousId`),
  KEY `webpageprevious_currentpageurl_foreign` (`currentpageURL`),
  KEY `webpageprevious_previouspageurl_foreign` (`previouspageURL`),
  CONSTRAINT `webpageprevious_currentpageurl_foreign` FOREIGN KEY (`currentpageURL`) REFERENCES `webpage` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `webpageprevious_previouspageurl_foreign` FOREIGN KEY (`previouspageURL`) REFERENCES `webpage` (`pageURL`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webpageprevious`
--

LOCK TABLES `webpageprevious` WRITE;
/*!40000 ALTER TABLE `webpageprevious` DISABLE KEYS */;
INSERT INTO `webpageprevious` VALUES (1,'ebaywelcomeMenu.jsp','ebayaddProduct.jsp'),(2,'ebaywelcomeMenu.jsp','ebayshowProduct.jsp'),(4,'ebayshowProduct.jsp','ebaywelcomeMenu.jsp'),(5,'ebaywelcomeMenu.jsp','ebaywelcomeMenu.jsp'),(6,'ebayprocessProduct.jsp','ebayshowProduct.jsp'),(8,'ebayvalidationHashing.jsp','ebaywelcomeMenu.jsp'),(9,'ebayshowProduct.jsp','ebayprocessBid.jsp'),(11,'ebayprocessBid.jsp','ebayshowProduct.jsp'),(14,'ebaywelcomeMenu.jsp','ebaysearch.jsp'),(15,'ebayshowProduct.jsp','ebaysearch.jsp'),(16,'ebaysearch.jsp','ebayshowProduct.jsp'),(17,'ebaysearch.jsp','ebaysearch.jsp'),(18,'ebaysearch.jsp','ebaywelcomeMenu.jsp'),(19,'ebaysearch.jsp','ebayaddProduct.jsp'),(20,'ebayaddProduct.jsp','ebaysearch.jsp'),(21,'ebayshowProduct.jsp','ebayaddProduct.jsp'),(22,'ebayaddProduct.jsp','ebaywelcomeMenu.jsp'),(23,'ebaywelcomeMenu.jsp','ebayadminTools.jsp'),(24,'ebayadminTools.jsp','ebaymanageDepartments.jsp'),(25,'ebayadminTools.jsp','ebaymanageUsers.jsp'),(26,'ebayadminTools.jsp','ebaymanageProducts.jsp'),(27,'ebaymanageDepartments.jsp','ebayaddDepartment.jsp'),(28,'ebaymanageDepartments.jsp','ebaymodifyDepartment.jsp'),(30,'ebaymanageDepartments.jsp','ebaydeleteDepartment.jsp'),(31,'ebaymanageUsers.jsp','ebaymodifyUser.jsp'),(32,'ebaymanageUsers.jsp','ebaydeleteUser.jsp'),(36,'ebaymanageProducts.jsp','ebaymodifyProduct.jsp'),(37,'ebaymanageProducts.jsp','ebaydeleteProduct.jsp'),(38,'ebaymanageProducts.jsp','ebayprocessProduct.jsp'),(42,'ebaymanageDepartments.jsp','ebayaddProduct.jsp'),(43,'ebaymanageDepartments.jsp','ebaywelcomeMenu.jsp'),(44,'ebaymanageDepartments.jsp','ebayadminTools.jsp'),(45,'ebayaddDepartment.jsp','ebaywelcomeMenu.jsp'),(46,'ebayaddDepartment.jsp','ebayadminTools.jsp'),(47,'ebayaddDepartment.jsp','ebaymanageDepartments.jsp'),(48,'ebayadminTools.jsp','ebaywelcomeMenu.jsp'),(49,'ebayadminTools.jsp','ebayaddProduct.jsp'),(50,'ebayadminTools.jsp','ebaysearch.jsp'),(51,'ebaymodifyDepartment.jsp','ebaymanageDepartments.jsp'),(52,'ebaymodifyDepartment.jsp','ebaywelcomeMenu.jsp'),(53,'ebaymodifyDepartment.jsp','ebayadminTools.jsp'),(54,'ebaydeleteDepartment.jsp','ebaywelcomeMenu.jsp'),(55,'ebaydeleteDepartment.jsp','ebayadminTools.jsp'),(56,'ebaydeleteDepartment.jsp','ebaymanageDepartments.jsp'),(60,'ebaydeleteProduct.jsp','ebaywelcomeMenu.jsp'),(61,'ebaydeleteProduct.jsp','ebayadminTools.jsp'),(62,'ebaydeleteProduct.jsp','ebaymanageProducts.jsp'),(63,'ebaymodifyProduct.jsp','ebaymanageProducts.jsp'),(64,'ebaymodifyProduct.jsp','ebaywelcomeMenu.jsp'),(65,'ebaymodifyProduct.jsp','ebayAdminTools.jsp'),(67,'ebayaddUser.jsp','ebaywelcomeMenu.jsp'),(68,'ebaymanageUsers.jsp','ebaycreateUser.jsp'),(69,'ebaycreateUser.jsp','ebaymanageUsers.jsp'),(70,'ebaycreateUser.jsp','ebaywelcomeMenu.jsp'),(71,'ebaycreateUser.jsp','ebayadminTools.jsp'),(72,'ebaydeleteUser.jsp','ebaywelcomeMenu.jsp'),(73,'ebaydeleteUser.jsp','ebayadminTools.jsp'),(74,'ebaydeleteUser.jsp','ebaymanageUsers.jsp'),(75,'ebaymodifyUser.jsp','ebaywelcomeMenu.jsp'),(76,'ebaymodifyUser.jsp','ebaymanageUsers.jsp'),(77,'ebaymodifyUser.jsp','ebayadminTools.jsp'),(81,'ebaymanageUsers.jsp','ebayadminTools.jsp'),(82,'ebaymanageProducts.jsp','ebaywelcomeMenu.jsp'),(83,'ebayshowProduct.jsp','ebayshowProduct.jsp'),(84,'ebayshowProduct.jsp','ebayadminTools.jsp'),(85,'ebaymanageProducts.jsp','ebayadminTools.jsp'),(87,'ebaymodifyUser.jsp','ebaymodifyUser.jsp'),(88,'ebaydeleteDepartment.jsp','ebaydeleteDepartment.jsp'),(89,'ebayprocessBid.jsp','ebayprocessBid.jsp'),(90,'ebayprocessProduct.jsp','ebayprocessProduct.jsp'),(91,'ebayaddDepartment.jsp','ebayaddDepartment.jsp'),(92,'ebayvalidationHashing.jsp','ebayvalidationHashing.jsp'),(93,'ebaymanageUsers.jsp','ebaymanageUsers.jsp'),(94,'ebayadminTools.jsp','ebayadminTools.jsp'),(95,'ebaydeleteUser.jsp','ebaydeleteUser.jsp'),(96,'ebaymanageDepartments.jsp','ebaymanageDepartments.jsp'),(97,'ebaydeleteProduct.jsp','ebaydeleteProduct.jsp'),(98,'ebaymodifyDepartment.jsp','ebaymodifyDepartment.jsp'),(99,'ebayaddProduct.jsp','ebayaddProduct.jsp'),(100,'ebaycreateUser.jsp','ebaycreateUser.jsp'),(101,'ebayaddUser.jsp','ebayaddUser.jsp'),(102,'ebaymanageProducts.jsp','ebaymanageProducts.jsp'),(103,'ebaymodifyProduct.jsp','ebaymodifyProduct.jsp'),(104,'ebayAdminTools.jsp','ebayAdminTools.jsp'),(105,'ebayaddProduct.jsp','ebayadminTools.jsp');
/*!40000 ALTER TABLE `webpageprevious` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-03-31 18:29:27
