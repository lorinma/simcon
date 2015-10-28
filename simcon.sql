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
                            QualityCheck,TaskSelectionFunction) SELECT * FROM (
    SELECT 1,10,1.0,1.0,0,1
    UNION ALL
    SELECT 10,10,1.0,1.0,0,1
    UNION ALL
    SELECT 0,10,1.0,1.0,0,1
);

DROP TABLE IF EXISTS "Fact_Sub";
CREATE TABLE IF NOT EXISTS "Fact_Sub" (
	`SubName`	TEXT NOT NULL UNIQUE,
	PRIMARY KEY(SubName)
);
INSERT INTO 'Fact_Sub' (SubName) SELECT * FROM (
  SELECT 'Electricity'
  UNION ALL
  SELECT 'Gravel'
  UNION ALL
  SELECT 'Partition'
  UNION ALL
  SELECT 'Plumbing'
  UNION ALL
  SELECT 'Tiling'
);

DROP TABLE IF EXISTS "Fact_WorkSpace";
CREATE TABLE IF NOT EXISTS "Fact_WorkSpace" (
	`Floor`	INTEGER NOT NULL UNIQUE,
	`InitialPriority`	REAL NOT NULL,
	PRIMARY KEY(Floor)
);
INSERT INTO  'Fact_WorkSpace' (Floor, InitialPriority) SELECT * FROM (
  SELECT
    1,
    5.0
  UNION ALL
  SELECT
    2,
    4.0
  UNION ALL
  SELECT
    3,
    3.0
  UNION ALL
  SELECT
    4,
    1.0
  UNION ALL
  SELECT
    5,
    1.0
);

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
INSERT INTO `Fact_WorkMethod` (SubName, WorkMethod, InitialProductionRate, QualityRate, PerformanceStd) SELECT * FROM (
  SELECT
    'Gravel',
    'Gravel base layer',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Plumbing',
    'Pipes in the floor',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Electricity',
    'Electric conduits in the floor',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Tiling',
    'Floor tiling',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Partition',
    'Partition phase 1',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Plumbing',
    'Pipes in the wall',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Partition',
    'Partition phase 2',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Electricity',
    'Electric conduits in the wall',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Partition',
    'Partition phase 3',
    1.0,
    1.0,
    0.3
  UNION ALL
  SELECT
    'Tiling',
    'Wall tiling',
    1.0,
    1.0,
    0.3
);

DROP TABLE IF EXISTS "Fact_WorkMethodDependency";
CREATE TABLE IF NOT EXISTS "Fact_WorkMethodDependency" (
	`PredecessorWorkMethod`	TEXT NOT NULL,
	`SuccessorWorkMethod`	TEXT NOT NULL,
	FOREIGN KEY(`PredecessorWorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod ),
	FOREIGN KEY(`SuccessorWorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod )
);
INSERT INTO `Fact_WorkMethodDependency` (PredecessorWorkMethod, SuccessorWorkMethod) SELECT * FROM (
  SELECT
    'Gravel base layer',
    'Pipes in the floor'
  UNION ALL
  SELECT
    'Gravel base layer',
    'Electric conduits in the floor'
  UNION ALL
  SELECT
    'Pipes in the floor',
    'Floor tiling'
  UNION ALL
  SELECT
    'Electric conduits in the floor',
    'Floor tiling'
  UNION ALL
  SELECT
    'Partition phase 1',
    'Pipes in the wall'
  UNION ALL
  SELECT
    'Pipes in the wall',
    'Partition phase 2'
  UNION ALL
  SELECT
    'Partition phase 2',
    'Electric conduits in the wall'
  UNION ALL
  SELECT
    'Electric conduits in the wall',
    'Partition phase 3'
  UNION ALL
  SELECT
    'Partition phase 3',
    'Wall tiling'
);

