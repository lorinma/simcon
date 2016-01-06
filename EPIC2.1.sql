CREATE DATABASE  IF NOT EXISTS `EPIC2` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `EPIC2`;
-- MySQL dump 10.13  Distrib 5.7.9, for Win64 (x86_64)
--
-- Host: 104.155.79.181    Database: EPIC2
-- ------------------------------------------------------
-- Server version	5.6.25-google

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Event_DesignChange`
--

DROP TABLE IF EXISTS `Event_DesignChange`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_DesignChange` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TaskID` int(11) NOT NULL,
  `TotalQty` double NOT NULL DEFAULT '0',
  `sDay` int(11) NOT NULL DEFAULT '0',
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_designchange` (`ProjectID`),
  KEY `fk_designchange_task` (`TaskID`),
  CONSTRAINT `fk_designchange` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_designchange_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_Meeting`
--

DROP TABLE IF EXISTS `Event_Meeting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_Meeting` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_meeting` (`ProjectID`),
  CONSTRAINT `fk_meeting` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_QualityCheck`
--

DROP TABLE IF EXISTS `Event_QualityCheck`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_QualityCheck` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TaskID` int(11) NOT NULL,
  `Pass` int(11) NOT NULL DEFAULT '1',
  `ProjectID` int(11) NOT NULL,
  `sDay` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_qualitycheck` (`ProjectID`),
  KEY `fk_qualitycheck_task` (`TaskID`),
  CONSTRAINT `fk_qualitycheck` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_qualitycheck_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=378 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_RetraceExternalCondition`
--

DROP TABLE IF EXISTS `Event_RetraceExternalCondition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_RetraceExternalCondition` (
  `sDay` int(11) NOT NULL,
  `TaskID` int(11) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_retrace_external` (`ProjectID`),
  KEY `fk_retrace_external_task` (`TaskID`),
  CONSTRAINT `fk_retrace_external` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_retrace_external_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=225 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_RetracePredecessor`
--

DROP TABLE IF EXISTS `Event_RetracePredecessor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_RetracePredecessor` (
  `sDay` int(11) NOT NULL,
  `TaskID` int(11) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_retrace_predecessor` (`ProjectID`),
  KEY `fk_retrace_predecessor_task` (`TaskID`),
  CONSTRAINT `fk_retrace_predecessor` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_retrace_predecessor_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=278 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_RetraceWorkSpace`
--

DROP TABLE IF EXISTS `Event_RetraceWorkSpace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_RetraceWorkSpace` (
  `sDay` int(11) NOT NULL,
  `TaskID` int(11) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_retrace_workspace` (`ProjectID`),
  KEY `fk_retrace_workspace_task` (`TaskID`),
  CONSTRAINT `fk_retrace_workspace` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_retrace_workspace_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Event_WorkBegin`
--

DROP TABLE IF EXISTS `Event_WorkBegin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Event_WorkBegin` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `TaskID` int(11) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_workbegin` (`ProjectID`),
  KEY `fk_workbegin_task` (`TaskID`),
  CONSTRAINT `fk_workbegin` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_workbegin_task` FOREIGN KEY (`TaskID`) REFERENCES `Fact_Task` (`TaskID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=572 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_Project`
--

DROP TABLE IF EXISTS `Fact_Project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_Project` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MeetingCycle` int(11) NOT NULL DEFAULT '0',
  `DesignChangeCycle` int(11) NOT NULL DEFAULT '0',
  `ProductionRateChange` int(11) NOT NULL DEFAULT '0',
  `QualityCheck` int(11) NOT NULL DEFAULT '0',
  `PriorityChange` int(11) NOT NULL DEFAULT '0',
  `TaskSelectionFunction` int(11) NOT NULL DEFAULT '0',
  `CollisionInformationExchange` int(11) NOT NULL DEFAULT '1',
  `Done` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1450 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_Sub`
--

DROP TABLE IF EXISTS `Fact_Sub`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_Sub` (
  `SubID` int(11) NOT NULL AUTO_INCREMENT,
  `SubName` char(20) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`SubID`),
  UNIQUE KEY `SubID` (`SubID`),
  KEY `fk_sub` (`ProjectID`),
  CONSTRAINT `fk_sub` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=222629 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_Task`
--

DROP TABLE IF EXISTS `Fact_Task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_Task` (
  `TaskID` int(11) NOT NULL AUTO_INCREMENT,
  `WorkMethod` char(50) NOT NULL,
  `Space` int(11) NOT NULL,
  `InitialQty` double NOT NULL,
  `DesignChangeVariation` double NOT NULL DEFAULT '0',
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`TaskID`),
  UNIQUE KEY `TaskID` (`TaskID`),
  KEY `fk_task` (`ProjectID`),
  CONSTRAINT `fk_task` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=209069 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_WorkMethod`
--

DROP TABLE IF EXISTS `Fact_WorkMethod`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_WorkMethod` (
  `WorkMethodID` int(11) NOT NULL AUTO_INCREMENT,
  `SubName` char(20) NOT NULL,
  `WorkMethod` char(50) NOT NULL,
  `InitialProductionRate` double NOT NULL,
  `QualityRate` double NOT NULL,
  `PerformanceStd` double DEFAULT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`WorkMethodID`),
  UNIQUE KEY `WorkMethodID` (`WorkMethodID`),
  KEY `fk_workmethod` (`ProjectID`),
  CONSTRAINT `fk_workmethod` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51813 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_WorkMethodDependency`
--

DROP TABLE IF EXISTS `Fact_WorkMethodDependency`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_WorkMethodDependency` (
  `WorkMethodDependencyID` int(11) NOT NULL AUTO_INCREMENT,
  `PredecessorWorkMethod` char(50) NOT NULL,
  `SuccessorWorkMethod` char(50) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`WorkMethodDependencyID`),
  UNIQUE KEY `WorkMethodDependencyID` (`WorkMethodDependencyID`),
  KEY `fk_workmethoddependency` (`ProjectID`),
  CONSTRAINT `fk_workmethoddependency` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=51643 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Fact_WorkSpace`
--

DROP TABLE IF EXISTS `Fact_WorkSpace`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Fact_WorkSpace` (
  `WorkSpaceID` int(11) NOT NULL AUTO_INCREMENT,
  `Space` int(11) NOT NULL,
  `InitialPriority` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`WorkSpaceID`),
  UNIQUE KEY `WorkSpaceID` (`WorkSpaceID`),
  KEY `fk_workspace` (`ProjectID`),
  CONSTRAINT `fk_workspace` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25627 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Result`
--

