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
SELECT *
FROM (
  SELECT 2,1,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,1
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 7,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,1
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
--   UNION ALL
--   SELECT 0,9,1.0,1,1,0
);

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

DROP TABLE IF EXISTS "Fact_WorkMethod";
CREATE TABLE IF NOT EXISTS "Fact_WorkMethod" (
	`SubName`	TEXT NOT NULL,
	`WorkMethod`	TEXT NOT NULL UNIQUE,
	`InitialProductionRate`	REAL NOT NULL,
	`QualityRate`	REAL NOT NULL,
	`PerformanceStd`	REAL,
	PRIMARY KEY(WorkMethod),
	FOREIGN KEY(`SubName`) REFERENCES Fact_Sub ( SubName )
);
INSERT INTO `Fact_WorkMethod` VALUES ('Gravel','Gravel base layer',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Plumbing','Pipes in the floor',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Electricity','Electric conduits in the floor',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Tiling','Floor tiling',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Partition','Partition phase 1',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Plumbing','Pipes in the wall',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Electricity','Electric conduits in the wall',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Partition','Partition phase 2',1.0,0.9,0.3);
INSERT INTO `Fact_WorkMethod` VALUES ('Tiling','Wall tiling',1.0,0.9,0.3);

DROP TABLE IF EXISTS "Fact_WorkMethodDependency";
CREATE TABLE IF NOT EXISTS "Fact_WorkMethodDependency" (
	`PredecessorWorkMethod`	TEXT NOT NULL,
	`SuccessorWorkMethod`	TEXT NOT NULL,
	FOREIGN KEY(`PredecessorWorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod ),
	FOREIGN KEY(`SuccessorWorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod )
);
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Gravel base layer','Pipes in the floor');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Gravel base layer','Electric conduits in the floor');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Pipes in the floor','Floor tiling');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Electric conduits in the floor','Floor tiling');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Partition phase 1','Pipes in the wall');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Partition phase 1','Electric conduits in the wall');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Pipes in the wall','Partition phase 2');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Electric conduits in the wall','Partition phase 2');
INSERT INTO `Fact_WorkMethodDependency` VALUES ('Partition phase 2','Wall tiling');