DROP TABLE IF EXISTS "Fact_Task";
CREATE TABLE IF NOT EXISTS "Fact_Task" (
	`TaskID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkMethod`	TEXT NOT NULL,
	`Floor`	INTEGER NOT NULL,
	`InitialQty`	REAL NOT NULL,
	FOREIGN KEY(`WorkMethod`) REFERENCES Fact_WorkMethod ( WorkMethod ),
	FOREIGN KEY(`Floor`) REFERENCES Fact_WorkSpace ( Floor )
);
INSERT INTO `Fact_Task` (TaskID, WorkMethod, Floor, InitialQty) SELECT * FROM (
  SELECT
    1,
    'Gravel base layer',
    1,
    5.0
  UNION ALL
  SELECT
    2,
    'Gravel base layer',
    2,
    5.0
  UNION ALL
  SELECT
    3,
    'Gravel base layer',
    3,
    5.0
  UNION ALL
  SELECT
    4,
    'Gravel base layer',
    4,
    5.0
  UNION ALL
  SELECT
    5,
    'Gravel base layer',
    5,
    5.0
  UNION ALL
  SELECT
    6,
    'Pipes in the floor',
    1,
    5.0
  UNION ALL
  SELECT
    7,
    'Pipes in the floor',
    2,
    5.0
  UNION ALL
  SELECT
    8,
    'Pipes in the floor',
    3,
    5.0
  UNION ALL
  SELECT
    9,
    'Pipes in the floor',
    4,
    5.0
  UNION ALL
  SELECT
    10,
    'Pipes in the floor',
    5,
    5.0
  UNION ALL
  SELECT
    11,
    'Electric conduits in the floor',
    1,
    5.0
  UNION ALL
  SELECT
    12,
    'Electric conduits in the floor',
    2,
    5.0
  UNION ALL
  SELECT
    13,
    'Electric conduits in the floor',
    3,
    5.0
  UNION ALL
  SELECT
    14,
    'Electric conduits in the floor',
    4,
    5.0
  UNION ALL
  SELECT
    15,
    'Electric conduits in the floor',
    5,
    5.0
  UNION ALL
  SELECT
    16,
    'Floor tiling',
    1,
    5.0
  UNION ALL
  SELECT
    17,
    'Floor tiling',
    2,
    5.0
  UNION ALL
  SELECT
    18,
    'Floor tiling',
    3,
    5.0
  UNION ALL
  SELECT
    19,
    'Floor tiling',
    4,
    5.0
  UNION ALL
  SELECT
    20,
    'Floor tiling',
    5,
    5.0
  UNION ALL
  SELECT
    21,
    'Partition phase 1',
    1,
    5.0
  UNION ALL
  SELECT
    22,
    'Partition phase 1',
    2,
    5.0
  UNION ALL
  SELECT
    23,
    'Partition phase 1',
    3,
    5.0
  UNION ALL
  SELECT
    24,
    'Partition phase 1',
    4,
    5.0
  UNION ALL
  SELECT
    25,
    'Partition phase 1',
    5,
    5.0
  UNION ALL
  SELECT
    26,
    'Pipes in the wall',
    1,
    5.0
  UNION ALL
  SELECT
    27,
    'Pipes in the wall',
    2,
    5.0
  UNION ALL
  SELECT
    28,
    'Pipes in the wall',
    3,
    5.0
  UNION ALL
  SELECT
    29,
    'Pipes in the wall',
    4,
    5.0
  UNION ALL
  SELECT
    30,
    'Pipes in the wall',
    5,
    5.0
  UNION ALL
  SELECT
    31,
    'Electric conduits in the wall',
    1,
    5.0
  UNION ALL
  SELECT
    32,
    'Electric conduits in the wall',
    2,
    5.0
  UNION ALL
  SELECT
    33,
    'Electric conduits in the wall',
    3,
    5.0
  UNION ALL
  SELECT
    34,
    'Electric conduits in the wall',
    4,
    5.0
  UNION ALL
  SELECT
    35,
    'Electric conduits in the wall',
    5,
    5.0
  UNION ALL
  SELECT
    36,
    'Partition phase 2',
    1,
    5.0
  UNION ALL
  SELECT
    37,
    'Partition phase 2',
    2,
    5.0
  UNION ALL
  SELECT
    38,
    'Partition phase 2',
    3,
    5.0
  UNION ALL
  SELECT
    39,
    'Partition phase 2',
    4,
    5.0
  UNION ALL
  SELECT
    40,
    'Partition phase 2',
    5,
    5.0
  UNION ALL
  SELECT
    41,
    'Wall tiling',
    1,
    5.0
  UNION ALL
  SELECT
    42,
    'Wall tiling',
    2,
    5.0
  UNION ALL
  SELECT
    43,
    'Wall tiling',
    3,
    5.0
  UNION ALL
  SELECT
    44,
    'Wall tiling',
    4,
    5.0
  UNION ALL
  SELECT
    45,
    'Wall tiling',
    5,
    5.0
  UNION ALL
  SELECT
    46,
    'Partition phase 3',
    1,
    5.0
  UNION ALL
  SELECT
    47,
    'Partition phase 3',
    2,
    5.0
  UNION ALL
  SELECT
    48,
    'Partition phase 3',
    3,
    5.0
  UNION ALL
  SELECT
    49,
    'Partition phase 3',
    4,
    5.0
  UNION ALL
  SELECT
    50,
    'Partition phase 3',
    5,
    5.0
);

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