DROP TABLE IF EXISTS `Result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Result` (
  `WPName` char(50) NOT NULL,
  `sDate` date DEFAULT NULL,
  `sDay` int(11) NOT NULL,
  `TaskStatus` double NOT NULL,
  `WorkMethod` char(50) NOT NULL,
  `SubName` char(50) NOT NULL,
  `Space` int(11) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `TaskID` int(11) NOT NULL,
  `NotMature` int(11) NOT NULL,
  `DesignChange` int(11) NOT NULL,
  `PredecessorIncomplete` int(11) NOT NULL,
  `WorkSpaceCongestion` int(11) NOT NULL,
  `ExternalCondition` int(11) NOT NULL,
  `QualityFail` int(11) NOT NULL,
  `MeetingCycle` int(11) NOT NULL DEFAULT '0',
  `DesignChangeCycle` int(11) NOT NULL DEFAULT '0',
  `ProductionRateChange` int(11) NOT NULL DEFAULT '0',
  `QualityCheck` int(11) NOT NULL DEFAULT '0',
  `TaskSelectionFunction` int(11) NOT NULL DEFAULT '0',
  `PriorityChange` int(11) NOT NULL DEFAULT '0',
  `CollisionInformationExchange` int(11) NOT NULL DEFAULT '1',
  `BeginDay` int(11) NOT NULL DEFAULT '0',
  `QualityWaste` int(11) NOT NULL DEFAULT '0',
  `DesignWaste` int(11) NOT NULL DEFAULT '0',
  `WasteDay` int(11) NOT NULL DEFAULT '0',
  `AddValue` int(11) NOT NULL DEFAULT '0',
  KEY `fk_result` (`ProjectID`),
  CONSTRAINT `fk_result` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Result_InformationFlow`
--

DROP TABLE IF EXISTS `Result_InformationFlow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Result_InformationFlow` (
  `ProjectID` int(11) NOT NULL,
  `Space` int(11) NOT NULL DEFAULT '0',
  `Crews` int(11) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `MeetType` char(20) NOT NULL,
  KEY `fk_info_flow` (`ProjectID`),
  CONSTRAINT `fk_info_flow` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Result_ProductionRate`
--

DROP TABLE IF EXISTS `Result_ProductionRate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Result_ProductionRate` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `WorkMethod` char(50) NOT NULL,
  `ProductionRate` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_log_productionrate` (`ProjectID`),
  CONSTRAINT `fk_log_productionrate` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5243 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `Result_Retrace`
--

DROP TABLE IF EXISTS `Result_Retrace`;
/*!50001 DROP VIEW IF EXISTS `Result_Retrace`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `Result_Retrace` AS SELECT 
 1 AS `sDay`,
 1 AS `TaskID`,
 1 AS `ProjectID`,
 1 AS `ID`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `Result_Task`
--

DROP TABLE IF EXISTS `Result_Task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Result_Task` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `TaskID` int(11) NOT NULL,
  `RemainingQty` double NOT NULL,
  `TotalQty` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_log_task` (`ProjectID`),
  CONSTRAINT `fk_log_task` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=50170 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Result_WorkSpacePriority`
--

DROP TABLE IF EXISTS `Result_WorkSpacePriority`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Result_WorkSpacePriority` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `Space` int(11) NOT NULL,
  `WorkSpacePriority` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `SubName` char(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`),
  KEY `fk_log_workspacepriority` (`ProjectID`),
  CONSTRAINT `fk_log_workspacepriority` FOREIGN KEY (`ProjectID`) REFERENCES `Fact_Project` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5371 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `View_NewSimulationProjects`
--

DROP TABLE IF EXISTS `View_NewSimulationProjects`;
/*!50001 DROP VIEW IF EXISTS `View_NewSimulationProjects`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `View_NewSimulationProjects` AS SELECT 
 1 AS `ID`,
 1 AS `MeetingCycle`,
 1 AS `DesignChangeCycle`,
 1 AS `ProductionRateChange`,
 1 AS `QualityCheck`,
 1 AS `PriorityChange`,
 1 AS `TaskSelectionFunction`,
 1 AS `CollisionInformationExchange`,
 1 AS `Done`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'EPIC2'
--
/*!50003 DROP FUNCTION IF EXISTS `gauss` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE FUNCTION `gauss`(mean float, stdev float) RETURNS float
BEGIN
set @x=rand(), @y=rand();
set @gaus = ((sqrt(-2*log(@x))*cos(2*pi()*@y))*stdev)+mean;
return @gaus;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Reset_Latest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Reset_Latest`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS View_TaskLatest;
CREATE TEMPORARY TABLE View_TaskLatest
SELECT 
    d.*, t.SubName, DesignChangeVariation, Space, WorkMethod, PerformanceStd, QualityRate
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        a.*
    FROM
        Log_Task a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    ORDER BY a.ID DESC) c
    GROUP BY ProjectID , KnowledgeOwner , TaskID) d
        LEFT JOIN
    Fact_UnfinishedTaskDetail t ON d.TaskID = t.TaskID;
    
DROP TEMPORARY TABLE IF EXISTS View_UnfinishedTask;
CREATE TEMPORARY TABLE View_UnfinishedTask
SELECT 
    *
FROM
    View_TaskLatest
WHERE
    RemainingQty > 0;

DROP TEMPORARY TABLE IF EXISTS View_ProductionRateLatest;
CREATE TEMPORARY TABLE View_ProductionRateLatest
SELECT 
    *
FROM
    (SELECT 
        a.*
    FROM
        Log_ProductionRate a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    ORDER BY a.ID DESC) c
GROUP BY ProjectID , KnowledgeOwner , WorkMethod;

DROP TEMPORARY TABLE IF EXISTS View_WorkSpacePriorityLatest;
CREATE TEMPORARY TABLE View_WorkSpacePriorityLatest
SELECT 
    *
FROM
    (SELECT 
        a.*
    FROM
        Log_WorkSpacePriority a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    ORDER BY a.ID DESC) c
GROUP BY ProjectID , KnowledgeOwner , SubName , Space;

DROP TEMPORARY TABLE IF EXISTS True_TaskLatest;
CREATE TEMPORARY TABLE True_TaskLatest
SELECT 
    *
FROM
    View_TaskLatest
WHERE
    KnowledgeOwner = SubName;
    
DROP TEMPORARY TABLE IF EXISTS True_UnfinishedTask;
CREATE TEMPORARY TABLE True_UnfinishedTask
SELECT 
    *
FROM
    True_TaskLatest
WHERE
    RemainingQty > 0;

DROP TEMPORARY TABLE IF EXISTS True_UnfinishedSub;
CREATE TEMPORARY TABLE True_UnfinishedSub
SELECT 
    ProjectID, SubName
FROM
    True_UnfinishedTask
GROUP BY ProjectID , SubName;

DROP TEMPORARY TABLE IF EXISTS True_ProductionRateLatest;
create temporary table True_ProductionRateLatest
SELECT 
    a.*,SubName
FROM
    View_ProductionRateLatest a
        JOIN
    Fact_WorkMethod b ON a.ProjectID = b.ProjectID
        AND a.WorkMethod = b.WorkMethod
WHERE
    a.KnowledgeOwner = b.SubName;

DROP TEMPORARY TABLE IF EXISTS True_WorkSpacePriorityLatest;
create temporary table True_WorkSpacePriorityLatest
SELECT 
    *
FROM
    View_WorkSpacePriorityLatest
WHERE
    KnowledgeOwner = SubName;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Reset_Maturity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Reset_Maturity`()
BEGIN
call Reset_Latest();
call Reset_ViewMaturity();
call Reset_TrueMaturity();    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Reset_TrueMaturity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Reset_TrueMaturity`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS True_UnfinishedTaskDup;
CREATE TEMPORARY TABLE True_UnfinishedTaskDup
SELECT 
    *
FROM
    True_UnfinishedTask;
    
DROP TEMPORARY TABLE IF EXISTS True_PrdecessorUnfinishedTask;
CREATE TEMPORARY TABLE True_PrdecessorUnfinishedTask
SELECT 
    c.ProjectID, c.KnowledgeOwner, c.TaskID
FROM
    (SELECT 
        a.*, PredecessorTaskID
    FROM
        True_UnfinishedTask a
    JOIN Fact_TaskDependency b ON b.SuccessorTaskID = a.TaskID) c
        JOIN
    True_UnfinishedTaskDup d ON c.PredecessorTaskID = d.TaskID
GROUP BY c.ProjectID , c.TaskID;

DROP TEMPORARY TABLE IF EXISTS True_PrdecessorFreeTask;
CREATE TEMPORARY TABLE True_PrdecessorFreeTask
SELECT 
    a.*
FROM
    True_UnfinishedTask a
        LEFT JOIN
    True_PrdecessorUnfinishedTask c ON a.TaskID = c.TaskID
WHERE
    ISNULL(c.TaskID);
   
DROP TEMPORARY TABLE IF EXISTS True_WorkingTask;
CREATE TEMPORARY TABLE True_WorkingTask
SELECT 
    *
FROM
    View_WorkingTask
WHERE
    KnowledgeOwner = SubName;

