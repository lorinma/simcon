BEGIN TRANSACTION;

DROP TABLE IF EXISTS "Fact_Project";
CREATE TABLE IF NOT EXISTS "Fact_Project" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`MeetingCycle`	INTEGER NOT NULL DEFAULT 0,
	`DesignChangeCycle`	INTEGER NOT NULL DEFAULT 0,
	`DesignChangeVariation`	REAL NOT NULL DEFAULT 0,
	`ProductionRateChange`	INTEGER NOT NULL DEFAULT 0,
	`QualityCheck`	INTEGER NOT NULL DEFAULT 0,
	`PriorityChange`	INTEGER NOT NULL DEFAULT 0,
	`TaskSelectionFunction`	INTEGER NOT NULL DEFAULT 0,
	`Done`	INTEGER NOT NULL DEFAULT 0
);
INSERT INTO `Fact_Project` (MeetingCycle, DesignChangeCycle,
                            DesignChangeVariation,ProductionRateChange,
                            QualityCheck,TaskSelectionFunction)
VALUES (0,9,1.0,1,1,0);
INSERT INTO `Fact_Project` (MeetingCycle, DesignChangeCycle,
                            DesignChangeVariation,ProductionRateChange,
                            QualityCheck,TaskSelectionFunction)
VALUES (7,9,1.0,1,1,0);
INSERT INTO `Fact_Project` (MeetingCycle, DesignChangeCycle,
                            DesignChangeVariation,ProductionRateChange,
                            QualityCheck,TaskSelectionFunction)
VALUES (0,9,1.0,1,1,1);
INSERT INTO `Fact_Project` (MeetingCycle, DesignChangeCycle,
                            DesignChangeVariation,ProductionRateChange,
                            QualityCheck,TaskSelectionFunction)
VALUES (7,9,1.0,1,1,1);

DROP TABLE IF EXISTS "Log_WorkSpacePriority";
CREATE TABLE IF NOT EXISTS "Log_WorkSpacePriority" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`KnowledgeOwner`	TEXT NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`Floor`	INTEGER NOT NULL,
	`Priority`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`SubName`	TEXT NOT NULL,
	FOREIGN KEY(`KnowledgeOwner`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`Floor`) REFERENCES Fact_WorkSpace ( Floor ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID ),
	FOREIGN KEY(`SubName`) REFERENCES Fact_Sub ( SubName )
);

DROP TABLE IF EXISTS "Log_WorkPackage";
CREATE TABLE IF NOT EXISTS "Log_WorkPackage" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`KnowledgeOwner`	TEXT NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`WorkPackageID`	INTEGER NOT NULL,
	`RemainingQty`	REAL NOT NULL,
	`TotalQty`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`KnowledgeOwner`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Log_ProductionRate";
CREATE TABLE IF NOT EXISTS "Log_ProductionRate" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`KnowledgeOwner`	TEXT NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`WorkProcedure`	TEXT NOT NULL,
	`ProductionRate`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`KnowledgeOwner`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`WorkProcedure`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Fact_WorkSpace";
CREATE TABLE IF NOT EXISTS "Fact_WorkSpace" (
	`Floor`	INTEGER NOT NULL UNIQUE,
	`InitialPriority`	REAL NOT NULL,
	PRIMARY KEY(Floor)
);
INSERT INTO `Fact_WorkSpace` VALUES (1,5.0);
INSERT INTO `Fact_WorkSpace` VALUES (2,4.0);
INSERT INTO `Fact_WorkSpace` VALUES (3,3.0);
INSERT INTO `Fact_WorkSpace` VALUES (4,2.0);
INSERT INTO `Fact_WorkSpace` VALUES (5,1.0);

DROP TABLE IF EXISTS "Fact_WorkProcedureDependency";
CREATE TABLE IF NOT EXISTS "Fact_WorkProcedureDependency" (
	`PredecessorWorkProcedure`	TEXT NOT NULL,
	`SuccessorWorkProcedure`	TEXT NOT NULL,
	FOREIGN KEY(`PredecessorWorkProcedure`) REFERENCES Fact_WorkProcedure ( WorkProcedure ),
	FOREIGN KEY(`SuccessorWorkProcedure`) REFERENCES Fact_WorkProcedure ( WorkProcedure )
);
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Gravel base layer','Pipes in the floor');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Gravel base layer','Electric conduits in the floor');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Pipes in the floor','Floor tiling');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Electric conduits in the floor','Floor tiling');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Partition phase 1','Pipes in the wall');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Partition phase 1','Electric conduits in the wall');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Pipes in the wall','Partition phase 2');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Electric conduits in the wall','Partition phase 2');
INSERT INTO `Fact_WorkProcedureDependency` VALUES ('Partition phase 2','Wall tiling');