DROP TABLE IF EXISTS "Fact_Task";
CREATE TABLE IF NOT EXISTS "Fact_Task" (
	`TaskID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkMethod`	TEXT NOT NULL,
	`Floor`	INTEGER NOT NULL,
	`InitialQty`	REAL NOT NULL,
	FOREIGN KEY(`WorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod ),
	FOREIGN KEY(`Floor`) REFERENCES Fact_WorkSpace ( Floor )
);
INSERT INTO `Fact_Task` VALUES (1,'Gravel base layer',1,5.0);
INSERT INTO `Fact_Task` VALUES (2,'Gravel base layer',2,5.0);
INSERT INTO `Fact_Task` VALUES (3,'Gravel base layer',3,5.0);
INSERT INTO `Fact_Task` VALUES (4,'Gravel base layer',4,5.0);
INSERT INTO `Fact_Task` VALUES (5,'Gravel base layer',5,5.0);
INSERT INTO `Fact_Task` VALUES (6,'Pipes in the floor',1,5.0);
INSERT INTO `Fact_Task` VALUES (7,'Pipes in the floor',2,5.0);
INSERT INTO `Fact_Task` VALUES (8,'Pipes in the floor',3,5.0);
INSERT INTO `Fact_Task` VALUES (9,'Pipes in the floor',4,5.0);
INSERT INTO `Fact_Task` VALUES (10,'Pipes in the floor',5,5.0);
INSERT INTO `Fact_Task` VALUES (11,'Electric conduits in the floor',1,5.0);
INSERT INTO `Fact_Task` VALUES (12,'Electric conduits in the floor',2,5.0);
INSERT INTO `Fact_Task` VALUES (13,'Electric conduits in the floor',3,5.0);
INSERT INTO `Fact_Task` VALUES (14,'Electric conduits in the floor',4,5.0);
INSERT INTO `Fact_Task` VALUES (15,'Electric conduits in the floor',5,5.0);
INSERT INTO `Fact_Task` VALUES (16,'Floor tiling',1,5.0);
INSERT INTO `Fact_Task` VALUES (17,'Floor tiling',2,5.0);
INSERT INTO `Fact_Task` VALUES (18,'Floor tiling',3,5.0);
INSERT INTO `Fact_Task` VALUES (19,'Floor tiling',4,5.0);
INSERT INTO `Fact_Task` VALUES (20,'Floor tiling',5,5.0);
INSERT INTO `Fact_Task` VALUES (21,'Partition phase 1',1,5.0);
INSERT INTO `Fact_Task` VALUES (22,'Partition phase 1',2,5.0);
INSERT INTO `Fact_Task` VALUES (23,'Partition phase 1',3,5.0);
INSERT INTO `Fact_Task` VALUES (24,'Partition phase 1',4,5.0);
INSERT INTO `Fact_Task` VALUES (25,'Partition phase 1',5,5.0);
INSERT INTO `Fact_Task` VALUES (26,'Pipes in the wall',1,5.0);
INSERT INTO `Fact_Task` VALUES (27,'Pipes in the wall',2,5.0);
INSERT INTO `Fact_Task` VALUES (28,'Pipes in the wall',3,5.0);
INSERT INTO `Fact_Task` VALUES (29,'Pipes in the wall',4,5.0);
INSERT INTO `Fact_Task` VALUES (30,'Pipes in the wall',5,5.0);
INSERT INTO `Fact_Task` VALUES (31,'Electric conduits in the wall',1,5.0);
INSERT INTO `Fact_Task` VALUES (32,'Electric conduits in the wall',2,5.0);
INSERT INTO `Fact_Task` VALUES (33,'Electric conduits in the wall',3,5.0);
INSERT INTO `Fact_Task` VALUES (34,'Electric conduits in the wall',4,5.0);
INSERT INTO `Fact_Task` VALUES (35,'Electric conduits in the wall',5,5.0);
INSERT INTO `Fact_Task` VALUES (36,'Partition phase 2',1,5.0);
INSERT INTO `Fact_Task` VALUES (37,'Partition phase 2',2,5.0);
INSERT INTO `Fact_Task` VALUES (38,'Partition phase 2',3,5.0);
INSERT INTO `Fact_Task` VALUES (39,'Partition phase 2',4,5.0);
INSERT INTO `Fact_Task` VALUES (40,'Partition phase 2',5,5.0);
INSERT INTO `Fact_Task` VALUES (41,'Wall tiling',1,5.0);
INSERT INTO `Fact_Task` VALUES (42,'Wall tiling',2,5.0);
INSERT INTO `Fact_Task` VALUES (43,'Wall tiling',3,5.0);
INSERT INTO `Fact_Task` VALUES (44,'Wall tiling',4,5.0);
INSERT INTO `Fact_Task` VALUES (45,'Wall tiling',5,5.0);

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

DROP TABLE IF EXISTS "Log_Task";
CREATE TABLE IF NOT EXISTS "Log_Task" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`KnowledgeOwner`	TEXT NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`TaskID`	INTEGER NOT NULL,
	`RemainingQty`	REAL NOT NULL,
	`TotalQty`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`KnowledgeOwner`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Log_ProductionRate";
CREATE TABLE IF NOT EXISTS "Log_ProductionRate" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`KnowledgeOwner`	TEXT NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`WorkMethod`	TEXT NOT NULL,
	`ProductionRate`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`KnowledgeOwner`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`WorkMethod`) REFERENCES Fact_Sub ( SubName ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_Retrace";
CREATE TABLE IF NOT EXISTS "Event_Retrace" (
	`Day`	INTEGER NOT NULL,
	`TaskID`	INTEGER NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_QualityCheck";
CREATE TABLE IF NOT EXISTS "Event_QualityCheck" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`TaskID`	INTEGER NOT NULL,
	`Pass`	INTEGER NOT NULL DEFAULT 1,
	`ProjectID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
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
	`TaskID`	INTEGER NOT NULL,
	`TotalQty`	REAL NOT NULL DEFAULT 0,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_WorkBegin";
CREATE TABLE IF NOT EXISTS "Event_WorkBegin" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`TaskID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

-- UPDATE Fact_Project SET Done=0;
-- DELETE FROM Fact_Project WHERE ID>58;
delete from Event_DesignChange where ProjectID not in (select ID from Fact_Project where Done=1);
delete from Event_Meeting where ProjectID NOT in (select ID from Fact_Project where Done=1);
delete from Event_QualityCheck where ProjectID NOT in (select ID from Fact_Project where Done=1);
delete from Event_Retrace where ProjectID not in (select ID from Fact_Project where Done=1);
delete from Event_WorkBegin where ProjectID NOT in (select ID from Fact_Project where Done=1);

delete from Log_ProductionRate where ProjectID NOT in (select ID from Fact_Project where Done=1);
delete from Log_Task where ProjectID NOT in (select ID from Fact_Project where Done=1);
delete from Log_WorkSpacePriority where ProjectID NOT in (select ID from Fact_Project where Done=1);

insert into Log_ProductionRate (KnowledgeOwner,ProductionRate,WorkMethod, ProjectID)
select A.SubName KnowledgeOwner, InitialProductionRate ProductionRate, WorkMethod, C.ID ProjectID from Fact_Sub A join Fact_WorkMethod B join Fact_Project C where C.Done=0;

insert into Log_Task (KnowledgeOwner,TaskID,RemainingQty, TotalQty, ProjectID)
select B.SubName KnowledgeOwner, TaskID, InitialQty RemainingQty, InitialQty TotalQty, C.ID ProjectID from Fact_Task A join Fact_Sub B join Fact_Project C where C.Done=0;

insert into Log_WorkSpacePriority (KnowledgeOwner,Floor,Priority,SubName,ProjectID)
select A.SubName KnowledgeOwner, B.Floor, B.InitialPriority Priority, C.SubName SubName, D.ID ProjectID from Fact_Sub A join Fact_WorkSpace B join Fact_Sub C join Fact_Project D where D.Done=0;



------------------------------------------------------------------------------------------------------------------------------

DROP VIEW IF EXISTS Fact_TaskDetail;
CREATE VIEW IF NOT EXISTS Fact_TaskDetail as
  SELECT TaskID,Floor,Fact_WorkMethod.*
  FROM Fact_Task
  LEFT JOIN Fact_WorkMethod
  ON Fact_WorkMethod.WorkMethod = Fact_Task.WorkMethod;

DROP VIEW IF EXISTS True_TaskLatest;
CREATE VIEW IF NOT EXISTS True_TaskLatest as
SELECT Latest.*,Floor
FROM (
  SELECT KnowledgeOwner,Day,TaskID,RemainingQty,TotalQty,ProjectID,SubName
  FROM (
    SELECT Log_Task.*,WorkMethod,SubName
    FROM Log_Task
      LEFT JOIN Fact_TaskDetail
        ON Log_Task.TaskID=Fact_TaskDetail.TaskID
    WHERE KnowledgeOwner=SubName
    ORDER BY ProjectID,KnowledgeOwner,TaskID,ID
  )
  GROUP BY ProjectID,KnowledgeOwner,TaskID
)Latest
LEFT JOIN Fact_Task
ON Latest.TaskID=Fact_Task.TaskID;

DROP VIEW IF EXISTS True_ProductionRateLatest;
CREATE VIEW IF NOT EXISTS True_ProductionRateLatest as
SELECT KnowledgeOwner,Day,WorkMethod,ProductionRate,ProjectID,SubName
FROM (
  SELECT Log_ProductionRate.*,SubName
  FROM Log_ProductionRate
  LEFT JOIN Fact_WorkMethod
  ON Fact_WorkMethod.WorkMethod=Log_ProductionRate.WorkMethod
  WHERE KnowledgeOwner=SubName AND ProductionRate>0
  ORDER BY ProjectID,KnowledgeOwner,WorkMethod,ID
)
GROUP BY ProjectID,KnowledgeOwner,WorkMethod;

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

DROP VIEW IF EXISTS Fact_TaskDependency;
CREATE VIEW IF NOT EXISTS Fact_TaskDependency as
SELECT PredecessorTaskID,Fact_Task.TaskID SuccessorTaskID
FROM (
  SELECT Fact_Task.TaskID PredecessorTaskID,Floor,SuccessorWorkMethod
  FROM Fact_Task
    INNER JOIN Fact_WorkMethodDependency
  ON Fact_Task.WorkMethod=Fact_WorkMethodDependency.PredecessorWorkMethod
) PredecessorTask
INNER JOIN Fact_Task
ON PredecessorTask.Floor=Fact_Task.Floor AND PredecessorTask.SuccessorWorkMethod=Fact_Task.WorkMethod
ORDER BY PredecessorTaskID,SuccessorTaskID;

DROP VIEW IF EXISTS View_TaskLatest;
CREATE VIEW IF NOT EXISTS View_TaskLatest as
SELECT *
FROM (
  SELECT *
  FROM Log_Task
  ORDER BY ProjectID,KnowledgeOwner,TaskID,ID
)
GROUP BY ProjectID,KnowledgeOwner,TaskID;

DROP VIEW IF EXISTS View_SubAppearanceLatest;
CREATE VIEW IF NOT EXISTS View_SubAppearanceLatest as
SELECT ProjectID, KnowledgeOwner, SubName,Floor
FROM (
  SELECT ProjectID,KnowledgeOwner,SubName,Day,Log_Task.TaskID, Floor
  FROM Log_Task
    LEFT JOIN Fact_TaskDetail
    ON Log_Task.TaskID=Fact_TaskDetail.TaskID
  WHERE Day>0
  ORDER BY ProjectID, KnowledgeOwner, SubName,Day
) GROUP BY ProjectID, KnowledgeOwner, SubName;

DROP VIEW IF EXISTS View_TaskBacklog;
CREATE VIEW IF NOT EXISTS View_TaskBacklog as
SELECT BacklogDetail.*,1-RemainingQty/TotalQty TaskCompleteness,View_SubAppearanceLatest.Floor LastFloor, Priority,ProductionRate, random()%1000 Ran
FROM (
       SELECT Backlog.*,SubName,Floor,WorkMethod
       FROM (
              SELECT Unfinished.ProjectID ProjectID, Unfinished.KnowledgeOwner KnowledgeOwner,Unfinished.Day Day,Unfinished.TaskID TaskID,Unfinished.RemainingQty RemainingQty,Unfinished.TotalQty TotalQty
              FROM (
                     SELECT View_TaskLatest.*
                     FROM View_TaskLatest
                       INNER JOIN (
                                    SELECT DISTINCT KnowledgeOwner,ProjectID
                                    FROM True_TaskLatest
                                    WHERE RemainingQty>0
                                  )UnfinishedSub
                         ON View_TaskLatest.ProjectID=UnfinishedSub.ProjectID AND
                            View_TaskLatest.KnowledgeOwner=UnfinishedSub.KnowledgeOwner
                     WHERE RemainingQty>0
                   ) Unfinished
                LEFT JOIN Fact_TaskDependency
                  ON Unfinished.TaskID=Fact_TaskDependency.SuccessorTaskID
              WHERE PredecessorTaskID ISNULL
              UNION
              SELECT ProjectID,KnowledgeOwner,Day,TaskID,RemainingQty,TotalQty
              FROM (
                SELECT SuccessorTask.ProjectID ProjectID,SuccessorTask.KnowledgeOwner KnowledgeOwner,SuccessorTask.Day Day,SuccessorTask.TaskID TaskID,SuccessorTask.RemainingQty RemainingQty,SuccessorTask.TotalQty TotalQty, sum(View_TaskLatest.RemainingQty) PredecessorWork
                FROM (
                       SELECT View_TaskLatest.*,PredecessorTaskID
                       FROM View_TaskLatest
                         INNER JOIN Fact_TaskDependency
                           ON View_TaskLatest.TaskID=Fact_TaskDependency.SuccessorTaskID
                         INNER JOIN (
                                      SELECT DISTINCT KnowledgeOwner,ProjectID
                                      FROM True_TaskLatest
                                      WHERE RemainingQty>0
                                    )UnfinishedSub
                           ON View_TaskLatest.ProjectID=UnfinishedSub.ProjectID AND
                              View_TaskLatest.KnowledgeOwner=UnfinishedSub.KnowledgeOwner
                       WHERE RemainingQty>0
                     ) SuccessorTask
                  INNER JOIN View_TaskLatest
                    ON SuccessorTask.PredecessorTaskID=View_TaskLatest.TaskID AND
                       SuccessorTask.KnowledgeOwner=View_TaskLatest.KnowledgeOwner AND
                       SuccessorTask.ProjectID=View_TaskLatest.ProjectID
                GROUP BY SuccessorTask.ProjectID,SuccessorTask.KnowledgeOwner,SuccessorTask.TaskID
              )
              WHERE PredecessorWork=0
            ) Backlog
         LEFT JOIN Fact_TaskDetail
           ON Backlog.TaskID=Fact_TaskDetail.TaskID
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
              GROUP BY ProjectID,KnowledgeOwner,WorkMethod
            )Productivity
    ON BacklogDetail.ProjectID=Productivity.ProjectID AND
       BacklogDetail.WorkMethod=Productivity.WorkMethod AND
       BacklogDetail.KnowledgeOwner=Productivity.KnowledgeOwner
  LEFT JOIN View_SubAppearanceLatest
  ON BacklogDetail.ProjectID=View_SubAppearanceLatest.ProjectID AND
     BacklogDetail.KnowledgeOwner=View_SubAppearanceLatest.KnowledgeOwner AND
      BacklogDetail.SubName=View_SubAppearanceLatest.SubName
ORDER BY ProjectID,KnowledgeOwner,SubName, TaskCompleteness, Priority, Ran;

DROP VIEW IF EXISTS View_TaskBacklogPriority;
CREATE VIEW IF NOT EXISTS View_TaskBacklogPriority as
SELECT View_TaskBacklogDetail.*, PerformanceStd, FloorCompleteness,WorkMethodCompleteness,SuccessorWork, FloorTotalWork,RemainingQty/FloorTotalWork SignificanceToFloor, SuccessorWork/FloorTotalWork SuccessorWorkContribution
FROM View_TaskBacklog View_TaskBacklogDetail
    LEFT JOIN Fact_TaskDetail
      ON View_TaskBacklogDetail.TaskID=Fact_TaskDetail.TaskID
    LEFT JOIN (
                SELECT ProjectID,KnowledgeOwner,Floor,1-sum(RemainingQty)/sum(TotalQty) FloorCompleteness, sum(TotalQty) FloorTotalWork
                FROM View_TaskLatest
                  LEFT JOIN Fact_TaskDetail
                    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
                GROUP BY ProjectID,KnowledgeOwner,Floor
              ) FloorCompleteness
      ON FloorCompleteness.ProjectID=View_TaskBacklogDetail.ProjectID AND
         FloorCompleteness.KnowledgeOwner=View_TaskBacklogDetail.KnowledgeOwner AND
         FloorCompleteness.Floor=View_TaskBacklogDetail.Floor
    LEFT JOIN (
                SELECT ProjectID,KnowledgeOwner,WorkMethod,1-sum(RemainingQty)/sum(TotalQty) WorkMethodCompleteness
                FROM View_TaskLatest
                  LEFT JOIN Fact_TaskDetail
                    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
                GROUP BY ProjectID,KnowledgeOwner,WorkMethod
              ) WorkMethodCompletenes
      ON WorkMethodCompletenes.ProjectID=View_TaskBacklogDetail.ProjectID AND
         WorkMethodCompletenes.KnowledgeOwner=View_TaskBacklogDetail.KnowledgeOwner AND
         WorkMethodCompletenes.WorkMethod=Fact_TaskDetail.WorkMethod
    LEFT JOIN (
                SELECT Predecessor.ProjectID ProjectID,Predecessor.KnowledgeOwner KnowledgeOwner,Predecessor.TaskID TaskID,sum(RemainingQty) SuccessorWork
                FROM (
                       SELECT ProjectID,KnowledgeOwner,TaskID,SuccessorTaskID
                       FROM View_TaskBacklog
                         INNER JOIN Fact_TaskDependency
                           ON View_TaskBacklog.TaskID=Fact_TaskDependency.PredecessorTaskID
                     )Predecessor
                  INNER JOIN (
                               SELECT *
                               FROM Log_Task
                               GROUP BY ProjectID,KnowledgeOwner,TaskID
                             )TaskLatest
                    ON Predecessor.SuccessorTaskID=TaskLatest.TaskID AND
                       Predecessor.ProjectID=TaskLatest.ProjectID AND
                       Predecessor.KnowledgeOwner=TaskLatest.KnowledgeOwner
                GROUP BY Predecessor.ProjectID,Predecessor.KnowledgeOwner,Predecessor.TaskID
              )SuccessorWork
      ON SuccessorWork.ProjectID=View_TaskBacklogDetail.ProjectID AND
         SuccessorWork.KnowledgeOwner=View_TaskBacklogDetail.KnowledgeOwner AND
         SuccessorWork.TaskID=View_TaskBacklogDetail.TaskID
  ORDER BY ProjectID,KnowledgeOwner,SubName,TaskCompleteness,Priority,FloorCompleteness,SuccessorWorkContribution,SuccessorWork,FloorTotalWork DESC ,WorkMethodCompleteness,ProductionRate,Ran;

Drop VIEW IF EXISTS View_TaskSelectedRandom;
CREATE VIEW IF NOT EXISTS View_TaskSelectedRandom AS
SELECT Backlog.KnowledgeOwner,Backlog.ProjectID,Backlog.SubName,Backlog.TaskID,Fact_TaskDetail.Floor,Fact_TaskDetail.WorkMethod,Backlog.RemainingQty,Backlog.TotalQty,ProductionRate,PerformanceStd
FROM (
  SELECT *
  FROM View_TaskBacklog
  WHERE KnowledgeOwner=SubName
  GROUP BY ProjectID,KnowledgeOwner,SubName
)Backlog
LEFT JOIN Fact_TaskDetail
ON Backlog.TaskID=Fact_TaskDetail.TaskID;

DROP VIEW IF EXISTS View_TaskSelected;
CREATE VIEW IF NOT EXISTS View_TaskSelected as
SELECT *
FROM View_TaskBacklogPriority
WHERE View_TaskBacklogPriority.KnowledgeOwner=View_TaskBacklogPriority.SubName
GROUP BY View_TaskBacklogPriority.ProjectID,View_TaskBacklogPriority.KnowledgeOwner,View_TaskBacklogPriority.SubName;

DROP VIEW IF EXISTS True_TaskBacklog;
CREATE VIEW IF NOT EXISTS True_TaskBacklog as
SELECT *
FROM (
  SELECT Unfinished.ProjectID ProjectID,Unfinished.TaskID TaskID
  FROM(
        SELECT *
        FROM True_TaskLatest
        WHERE RemainingQty>0
      ) Unfinished
    LEFT JOIN Fact_TaskDependency
      ON Unfinished.TaskID=Fact_TaskDependency.SuccessorTaskID
  WHERE PredecessorTaskID ISNULL
  UNION
  SELECT ProjectID,TaskID
  FROM (
    SELECT SuccessorTask.ProjectID,SuccessorTask.TaskID,sum(True_TaskLatest.RemainingQty) TotalPredecessorWork
    FROM (
           SELECT True_TaskLatest.*,PredecessorTaskID
           FROM True_TaskLatest
             INNER JOIN Fact_TaskDependency
               ON True_TaskLatest.TaskID=Fact_TaskDependency.SuccessorTaskID
           WHERE RemainingQty>0
         ) SuccessorTask
      INNER JOIN True_TaskLatest
        ON SuccessorTask.PredecessorTaskID=True_TaskLatest.TaskID AND
          SuccessorTask.ProjectID=True_TaskLatest.ProjectID
    GROUP BY SuccessorTask.ProjectID, SuccessorTask.TaskID
  )
  WHERE TotalPredecessorWork=0
);

DROP VIEW IF EXISTS True_TaskTrace;
CREATE VIEW IF NOT EXISTS True_TaskTrace as
SELECT Log_Task.*,KnowledgeOwner SubName,Floor,WorkMethod
FROM Log_Task
LEFT JOIN Fact_TaskDetail
  ON Log_Task.TaskID=Fact_TaskDetail.TaskID
WHERE KnowledgeOwner=SubName
GROUP BY Day,Log_Task.TaskID, ProjectID;

DROP VIEW IF EXISTS True_SubAppearance;
CREATE VIEW IF NOT EXISTS True_SubAppearance as
SELECT *
FROM (
  SELECT SubName,Day,Floor,TaskID, ProjectID,0 Retrace
  FROM True_TaskTrace
  WHERE Day>0
  UNION
  SELECT SubName,Day,Floor,Event_Retrace.TaskID TaskID, ProjectID,1 Retrace
  FROM Event_Retrace
    LEFT JOIN Fact_TaskDetail
    ON Event_Retrace.TaskID=Fact_TaskDetail.TaskID
) GROUP BY SubName,Day, ProjectID;

DROP VIEW IF EXISTS True_SubCollision;
CREATE VIEW IF NOT EXISTS True_SubCollision as
SELECT True_SubAppearance.ProjectID ProjectID, True_SubAppearance.SubName SubName,True_SubAppearance.Floor Floor,True_SubAppearance.Day Day,Collision
FROM (
  SELECT ProjectID,Day,Floor,Collision
  FROM (
    SELECT ProjectID,Day,Floor,count(SubName) Collision
    FROM True_SubAppearance
    GROUP BY ProjectID,Day,Floor
  )
  WHERE Collision>1
)Collision
LEFT JOIN True_SubAppearance
ON Collision.ProjectID=True_SubAppearance.ProjectID AND
   Collision.Day=True_SubAppearance.Day AND
   Collision.Floor=True_SubAppearance.Floor;

DROP VIEW IF EXISTS True_ProjectCompleteness;
CREATE VIEW IF NOT EXISTS True_ProjectCompleteness as
SELECT ProjectID, sum(RemainingQty) TRQty, sum(TotalQty) TQty,
  1-sum(RemainingQty)/sum(TotalQty) TotalCompleteness
FROM True_TaskLatest
GROUP BY ProjectID;

DROP VIEW IF EXISTS True_TaskQualityUncheck;
CREATE VIEW IF NOT EXISTS True_TaskQualityUncheck as
SELECT Fact_Task.TaskID,ID ProjectID
FROM Fact_Task JOIN Fact_Project
LEFT JOIN (
    SELECT ProjectID,TaskID
    FROM (
      SELECT ProjectID,TaskID,Pass
      FROM Event_QualityCheck
      GROUP BY ProjectID,TaskID
    )
    WHERE Pass>0
    )Passed
ON Fact_Task.TaskID=Passed.TaskID AND
      Fact_Project.ID=Passed.ProjectID
WHERE Passed.TaskID ISNULL;

DROP VIEW IF EXISTS True_DesignChangeRandom;
CREATE VIEW IF NOT EXISTS True_DesignChangeRandom as
SELECT *
FROM (
  SELECT True_TaskLatest.KnowledgeOwner,True_TaskLatest.Day Day,True_TaskLatest.RemainingQty, True_TaskLatest.ProjectID ProjectID,True_TaskLatest.TaskID TaskID,TotalQty,random()%1000 Ran
  FROM True_TaskQualityUncheck
    LEFT JOIN True_TaskLatest
      ON True_TaskQualityUncheck.ProjectID=True_TaskLatest.ProjectID AND
         True_TaskQualityUncheck.TaskID=True_TaskLatest.TaskID
  ORDER BY ProjectID,Ran
)GROUP BY ProjectID;

DROP VIEW IF EXISTS True_TaskFinishedQualityUncheck;
CREATE VIEW IF NOT EXISTS True_TaskFinishedQualityUncheck AS
SELECT True_TaskLatest.*,1-(1-QualityRate)*(1-WorkMethodCompleteness) QualityPassRate
FROM True_TaskQualityUncheck
LEFT JOIN True_TaskLatest
ON True_TaskQualityUncheck.ProjectID=True_TaskLatest.ProjectID AND
      True_TaskQualityUncheck.TaskID=True_TaskLatest.TaskID
LEFT JOIN Fact_TaskDetail
  ON True_TaskQualityUncheck.TaskID=Fact_TaskDetail.TaskID
LEFT JOIN (
    SELECT ProjectID,WorkMethod, 1- sum(RemainingQty)/sum(TotalQty) WorkMethodCompleteness
    FROM True_TaskLatest
      LEFT JOIN Fact_TaskDetail
        ON True_TaskLatest.TaskID=Fact_TaskDetail.TaskID
    GROUP BY ProjectID,WorkMethod
    )Completenes
ON True_TaskQualityUncheck.ProjectID=Completenes.ProjectID
   AND Fact_TaskDetail.WorkMethod=Completenes.WorkMethod
WHERE RemainingQty=0;

DROP VIEW IF EXISTS _Result;
CREATE VIEW IF NOT EXISTS _Result as
SELECT Fact_TaskDetail.Floor||'-'||Fact_TaskDetail.WorkMethod WPName,Activity.Day Day, ifnull(Fact_TaskDetail.Floor-1+TaskCompleteness,Fact_TaskDetail.Floor-1) Status,
  Fact_TaskDetail.SubName,Fact_TaskDetail.Floor, Fact_TaskDetail.WorkMethod, Activity.TaskID TaskID,Activity.ProjectID,
  ifnull(abs(Pass-1),0) QualityFail,ProductionRate, CASE WHEN (ProductionRate=0) THEN 1 ELSE 0 END LowProductivity,
  ifnull(Retrace,0) Retrace, CASE WHEN (Event_DesignChange.Day IS NOT NULL ) THEN 1 ELSE 0 END DesignChange,
  CASE WHEN (Event_Meeting.Day IS NOT NULL ) THEN 1 ELSE 0 END Meeting,ifnull(Collision,1) Collision
--   , CASE WHEN Event_DesignChange.Day IS NOT NULL THEN NULL ELSE Floor-1+TaskCompleteness END StatusFiltered
FROM (
  SELECT True_SubAppearance.ProjectID ProjectID,True_SubAppearance.TaskID TaskID,
         True_SubAppearance.Day Day,1-RemainingQty/TotalQty TaskCompleteness,Retrace
  FROM True_SubAppearance
    LEFT JOIN (
                SELECT Log_Task.ProjectID,Log_Task.TaskID,RemainingQty,Day,TotalQty,Floor
                FROM Log_Task
                  LEFT JOIN Fact_TaskDetail
                    ON Log_Task.TaskID=Fact_TaskDetail.TaskID
                WHERE KnowledgeOwner=SubName AND Day>0
                GROUP BY ProjectID,Log_Task.TaskID,Day
              )Work
      ON True_SubAppearance.ProjectID=Work.ProjectID AND
         True_SubAppearance.TaskID=Work.TaskID AND
         True_SubAppearance.Day=Work.Day
  UNION
  SELECT Begin.*,0 TaskCompleteness,NULL Retrace
  FROM (
         SELECT ProjectID,TaskID,Day-1 Day
         FROM Event_WorkBegin
       ) Begin
    LEFT JOIN True_SubAppearance
      ON Begin.ProjectID=True_SubAppearance.ProjectID AND
         Begin.Day=True_SubAppearance.Day AND
         Begin.TaskID=True_SubAppearance.TaskID
  WHERE True_SubAppearance.Day ISNULL
  )Activity
LEFT JOIN Event_QualityCheck
ON Event_QualityCheck.ProjectID=Activity.ProjectID AND
Event_QualityCheck.TaskID=Activity.TaskID AND
Event_QualityCheck.Day=Activity.Day
LEFT JOIN Event_Meeting
ON Event_Meeting.ProjectID=Activity.ProjectID AND
Event_Meeting.Day=Activity.Day
LEFT JOIN Event_DesignChange
ON Event_DesignChange.ProjectID=Activity.ProjectID AND
Event_DesignChange.TaskID=Activity.TaskID AND
Event_DesignChange.Day=Activity.Day
LEFT JOIN Fact_TaskDetail
ON Activity.TaskID=Fact_TaskDetail.TaskID
LEFT JOIN (
    SELECT ProjectID,Log_ProductionRate.WorkMethod,ProductionRate,Day
    FROM Log_ProductionRate
      LEFT JOIN Fact_WorkMethod
      ON Log_ProductionRate.WorkMethod=Fact_WorkMethod.WorkMethod
    WHERE KnowledgeOwner=SubName AND Day>0
    GROUP BY ProjectID,Log_ProductionRate.WorkMethod,Day
    )Productivity
ON Activity.ProjectID=Productivity.ProjectID AND
Fact_TaskDetail.WorkMethod=Productivity.WorkMethod AND
Productivity.Day=Activity.Day
LEFT JOIN True_SubCollision
ON True_SubCollision.ProjectID=Activity.ProjectID AND
True_SubCollision.Day=Activity.Day AND
True_SubCollision.SubName=Fact_TaskDetail.SubName;

DROP VIEW IF EXISTS Result_WaitingDays;
CREATE VIEW IF NOT EXISTS Result_WaitingDays AS
SELECT Start.*,EndDay,EndDay-StartDay-WorkDays+1 WaitingDays,WorkDays
FROM (
  SELECT ProjectID,SubName,Day StartDay
  FROM (
    SELECT *
    FROM Event_WorkBegin
      LEFT JOIN Fact_TaskDetail
        ON Event_WorkBegin.TaskID=Fact_TaskDetail.TaskID
    ORDER BY ProjectID,SubName,Day DESC
  )
  GROUP BY ProjectID,SubName
)Start
LEFT JOIN (
    SELECT ProjectID,SubName,Day EndDay
    FROM (
      SELECT *
      FROM True_TaskLatest
      ORDER BY ProjectID,SubName,Day
    )
    GROUP BY ProjectID,SubName
    )End
ON Start.ProjectID=End.ProjectID and Start.SubName=End.SubName
LEFT JOIN (
    SELECT ProjectID,SubName, count(Day) WorkDays
    FROM True_TaskTrace
    WHERE RemainingQty<>TotalQty
    GROUP BY ProjectID,SubName
    )Work
ON Start.ProjectID=Work.ProjectID AND Start.SubName=Work.SubName AND End.ProjectID=Work.ProjectID AND End.SubName=Work.SubName;

COMMIT;