DROP TEMPORARY TABLE IF EXISTS True_PrdecessorAndSpaceFreeTask;
CREATE TEMPORARY TABLE True_PrdecessorAndSpaceFreeTask
SELECT 
    a.*,
    CASE
        WHEN a.TaskID = b.TaskID THEN 1
        ELSE 0
    END WorkingYesterDay
FROM
    True_PrdecessorFreeTask a
        LEFT JOIN
    (SELECT 
        TaskID, ProjectID, Space
    FROM
        True_WorkingTask) b ON a.ProjectID = b.ProjectID
        AND a.Space = b.Space
WHERE
    a.TaskID = b.TaskID OR ISNULL(b.TaskID);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Reset_ViewMaturity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Reset_ViewMaturity`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS View_UnfinishedTaskDup;
CREATE TEMPORARY TABLE View_UnfinishedTaskDup
SELECT 
    TaskID,KnowledgeOwner,sDay,ProjectID
FROM
    View_UnfinishedTask;

DROP TEMPORARY TABLE IF EXISTS View_PrdecessorUnfinishedTask;
CREATE TEMPORARY TABLE View_PrdecessorUnfinishedTask
SELECT 
    c.ProjectID, c.KnowledgeOwner, c.TaskID
FROM
    (SELECT 
        a.*, PredecessorTaskID
    FROM
        View_UnfinishedTask a
    JOIN Fact_TaskDependency b ON b.SuccessorTaskID = a.TaskID) c
        JOIN
    View_UnfinishedTaskDup d ON c.PredecessorTaskID = d.TaskID
        AND c.KnowledgeOwner = d.KnowledgeOwner
GROUP BY c.ProjectID , c.KnowledgeOwner , c.TaskID;

DROP TEMPORARY TABLE IF EXISTS View_WorkingTask;
CREATE TEMPORARY TABLE View_WorkingTask
SELECT 
    *
FROM
    (SELECT 
        ProjectID, KnowledgeOwner, Space, TaskID, sDay, SubName
    FROM
        View_UnfinishedTask
    WHERE
        RemainingQty < TotalQty
    ORDER BY ProjectID , KnowledgeOwner , Space , sDay DESC , RAND()) a
GROUP BY ProjectID , KnowledgeOwner , Space;
        
DROP TEMPORARY TABLE IF EXISTS View_PrdecessorFreeTask;
CREATE TEMPORARY TABLE View_PrdecessorFreeTask
SELECT 
    g.*, WorkSpacePriority
FROM
    (SELECT 
        c.*, ProductionRate
    FROM
        (SELECT 
        a.*
    FROM
        View_UnfinishedTask a
    LEFT JOIN View_PrdecessorUnfinishedTask b ON a.ProjectID = b.ProjectID
        AND a.KnowledgeOwner = b.KnowledgeOwner
        AND a.TaskID = b.TaskID
    WHERE
        ISNULL(b.TaskID)) c
    LEFT JOIN View_ProductionRateLatest d ON d.ProjectID = c.ProjectID
        AND d.WorkMethod = c.WorkMethod
        AND d.KnowledgeOwner = c.KnowledgeOwner) g
        LEFT JOIN
    View_WorkSpacePriorityLatest h ON g.ProjectID = h.ProjectID
        AND g.KnowledgeOwner = h.KnowledgeOwner
        AND g.Space = h.Space
        AND g.SubName = h.SubName;

DROP TEMPORARY TABLE IF EXISTS View_PrdecessorAndSpaceFreeTask;
CREATE TEMPORARY TABLE View_PrdecessorAndSpaceFreeTask
SELECT 
    a.*,
    CASE
        WHEN a.TaskID = b.TaskID THEN 1
        ELSE 0
    END WorkingYesterDay
FROM
    View_PrdecessorFreeTask a
        LEFT JOIN
    (SELECT 
        KnowledgeOwner, TaskID, ProjectID, Space
    FROM
        View_WorkingTask) b ON a.KnowledgeOwner = b.KnowledgeOwner
        AND a.Space = b.Space
WHERE
    a.TaskID = b.TaskID OR ISNULL(b.TaskID);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Result` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Result`()
BEGIN

insert into Result_Task (KnowledgeOwner,sDay,TaskID,RemainingQty,TotalQty,ProjectID)
SELECT 
    KnowledgeOwner,
    sDay,
    TaskID,
    RemainingQty,
    TotalQty,
    ProjectID
FROM
    Log_Task;

insert into Result_ProductionRate (KnowledgeOwner,sDay,WorkMethod,ProductionRate,ProjectID)
SELECT 
    KnowledgeOwner, sDay, WorkMethod, ProductionRate, ProjectID
FROM
    Log_ProductionRate;

insert into Result_WorkSpacePriority (KnowledgeOwner,sDay,Space,WorkSpacePriority,ProjectID,SubName)
SELECT 
    KnowledgeOwner,
    sDay,
    Space,
    WorkSpacePriority,
    ProjectID,
    SubName
FROM
    Log_WorkSpacePriority;
    
DROP TEMPORARY TABLE IF EXISTS Result_TaskTraceWork;
CREATE TEMPORARY TABLE Result_TaskTraceWork
SELECT 
    *
FROM
    (SELECT 
        Log_Task.ProjectID,
            Fact_UnfinishedTaskDetail.TaskID,
            sDay,
            SubName,
            Space,
            WorkMethod,
            1 - RemainingQty / TotalQty Completeness,
            Space - RemainingQty / TotalQty TaskStatus,
            0 BeginDay
    FROM
        Log_Task
    LEFT JOIN Fact_UnfinishedTaskDetail ON Log_Task.TaskID = Fact_UnfinishedTaskDetail.TaskID
    WHERE
        Log_Task.KnowledgeOwner = Fact_UnfinishedTaskDetail.SubName
            AND sDay > 0
            AND Log_Task.ProjectID = Fact_UnfinishedTaskDetail.ProjectID
    ORDER BY Log_Task.ID desc) a
GROUP BY ProjectID , TaskID , sDay; 

DROP TEMPORARY TABLE IF EXISTS Result_TaskTraceWorkStart;
CREATE TEMPORARY TABLE Result_TaskTraceWorkStart
SELECT 
    Event_WorkBegin.ProjectID,
    Fact_UnfinishedTaskDetail.TaskID,
    sDay,
    SubName,
    Space,
    WorkMethod,
    0 Completeness,
    Space - 1 TaskStatus,
    1 BeginDay
FROM
    Event_WorkBegin
        LEFT JOIN
    Fact_UnfinishedTaskDetail ON Fact_UnfinishedTaskDetail.TaskID = Event_WorkBegin.TaskID;

DROP TEMPORARY TABLE IF EXISTS True_TaskTrace;
CREATE TEMPORARY TABLE True_TaskTrace
(SELECT 
    *
FROM
    Result_TaskTraceWork) UNION (SELECT 
    *
FROM
    Result_TaskTraceWorkStart);
    
DROP TEMPORARY TABLE IF EXISTS True_LatestQualityFail;
CREATE TEMPORARY TABLE True_LatestQualityFail
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        Event_QualityCheck
    WHERE
        Pass = 0
    ORDER BY TaskID , sDay desc) a
GROUP BY TaskID;

DROP TEMPORARY TABLE IF EXISTS True_LatestDesignChange;
CREATE TEMPORARY TABLE True_LatestDesignChange
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        Event_DesignChange
    ORDER BY TaskID , sDay desc) a
GROUP BY TaskID;

DROP TEMPORARY TABLE IF EXISTS True_Result;
CREATE TEMPORARY TABLE True_Result
SELECT 
    CONCAT(Space, '-', WorkMethod) WPName,
    DATE_ADD('2015-01-01',INTERVAL sDay DAY) sDate,
    sDay,
    TaskStatus,
    WorkMethod,
    SubName,
    Space,
    b.ProjectID,
    TaskID,
    NotMature,
    DesignChange,
    PredecessorIncomplete,
    WorkSpaceCongestion,
    ExternalCondition,
    QualityFail,
    MeetingCycle,
    DesignChangeCycle,
    ProductionRateChange,
    QualityCheck,
    TaskSelectionFunction,
    PriorityChange,
    CollisionInformationExchange,
    BeginDay,
    QualityWaste,
    DesignWaste,
    WasteDay,
    AddValue
FROM
    (SELECT 
        *,
            CASE
                WHEN (QualityWaste = 1 OR DesignWaste = 1) THEN 1
                ELSE 0
            END WasteDay,
            CASE
                WHEN
                    (NotMature < 1 AND QualityWaste < 1
                        AND DesignWaste < 1
                        AND BeginDay < 1)
                THEN
                    1
                ELSE 0
            END AddValue
    FROM
        (SELECT 
        True_TaskTrace.*,
            CASE
                WHEN
                    ISNULL(Event_RetracePredecessor.sDay)
                        AND ISNULL(Event_RetraceWorkSpace.sDay)
                        AND ISNULL(Event_RetraceExternalCondition.sDay)
                THEN
                    0
                ELSE 1
            END NotMature,
            CASE
                WHEN ISNULL(Event_RetracePredecessor.sDay) THEN 0
                ELSE 1
            END PredecessorIncomplete,
            CASE
                WHEN ISNULL(Event_RetraceWorkSpace.sDay) THEN 0
                ELSE 1
            END WorkSpaceCongestion,
            CASE
                WHEN ISNULL(Event_RetraceExternalCondition.sDay) THEN 0
                ELSE 1
            END ExternalCondition,
            CASE
                WHEN ISNULL(Event_DesignChange.sDay) THEN 0
                ELSE 1
            END DesignChange,
            CASE
                WHEN Event_QualityCheck.Pass = 0 THEN 1
                ELSE 0
            END QualityFail,
            CASE
                WHEN True_TaskTrace.sDay <= True_LatestQualityFail.sDay THEN 1
                ELSE 0
            END QualityWaste,
            CASE
                WHEN True_TaskTrace.sDay <= True_LatestDesignChange.sDay THEN 1
                ELSE 0
            END DesignWaste
    FROM
        True_TaskTrace
    LEFT JOIN Event_RetracePredecessor ON True_TaskTrace.ProjectID = Event_RetracePredecessor.ProjectID
        AND True_TaskTrace.TaskID = Event_RetracePredecessor.TaskID
        AND True_TaskTrace.sDay = Event_RetracePredecessor.sDay
    LEFT JOIN Event_RetraceWorkSpace ON True_TaskTrace.ProjectID = Event_RetraceWorkSpace.ProjectID
        AND True_TaskTrace.TaskID = Event_RetraceWorkSpace.TaskID
        AND True_TaskTrace.sDay = Event_RetraceWorkSpace.sDay
    LEFT JOIN Event_RetraceExternalCondition ON True_TaskTrace.ProjectID = Event_RetraceExternalCondition.ProjectID
        AND True_TaskTrace.TaskID = Event_RetraceExternalCondition.TaskID
        AND True_TaskTrace.sDay = Event_RetraceExternalCondition.sDay
    LEFT JOIN Event_DesignChange ON True_TaskTrace.ProjectID = Event_DesignChange.ProjectID
        AND True_TaskTrace.TaskID = Event_DesignChange.TaskID
        AND True_TaskTrace.sDay = Event_DesignChange.sDay
    LEFT JOIN Event_QualityCheck ON True_TaskTrace.ProjectID = Event_QualityCheck.ProjectID
        AND True_TaskTrace.TaskID = Event_QualityCheck.TaskID
        AND True_TaskTrace.sDay = Event_QualityCheck.sDay
    LEFT JOIN True_LatestQualityFail ON True_TaskTrace.TaskID = True_LatestQualityFail.TaskID
    LEFT JOIN True_LatestDesignChange ON True_TaskTrace.TaskID = True_LatestDesignChange.TaskID
    ORDER BY True_TaskTrace.TaskID , True_TaskTrace.sDay) a) b
        LEFT JOIN
    Fact_Project c ON b.ProjectID = c.ID;
                
insert into Result(WPName,sDate,sDay,TaskStatus,WorkMethod,SubName,Space,ProjectID,TaskID,NotMature,DesignChange,PredecessorIncomplete,WorkSpaceCongestion,ExternalCondition,QualityFail,MeetingCycle,
DesignChangeCycle,ProductionRateChange,QualityCheck,TaskSelectionFunction,PriorityChange,CollisionInformationExchange,BeginDay,QualityWaste,DesignWaste,WasteDay,AddValue)
SELECT 
    *
FROM
    True_Result;

DROP TEMPORARY TABLE IF EXISTS Result_CollisionHistory;
CREATE TEMPORARY TABLE Result_CollisionHistory						
SELECT 
    c.ProjectID,Space,Crews,c.sDay,MeetType
FROM
    (SELECT 
        ProjectID, Space, COUNT(*) Crews, sDay, 'RandomMeeting' MeetType
    FROM
        True_TaskTrace a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    WHERE
        BeginDay = 0
            AND CollisionInformationExchange = 1
    GROUP BY ProjectID , Space , sDay
    HAVING Crews > 1) c
        LEFT JOIN
    Event_Meeting d ON c.ProjectID = d.ProjectID
        AND c.sDay = d.sDay
WHERE
    ISNULL(d.sDay);

insert into Result_InformationFlow (ProjectID, Space, Crews, sDay, MeetType)
(SELECT 
    *
FROM
    Result_CollisionHistory) UNION (SELECT 
    c.ProjectID, 0 Space, Crews, sDay, 'SiteMeeting' MeetType
FROM
    (SELECT 
        d.ProjectID, sDay, SubName
    FROM
        Event_Meeting d
    LEFT JOIN Fact_Sub e ON d.ProjectID = e.ProjectID) c
        LEFT JOIN
    (SELECT 
        ProjectID, COUNT(SubName) Crews
    FROM
        (SELECT 
        ProjectID, SubName
    FROM
        Fact_UnfinishedTaskDetail
    GROUP BY ProjectID , SubName) a
    GROUP BY ProjectID) b ON c.ProjectID = b.ProjectID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_ADay` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_ADay`(in thisDay int)
BEGIN
	call Run_Work(thisDay);
	call Run_Infer(thisDay);
	call Run_Events(thisDay);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_ChooseProjects` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_ChooseProjects`(in number_of_projects int)
BEGIN

# choose given number of projects
DROP TEMPORARY TABLE IF EXISTS Fact_UnfinishedProject;
CREATE TEMPORARY TABLE Fact_UnfinishedProject
SELECT 
    *
FROM
    Fact_Project
WHERE
    Done = 0 
    order by ID limit number_of_projects
    ;

# create temp tables for speeding up log process, cause it slice part of the projects
DROP TEMPORARY TABLE IF EXISTS Log_Task;
CREATE TEMPORARY TABLE `Log_Task` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `TaskID` int(11) NOT NULL,
  `RemainingQty` double NOT NULL,
  `TotalQty` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
); 
insert into Log_Task (KnowledgeOwner,sDay,TaskID,RemainingQty,TotalQty,ProjectID)
SELECT 
    Fact_Sub.SubName AS KnowledgeOwner,
    0 sDay,
    TaskID,
    InitialQty RemainingQty,
    InitialQty TotalQty,
    Fact_Task.ProjectID
FROM
    Fact_Task
        JOIN
    Fact_Sub ON Fact_Task.ProjectID = Fact_Sub.ProjectID
        JOIN
    Fact_UnfinishedProject ON Fact_Task.ProjectID = Fact_UnfinishedProject.ID;

DROP TEMPORARY TABLE IF EXISTS Log_WorkSpacePriority;
CREATE TEMPORARY TABLE `Log_WorkSpacePriority` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `Space` int(11) NOT NULL,
  `WorkSpacePriority` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  `SubName` char(20) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
);
insert into Log_WorkSpacePriority (KnowledgeOwner,sDay,Space,WorkSpacePriority,ProjectID,SubName)
SELECT 
    b.SubName KnowledgeOwner,
    0 sDay,
    Space,
    InitialPriority WorkSpacePriority,
    Fact_WorkSpace.ProjectID,
    a.SubName
FROM
    Fact_WorkSpace
        JOIN
    Fact_Sub a ON Fact_WorkSpace.ProjectID = a.ProjectID
        JOIN
    Fact_Sub b ON a.ProjectID = b.ProjectID
        JOIN
    Fact_UnfinishedProject ON Fact_WorkSpace.ProjectID = Fact_UnfinishedProject.ID;

DROP TEMPORARY TABLE IF EXISTS Log_ProductionRate;
CREATE TEMPORARY TABLE `Log_ProductionRate` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `KnowledgeOwner` char(20) NOT NULL,
  `sDay` int(11) NOT NULL DEFAULT '0',
  `WorkMethod` char(50) NOT NULL,
  `ProductionRate` double NOT NULL,
  `ProjectID` int(11) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `ID` (`ID`)
);
insert into Log_ProductionRate (KnowledgeOwner,sDay,WorkMethod,ProductionRate,ProjectID)
SELECT 
    b.SubName KnowledgeOwner,
    0 sDay,
    WorkMethod,
    InitialProductionRate ProductionRate,
    a.ProjectID
FROM
    Fact_WorkMethod a
        JOIN
    Fact_Sub b ON a.ProjectID = b.ProjectID
        JOIN
    Fact_UnfinishedProject ON a.ProjectID = Fact_UnfinishedProject.ID;

DROP TEMPORARY TABLE IF EXISTS Fact_UnfinishedTaskDetail;
CREATE TEMPORARY TABLE Fact_UnfinishedTaskDetail
SELECT 
    c.*,
    SubName,
    InitialProductionRate,
    QualityRate,
    PerformanceStd
FROM
    (SELECT 
        a.*
    FROM
        Fact_Task a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID) c
        JOIN
    Fact_WorkMethod d ON c.WorkMethod = d.WorkMethod
        AND c.ProjectID = d.ProjectID;

DROP TEMPORARY TABLE IF EXISTS Fact_TaskDependency;
CREATE TEMPORARY TABLE Fact_TaskDependency
SELECT 
    c.SuccessorTaskID, d.TaskID PredecessorTaskID
FROM
    (SELECT 
        a.TaskID SuccessorTaskID,
            a.Space,
            PredecessorWorkMethod,
            a.ProjectID
    FROM
        Fact_UnfinishedTaskDetail a
    JOIN Fact_WorkMethodDependency b ON a.WorkMethod = b.SuccessorWorkMethod
        AND a.ProjectID = b.ProjectID) c
        JOIN
    Fact_Task d ON c.PredecessorWorkMethod = d.WorkMethod
        AND d.ProjectID = c.ProjectID
        AND c.Space = d.Space;
        
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_Events` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_Events`(in thisDay int)
BEGIN

call Run_EventsDesignChange(thisDay);
call Run_EventsQualityCheck(thisDay);
# meeting on the end of the day is the same as meeting at the begining of the next day
call Run_EventsMeeting(thisDay+1);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_EventsDesignChange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_EventsDesignChange`(in thisDay int)
BEGIN