DROP TABLE IF EXISTS "Log_Manager";
CREATE TABLE IF NOT EXISTS "Log_Manager" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`TaskID`	INTEGER NOT NULL,
	`RemainingQty`	REAL NOT NULL,
	`TotalQty`	REAL NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
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

DROP TABLE IF EXISTS "Event_RetracePredecessor";
CREATE TABLE IF NOT EXISTS "Event_RetracePredecessor" (
	`Day`	INTEGER NOT NULL,
	`TaskID`	INTEGER NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_RetraceWorkSpace";
CREATE TABLE IF NOT EXISTS "Event_RetraceWorkSpace" (
	`Day`	INTEGER NOT NULL,
	`TaskID`	INTEGER NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	FOREIGN KEY(`TaskID`) REFERENCES Fact_Task ( TaskID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

DROP TABLE IF EXISTS "Event_RetraceExternalCondition";
CREATE TABLE IF NOT EXISTS "Event_RetraceExternalCondition" (
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
    ORDER BY ProjectID, KnowledgeOwner, TaskID, ID
  )
  GROUP BY ProjectID,KnowledgeOwner,TaskID;

DROP VIEW IF EXISTS True_TaskLatest;
CREATE VIEW IF NOT EXISTS True_TaskLatest as
  SELECT View_TaskLatest.*,SubName,Floor,WorkMethod
  FROM View_TaskLatest
    LEFT JOIN Fact_TaskDetail
    ON Fact_TaskDetail.TaskID=View_TaskLatest.TaskID
  WHERE View_TaskLatest.KnowledgeOwner = Fact_TaskDetail.SubName;

DROP VIEW IF EXISTS True_ProjectCompleteness;
CREATE VIEW IF NOT EXISTS True_ProjectCompleteness as
  SELECT ProjectID, sum(RemainingQty) TRQty, sum(TotalQty) TQty,
    1-sum(RemainingQty)/sum(TotalQty) ProjectCompleteness
  FROM True_TaskLatest
  GROUP BY ProjectID;

DROP VIEW IF EXISTS View_SubCompleteness;
CREATE VIEW IF NOT EXISTS View_SubCompleteness as
  SELECT ProjectID,KnowledgeOwner,SubName,1-sum(RemainingQty)/sum(TotalQty) SubCompleteness, sum(TotalQty) SubTotalWork
  FROM View_TaskLatest
    LEFT JOIN Fact_TaskDetail
    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
  GROUP BY View_TaskLatest.ProjectID,View_TaskLatest.KnowledgeOwner,Fact_TaskDetail.SubName;

DROP VIEW IF EXISTS True_SubCompleteness;
CREATE VIEW IF NOT EXISTS True_SubCompleteness AS
  SELECT ProjectID,SubName, 1-sum(True_TaskLatest.RemainingQty)/sum(True_TaskLatest.TotalQty) SubCompleteness
  FROM True_TaskLatest
  GROUP BY True_TaskLatest.ProjectID,True_TaskLatest.SubName;

DROP VIEW IF EXISTS Sync_Task;
CREATE VIEW IF NOT EXISTS Sync_Task AS
  SELECT LatestStatus.*, True_SubCompleteness.SubName KnowledgeOwner
  FROM True_SubCompleteness
  LEFT JOIN (
    SELECT True_TaskLatest.ProjectID, True_TaskLatest.TaskID,True_TaskLatest.RemainingQty,True_TaskLatest.TotalQty, True_TaskLatest.SubName
    FROM True_TaskLatest
      INNER JOIN True_ProjectCompleteness
      ON True_ProjectCompleteness.ProjectID=True_TaskLatest.ProjectID
    WHERE True_ProjectCompleteness.ProjectCompleteness<1
    )LatestStatus
    ON True_SubCompleteness.ProjectID=LatestStatus.ProjectID
  WHERE True_SubCompleteness.SubCompleteness<1 AND
        True_SubCompleteness.SubName<>LatestStatus.SubName;

-- only positive production rate is used in work planning
DROP VIEW IF EXISTS View_ProductionRateLatest;
CREATE VIEW IF NOT EXISTS View_ProductionRateLatest as
  SELECT *
  FROM Log_ProductionRate
    WHERE ProductionRate>0
  GROUP BY ProjectID,KnowledgeOwner,WorkMethod;

DROP VIEW IF EXISTS True_ProductionRateLatest;
CREATE VIEW IF NOT EXISTS True_ProductionRateLatest as
  SELECT View_ProductionRateLatest.*,SubName
  FROM View_ProductionRateLatest
    LEFT JOIN Fact_WorkMethod
    ON Fact_WorkMethod.WorkMethod=View_ProductionRateLatest.WorkMethod
  WHERE View_ProductionRateLatest.KnowledgeOwner=Fact_WorkMethod.SubName;

DROP VIEW IF EXISTS Sync_ProductionRate;
CREATE VIEW IF NOT EXISTS Sync_ProductionRate AS
SELECT LatestStatus.*, True_SubCompleteness.SubName KnowledgeOwner
FROM True_SubCompleteness
LEFT JOIN (
    SELECT True_ProductionRateLatest.ProjectID, True_ProductionRateLatest.WorkMethod,True_ProductionRateLatest.SubName,True_ProductionRateLatest.ProductionRate
    FROM True_ProductionRateLatest
      INNER JOIN True_ProjectCompleteness
      ON True_ProjectCompleteness.ProjectID=True_ProductionRateLatest.ProjectID
    WHERE True_ProjectCompleteness.ProjectCompleteness<1
    )LatestStatus
    ON True_SubCompleteness.ProjectID=LatestStatus.ProjectID
  WHERE True_SubCompleteness.SubCompleteness<1 AND
        True_SubCompleteness.SubName<>LatestStatus.SubName;

DROP VIEW IF EXISTS View_WorkSpacePriorityLatest;
CREATE VIEW IF NOT EXISTS View_WorkSpacePriorityLatest as
  SELECT *
  FROM Log_WorkSpacePriority
  GROUP BY ProjectID,KnowledgeOwner,SubName,Floor;

DROP VIEW IF EXISTS True_WorkSpacePriorityLatest;
CREATE VIEW IF NOT EXISTS True_WorkSpacePriorityLatest as
  SELECT View_WorkSpacePriorityLatest.*
  FROM View_WorkSpacePriorityLatest
  WHERE View_WorkSpacePriorityLatest.KnowledgeOwner=View_WorkSpacePriorityLatest.SubName;

DROP VIEW IF EXISTS Sync_WorkSpacePriority;
CREATE VIEW IF NOT EXISTS Sync_WorkSpacePriority AS
SELECT LatestStatus.*, True_SubCompleteness.SubName KnowledgeOwner
FROM True_SubCompleteness
LEFT JOIN (
    SELECT True_WorkSpacePriorityLatest.ProjectID, True_WorkSpacePriorityLatest.SubName,True_WorkSpacePriorityLatest.Floor,True_WorkSpacePriorityLatest.Priority
    FROM True_WorkSpacePriorityLatest
      INNER JOIN True_ProjectCompleteness
      ON True_ProjectCompleteness.ProjectID=True_WorkSpacePriorityLatest.ProjectID
    WHERE True_ProjectCompleteness.ProjectCompleteness<1
    )LatestStatus
    ON True_SubCompleteness.ProjectID=LatestStatus.ProjectID
  WHERE True_SubCompleteness.SubCompleteness<1 AND
        True_SubCompleteness.SubName<>LatestStatus.SubName;

DROP VIEW IF EXISTS View_FloorCompleteness;
CREATE VIEW IF NOT EXISTS View_FloorCompleteness as
  SELECT ProjectID,KnowledgeOwner,Floor,1-sum(RemainingQty)/sum(TotalQty) FloorCompleteness, sum(TotalQty) FloorTotalWork
  FROM View_TaskLatest
    LEFT JOIN Fact_TaskDetail
    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
  GROUP BY ProjectID,KnowledgeOwner,Floor;

DROP VIEW IF EXISTS True_FloorCompleteness;
CREATE VIEW IF NOT EXISTS True_FloorCompleteness AS
  SELECT True_TaskLatest.*, 1-sum(True_TaskLatest.RemainingQty)/sum(True_TaskLatest.TotalQty) FloorCompleteness
  FROM True_TaskLatest
  GROUP BY True_TaskLatest.ProjectID,True_TaskLatest.Floor;

DROP VIEW IF EXISTS View_WorkMethodCompleteness;
CREATE VIEW IF NOT EXISTS View_WorkMethodCompleteness as
  SELECT ProjectID,KnowledgeOwner,WorkMethod,1-sum(RemainingQty)/sum(TotalQty) WorkMethodCompleteness, sum(TotalQty) WorkMethodTotalWork
  FROM View_TaskLatest
    LEFT JOIN Fact_TaskDetail
    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
  GROUP BY ProjectID,KnowledgeOwner,WorkMethod;

DROP VIEW IF EXISTS True_WorkMethodCompleteness;
CREATE VIEW IF NOT EXISTS True_WorkMethodCompleteness as
SELECT True_TaskLatest.*, 1- sum(RemainingQty)/sum(TotalQty) WorkMethodCompleteness
    FROM True_TaskLatest
    GROUP BY True_TaskLatest.ProjectID,True_TaskLatest.WorkMethod;

DROP VIEW IF EXISTS View_SubWorking;
CREATE VIEW IF NOT EXISTS View_SubWorking as
SELECT View_TaskLatest.ProjectID,KnowledgeOwner,Day,Fact_TaskDetail.*
  FROM View_TaskLatest
    LEFT JOIN Fact_TaskDetail
    ON View_TaskLatest.TaskID=Fact_TaskDetail.TaskID
    INNER JOIN (
      SELECT ProjectID, max(Day) mDay
      FROM View_TaskLatest
      GROUP BY ProjectID
      )mDay
    ON View_TaskLatest.ProjectID=mDay.ProjectID AND View_TaskLatest.Day=mDay.mDay
WHERE RemainingQty>0 AND RemainingQty<View_TaskLatest.TotalQty AND Day>0
ORDER BY View_TaskLatest.ProjectID, KnowledgeOwner, SubName;

DROP VIEW IF EXISTS True_SubWorking;
CREATE VIEW IF NOT EXISTS True_SubWorking as
	SELECT *
	FROM View_SubWorking
	WHERE View_SubWorking.KnowledgeOwner=View_SubWorking.SubName;

DROP VIEW IF EXISTS View_TaskBacklog;
CREATE VIEW IF NOT EXISTS View_TaskBacklog as
  SELECT Backlog.*,1-RemainingQty/TotalQty TaskCompleteness,ProductionRate,Priority WorkspacePriority,FloorCompleteness,WorkMethodCompleteness, random()%1000 Ran, FloorTotalWork, WorkMethodTotalWork, RemainingQty/FloorTotalWork SignificanceToFloor, RemainingQty/WorkMethodTotalWork SignificanceToWorkMethod
  FROM (
    SELECT
      FreeTask.*,
      Fact_TaskDetail.SubName,
      Fact_TaskDetail.Floor,
      Fact_TaskDetail.WorkMethod,
      Fact_TaskDetail.PerformanceStd
    FROM (
      SELECT *
      FROM (
        SELECT *,sum(pre) PreQty
        FROM (
          SELECT Unfinished.*, View_TaskLatest.RemainingQty pre
          FROM (
                 SELECT Unfinished.*, PredecessorTaskID
                 FROM (
                        SELECT View_TaskLatest.*
                        FROM View_TaskLatest
                          INNER JOIN (
                                       SELECT
                                         SubName,
                                         ProjectID
                                       FROM True_SubCompleteness
                                       WHERE SubCompleteness < 1
                                     ) UnfinishedSub
                            ON View_TaskLatest.ProjectID = UnfinishedSub.ProjectID AND
                               View_TaskLatest.KnowledgeOwner = UnfinishedSub.SubName
                        WHERE RemainingQty > 0
                      ) Unfinished
                   LEFT JOIN Fact_TaskDependency
                     ON Unfinished.TaskID = Fact_TaskDependency.SuccessorTaskID
               )Unfinished
            LEFT JOIN View_TaskLatest
              ON Unfinished.ProjectID = View_TaskLatest.ProjectID AND
                 Unfinished.KnowledgeOwner = View_TaskLatest.KnowledgeOwner AND
                 Unfinished.PredecessorTaskID = View_TaskLatest.TaskID
        )GROUP BY ProjectID,KnowledgeOwner,TaskID
      )WHERE PreQty IS NULL OR PreQty = 0
         ) FreeTask
      LEFT JOIN Fact_TaskDetail
        ON FreeTask.TaskID = Fact_TaskDetail.TaskID
      LEFT JOIN View_SubWorking View_SubWorking1
        ON View_SubWorking1.ProjectID = FreeTask.ProjectID AND
           View_SubWorking1.KnowledgeOwner = FreeTask.KnowledgeOwner AND
           View_SubWorking1.Floor = Fact_TaskDetail.Floor
      LEFT JOIN View_SubWorking View_SubWorking2
        ON View_SubWorking2.ProjectID = FreeTask.ProjectID AND
           View_SubWorking2.KnowledgeOwner = FreeTask.KnowledgeOwner AND
           View_SubWorking2.SubName = Fact_TaskDetail.SubName
    WHERE (View_SubWorking2.Floor=Fact_TaskDetail.Floor AND View_SubWorking1.SubName=Fact_TaskDetail.SubName) OR
          (View_SubWorking2.Floor IS NULL AND View_SubWorking1.SubName IS NULL)
    )Backlog
  LEFT JOIN View_ProductionRateLatest
  ON Backlog.ProjectID=View_ProductionRateLatest.ProjectID AND
        Backlog.KnowledgeOwner=View_ProductionRateLatest.KnowledgeOwner AND
        Backlog.WorkMethod=View_ProductionRateLatest.WorkMethod
  LEFT JOIN View_WorkSpacePriorityLatest
  ON Backlog.ProjectID=View_WorkSpacePriorityLatest.ProjectID AND
        Backlog.KnowledgeOwner=View_WorkSpacePriorityLatest.KnowledgeOwner AND
        Backlog.SubName=View_WorkSpacePriorityLatest.SubName AND
        Backlog.Floor=View_WorkSpacePriorityLatest.Floor
  LEFT JOIN View_FloorCompleteness
  ON View_FloorCompleteness.ProjectID=Backlog.ProjectID AND
        View_FloorCompleteness.Floor=Backlog.Floor AND
        View_FloorCompleteness.KnowledgeOwner=Backlog.KnowledgeOwner
  LEFT JOIN View_WorkMethodCompleteness
  ON View_WorkMethodCompleteness.ProjectID=Backlog.ProjectID AND
  View_WorkMethodCompleteness.KnowledgeOwner=Backlog.KnowledgeOwner AND
  View_WorkMethodCompleteness.WorkMethod=Backlog.WorkMethod
  ORDER BY ProjectID,KnowledgeOwner,SubName,TaskCompleteness,FloorCompleteness,Priority,Ran;

Drop VIEW IF EXISTS View_TaskSelectedRandom;
CREATE VIEW IF NOT EXISTS View_TaskSelectedRandom AS
  SELECT *
    FROM (
      SELECT *
      FROM View_TaskBacklog
        WHERE KnowledgeOwner=SubName
      ORDER BY ProjectID,KnowledgeOwner,SubName,TaskCompleteness, Ran
    )
    GROUP BY ProjectID,KnowledgeOwner,SubName;

DROP VIEW IF EXISTS View_TaskSelectedPrioritized;
CREATE VIEW IF NOT EXISTS View_TaskSelectedPrioritized as
  SELECT *
  FROM View_TaskBacklog
  WHERE View_TaskBacklog.KnowledgeOwner=View_TaskBacklog.SubName
  GROUP BY View_TaskBacklog.ProjectID,View_TaskBacklog.KnowledgeOwner,View_TaskBacklog.SubName;

DROP VIEW IF EXISTS View_TaskSelected;
CREATE VIEW IF NOT EXISTS View_TaskSelected as
SELECT Selected.*,ProductionRateChange
FROM (
  SELECT View_TaskSelectedPrioritized.*
  FROM View_TaskSelectedPrioritized
    INNER JOIN Fact_Project
      ON Fact_Project.ID=View_TaskSelectedPrioritized.ProjectID
  WHERE Fact_Project.TaskSelectionFunction=1 AND Fact_Project.Done=0
  UNION
  SELECT View_TaskSelectedRandom.*
  FROM View_TaskSelectedRandom
    INNER JOIN Fact_Project
      ON Fact_Project.ID=View_TaskSelectedRandom.ProjectID
  WHERE Fact_Project.TaskSelectionFunction=0 AND Fact_Project.Done=0
) Selected
LEFT JOIN Fact_Project
ON Fact_Project.ID=Selected.ProjectID;

DROP VIEW IF EXISTS True_TaskBacklog;
CREATE VIEW IF NOT EXISTS True_TaskBacklog as
SELECT FreeTask.*
FROM (
	SELECT * FROM (
    SELECT
      *,
      sum(pre) PreQty
    FROM (
      SELECT
        Unfinished.*,
        True_TaskLatest.RemainingQty pre
      FROM (
             SELECT
               Unfinished.*,
               PredecessorTaskID
             FROM (
                    SELECT *
                    FROM True_TaskLatest
                    WHERE RemainingQty > 0
                  ) Unfinished
               LEFT JOIN Fact_TaskDependency
                 ON Unfinished.TaskID = Fact_TaskDependency.SuccessorTaskID
           ) Unfinished
        LEFT JOIN True_TaskLatest
          ON True_TaskLatest.ProjectID = Unfinished.ProjectID AND
             True_TaskLatest.TaskID = Unfinished.PredecessorTaskID
    )
    GROUP BY ProjectID, TaskID
  )
	WHERE PreQty IS NULL OR PreQty = 0
)FreeTask
		LEFT JOIN View_SubWorking View_SubWorking1
			ON View_SubWorking1.ProjectID = FreeTask.ProjectID AND
				 View_SubWorking1.KnowledgeOwner = FreeTask.KnowledgeOwner AND
				 View_SubWorking1.Floor = FreeTask.Floor
		LEFT JOIN View_SubWorking View_SubWorking2
			ON View_SubWorking2.ProjectID = FreeTask.ProjectID AND
				 View_SubWorking2.KnowledgeOwner = FreeTask.KnowledgeOwner AND
				 View_SubWorking2.SubName = FreeTask.SubName
	WHERE (View_SubWorking2.Floor=FreeTask.Floor AND View_SubWorking1.SubName=FreeTask.SubName) OR
				(View_SubWorking2.Floor IS NULL AND View_SubWorking1.SubName IS NULL);

DROP VIEW IF EXISTS True_DesignChangeRandom;
CREATE VIEW IF NOT EXISTS True_DesignChangeRandom as
  SELECT Change.*,Fact_Project.DesignChangeVariation
  FROM (
    SELECT *
    FROM (
      SELECT
        *,
        random() % 1000 Ran
      FROM True_TaskLatest
      WHERE True_TaskLatest.RemainingQty > 0
      ORDER BY True_TaskLatest.ProjectID, Ran
    )
    GROUP BY ProjectID
  )Change
  LEFT JOIN Fact_Project
  ON Change.ProjectID=Fact_Project.ID;

DROP VIEW IF EXISTS True_TaskLatestRandomFloor;
CREATE VIEW IF NOT EXISTS True_TaskLatestRandomFloor AS
  SELECT True_TaskLatest.*
  FROM True_ProjectCompleteness
    LEFT JOIN True_TaskLatest
    ON True_TaskLatest.ProjectID=True_ProjectCompleteness.ProjectID AND
        True_TaskLatest.Floor=abs(random()% (SELECT max(Floor) FROM Fact_WorkSpace))+1
  WHERE ProjectCompleteness<1;

DROP VIEW IF EXISTS True_TaskTrace;
CREATE VIEW IF NOT EXISTS True_TaskTrace as
SELECT Floor||'-'||WorkMethod WPName, Day, Status, SubName, Floor, WorkMethod, TaskID, ProjectID
FROM
  (
    SELECT
      ProjectID,
      Fact_TaskDetail.TaskID,
      Day,
      SubName,
      Floor,
      WorkMethod,
      1 - RemainingQty / TotalQty     Completeness,
      Floor - RemainingQty / TotalQty Status
    FROM Log_Task
      LEFT JOIN Fact_TaskDetail
        ON Log_Task.TaskID = Fact_TaskDetail.TaskID
    WHERE Log_Task.KnowledgeOwner = Fact_TaskDetail.SubName AND Day > 0
  GROUP BY ProjectID, Log_Task.TaskID, Day
UNION
SELECT
  ProjectID,
  Fact_TaskDetail.TaskID,
  Day - 1   Day,
  SubName,
  Floor,
  WorkMethod,
  0         Completeness,
  Floor - 1 Status
FROM Event_WorkBegin
  LEFT JOIN Fact_TaskDetail
    ON Fact_TaskDetail.TaskID = Event_WorkBegin.TaskID
  )
ORDER BY ProjectID, Day, TaskID;

DROP VIEW IF EXISTS _Result;
CREATE VIEW IF NOT EXISTS _Result as
SELECT True_TaskTrace.*,
  CASE WHEN (Event_Retrace.Day ISNULL ) THEN 0 ELSE 1 END NotMature,
  CASE WHEN (Event_RetracePredecessor.Day ISNULL ) THEN 0 ELSE 1 END PredecessorIncomplete,
  CASE WHEN (Event_RetraceWorkSpace.Day ISNULL ) THEN 0 ELSE 1 END WorkSpaceCongestion,
  CASE WHEN (Event_RetraceExternalCondition.Day ISNULL ) THEN 0 ELSE 1 END ExternalCondition,
  CASE WHEN (Event_DesignChange.Day ISNULL ) THEN 0 ELSE 1 END DesignChange
FROM True_TaskTrace
    LEFT JOIN Event_Retrace
    ON True_TaskTrace.ProjectID=Event_Retrace.ProjectID AND
      True_TaskTrace.TaskID=Event_Retrace.TaskID AND
      True_TaskTrace.Day=Event_Retrace.Day
    LEFT JOIN Event_RetracePredecessor
    ON True_TaskTrace.ProjectID=Event_RetracePredecessor.ProjectID AND
      True_TaskTrace.TaskID=Event_RetracePredecessor.TaskID AND
      True_TaskTrace.Day=Event_RetracePredecessor.Day
    LEFT JOIN Event_RetraceWorkSpace
    ON True_TaskTrace.ProjectID=Event_RetraceWorkSpace.ProjectID AND
      True_TaskTrace.TaskID=Event_RetraceWorkSpace.TaskID AND
      True_TaskTrace.Day=Event_RetraceWorkSpace.Day
    LEFT JOIN Event_RetraceExternalCondition
    ON True_TaskTrace.ProjectID=Event_RetraceExternalCondition.ProjectID AND
      True_TaskTrace.TaskID=Event_RetraceExternalCondition.TaskID AND
      True_TaskTrace.Day=Event_RetraceExternalCondition.Day
    LEFT JOIN Event_DesignChange
    ON True_TaskTrace.ProjectID=Event_DesignChange.ProjectID AND
      True_TaskTrace.TaskID=Event_DesignChange.TaskID AND
      True_TaskTrace.Day=Event_DesignChange.Day;
COMMIT;