DROP TABLE IF EXISTS "Fact_WorkProcedure";
CREATE TABLE IF NOT EXISTS "Fact_WorkProcedure" (
	`SubName`	TEXT NOT NULL,
	`WorkProcedure`	TEXT NOT NULL UNIQUE,
	`InitialProductionRate`	REAL NOT NULL,
	`QualityRate`	REAL NOT NULL,
	`PerformanceStd`	REAL,
	PRIMARY KEY(WorkProcedure),
	FOREIGN KEY(`SubName`) REFERENCES Fact_Sub ( SubName )
);
INSERT INTO `Fact_WorkProcedure` VALUES ('Gravel','Gravel base layer',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Plumbing','Pipes in the floor',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Electricity','Electric conduits in the floor',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Tiling','Floor tiling',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Partition','Partition phase 1',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Plumbing','Pipes in the wall',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Electricity','Electric conduits in the wall',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Partition','Partition phase 2',1.0,0.9,0.3);
INSERT INTO `Fact_WorkProcedure` VALUES ('Tiling','Wall tiling',1.0,0.9,0.3);

DROP TABLE IF EXISTS "Fact_WorkPackage";
CREATE TABLE IF NOT EXISTS "Fact_WorkPackage" (
	`WorkPackageID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkProcedure`	TEXT NOT NULL,
	`Floor`	INTEGER NOT NULL,
	`InitialQty`	REAL NOT NULL,
	FOREIGN KEY(`WorkProcedure`) REFERENCES Fact_WorkProcedure ( WorkProcedure ),
	FOREIGN KEY(`Floor`) REFERENCES Fact_WorkSpace ( Floor )
);
INSERT INTO `Fact_WorkPackage` VALUES (1,'Gravel base layer',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (2,'Gravel base layer',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (3,'Gravel base layer',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (4,'Gravel base layer',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (5,'Gravel base layer',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (6,'Pipes in the floor',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (7,'Pipes in the floor',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (8,'Pipes in the floor',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (9,'Pipes in the floor',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (10,'Pipes in the floor',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (11,'Electric conduits in the floor',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (12,'Electric conduits in the floor',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (13,'Electric conduits in the floor',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (14,'Electric conduits in the floor',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (15,'Electric conduits in the floor',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (16,'Floor tiling',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (17,'Floor tiling',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (18,'Floor tiling',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (19,'Floor tiling',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (20,'Floor tiling',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (21,'Partition phase 1',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (22,'Partition phase 1',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (23,'Partition phase 1',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (24,'Partition phase 1',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (25,'Partition phase 1',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (26,'Pipes in the wall',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (27,'Pipes in the wall',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (28,'Pipes in the wall',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (29,'Pipes in the wall',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (30,'Pipes in the wall',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (31,'Electric conduits in the wall',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (32,'Electric conduits in the wall',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (33,'Electric conduits in the wall',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (34,'Electric conduits in the wall',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (35,'Electric conduits in the wall',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (36,'Partition phase 2',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (37,'Partition phase 2',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (38,'Partition phase 2',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (39,'Partition phase 2',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (40,'Partition phase 2',5,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (41,'Wall tiling',1,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (42,'Wall tiling',2,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (43,'Wall tiling',3,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (44,'Wall tiling',4,5.0);
INSERT INTO `Fact_WorkPackage` VALUES (45,'Wall tiling',5,5.0);

DROP TABLE IF EXISTS "Fact_Sub";
CREATE TABLE IF NOT EXISTS "Fact_Sub" (
	`SubName`	TEXT NOT NULL UNIQUE,
	PRIMARY KEY(SubName)
);
INSERT INTO `Fact_Sub` VALUES ('Electricity');
INSERT INTO `Fact_Sub` VALUES ('Gravel');
INSERT INTO `Fact_Sub` VALUES ('Partition');
INSERT INTO `Fact_Sub` VALUES ('Plumbing');
INSERT INTO `Fact_Sub` VALUES ('Tiling');

DROP TABLE IF EXISTS "Event_Retrace";
CREATE TABLE IF NOT EXISTS "Event_Retrace" (
	`Day`	INTEGER NOT NULL,
	`WorkPackageID`	INTEGER NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_QualityCheck";
CREATE TABLE IF NOT EXISTS "Event_QualityCheck" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkPackageID`	INTEGER NOT NULL,
	`Pass`	INTEGER NOT NULL DEFAULT 1,
	`ProjectID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_Meeting";
CREATE TABLE IF NOT EXISTS "Event_Meeting" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`ProjectID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL,
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project(ID)
);

DROP TABLE IF EXISTS "Event_DesignChange";
CREATE TABLE IF NOT EXISTS "Event_DesignChange" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkPackageID`	INTEGER NOT NULL,
	`TotalQty`	REAL NOT NULL DEFAULT 0,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_WorkBegin";
CREATE TABLE IF NOT EXISTS "Event_WorkBegin" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkPackageID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

UPDATE Fact_Project SET Done=0;
delete from Event_DesignChange where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_Meeting where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_QualityCheck where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_Retrace where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_WorkBegin where ProjectID in (select ID from Fact_Project where Done=0);

delete from Log_ProductionRate where ProjectID in (select ID from Fact_Project where Done=0);
delete from Log_WorkPackage where ProjectID in (select ID from Fact_Project where Done=0);
delete from Log_WorkSpacePriority where ProjectID in (select ID from Fact_Project where Done=0);

insert into Log_ProductionRate (KnowledgeOwner,ProductionRate,WorkProcedure, ProjectID)
select A.SubName KnowledgeOwner, InitialProductionRate ProductionRate, WorkProcedure, C.ID ProjectID from Fact_Sub A join Fact_WorkProcedure B join Fact_Project C where C.Done=0;

insert into Log_WorkPackage (KnowledgeOwner,WorkPackageID,RemainingQty, TotalQty, ProjectID)
select B.SubName KnowledgeOwner, WorkPackageID, InitialQty RemainingQty, InitialQty TotalQty, C.ID ProjectID from Fact_WorkPackage A join Fact_Sub B join Fact_Project C where C.Done=0;

insert into Log_WorkSpacePriority (KnowledgeOwner,Floor,Priority,SubName,ProjectID)
select A.SubName KnowledgeOwner, B.Floor, B.InitialPriority Priority, C.SubName SubName, D.ID ProjectID from Fact_Sub A join Fact_WorkSpace B join Fact_Sub C join Fact_Project D where D.Done=0;






------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Fact_WorkPackageDetail;
CREATE VIEW IF NOT EXISTS Fact_WorkPackageDetail as
  SELECT WorkPackageID,Floor,Fact_WorkProcedure.*
  FROM Fact_WorkPackage
  LEFT JOIN Fact_WorkProcedure
  ON Fact_WorkProcedure.WorkProcedure = Fact_WorkPackage.WorkProcedure;

DROP VIEW IF EXISTS True_WorkPackageLatest;
CREATE VIEW IF NOT EXISTS True_WorkPackageLatest as
SELECT Latest.*,Floor
FROM (
  SELECT KnowledgeOwner,Day,WorkPackageID,RemainingQty,TotalQty,ProjectID,SubName
  FROM (
    SELECT Log_WorkPackage.*,WorkProcedure,SubName
    FROM Log_WorkPackage
      LEFT JOIN Fact_WorkPackageDetail
        ON Log_WorkPackage.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
    WHERE KnowledgeOwner=SubName
    ORDER BY ProjectID,KnowledgeOwner,WorkPackageID,ID
  )
  GROUP BY ProjectID,KnowledgeOwner,WorkPackageID
)Latest
LEFT JOIN Fact_WorkPackage
ON Latest.WorkPackageID=Fact_WorkPackage.WorkPackageID;

DROP VIEW IF EXISTS True_ProductionRateLatest;
CREATE VIEW IF NOT EXISTS True_ProductionRateLatest as
SELECT KnowledgeOwner,Day,WorkProcedure,ProductionRate,ProjectID,SubName
FROM (
  SELECT Log_ProductionRate.*,SubName
  FROM Log_ProductionRate
  LEFT JOIN Fact_WorkProcedure
  ON Fact_WorkProcedure.WorkProcedure=Log_ProductionRate.WorkProcedure
  WHERE KnowledgeOwner=SubName AND ProductionRate>0
  ORDER BY ProjectID,KnowledgeOwner,WorkProcedure,ID
)
GROUP BY ProjectID,KnowledgeOwner,WorkProcedure;

DROP VIEW IF EXISTS True_WorkSpacePriorityLatest;
CREATE VIEW IF NOT EXISTS True_WorkSpacePriorityLatest as
SELECT KnowledgeOwner,Day,Floor,Priority,ProjectID,SubName
FROM (
  SELECT *
  FROM Log_WorkSpacePriority
  WHERE KnowledgeOwner=SubName
  ORDER BY ProjectID,KnowledgeOwner,Floor,ID
)
GROUP BY ProjectID,KnowledgeOwner,Floor;

DROP VIEW IF EXISTS Fact_WorkPackageDependency;
CREATE VIEW IF NOT EXISTS Fact_WorkPackageDependency as
SELECT PredecessorWorkPackageID,Fact_WorkPackage.WorkPackageID SuccessorWorkPackageID
FROM (
  SELECT Fact_WorkPackage.WorkPackageID PredecessorWorkPackageID,Floor,SuccessorWorkProcedure
  FROM Fact_WorkPackage
    INNER JOIN Fact_WorkProcedureDependency
  ON Fact_WorkPackage.WorkProcedure=Fact_WorkProcedureDependency.PredecessorWorkProcedure
) PredecessorWorkPackage
INNER JOIN Fact_WorkPackage
ON PredecessorWorkPackage.Floor=Fact_WorkPackage.Floor AND PredecessorWorkPackage.SuccessorWorkProcedure=Fact_WorkPackage.WorkProcedure
ORDER BY PredecessorWorkPackageID,SuccessorWorkPackageID;

DROP VIEW IF EXISTS View_WorkPackageLatest;
CREATE VIEW IF NOT EXISTS View_WorkPackageLatest as
SELECT *
FROM (
  SELECT *
  FROM Log_WorkPackage
  ORDER BY ProjectID,KnowledgeOwner,WorkPackageID,ID
)
GROUP BY ProjectID,KnowledgeOwner,WorkPackageID;

DROP VIEW IF EXISTS View_WorkPackageBacklog;
CREATE VIEW IF NOT EXISTS View_WorkPackageBacklog as
SELECT BacklogDetail.*,1-RemainingQty/TotalQty WorkPackageCompleteness, Priority,ProductionRate, random()%1000 Ran
FROM (
       SELECT Backlog.*,SubName,Floor,WorkProcedure
       FROM (
              SELECT Unfinished.ProjectID ProjectID, Unfinished.KnowledgeOwner KnowledgeOwner,Unfinished.Day Day,Unfinished.WorkPackageID WorkPackageID,Unfinished.RemainingQty RemainingQty,Unfinished.TotalQty TotalQty
              FROM (
                SELECT *
                FROM View_WorkPackageLatest
                WHERE RemainingQty>0
                ) Unfinished
                LEFT JOIN Fact_WorkPackageDependency
                  ON Unfinished.WorkPackageID=Fact_WorkPackageDependency.SuccessorWorkPackageID
              WHERE PredecessorWorkPackageID ISNULL
              UNION
              SELECT ProjectID,KnowledgeOwner,Day,WorkPackageID,RemainingQty,TotalQty
              FROM (
                SELECT SuccessorWorkPackage.ProjectID ProjectID,SuccessorWorkPackage.KnowledgeOwner KnowledgeOwner,SuccessorWorkPackage.Day Day,SuccessorWorkPackage.WorkPackageID WorkPackageID,SuccessorWorkPackage.RemainingQty RemainingQty,SuccessorWorkPackage.TotalQty TotalQty, sum(View_WorkPackageLatest.RemainingQty) PredecessorWork
                FROM (
                       SELECT View_WorkPackageLatest.*,PredecessorWorkPackageID
                       FROM View_WorkPackageLatest
                         INNER JOIN Fact_WorkPackageDependency
                           ON View_WorkPackageLatest.WorkPackageID=Fact_WorkPackageDependency.SuccessorWorkPackageID
                       WHERE RemainingQty>0
                     ) SuccessorWorkPackage
                  INNER JOIN View_WorkPackageLatest
                    ON SuccessorWorkPackage.PredecessorWorkPackageID=View_WorkPackageLatest.WorkPackageID AND
                       SuccessorWorkPackage.KnowledgeOwner=View_WorkPackageLatest.KnowledgeOwner AND
                       SuccessorWorkPackage.ProjectID=View_WorkPackageLatest.ProjectID
                GROUP BY SuccessorWorkPackage.ProjectID,SuccessorWorkPackage.KnowledgeOwner,SuccessorWorkPackage.WorkPackageID
              )
              WHERE PredecessorWork=0
            ) Backlog
         LEFT JOIN Fact_WorkPackageDetail
           ON Backlog.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
     ) BacklogDetail
  LEFT JOIN (
              SELECT KnowledgeOwner,Day,Floor,Priority,ProjectID,SubName
              FROM (
                SELECT *
                FROM Log_WorkSpacePriority
                ORDER BY ProjectID,KnowledgeOwner,SubName,Floor,ID
              )
              GROUP BY ProjectID,KnowledgeOwner,SubName,Floor
            )WorkSpacePriorityLatest
    ON BacklogDetail.ProjectID=WorkSpacePriorityLatest.ProjectID AND
       BacklogDetail.KnowledgeOwner=WorkSpacePriorityLatest.KnowledgeOwner AND
       BacklogDetail.SubName=WorkSpacePriorityLatest.SubName AND
       BacklogDetail.Floor=WorkSpacePriorityLatest.Floor
  LEFT JOIN (
              SELECT *
              FROM Log_ProductionRate
              GROUP BY ProjectID,KnowledgeOwner,WorkProcedure
            )Productivity
    ON BacklogDetail.ProjectID=Productivity.ProjectID AND
       BacklogDetail.WorkProcedure=Productivity.WorkProcedure AND
       BacklogDetail.KnowledgeOwner=Productivity.KnowledgeOwner
ORDER BY ProjectID,KnowledgeOwner,SubName, WorkPackageCompleteness, Priority, Ran;

DROP VIEW IF EXISTS View_WorkPackageBacklogPriority;
CREATE VIEW IF NOT EXISTS View_WorkPackageBacklogPriority as
SELECT View_WorkPackageBacklogDetail.*, PerformanceStd, FloorCompleteness,WorkProcedureCompleteness,SuccessorWork, FloorTotalWork,RemainingQty/FloorTotalWork SignificanceToFloor, SuccessorWork/FloorTotalWork SuccessorWorkContribution
FROM View_WorkPackageBacklog View_WorkPackageBacklogDetail
    LEFT JOIN Fact_WorkPackageDetail
      ON View_WorkPackageBacklogDetail.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
    LEFT JOIN (
                SELECT ProjectID,KnowledgeOwner,Floor,1-sum(RemainingQty)/sum(TotalQty) FloorCompleteness, sum(TotalQty) FloorTotalWork
                FROM View_WorkPackageLatest
                  LEFT JOIN Fact_WorkPackageDetail
                    ON View_WorkPackageLatest.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
                GROUP BY ProjectID,KnowledgeOwner,Floor
              ) FloorCompleteness
      ON FloorCompleteness.ProjectID=View_WorkPackageBacklogDetail.ProjectID AND
         FloorCompleteness.KnowledgeOwner=View_WorkPackageBacklogDetail.KnowledgeOwner AND
         FloorCompleteness.Floor=View_WorkPackageBacklogDetail.Floor
    LEFT JOIN (
                SELECT ProjectID,KnowledgeOwner,WorkProcedure,1-sum(RemainingQty)/sum(TotalQty) WorkProcedureCompleteness
                FROM View_WorkPackageLatest
                  LEFT JOIN Fact_WorkPackageDetail
                    ON View_WorkPackageLatest.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
                GROUP BY ProjectID,KnowledgeOwner,WorkProcedure
              ) WorkProcedureCompletenes
      ON WorkProcedureCompletenes.ProjectID=View_WorkPackageBacklogDetail.ProjectID AND
         WorkProcedureCompletenes.KnowledgeOwner=View_WorkPackageBacklogDetail.KnowledgeOwner AND
         WorkProcedureCompletenes.WorkProcedure=Fact_WorkPackageDetail.WorkProcedure
    LEFT JOIN (
                SELECT Predecessor.ProjectID ProjectID,Predecessor.KnowledgeOwner KnowledgeOwner,Predecessor.WorkPackageID WorkPackageID,sum(RemainingQty) SuccessorWork
                FROM (
                       SELECT ProjectID,KnowledgeOwner,WorkPackageID,SuccessorWorkPackageID
                       FROM View_WorkPackageBacklog
                         INNER JOIN Fact_WorkPackageDependency
                           ON View_WorkPackageBacklog.WorkPackageID=Fact_WorkPackageDependency.PredecessorWorkPackageID
                     )Predecessor
                  INNER JOIN (
                               SELECT *
                               FROM Log_WorkPackage
                               GROUP BY ProjectID,KnowledgeOwner,WorkPackageID
                             )WorkPackageLatest
                    ON Predecessor.SuccessorWorkPackageID=WorkPackageLatest.WorkPackageID AND
                       Predecessor.ProjectID=WorkPackageLatest.ProjectID AND
                       Predecessor.KnowledgeOwner=WorkPackageLatest.KnowledgeOwner
                GROUP BY Predecessor.ProjectID,Predecessor.KnowledgeOwner,Predecessor.WorkPackageID
              )SuccessorWork
      ON SuccessorWork.ProjectID=View_WorkPackageBacklogDetail.ProjectID AND
         SuccessorWork.KnowledgeOwner=View_WorkPackageBacklogDetail.KnowledgeOwner AND
         SuccessorWork.WorkPackageID=View_WorkPackageBacklogDetail.WorkPackageID
  ORDER BY ProjectID,KnowledgeOwner,SubName,WorkPackageCompleteness,Priority,FloorCompleteness,SuccessorWorkContribution,SuccessorWork,FloorTotalWork DESC ,WorkProcedureCompleteness,ProductionRate,Ran;

Drop VIEW IF EXISTS View_WorkPackageSelectedRandom;
CREATE VIEW IF NOT EXISTS View_WorkPackageSelectedRandom AS
SELECT Backlog.KnowledgeOwner,Backlog.ProjectID,Backlog.SubName,Backlog.WorkPackageID,Fact_WorkPackageDetail.Floor,Fact_WorkPackageDetail.Workprocedure,Backlog.RemainingQty,Backlog.TotalQty,ProductionRate,PerformanceStd
FROM (
  SELECT *
  FROM View_WorkPackageBacklog
  WHERE KnowledgeOwner=SubName
  GROUP BY ProjectID,KnowledgeOwner,SubName
)Backlog
LEFT JOIN Fact_WorkPackageDetail
ON Backlog.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID;

DROP VIEW IF EXISTS View_WorkPackageSelected;
CREATE VIEW IF NOT EXISTS View_WorkPackageSelected as
SELECT *
FROM View_WorkPackageBacklogPriority
WHERE KnowledgeOwner=SubName
GROUP BY ProjectID,KnowledgeOwner,SubName;

DROP VIEW IF EXISTS True_WorkPackageBacklog;
CREATE VIEW IF NOT EXISTS True_WorkPackageBacklog as
SELECT *
FROM (
  SELECT Unfinished.ProjectID ProjectID,Unfinished.WorkPackageID WorkPackageID
  FROM(
        SELECT *
        FROM True_WorkPackageLatest
        WHERE RemainingQty>0
      ) Unfinished
    LEFT JOIN Fact_WorkPackageDependency
      ON Unfinished.WorkPackageID=Fact_WorkPackageDependency.SuccessorWorkPackageID
  WHERE PredecessorWorkPackageID ISNULL
  UNION
  SELECT ProjectID,WorkPackageID
  FROM (
    SELECT SuccessorWorkPackage.ProjectID,SuccessorWorkPackage.WorkPackageID,sum(True_WorkPackageLatest.RemainingQty) TotalPredecessorWork
    FROM (
           SELECT True_WorkPackageLatest.*,PredecessorWorkPackageID
           FROM True_WorkPackageLatest
             INNER JOIN Fact_WorkPackageDependency
               ON True_WorkPackageLatest.WorkPackageID=Fact_WorkPackageDependency.SuccessorWorkPackageID
           WHERE RemainingQty>0
         ) SuccessorWorkPackage
      INNER JOIN True_WorkPackageLatest
        ON SuccessorWorkPackage.PredecessorWorkPackageID=True_WorkPackageLatest.WorkPackageID AND
          SuccessorWorkPackage.ProjectID=True_WorkPackageLatest.ProjectID
    GROUP BY SuccessorWorkPackage.ProjectID, SuccessorWorkPackage.WorkPackageID
  )
  WHERE TotalPredecessorWork=0
);

DROP VIEW IF EXISTS True_WorkPackageTrace;
CREATE VIEW IF NOT EXISTS True_WorkPackageTrace as
SELECT Log_WorkPackage.*,KnowledgeOwner SubName,Floor,WorkProcedure
FROM Log_WorkPackage
LEFT JOIN Fact_WorkPackageDetail
  ON Log_WorkPackage.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
WHERE KnowledgeOwner=SubName
GROUP BY Day,Log_WorkPackage.WorkPackageID, ProjectID;

DROP VIEW IF EXISTS True_SubAppearance;
CREATE VIEW IF NOT EXISTS True_SubAppearance as
SELECT *
FROM (
  SELECT SubName,Day,Floor,WorkPackageID, ProjectID,0 Retrace
  FROM True_WorkPackageTrace
  WHERE Day>0
  UNION
  SELECT SubName,Day,Floor,Event_Retrace.WorkPackageID WorkPackageID, ProjectID,1 Retrace
  FROM Event_Retrace
    LEFT JOIN Fact_WorkPackageDetail
    ON Event_Retrace.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
) GROUP BY SubName,Day, ProjectID;

DROP VIEW IF EXISTS True_SubCollision;
CREATE VIEW IF NOT EXISTS True_SubCollision as
SELECT True_SubAppearance.ProjectID ProjectID, True_SubAppearance.SubName SubName,True_SubAppearance.Floor Floor,True_SubAppearance.Day Day
FROM (
  SELECT ProjectID,Day,Floor
  FROM (
    SELECT ProjectID,Day,Floor,count(SubName) co
    FROM True_SubAppearance
    GROUP BY ProjectID,Day,Floor
  )
  WHERE co>1
)Collision
LEFT JOIN True_SubAppearance
ON Collision.ProjectID=True_SubAppearance.ProjectID AND
   Collision.Day=True_SubAppearance.Day AND
   Collision.Floor=True_SubAppearance.Floor;

DROP VIEW IF EXISTS True_ProjectCompleteness;
CREATE VIEW IF NOT EXISTS True_ProjectCompleteness as
SELECT ProjectID, sum(RemainingQty) TRQty, sum(TotalQty) TQty,
  1-sum(RemainingQty)/sum(TotalQty) TotalCompleteness
FROM True_WorkPackageLatest
GROUP BY ProjectID;

DROP VIEW IF EXISTS True_WorkPackageQualityUncheck;
CREATE VIEW IF NOT EXISTS True_WorkPackageQualityUncheck as
SELECT Fact_WorkPackage.WorkPackageID,ID ProjectID
FROM Fact_WorkPackage JOIN Fact_Project
LEFT JOIN (
    SELECT ProjectID,WorkPackageID
    FROM (
      SELECT ProjectID,WorkPackageID,Pass
      FROM Event_QualityCheck
      GROUP BY ProjectID,WorkPackageID
    )
    WHERE Pass>0
    )Passed
ON Fact_WorkPackage.WorkPackageID=Passed.WorkPackageID AND
      Fact_Project.ID=Passed.ProjectID
WHERE Passed.WorkPackageID ISNULL;

DROP VIEW IF EXISTS True_DesignChangeRandom;
CREATE VIEW IF NOT EXISTS True_DesignChangeRandom as
SELECT *
FROM (
  SELECT True_WorkPackageLatest.KnowledgeOwner,True_WorkPackageLatest.Day Day,True_WorkPackageLatest.RemainingQty, True_WorkPackageLatest.ProjectID ProjectID,True_WorkPackageLatest.WorkPackageID WorkPackageID,TotalQty,random()%1000 Ran
  FROM True_WorkPackageQualityUncheck
    LEFT JOIN True_WorkPackageLatest
      ON True_WorkPackageQualityUncheck.ProjectID=True_WorkPackageLatest.ProjectID AND
         True_WorkPackageQualityUncheck.WorkPackageID=True_WorkPackageLatest.WorkPackageID
  ORDER BY ProjectID,Ran
)GROUP BY ProjectID;

DROP VIEW IF EXISTS True_WorkPackageFinishedQualityUncheck;
CREATE VIEW IF NOT EXISTS True_WorkPackageFinishedQualityUncheck AS
SELECT True_WorkPackageLatest.*,1-(1-QualityRate)*(1-WorkProcedureCompleteness) QualityPassRate
FROM True_WorkPackageQualityUncheck
LEFT JOIN True_WorkPackageLatest
ON True_WorkPackageQualityUncheck.ProjectID=True_WorkPackageLatest.ProjectID AND
      True_WorkPackageQualityUncheck.WorkPackageID=True_WorkPackageLatest.WorkPackageID
LEFT JOIN Fact_WorkPackageDetail
  ON True_WorkPackageQualityUncheck.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
LEFT JOIN (
    SELECT ProjectID,WorkProcedure, 1- sum(RemainingQty)/sum(TotalQty) WorkProcedureCompleteness
    FROM True_WorkPackageLatest
      LEFT JOIN Fact_WorkPackageDetail
        ON True_WorkPackageLatest.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
    GROUP BY ProjectID,WorkProcedure
    )Completenes
ON True_WorkPackageQualityUncheck.ProjectID=Completenes.ProjectID
   AND Fact_WorkPackageDetail.WorkProcedure=Completenes.WorkProcedure
WHERE RemainingQty=0;

DROP VIEW IF EXISTS _Result;
CREATE VIEW _Result as
SELECT Floor||'-'||Fact_WorkPackageDetail.WorkProcedure WPName,Activity.Day Day, ifnull(Floor-1+WorkPackageCompleteness,Floor-1) Status,
  SubName,Floor, Fact_WorkPackageDetail.WorkProcedure, Activity.WorkPackageID WorkPackageID,Activity.ProjectID,
  ifnull(abs(Pass-1),0) QualityFail,ProductionRate, CASE WHEN (ProductionRate=0) THEN 1 ELSE 0 END LowProductivity,
  ifnull(Retrace,0) Retrace, CASE WHEN (Event_DesignChange.Day IS NOT NULL ) THEN 1 ELSE 0 END DesignChange,
  CASE WHEN (Event_Meeting.Day IS NOT NULL ) THEN 1 ELSE 0 END Meeting
--   , CASE WHEN Event_DesignChange.Day IS NOT NULL THEN NULL ELSE Floor-1+WorkPackageCompleteness END StatusFiltered
FROM (
  SELECT True_SubAppearance.ProjectID ProjectID,True_SubAppearance.WorkPackageID WorkPackageID,
         True_SubAppearance.Day Day,1-RemainingQty/TotalQty WorkPackageCompleteness,Retrace
  FROM True_SubAppearance
    LEFT JOIN (
                SELECT Log_WorkPackage.ProjectID,Log_WorkPackage.WorkPackageID,RemainingQty,Day,TotalQty,Floor
                FROM Log_WorkPackage
                  LEFT JOIN Fact_WorkPackageDetail
                    ON Log_WorkPackage.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
                WHERE KnowledgeOwner=SubName AND Day>0
                GROUP BY ProjectID,Log_WorkPackage.WorkPackageID,Day
              )Work
      ON True_SubAppearance.ProjectID=Work.ProjectID AND
         True_SubAppearance.WorkPackageID=Work.WorkPackageID AND
         True_SubAppearance.Day=Work.Day
  UNION
  SELECT Begin.*,0 WorkPackageCompleteness,NULL Retrace
  FROM (
         SELECT ProjectID,WorkPackageID,Day-1 Day
         FROM Event_WorkBegin
       ) Begin
    LEFT JOIN True_SubAppearance
      ON Begin.ProjectID=True_SubAppearance.ProjectID AND
         Begin.Day=True_SubAppearance.Day AND
         Begin.WorkPackageID=True_SubAppearance.WorkPackageID
  WHERE True_SubAppearance.Day ISNULL
  )Activity
LEFT JOIN Event_QualityCheck
ON Event_QualityCheck.ProjectID=Activity.ProjectID AND
Event_QualityCheck.WorkPackageID=Activity.WorkPackageID AND
Event_QualityCheck.Day=Activity.Day
LEFT JOIN Event_Meeting
ON Event_Meeting.ProjectID=Activity.ProjectID AND
Event_Meeting.Day=Activity.Day
LEFT JOIN Event_DesignChange
ON Event_DesignChange.ProjectID=Activity.ProjectID AND
Event_DesignChange.WorkPackageID=Activity.WorkPackageID AND
Event_DesignChange.Day=Activity.Day
LEFT JOIN Fact_WorkPackageDetail
ON Activity.WorkPackageID=Fact_WorkPackageDetail.WorkPackageID
LEFT JOIN (
    SELECT ProjectID,Log_ProductionRate.WorkProcedure,ProductionRate
    FROM Log_ProductionRate
      LEFT JOIN Fact_WorkProcedure
      ON Log_ProductionRate.WorkProcedure=Fact_WorkProcedure.WorkProcedure
    WHERE KnowledgeOwner=SubName
    GROUP BY ProjectID,Log_ProductionRate.WorkProcedure
    )Productivity
ON Activity.ProjectID=Productivity.ProjectID AND
Fact_WorkPackageDetail.WorkProcedure=Productivity.WorkProcedure;

COMMIT;