call Reset_Latest();

DROP TEMPORARY TABLE IF EXISTS True_WorkMethodCompleteness;
CREATE TEMPORARY TABLE True_WorkMethodCompleteness
SELECT 
    *, 1 - RemainingQty / TotalQty WorkMethodCompleteness
FROM
    (SELECT 
        SUM(RemainingQty) RemainingQty,
            SUM(TotalQty) TotalQty,
            ProjectID,
            WorkMethod
    FROM
        True_UnfinishedTask
    GROUP BY ProjectID , WorkMethod) d;

DROP TEMPORARY TABLE IF EXISTS True_ProjectCompletess;
CREATE TEMPORARY TABLE True_ProjectCompletess
SELECT 
    1 - SUM(RemainingQty) / SUM(TotalQty) ProjectCompleteness,
    ProjectID
FROM
    True_WorkMethodCompleteness
GROUP BY ProjectID;

DROP TEMPORARY TABLE IF EXISTS True_DesignChangeProjects;
CREATE TEMPORARY TABLE True_DesignChangeProjects
SELECT 
    CASE
        WHEN RAND() < ProjectCompleteness THEN NULL
        ELSE ProjectID
    END ProjectID
FROM
    (SELECT 
        a.*
    FROM
        True_ProjectCompletess a
    JOIN (SELECT 
        CASE
                WHEN MOD(thisDay, DesignChangeCycle) = 0 THEN ID
                ELSE NULL
            END ProjectID
    FROM
        Fact_UnfinishedProject) b ON a.ProjectID = b.ProjectID) c;

