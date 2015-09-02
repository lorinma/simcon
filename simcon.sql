BEGIN TRANSACTION;
CREATE TABLE "Log_WorkSpacePriority" (
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
CREATE TABLE "Log_WorkPackage" (
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
CREATE TABLE "Log_ProductionRate" (
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
CREATE TABLE "Fact_WorkSpace" (
	`Floor`	INTEGER NOT NULL UNIQUE,
	`InitialPriority`	REAL NOT NULL,
	PRIMARY KEY(Floor)
);
INSERT INTO `Fact_WorkSpace` VALUES (1,5.0);
INSERT INTO `Fact_WorkSpace` VALUES (2,4.0);
INSERT INTO `Fact_WorkSpace` VALUES (3,3.0);
INSERT INTO `Fact_WorkSpace` VALUES (4,2.0);
INSERT INTO `Fact_WorkSpace` VALUES (5,1.0);
CREATE TABLE "Fact_WorkProcedureDependency" (
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
CREATE TABLE "Fact_WorkProcedure" (
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
CREATE TABLE "Fact_WorkPackage" (
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
CREATE TABLE "Fact_Sub" (
	`SubName`	TEXT NOT NULL UNIQUE,
	PRIMARY KEY(SubName)
);
INSERT INTO `Fact_Sub` VALUES ('Electricity');
INSERT INTO `Fact_Sub` VALUES ('Gravel');
INSERT INTO `Fact_Sub` VALUES ('Partition');
INSERT INTO `Fact_Sub` VALUES ('Plumbing');
INSERT INTO `Fact_Sub` VALUES ('Tiling');
CREATE TABLE "Fact_Project" (
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
INSERT INTO `Fact_Project` VALUES (1,5,9,1.0,1,1,0,0,0);
CREATE TABLE "Event_Retrace" (
	`Day`	INTEGER NOT NULL,
	`WorkPackageID`	INTEGER NOT NULL,
	`ProjectID`	INTEGER NOT NULL,
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);
CREATE TABLE "Event_QualityCheck" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkPackageID`	INTEGER NOT NULL,
	`Pass`	INTEGER NOT NULL DEFAULT 1,
	`ProjectID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);
CREATE TABLE `Event_Meeting` (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`ProjectID`	INTEGER NOT NULL,
	`Day`	INTEGER NOT NULL,
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project(ID)
);
CREATE TABLE "Event_DesignChange" (
	`ID`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	`WorkPackageID`	INTEGER NOT NULL,
	`TotalQty`	REAL NOT NULL DEFAULT 0,
	`Day`	INTEGER NOT NULL DEFAULT 0,
	`ProjectID`	INTEGER NOT NULL,
	FOREIGN KEY(`WorkPackageID`) REFERENCES Fact_WorkPackage ( WorkPackageID ),
	FOREIGN KEY(`ProjectID`) REFERENCES Fact_Project ( ID )
);

delete from Event_DesignChange where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_Meeting where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_QualityCheck where ProjectID in (select ID from Fact_Project where Done=0);
delete from Event_Retrace where ProjectID in (select ID from Fact_Project where Done=0);

delete from Log_ProductionRate where ProjectID in (select ID from Fact_Project where Done=0);
delete from Log_WorkPackage where ProjectID in (select ID from Fact_Project where Done=0);
delete from Log_WorkSpacePriority where ProjectID in (select ID from Fact_Project where Done=0);

insert into Log_ProductionRate (KnowledgeOwner,ProductionRate,WorkProcedure, ProjectID)
select A.SubName KnowledgeOwner, InitialProductionRate ProductionRate, WorkProcedure, C.ID ProjectID from Fact_Sub A join Fact_WorkProcedure B join Fact_Project C where C.Done=0;

insert into Log_WorkPackage (KnowledgeOwner,WorkPackageID,RemainingQty, TotalQty, ProjectID)
select B.SubName KnowledgeOwner, WorkPackageID, InitialQty RemainingQty, InitialQty TotalQty, C.ID ProjectID from Fact_WorkPackage A join Fact_Sub B join Fact_Project C where C.Done=0;

insert into Log_WorkSpacePriority (KnowledgeOwner,Floor,Priority,SubName,ProjectID)
select A.SubName KnowledgeOwner, B.Floor, B.InitialPriority Priority, C.SubName SubName, D.ID ProjectID from Fact_Sub A join Fact_WorkSpace B join Fact_Sub C join Fact_Project D where D.Done=0;

CREATE VIEW Fact_WorkPackageDependency as
select PredecessorWorkPackageID, SuccessorWorkPackageID from (select A.WorkPackageID PredecessorWorkPackageID, B.WorkPackageID SuccessorWorkPackageID,A.WorkProcedure PredecessorWorkProcedure, B.WorkProcedure SuccessorWorkProcedure from Fact_WorkPackage A inner join Fact_WorkPackage B on A.Floor=B.Floor ) C inner join Fact_WorkProcedureDependency D on C.PredecessorWorkProcedure=D.PredecessorWorkProcedure and C.SuccessorWorkProcedure=D.SuccessorWorkProcedure;

CREATE VIEW Fact_WorkPackageDetail as
select A.WorkPackageID, A.Floor,A.InitialQty,B.* from Fact_WorkPackage A left join Fact_WorkProcedure B on A.WorkProcedure=B.WorkProcedure;

CREATE VIEW Log_WorkPackageDetail as
select * from Log_WorkPackage A left join Fact_WorkPackageDetail B on A.WorkPackageID=B.WorkPackageID order by ID;

CREATE VIEW View_WorkPackageTrace as
select * from Log_WorkPackageDetail group by KnowledgeOwner, WorkPackageID, Day, ProjectID;

CREATE VIEW View_WorkPackageLatestStatus as
select * from View_WorkPackageTrace group by KnowledgeOwner, WorkPackageID, ProjectID;

CREATE VIEW True_WorkPackageTrace as
select * from View_WorkPackageTrace where SubName=KnowledgeOwner;

CREATE VIEW True_WorkPackageLatestStatus as
select * from View_WorkPackageLatestStatus where SubName=KnowledgeOwner;

CREATE VIEW View_WorkPackageUnFinished as
select * from View_WorkPackageLatestStatus where RemainingQty>0;

CREATE VIEW View_WorkPackageUnSolvedDependency as
select KnowledgeOwner, WorkPackageID PreID, SuccessorWorkPackageID SucID, ProjectID from View_WorkPackageUnFinished inner join Fact_WorkPackageDependency on PreID=PredecessorWorkPackageID;

CREATE VIEW View_WorkSpacePriority as
select * from Log_WorkSpacePriority group by KnowledgeOwner, SubName, Floor,  ProjectID;

CREATE VIEW True_WorkSpacePriority as
select * from View_WorkSpacePriority where KnowledgeOwner=SubName;

CREATE VIEW View_WorkPackageBacklog as
select A.*,B.Priority Priority from (select A.* from View_WorkPackageUnFinished  A left join (select distinct SucID,ProjectID from View_WorkPackageUnSolvedDependency) B on A.ProjectID=B.ProjectID and WorkPackageID=SucID where SucID is Null) A left join View_WorkSpacePriority B on A.Floor=B.Floor and A.KnowledgeOwner=B.KnowledgeOwner and A.SubName=B.SubName and A.ProjectID=B.ProjectID;

CREATE VIEW View_ProductionRate as
select A.ID, A.KnowledgeOwner,A.Day,A.ProductionRate, A.ProjectID,B.* from Log_ProductionRate A left join Fact_WorkProcedure B on A.WorkProcedure=B.WorkProcedure group by KnowledgeOwner, A.WorkProcedure, ProjectID;

CREATE VIEW True_ProductionRate as
select * from View_ProductionRate where KnowledgeOwner=SubName;

CREATE VIEW View_WorkPackageBacklogProductivity as
select A.*, B.ProductionRate ProductionRate from View_WorkPackageBacklog A left join  View_ProductionRate B on A.KnowledgeOwner = B.KnowledgeOwner and A.WorkProcedure = B.WorkProcedure and A.ProjectID=B.ProjectID;

CREATE VIEW View_WorkSpaceCompleteness as
select ProjectID, KnowledgeOwner, Floor, 1-total(RemainingQty)/total(TotalQty) FloorCompleteness, total(RemainingQty) TotalRemainFloor, total(TotalQty) TotalWorkFloor from View_WorkPackageLatestStatus group by ProjectID, KnowledgeOwner, Floor;

CREATE VIEW View_WorkPackageSuccessorWork as
select A.ProjectID ProjectID, KnowledgeOwner, A.WorkPackageID, Floor, total(RemainingQty) SuccessorWork  from (select PredecessorWorkPackageID WorkPackageID,SuccessorWorkPackageID,ID ProjectID from Fact_WorkPackageDependency join Fact_Project) A left join View_WorkPackageLatestStatus B on A.SuccessorWorkPackageID=B.WorkPackageID and A.ProjectID=B.ProjectID group by B.ProjectID, KnowledgeOwner, A.WorkPackageID, Floor;

CREATE VIEW View_WorkPackageBacklogPriority as
select A.*,C.SuccessorWork SuccessorWork, SuccessorWork/TotalWorkFloor SuccessorContribution,random()%1000 Ran from (select *,RemainingQty/TotalWorkFloor SignificanceToFloor from View_WorkPackageBacklogProductivity A left join View_WorkSpaceCompleteness B  on A.ProjectID=B.ProjectID and A.KnowledgeOwner=B.KnowledgeOwner and A.Floor=B.Floor) A left join View_WorkPackageSuccessorWork C on A.ProjectID=C.ProjectID and A.KnowledgeOwner=C.KnowledgeOwner and A.WorkPackageID=C.WorkPackageID order by ProjectID, KnowledgeOwner, Priority, FloorCompleteness, TotalRemainFloor desc, SignificanceToFloor, SuccessorContribution, SuccessorWork, ProductionRate, Ran;

CREATE VIEW View_WorkPackageBacklogPriorityHigh as
select * from View_WorkPackageBacklogPriority group by ProjectID,KnowledgeOwner, SubName;

CREATE VIEW View_WorkPackageBacklogPriorityRandom as
select * from (select * from View_WorkPackageBacklogPriority order by ProjectID,KnowledgeOwner, SubName, Priority, Ran) group by ProjectID,KnowledgeOwner, SubName;

CREATE VIEW True_WorkPackageBacklog as
select A.*,B.Priority Priority from (select A.* from True_WorkPackageLatestStatus A left join (select distinct SucID,ProjectID from View_WorkPackageUnSolvedDependency) B on A.ProjectID=B.ProjectID and WorkPackageID=SucID where RemainingQty>0 and SucID is Null) A left join View_WorkSpacePriority B on A.Floor=B.Floor and A.KnowledgeOwner=B.KnowledgeOwner and A.SubName=B.SubName and A.ProjectID=B.ProjectID;

CREATE VIEW View_WorkPackageSelected as
select * from  View_WorkPackageBacklogPriorityHigh where SubName=KnowledgeOwner;

CREATE VIEW View_WorkPackageInference as
select * from  View_WorkPackageBacklogPriorityHigh where SubName<>KnowledgeOwner;

CREATE VIEW View_WorkPackageSelectedRandom as
select * from  View_WorkPackageBacklogPriorityRandom where SubName=KnowledgeOwner;

CREATE VIEW View_WorkPackageInferenceRandom as
select * from  View_WorkPackageBacklogPriorityRandom where SubName<>KnowledgeOwner;

CREATE VIEW View_WorkPackageLastUnfinishedMature as
select B.* from View_WorkPackageBacklog A inner join View_WorkPackageLatestStatus B on A.WorkPackageID=B.WorkPackageID and A.KnowledgeOwner=B.KnowledgeOwner and A.ProjectID=B.ProjectID where B.Day>0 and B.RemainingQty>0;

CREATE VIEW True_SubAppearance as
select SubName, Day, Floor, 1 Work, ProjectID from Log_WorkPackageDetail where Day>0 and KnowledgeOwner=SubName group by SubName, Day, ProjectID union select SubName,Day,Floor,0 Work, ProjectID from Event_Retrace A left join Fact_WorkPackageDetail B on A.WorkPackageID=B.WorkPackageID;

CREATE VIEW True_WorkSpaceCollision as
select Floor,Day,ProjectID from (select Day,Floor,ProjectID, Count(SubName) co from True_SubAppearance group by Day, Floor, ProjectID) where co>1;

CREATE VIEW True_SubCollision as
select B.* from (True_WorkSpaceCollision) A left join True_SubAppearance B on A.Day=B.Day and A.Floor=B.Floor and A.ProjectID=B.ProjectID;

CREATE VIEW True_WorkPackageQualityPass as
select * from (select * from Event_QualityCheck group by WorkPackageID,ProjectID) where Pass>0;

CREATE VIEW True_WorkPackageQualityUncheck as
select A.WorkPackageID,B.ID ProjectID from Fact_WorkPackage A left join Fact_Project B left join (select WorkPackageID,ProjectID from True_WorkPackageQualityPass) C on B.ID=C.ProjectID and A.WorkPackageID=C.WorkPackageID where C.WorkPackageID is null;

CREATE VIEW True_WorkPackageQualityUncheckRandom as
select * from (select *, random()%1000 Ran from True_WorkPackageQualityUncheck A left join True_WorkPackageLatestStatus B on A.WorkPackageID=B.WorkPackageID order by Ran) group by ProjectID;

CREATE VIEW True_WorkSpaceCompleteness as
select ProjectID,WorkProcedure, total(TotalQty) WorkProcedureTotalQty, total(TotalQty)-total(RemainingQty) WorkProcedureTotalWorked, 1- total(RemainingQty)/total(TotalQty) Completeness from True_WorkPackageLatestStatus group by ProjectID,Floor;

CREATE VIEW True_WorkProcedureCompleteness as
select ProjectID,WorkProcedure, total(TotalQty) WorkProcedureTotalQty, total(TotalQty)-total(RemainingQty) WorkProcedureTotalWorked, 1- total(RemainingQty)/total(TotalQty) WorkProcedureCompleteness from True_WorkPackageLatestStatus group by ProjectID,WorkProcedure;

CREATE VIEW True_WorkPackageFinishedQualityUncheck as
select *,1-(1-QualityRate)*(1-WorkProcedureCompleteness) QualityPassRate from (select A.* from (select * from True_WorkPackageLatestStatus where RemainingQty=0) A inner join True_WorkPackageQualityUncheck B on A.ProjectID=B.ProjectID and A.WorkPackageID=B.WorkPackageID) A left join True_WorkProcedureCompleteness B on A.WorkProcedure=B.WorkProcedure;

COMMIT;
