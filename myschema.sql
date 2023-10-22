-- MySQL dump 10.13  Distrib 8.0.34, for Linux (x86_64)
--
-- Host: localhost    Database: project
-- ------------------------------------------------------
-- Server version	8.0.34-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `application`
--

DROP TABLE IF EXISTS `application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application` (
  `appID` int NOT NULL AUTO_INCREMENT,
  `aName` varchar(255) DEFAULT NULL,
  `resume` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`appID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,'John Doe','A'),(2,'Jane Doe','B'),(3,'Ted Ned','C');
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `certification`
--

DROP TABLE IF EXISTS `certification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certification` (
  `appID` int NOT NULL,
  `certName` varchar(255) DEFAULT NULL,
  KEY `appID` (`appID`),
  CONSTRAINT `certification_ibfk_1` FOREIGN KEY (`appID`) REFERENCES `application` (`appID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certification`
--

LOCK TABLES `certification` WRITE;
/*!40000 ALTER TABLE `certification` DISABLE KEYS */;
INSERT INTO `certification` VALUES (1,'Aa'),(2,'Bb'),(3,'Cc');
/*!40000 ALTER TABLE `certification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `cityID` int NOT NULL AUTO_INCREMENT,
  `cName` varchar(50) NOT NULL,
  `sName` varchar(50) NOT NULL,
  `costOfLiving` decimal(9,2) NOT NULL,
  PRIMARY KEY (`cityID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (1,'CityA','StateA',12345.00),(2,'CityB','StateA',20342.00),(3,'CityC','StateB',14563.00),(4,'CityD','StateC',32191.00);
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empLocation`
--

DROP TABLE IF EXISTS `empLocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empLocation` (
  `eName` varchar(255) NOT NULL,
  `cityID` int NOT NULL,
  KEY `eName` (`eName`),
  KEY `cityID` (`cityID`),
  CONSTRAINT `empLocation_ibfk_1` FOREIGN KEY (`eName`) REFERENCES `employer` (`eName`),
  CONSTRAINT `empLocation_ibfk_2` FOREIGN KEY (`cityID`) REFERENCES `city` (`cityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empLocation`
--

LOCK TABLES `empLocation` WRITE;
/*!40000 ALTER TABLE `empLocation` DISABLE KEYS */;
INSERT INTO `empLocation` VALUES ('CompanyA',1),('CompanyB',2),('CompanyC',4),('CompanyC',2);
/*!40000 ALTER TABLE `empLocation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employer`
--

DROP TABLE IF EXISTS `employer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employer` (
  `eName` varchar(255) NOT NULL,
  `eRating` decimal(2,1) DEFAULT NULL,
  `eSize` int NOT NULL,
  PRIMARY KEY (`eName`),
  CONSTRAINT `employer_chk_1` CHECK ((`eRating` between 0.0 and 5.0)),
  CONSTRAINT `employer_chk_2` CHECK (((`eRating` >= 0.0) and (`eRating` <= 5.0))),
  CONSTRAINT `employer_chk_3` CHECK (((`eRating` >= 0.0) and (`eRating` <= 5.0)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employer`
--

LOCK TABLES `employer` WRITE;
/*!40000 ALTER TABLE `employer` DISABLE KEYS */;
INSERT INTO `employer` VALUES ('CompanyA',4.3,200),('CompanyB',4.7,10000),('CompanyC',3.5,1500),('CompanyD',4.0,100);
/*!40000 ALTER TABLE `employer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job` (
  `jobID` int NOT NULL AUTO_INCREMENT,
  `eName` varchar(50) NOT NULL,
  `cityID` int NOT NULL,
  `title` varchar(50) NOT NULL,
  `salary` decimal(9,2) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`jobID`),
  KEY `eName` (`eName`),
  KEY `cityID` (`cityID`),
  CONSTRAINT `job_ibfk_1` FOREIGN KEY (`eName`) REFERENCES `employer` (`eName`),
  CONSTRAINT `job_ibfk_2` FOREIGN KEY (`cityID`) REFERENCES `city` (`cityID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job`
--

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
INSERT INTO `job` VALUES (1,'CompanyA',4,'PositionA',103424.00,'DescA'),(2,'CompanyB',2,'PositionA',78436.00,'DescB'),(3,'CompanyC',3,'PositionB',83452.00,'DescC'),(4,'CompanyD',1,'PositionC',60325.00,'DescB');
/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobApp`
--

DROP TABLE IF EXISTS `jobApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobApp` (
  `jobID` int NOT NULL,
  `appID` int NOT NULL,
  KEY `jobID` (`jobID`),
  KEY `appID` (`appID`),
  CONSTRAINT `jobApp_ibfk_1` FOREIGN KEY (`jobID`) REFERENCES `job` (`jobID`),
  CONSTRAINT `jobApp_ibfk_2` FOREIGN KEY (`appID`) REFERENCES `application` (`appID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobApp`
--

LOCK TABLES `jobApp` WRITE;
/*!40000 ALTER TABLE `jobApp` DISABLE KEYS */;
INSERT INTO `jobApp` VALUES (1,1),(1,2),(2,3),(3,3);
/*!40000 ALTER TABLE `jobApp` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-22  3:36:56