DROP TEMPORARY TABLE IF EXISTS True_DesignChangeTasks;
CREATE TEMPORARY TABLE True_DesignChangeTasks
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    DesignChangeVariation
FROM
    (SELECT 
        a.*
    FROM
        True_UnfinishedTask a
    JOIN True_DesignChangeProjects b ON a.ProjectID = b.ProjectID
    ORDER BY RAND()) b
GROUP BY ProjectID;

DROP TEMPORARY TABLE IF EXISTS True_DesignChanges;
CREATE TEMPORARY TABLE True_DesignChanges
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    TRUNCATE(GAUSS(RemainingQty, DesignChangeVariation),
        0) DesignChange
FROM
    True_DesignChangeTasks;

#design change is not waste, is it value adding?
DROP TEMPORARY TABLE IF EXISTS True_DesignChangeEffects;
CREATE TEMPORARY TABLE True_DesignChangeEffects
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    DesignChange RemainingQty,
    (TotalQty - RemainingQty + DesignChange) as TotalQty
FROM
    (SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    CASE
        WHEN (DesignChange < 0) THEN TotalQty
        ELSE DesignChange
    END DesignChange
FROM
    True_DesignChanges) a;

insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    thisDay sDay
FROM
    True_DesignChangeEffects;

insert into Event_DesignChange (ProjectID,TaskID,TotalQty,sDay)
SELECT 
    ProjectID, TaskID, TotalQty, thisDay sDay
