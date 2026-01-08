-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: ai_vlm
-- ------------------------------------------------------
-- Server version	8.0.33

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
-- Table structure for table `action`
--

DROP TABLE IF EXISTS `action`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `action` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Action` enum('moving','carrying an object','releasing an object','empty hands') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `action`
--

LOCK TABLES `action` WRITE;
/*!40000 ALTER TABLE `action` DISABLE KEYS */;
INSERT INTO `action` VALUES (1,'carrying an object'),(2,'releasing an object');
/*!40000 ALTER TABLE `action` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `frame_cell`
--

DROP TABLE IF EXISTS `frame_cell`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `frame_cell` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `ID_Video_Frame` int unsigned NOT NULL,
  `ID_Video` int unsigned NOT NULL,
  `Cell_Number` int unsigned NOT NULL,
  `Reasoning` mediumtext NOT NULL,
  `ID_Action` int unsigned DEFAULT NULL,
  `ID_Object` int unsigned DEFAULT NULL,
  `ID_Person` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_frame_cell_video_frame` (`ID_Video_Frame`,`ID_Video`),
  KEY `fk_frame_cell_object` (`ID_Object`),
  KEY `fk_frame_cell_person` (`ID_Person`),
  KEY `fk_frame_cell_action` (`ID_Action`),
  CONSTRAINT `fk_frame_cell_action` FOREIGN KEY (`ID_Action`) REFERENCES `action` (`id`),
  CONSTRAINT `fk_frame_cell_object` FOREIGN KEY (`ID_Object`) REFERENCES `object` (`id`),
  CONSTRAINT `fk_frame_cell_person` FOREIGN KEY (`ID_Person`) REFERENCES `person` (`id`),
  CONSTRAINT `fk_frame_cell_video_frame` FOREIGN KEY (`ID_Video_Frame`, `ID_Video`) REFERENCES `video_frame` (`Frame_Number`, `ID_Video`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `frame_cell`
--

LOCK TABLES `frame_cell` WRITE;
/*!40000 ALTER TABLE `frame_cell` DISABLE KEYS */;
INSERT INTO `frame_cell` VALUES (1,0,1,1,'A person is walking in the driveway area, near a white vehicle.',NULL,NULL,1),(2,40,1,1,'A person is walking in the driveway area, near the white vehicle.',NULL,NULL,2),(3,80,1,1,'A person is standing in the driveway with arms raised, near the white vehicle.',NULL,NULL,3),(4,120,1,1,'A person is carrying a package towards the door area in the driveway.',1,1,4),(5,160,1,1,'A person is releasing a package onto the doormat in the driveway area.',2,NULL,5),(6,160,1,2,'The central area shows a doormat with a package placed on it.',NULL,2,NULL),(7,200,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,6),(8,200,1,2,'The central area shows a doormat with a package left on it.',NULL,3,NULL),(9,240,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,7),(10,240,1,2,'The central area shows a doormat with a package left on it.',NULL,4,NULL),(11,280,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,8),(12,280,1,2,'The central area shows a doormat with a package left on it.',NULL,5,NULL),(13,320,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,9),(14,320,1,2,'The central area shows a doormat with a package left on it.',NULL,6,NULL),(15,360,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,10),(16,360,1,2,'The central area shows a doormat with a package left on it.',NULL,7,NULL),(17,400,1,1,'A person is walking away from the door area, having just released a package.',NULL,NULL,11),(18,400,1,2,'The central area shows a doormat with a package left on it.',NULL,8,NULL);
/*!40000 ALTER TABLE `frame_cell` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `object`
--

DROP TABLE IF EXISTS `object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `object` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Type` enum('Box','Tool','Package','Other') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `object`
--

LOCK TABLES `object` WRITE;
/*!40000 ALTER TABLE `object` DISABLE KEYS */;
INSERT INTO `object` VALUES (1,'Package'),(2,'Package'),(3,'Package'),(4,'Package'),(5,'Package'),(6,'Package'),(7,'Package'),(8,'Package');
/*!40000 ALTER TABLE `object` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `person`
--

DROP TABLE IF EXISTS `person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Type` enum('person_1') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `person`
--

LOCK TABLES `person` WRITE;
/*!40000 ALTER TABLE `person` DISABLE KEYS */;
INSERT INTO `person` VALUES (1,'person_1'),(2,'person_1'),(3,'person_1'),(4,'person_1'),(5,'person_1'),(6,'person_1'),(7,'person_1'),(8,'person_1'),(9,'person_1'),(10,'person_1'),(11,'person_1');
/*!40000 ALTER TABLE `person` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video`
--

DROP TABLE IF EXISTS `video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `Name` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video`
--

LOCK TABLES `video` WRITE;
/*!40000 ALTER TABLE `video` DISABLE KEYS */;
INSERT INTO `video` VALUES (1,'fedex.mp4');
/*!40000 ALTER TABLE `video` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video_frame`
--

DROP TABLE IF EXISTS `video_frame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video_frame` (
  `Frame_Number` int unsigned NOT NULL,
  `ID_Video` int unsigned NOT NULL,
  PRIMARY KEY (`Frame_Number`,`ID_Video`),
  KEY `fk_videoframe_video` (`ID_Video`),
  CONSTRAINT `fk_videoframe_video` FOREIGN KEY (`ID_Video`) REFERENCES `video` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video_frame`
--

LOCK TABLES `video_frame` WRITE;
/*!40000 ALTER TABLE `video_frame` DISABLE KEYS */;
INSERT INTO `video_frame` VALUES (0,1),(40,1),(80,1),(120,1),(160,1),(200,1),(240,1),(280,1),(320,1),(360,1),(400,1);
/*!40000 ALTER TABLE `video_frame` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-08 23:21:41