FROM
    True_DesignChangeEffects;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_EventsMeeting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_EventsMeeting`(in thisDay int)
BEGIN

call Reset_Latest();

DROP TEMPORARY TABLE IF EXISTS True_MeetingTime;
CREATE TEMPORARY TABLE True_MeetingTime
SELECT 
    CASE
        WHEN MOD(thisDay, MeetingCycle) = 0 THEN ID
        ELSE NULL
    END ProjectID
FROM
    Fact_UnfinishedProject;

insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    a.ProjectID,
    b.SubName KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    sDay
FROM
    True_TaskLatest a
		join
	True_MeetingTime c on a.ProjectID=c.ProjectID
        JOIN
    True_UnfinishedSub b ON a.ProjectID = b.ProjectID
WHERE
    a.SubName <> b.SubName;

insert into Log_ProductionRate (ProjectID,KnowledgeOwner,WorkMethod,ProductionRate,sDay)
SELECT 
    a.ProjectID,
    b.SubName KnowledgeOwner,
    WorkMethod,
    ProductionRate,
    sDay
FROM
    True_ProductionRateLatest a
		join
	True_MeetingTime c on a.ProjectID=c.ProjectID
        JOIN
    True_UnfinishedSub b ON a.ProjectID = b.ProjectID
WHERE
    a.SubName <> b.SubName;

insert into Log_WorkSpacePriority (ProjectID,KnowledgeOwner,SubName,WorkSpacePriority,Space,sDay)
SELECT 
    a.ProjectID,
    b.SubName KnowledgeOwner,
    a.SubName,
    WorkSpacePriority,
    Space,
    sDay
FROM
    True_WorkSpacePriorityLatest a
		join
	True_MeetingTime c on a.ProjectID=c.ProjectID
        JOIN
    True_UnfinishedSub b ON a.ProjectID = b.ProjectID
WHERE
    a.SubName <> b.SubName;

insert into Event_Meeting (sDay,ProjectID)
SELECT 
    thisDay sDay, ProjectID
FROM
    True_MeetingTime
WHERE
    ProjectID IS NOT NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_EventsQualityCheck` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_EventsQualityCheck`(in thisDay int)
BEGIN

call Reset_Latest();

DROP TEMPORARY TABLE IF EXISTS True_FinishedUncheckedTasks;
CREATE TEMPORARY TABLE True_FinishedUncheckedTasks
SELECT 
    a.TaskID,a.ProjectID,a.KnowledgeOwner,a.RemainingQty,a.TotalQty,a.WorkMethod,DesignChangeVariation
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        e.*
    FROM
        True_TaskLatest e
    JOIN (SELECT 
        ID ProjectID
    FROM
        Fact_UnfinishedProject
    WHERE
        QualityCheck > 0) f ON e.ProjectID = f.ProjectID) g
    WHERE
        RemainingQty = 0) a
        LEFT JOIN
    (SELECT 
        *
    FROM
        (SELECT 
        *
    FROM
        (SELECT 
        *
    FROM
        Event_QualityCheck
    ORDER BY ID DESC) b
    GROUP BY TaskID) c
    WHERE
        Pass = 1) d ON a.TaskID = d.TaskID
WHERE
    ISNULL(d.TaskID);


DROP TEMPORARY TABLE IF EXISTS True_QualityCheckedTasks;
CREATE TEMPORARY TABLE True_QualityCheckedTasks
SELECT 
    a.TaskID,a.ProjectID,a.KnowledgeOwner,a.RemainingQty,a.TotalQty,a.DesignChangeVariation,
    CASE
        WHEN RAND() < WorkMethodCompleteness THEN 0
        ELSE 1
    END Pass
    
FROM
    True_FinishedUncheckedTasks a
        LEFT JOIN
    True_WorkMethodCompleteness b ON a.ProjectID = b.ProjectID
        AND a.WorkMethod = b.WorkMethod;

insert into Event_QualityCheck (TaskID,Pass,ProjectID,sDay) 
select TaskID,Pass,ProjectID,thisDay sDay from True_QualityCheckedTasks;

#rework=new RemainingQty, TotalQty is the total work including rework
insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    RemainingQty + TotalQty TotalQty,
	thisDay sDay 
FROM
    (SELECT 
        ProjectID,
            KnowledgeOwner,
            TaskID,
            TotalQty,
            TRUNCATE(GAUSS(RemainingQty, DesignChangeVariation), 0) RemainingQty
    FROM
        True_QualityCheckedTasks
    WHERE
        Pass = 0) a;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_Infer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_Infer`(in thisDay int)
BEGIN

call Reset_Maturity();

DROP TEMPORARY TABLE IF EXISTS View_MatureTaskOther;
CREATE TEMPORARY TABLE View_MatureTaskOther
SELECT 
    *
FROM
    View_PrdecessorAndSpaceFreeTask
WHERE
    KnowledgeOwner <> SubName;

DROP TEMPORARY TABLE IF EXISTS True_CollisionSubsDup;
CREATE TEMPORARY TABLE True_CollisionSubsDup
SELECT 
    *
FROM
    True_CollisionSubs;

DROP TEMPORARY TABLE IF EXISTS View_TaskUnknown;
CREATE TEMPORARY TABLE View_TaskUnknown
SELECT 
    c.*
FROM
    (SELECT 
        a.*
    FROM
        View_MatureTaskOther a
    LEFT JOIN View_Assignment b ON a.ProjectID = b.ProjectID
        AND a.KnowledgeOwner = b.KnowledgeOwner
        AND a.Space = b.Space
    WHERE
        ISNULL(b.TaskID)) c
        LEFT JOIN
    (SELECT 
        d.ProjectID, d.SubName, e.SubName KnowledgeOwner
    FROM
        True_CollisionSubsDup d
    JOIN True_CollisionSubs e ON d.ProjectID = e.ProjectID
        AND d.sDay = e.sDay
    WHERE
        d.SubName <> e.SubName) f ON c.ProjectID = f.ProjectID
        AND c.KnowledgeOwner = f.KnowledgeOwner
        AND c.SubName = f.SubName
WHERE
    ISNULL(f.ProjectID);    

DROP TEMPORARY TABLE IF EXISTS View_TaskSelectionInfer;
CREATE TEMPORARY TABLE View_TaskSelectionInfer
SELECT 
    *
FROM
    (SELECT 
        *
    FROM
        (SELECT 
        *
    FROM
        View_TaskUnknown
    ORDER BY ProjectID , KnowledgeOwner , SubName, WorkingYesterday DESC ,WorkSpacePriority desc, RAND()) a
    GROUP BY ProjectID , KnowledgeOwner , SubName
    ORDER BY ProjectID , KnowledgeOwner , Space, WorkingYesterday DESC , Space , RAND()) b
GROUP BY ProjectID , KnowledgeOwner , Space; 

insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    GREATEST(RemainingQty - ProductionRate, 0) RemainingQty,
    TotalQty,
    thisDay sDay
FROM
    View_TaskSelectionInfer;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_Simulation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_Simulation`(in concurrence int)
BEGIN
DECLARE thisDay INT;
DECLARE remainingTasks INT;
	call Run_ChooseProjects(concurrence);
	set thisDay=1;
    REPEAT
		call Run_ADay(thisDay);
		set thisDay = thisDay+1;
SELECT 
    COUNT(*) into remainingTasks
FROM
    ((SELECT 
        TaskID
    FROM
        True_QualityCheckedTasks
    WHERE
        pass = 0) UNION (SELECT 
        TaskID
    FROM
        True_UnfinishedTask)) a;
        
		UNTIL remainingTasks=0
        #UNTIL thisDay>6
    END REPEAT;
call Result();
UPDATE Fact_Project SET Done = 1 WHERE ID IN (SELECT ID FROM Fact_UnfinishedProject);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Run_Work` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Run_Work`(in thisDay int)
BEGIN

call Reset_Maturity();

DROP TEMPORARY TABLE IF EXISTS View_MatureTaskOwn;
CREATE TEMPORARY TABLE View_MatureTaskOwn
SELECT 
    *
FROM
    View_PrdecessorAndSpaceFreeTask
WHERE
    KnowledgeOwner = SubName;

DROP TEMPORARY TABLE IF EXISTS View_RandomTaskSelection;
CREATE TEMPORARY TABLE View_RandomTaskSelection
SELECT 
    *
FROM
    (SELECT 
        a.*
    FROM
        View_MatureTaskOwn a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    WHERE
        b.TaskSelectionFunction = 0
    ORDER BY ProjectID , KnowledgeOwner , WorkingYesterday DESC , RAND()) c
GROUP BY ProjectID , KnowledgeOwner; 

DROP TEMPORARY TABLE IF EXISTS View_PrioritizedTaskSelection;
CREATE TEMPORARY TABLE View_PrioritizedTaskSelection
SELECT 
    *
FROM
    (SELECT 
        a.*
    FROM
        View_MatureTaskOwn a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID
    WHERE
        b.TaskSelectionFunction = 1
    ORDER BY ProjectID , KnowledgeOwner , WorkingYesterday DESC , WorkSpacePriority DESC , RAND()) t2
GROUP BY ProjectID , KnowledgeOwner;

DROP TEMPORARY TABLE IF EXISTS View_Assignment;
CREATE TEMPORARY TABLE View_Assignment
SELECT 
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    ProjectID,
    SubName,
    DesignChangeVariation,
    Space,
    WorkMethod,
    PerformanceStd,
    WorkSpacePriority,
    WorkingYesterDay,
    ProductionRate,
    thisDay sDay
FROM
    ((select * from View_RandomTaskSelection) UNION (select * from View_PrioritizedTaskSelection)) a;

DROP TEMPORARY TABLE IF EXISTS View_AssignmentTechConstraint;
create  TEMPORARY TABLE View_AssignmentTechConstraint
SELECT 
    a.*,
    CASE
        WHEN ISNULL(b.TaskID) THEN 0
        ELSE 1
    END PredecessorFree
FROM
    View_Assignment a
        LEFT JOIN
    True_PrdecessorAndSpaceFreeTask b ON a.TaskID = b.TaskID;

insert into Event_RetracePredecessor (ProjectID,TaskID,sDay)
SELECT 
    ProjectID, TaskID, sDay
FROM
    View_AssignmentTechConstraint
WHERE
    PredecessorFree = 0;
    
DROP TEMPORARY TABLE IF EXISTS View_AssignmentSpaceFree;
create temporary  TABLE View_AssignmentSpaceFree
SELECT 
    t.*
FROM
    (SELECT 
        *
    FROM
        View_AssignmentTechConstraint
    WHERE
        PredecessorFree = 1
    ORDER BY RAND()) t
GROUP BY ProjectID , Space;

insert into Event_RetraceWorkSpace (ProjectID,TaskID,sDay)
SELECT 
    a.ProjectID, a.TaskID, a.sDay
FROM
    (SELECT 
        *
    FROM
        View_AssignmentTechConstraint
    WHERE
        PredecessorFree = 1) a
        LEFT JOIN
    View_AssignmentSpaceFree b ON a.TaskID = b.TaskID
WHERE
    ISNULL(b.TaskID);
    
DROP TEMPORARY TABLE IF EXISTS View_AssignmentProduction;
create temporary table View_AssignmentProduction
SELECT 
    a.*,
    CASE
        WHEN b.ProductionRateChange > 0 THEN TRUNCATE(GAUSS(ProductionRate, PerformanceStd),0)
        ELSE ProductionRate
    END newProductionRate
FROM
    View_AssignmentSpaceFree a
        JOIN
    Fact_UnfinishedProject b ON a.ProjectID = b.ID;

insert into Event_RetraceExternalCondition (ProjectID,TaskID,sDay)
SELECT 
    ProjectID, TaskID, sDay
FROM
    View_AssignmentProduction
WHERE
    newProductionRate <= 0;
    
DROP TEMPORARY TABLE IF EXISTS View_Work;
create temporary table View_Work
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty preRemainingQty,
    newProductionRate,
    ProductionRate,
    GREATEST(RemainingQty - newProductionRate, 0) RemainingQty,
    TotalQty,
    WorkMethod,
    sDay
FROM
    View_AssignmentProduction
WHERE
    newProductionRate > 0;

insert into Event_WorkBegin (ProjectID,TaskID,sDay)
SELECT 
    ProjectID, TaskID, sDay - 1 sDay
FROM
    View_Work
WHERE
    preRemainingQty = TotalQty;

insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    ProjectID,
    KnowledgeOwner,
    TaskID,
    RemainingQty,
    TotalQty,
    sDay
FROM
    View_Work;

DROP TEMPORARY TABLE IF EXISTS True_UpdatedTaskLatest;
CREATE TEMPORARY TABLE True_UpdatedTaskLatest
SELECT 
    a.ProjectID,
    a.KnowledgeOwner,
    a.SubName,
    a.TaskID,
    a.Space,
    CASE
        WHEN ISNULL(c.sDay) THEN a.sDay
        ELSE c.sDay
    END sDay,
    CASE
        WHEN ISNULL(c.RemainingQty) THEN a.RemainingQty
        ELSE c.RemainingQty
    END RemainingQty,
    CASE
        WHEN ISNULL(c.TotalQty) THEN a.TotalQty
        ELSE c.TotalQty
    END TotalQty
FROM
    True_TaskLatest a
        LEFT JOIN
    View_Work c ON a.TaskID = c.TaskID;
    
DROP TEMPORARY TABLE IF EXISTS View_ProductionRateChange;
create temporary table View_ProductionRateChange
SELECT 
    ProjectID,
    newProductionRate ProductionRate,
    KnowledgeOwner,
    WorkMethod,
    sDay
FROM
    View_Work
WHERE
    newProductionRate > 0 and newProductionRate<>ProductionRate;

insert into Log_ProductionRate (ProjectID,KnowledgeOwner,WorkMethod,ProductionRate,sDay)
SELECT 
    a.ProjectID,
    a.KnowledgeOwner,
    a.WorkMethod,
    a.ProductionRate,
    a.sDay
FROM
	View_ProductionRateChange a;

DROP TEMPORARY TABLE IF EXISTS True_UpdatedProductionRateLatest;
CREATE TEMPORARY TABLE True_UpdatedProductionRateLatest
SELECT 
    a.ProjectID,
    a.KnowledgeOwner,
    a.WorkMethod,
    CASE
        WHEN ISNULL(b.sDay) THEN a.sDay
        ELSE b.sDay
    END sDay,
    CASE
        WHEN ISNULL(b.ProductionRate) THEN a.ProductionRate
        ELSE b.ProductionRate
    END ProductionRate,
    a.SubName
FROM
    True_ProductionRateLatest a
        LEFT JOIN
    View_ProductionRateChange b ON a.ProjectID = b.ProjectID
        AND a.WorkMethod = b.WorkMethod;

insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    a.ProjectID,
    a.KnowledgeOwner,
    b.TaskID,
    b.RemainingQty,
    b.TotalQty,
    b.sDay
FROM
    View_Assignment a
        LEFT JOIN
    True_UpdatedTaskLatest b ON a.ProjectID = b.ProjectID
        AND a.Space = b.Space
WHERE
    a.SubName <> b.SubName;

DROP TEMPORARY TABLE IF EXISTS True_CollisionSpace;
create temporary table True_CollisionSpace
SELECT 
    ProjectID, Space
FROM
    View_Assignment a
        JOIN
    Fact_UnfinishedProject c ON a.ProjectID = c.ID
WHERE
    c.CollisionInformationExchange = 1
GROUP BY ProjectID , Space
HAVING COUNT(*) > 1;

DROP TEMPORARY TABLE IF EXISTS True_CollisionSubs;
create temporary table True_CollisionSubs
SELECT 
    a.ProjectID, a.SubName, a.sDay
FROM
    View_Assignment a
        JOIN
    True_CollisionSpace b ON a.ProjectID = b.ProjectID
        AND a.Space = b.Space;
        
DROP TEMPORARY TABLE IF EXISTS True_CollisionTasks;
create temporary table True_CollisionTasks
SELECT 
    a.ProjectID,
    a.TaskID,
    a.SubName,
    a.Space,
    a.RemainingQty,
    a.TotalQty,
    a.sDay
FROM
    True_UpdatedTaskLatest a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
        AND a.SubName = b.SubName;
        
insert into Log_Task (ProjectID,KnowledgeOwner,TaskID,RemainingQty,TotalQty,sDay)
SELECT 
    a.ProjectID,
    b.SubName KnowledgeOwner,
    a.TaskID,
    RemainingQty,
    TotalQty,
    a.sDay
FROM
    True_CollisionTasks a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
WHERE
    a.SubName <> b.SubName;
   
DROP TEMPORARY TABLE IF EXISTS True_CollisionProductionRates;
create temporary table True_CollisionProductionRates
SELECT 
    a.ProjectID,
    a.KnowledgeOwner,
    a.WorkMethod,
    a.ProductionRate,
    a.SubName,
    a.sDay
FROM
    (SELECT 
        d.*
    FROM
        True_UpdatedProductionRateLatest d
    JOIN Fact_UnfinishedProject c ON d.ProjectID = c.ID
    WHERE
        c.ProductionRateChange > 0) a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
        AND a.SubName = b.SubName;
        
insert into Log_ProductionRate (ProjectID, KnowledgeOwner, WorkMethod, ProductionRate, sDay)
SELECT 
    a.ProjectID,
    b.SubName KnowledgeOwner,
    a.WorkMethod,
    a.ProductionRate,
    a.sDay
FROM
    True_CollisionProductionRates a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
WHERE
    a.KnowledgeOwner <> b.SubName; 
    
DROP TEMPORARY TABLE IF EXISTS True_CollisionWorkSpacePriorities;
create temporary table True_CollisionWorkSpacePriorities
SELECT 
    a.*
FROM
    (SELECT 
        c.*
    FROM
        True_WorkSpacePriorityLatest c
    JOIN Fact_UnfinishedProject d ON c.ProjectID = d.ID
    WHERE
        d.PriorityChange > 0) a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
        AND a.SubName = b.SubName;

insert into Log_WorkSpacePriority (KnowledgeOwner,sDay,Space,WorkSpacePriority,ProjectID,SubName)
SELECT 
    b.SubName KnowledgeOwner,
    a.sDay,
    a.Space,
    a.WorkSpacePriority,
    a.ProjectID,
    a.SubName
FROM
    True_CollisionWorkSpacePriorities a
        JOIN
    True_CollisionSubs b ON a.ProjectID = b.ProjectID
WHERE
    a.KnowledgeOwner <> b.SubName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Set_InitialData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Set_InitialData`()
BEGIN

insert into Fact_Sub (SubName,ProjectID)
SELECT 
    SubName, b.ID AS ProjectID
FROM
    (SELECT 
        ID
    FROM
        Fact_Project
    WHERE
        Done = 0) b
        CROSS JOIN
    Fact_Sub a
WHERE
    b.ID <> a.ProjectID;

insert into Fact_Task (WorkMethod,Space,InitialQty,DesignChangeVariation,ProjectID)
SELECT 
    WorkMethod,
    Space,
    InitialQty,
    DesignChangeVariation,
    b.ID AS ProjectID
FROM
    (SELECT 
        ID
    FROM
        Fact_Project
    WHERE
        Done = 0) b
        CROSS JOIN
    Fact_Task a
WHERE
    b.ID <> a.ProjectID;

insert into Fact_WorkMethod (SubName,WorkMethod,InitialProductionRate,QualityRate,PerformanceStd,ProjectID)
SELECT 
    SubName,
    WorkMethod,
    InitialProductionRate,
    QualityRate,
    PerformanceStd,
    b.ID AS ProjectID
FROM
    (SELECT 
        ID
    FROM
        Fact_Project
    WHERE
        Done = 0) b
        CROSS JOIN
    Fact_WorkMethod a
WHERE
    b.ID <> a.ProjectID;

insert into Fact_WorkMethodDependency (PredecessorWorkMethod,SuccessorWorkMethod,ProjectID)
SELECT 
    PredecessorWorkMethod,
    SuccessorWorkMethod,
    b.ID AS ProjectID
FROM
    (SELECT 
        ID
    FROM
        Fact_Project
    WHERE
        Done = 0) b
        CROSS JOIN
    Fact_WorkMethodDependency a
WHERE
    b.ID <> a.ProjectID;

insert into Fact_WorkSpace (Space,InitialPriority,ProjectID)
SELECT 
    Space, InitialPriority, b.ID AS ProjectID
FROM
    (SELECT 
        ID
    FROM
        Fact_Project
    WHERE
        Done = 0) b
        CROSS JOIN
    Fact_WorkSpace a
WHERE
    b.ID <> a.ProjectID;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Set_Utils` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE PROCEDURE `Set_Utils`()
BEGIN

DROP TEMPORARY TABLE IF EXISTS Fact_UnfinishedProject;
CREATE TEMPORARY TABLE Fact_UnfinishedProject
SELECT 
    *
FROM
    Fact_Project
WHERE
    Done = 0 
    order by ID limit 1
    ;
    
DROP TEMPORARY TABLE IF EXISTS Fact_UnfinishedTaskDetail;
CREATE TEMPORARY TABLE Fact_UnfinishedTaskDetail
SELECT 
    c.*,
    SubName,
    InitialProductionRate,
    QualityRate,
    PerformanceStd
FROM
    (SELECT 
        a.*
    FROM
        Fact_Task a
    JOIN Fact_UnfinishedProject b ON a.ProjectID = b.ID) c
        LEFT JOIN
    Fact_WorkMethod d ON c.WorkMethod = d.WorkMethod
        AND c.ProjectID = d.ProjectID;

DROP TEMPORARY TABLE IF EXISTS Fact_TaskDependency;
CREATE TEMPORARY TABLE Fact_TaskDependency
SELECT 
    c.SuccessorTaskID, d.TaskID PredecessorTaskID
FROM
    (SELECT 
        a.TaskID SuccessorTaskID,
            a.Space,
            PredecessorWorkMethod,
            a.ProjectID
    FROM
        Fact_UnfinishedTaskDetail a
    JOIN Fact_WorkMethodDependency b ON a.WorkMethod = b.SuccessorWorkMethod
        AND a.ProjectID = b.ProjectID) c
        JOIN
    Fact_Task d ON c.PredecessorWorkMethod = d.WorkMethod
        AND d.ProjectID = c.ProjectID
        AND c.Space = d.Space;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `Result_Retrace`
--

/*!50001 DROP VIEW IF EXISTS `Result_Retrace`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `Result_Retrace` AS (select `Event_RetracePredecessor`.`sDay` AS `sDay`,`Event_RetracePredecessor`.`TaskID` AS `TaskID`,`Event_RetracePredecessor`.`ProjectID` AS `ProjectID`,`Event_RetracePredecessor`.`ID` AS `ID` from `Event_RetracePredecessor`) union (select `Event_RetraceWorkSpace`.`sDay` AS `sDay`,`Event_RetraceWorkSpace`.`TaskID` AS `TaskID`,`Event_RetraceWorkSpace`.`ProjectID` AS `ProjectID`,`Event_RetraceWorkSpace`.`ID` AS `ID` from `Event_RetraceWorkSpace`) union (select `Event_RetraceExternalCondition`.`sDay` AS `sDay`,`Event_RetraceExternalCondition`.`TaskID` AS `TaskID`,`Event_RetraceExternalCondition`.`ProjectID` AS `ProjectID`,`Event_RetraceExternalCondition`.`ID` AS `ID` from `Event_RetraceExternalCondition`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `View_NewSimulationProjects`
--

/*!50001 DROP VIEW IF EXISTS `View_NewSimulationProjects`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 SQL SECURITY DEFINER */
/*!50001 VIEW `View_NewSimulationProjects` AS select `Fact_Project`.`ID` AS `ID`,`Fact_Project`.`MeetingCycle` AS `MeetingCycle`,`Fact_Project`.`DesignChangeCycle` AS `DesignChangeCycle`,`Fact_Project`.`ProductionRateChange` AS `ProductionRateChange`,`Fact_Project`.`QualityCheck` AS `QualityCheck`,`Fact_Project`.`PriorityChange` AS `PriorityChange`,`Fact_Project`.`TaskSelectionFunction` AS `TaskSelectionFunction`,`Fact_Project`.`CollisionInformationExchange` AS `CollisionInformationExchange`,`Fact_Project`.`Done` AS `Done` from `Fact_Project` where (`Fact_Project`.`Done` = 0) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-01-05 15:48:21
