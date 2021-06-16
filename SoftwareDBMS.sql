/*  Homework DB440 Class 
**  5/9/2020
**  Done by Gevorg Hovakimyan*/

-- CREATING TABLES

/* System of Origin and Report aren't really related to the rest of the database because 
** we did not have to do the job of the product manager to turn reports into Work Items. */
CREATE TABLE SystemOfOrigin (
  SystemOfOriginId int primary key identity(1,1),
  SystemOfOrigin varchar(20),
);

CREATE TABLE Report (
  ReportId int primary key identity(1,1),
  SystemofOriginId int,
  ReportedBy varchar(30),
  RecordedDate date,
  foreign key (SystemofOriginId) references SystemOfOrigin(SystemOfOriginId)
);

-- Holds the release numbers
CREATE TABLE SoftwareRelease (
  SoftwareReleaseId int primary key identity(1,1),
  ReleaseNumberFirst smallint,
  ReleaseNumberSecond smallint,
  ReleaseNumberThird smallint,
);

-- Holds employees that are available to be assigned a workitem
CREATE TABLE AssignedEmployee (
  AssignedEmployeeId int primary key identity(1,1),
  Email varchar(50),
  FirstName varchar(20),
  LastName varchar(20),
);

-- Holds possible states (lookup table) could be used as dropdown menu
CREATE TABLE MyState (
  MyStateId int primary key identity(1,1),
  MyState varchar(10),
);

-- Holds possible priorities (lookup table) could be used as dropdown menu
-- Priorities: 1, 2, 3, 4
CREATE TABLE MyPriority (
  MyPriorityId int primary key identity(1,1),
  MyPriority tinyint,
);

/* Holds possible current activities (lookup table) could be used as dropdown menu
** Activites: Development and Support */
CREATE TABLE Activity (
  ActivityId int primary key identity(1,1),
  Activity varchar(20),
);

/* Holds possible types of work items (lookup table) could be used as dropdown menu
** WorkItemTypes: User Story, Task, Bug, Feature */
CREATE TABLE WorkItemType (
  WorkItemTypeId int primary key identity(1,1),
  WorkItemType varchar(15),
);

-- Holds all the information for a work item, uses references to lookup tables and employee table for efficiency
CREATE TABLE WorkItem (
  WorkItemId int primary key identity(1,1),
  WorkItemTypeId int,
  MyStateId int,
  ActivityId int,
  MyPriorityId int,
  AssignedEmployeeId int,
  Description varchar(4000),
  Title varchar(400),
  CreatedDate date,
  foreign key (WorkItemTypeId) references WorkItemType(WorkItemTypeId),
  foreign key (MyStateId) references MyState(MyStateId),
  foreign key (ActivityId) references Activity(ActivityId),
  foreign key (MyPriorityId) references MyPriority(MyPriorityId),
  foreign key (AssignedEmployeeId) references AssignedEmployee(AssignedEmployeeId),
);

-- Holds the transitions of one WorkItem turning into or creating another WorkItem
CREATE TABLE FeatureUserstoryTaskBug (
  FUTBId int primary key identity(1,1),
  WorkItemId int,
  ChildWorkItemId int,
  foreign key (WorkItemId) references WorkItem(WorkItemId),
);

-- Holds the list of features (references a feature by using an entry from the FeatureUserstoryTaskBug table by its ChildWorkItemId) 
CREATE TABLE Feature (
  FeatureId int primary key identity(1,1),
  FUTBId int,
  NotificationDate date,
  ReleaseDate date,
  foreign key (FUTBId) references FeatureUserstoryTaskBug(FUTBId),
);

-- Holds the smallest version number (the 2 in 1.1.8.[2]) for example
CREATE TABLE SoftwareVersion (
  SoftwareVersionId int primary key identity(1,1),
  SoftwareReleaseId int,
  VersionMinor tinyint,
  foreign key (SoftwareReleaseId) references SoftwareRelease(SoftwareReleaseId),
);

-- Shows what features a software version has (Bridge table)
CREATE TABLE SoftwareVersionFeature (
  SoftwareVersionFeatureId int primary key identity(1,1),
  FeatureId int,
  SoftwareVersionId int,
  foreign key (FeatureId) references Feature(FeatureId),
  foreign key (SoftwareVersionId) references SoftwareVersion(SoftwareVersionId),
);

-- Creating some Indexes for potential use
CREATE INDEX ReportIndex ON  Report (SystemofOriginId);
CREATE INDEX WorkItemIndex ON  WorkItem (WorkItemTypeId, MyStateId, ActivityId, MyPriorityId, AssignedEmployeeId);
CREATE INDEX FUTBIndex ON  FeatureUserstoryTaskBug (WorkItemId);
CREATE INDEX SVFIndex ON  SoftwareVersionFeature (FeatureId, SoftwareVersionId);
CREATE INDEX SoftwareVersionIndex ON  SoftwareVersion (SoftwareReleaseId);
CREATE INDEX FeatureIndex ON  Feature (FUTBId);

-- INSERTING DATA

--Inserting Possible Priorities into MyPriority
INSERT INTO MyPriority(MyPriority) VALUES (1);
INSERT INTO MyPriority(MyPriority) VALUES (2);
INSERT INTO MyPriority(MyPriority) VALUES (3);
INSERT INTO MyPriority(MyPriority) VALUES (4);

--Inserting possible States into MyState
INSERT INTO MyState(MyState) VALUES ('New');
INSERT INTO MyState(MyState) VALUES ('Closed');

--Inserting possible Activities into Activity
INSERT INTO Activity(Activity) VALUES ('Development');
INSERT INTO Activity(Activity) VALUES ('Support');

----Inserting possible Work Item Types into WorkItemType
INSERT INTO WorkItemType(WorkItemType) VALUES ('User Story');
INSERT INTO WorkItemType(WorkItemType) VALUES ('Task');
INSERT INTO WorkItemType(WorkItemType) VALUES ('Bug');
INSERT INTO WorkItemType(WorkItemType) VALUES ('Feature');

--Inserting current Employees into AssignedEmployee
INSERT INTO AssignedEmployee(Email, FirstName, LastName) VALUES ('robert@mask-me.net','Robert', NULL);
INSERT INTO AssignedEmployee(Email, FirstName, LastName) VALUES ('virginia@mask-me.net','Virginia', 'Mushkatblat');
INSERT INTO AssignedEmployee(Email, FirstName, LastName) VALUES ('cxxne1111@outlook.com','john', 'cxxne');
INSERT INTO AssignedEmployee(Email, FirstName, LastName) VALUES ('Developer@mask-me.net','HushHush', NULL);

--Inserting WorkItem with appropriate fk references + title + description
INSERT INTO WorkItem(WorkItemTypeId, MyStateId, ActivityId, MyPriorityId, AssignedEmployeeId, Title, Description, CreatedDate) 
VALUES (1,2,1,1,1, 
'Current layout needs change to the new look', 
'orem ipsum dolor sit amet, consectetur adipiscing elit. Etiam condimentum odio sed mi vehicula consequat. Nulla condimentum neque id convallis bibendum. Aliquam porttitor efficitur tristique. Donec fringilla vehicula auctor. Morbi mattis, tortor in rutrum faucibus, felis quam interdum ipsum, eu molestie ante dolor et leo. Nullam fringilla vel nisi non tincidunt. Praesent commodo, nunc ac venenatis consectetur, nunc massa tristique risus, ut ultrices tellus nunc at augue. Suspendisse potenti. Suspendisse potenti. Quisque ac nisi finibus, volutpat lacus eget, faucibus nisl. Quisque sed nunc risus. Etiam ultrices varius interdum.Mauris sed commodo orci. Nunc nulla turpis, lobortis sed tortor vitae, mollis fermentum eros. Ut laoreet facilisis purus non commodo. Vivamus mattis eros sodales rhoncus scelerisque. Fusce laoreet sapien sed nibh ornare blandit. Aliquam vulputate vulputate mauris id molestie. Pellentesque eget risus pulvinar, iaculis nisl aliquet, ornare nisi. Mauris porttitor ipsum a turpis fringilla, sit amet interdum nisl gravida. Nam cursus elementum tellus, nec rutrum dui malesuada id. Vestibulum interdum gravida eros, sed vestibulum diam convallis accumsan. Nullam porttitor nibh id est congue, sit amet mattis ex porta.', 
'2018-01-01');

INSERT INTO WorkItem(WorkItemTypeId, MyStateId, ActivityId, MyPriorityId, AssignedEmployeeId, Title, Description, CreatedDate) 
VALUES (2,2,1,2,3, 
'WebSite Graphics and Layout', 
'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas eget elit lobortis, viverra lorem et, elementum nibh. Aenean scelerisque nulla sed quam aliquam, ut volutpat eros lacinia. Phasellus fringilla lectus lectus, in eleifend nulla condimentum et. Donec feugiat ornare libero, ac laoreet ipsum tincidunt sit amet. Curabitur blandit scelerisque malesuada. Praesent quis tortor orci. Nullam vitae elementum orci. Aenean sodales leo turpis, at rhoncus lacus facilisis ut. Praesent a magna vitae magna suscipit aliquet. Cras quis nisi vitae neque tempus consectetur. Curabitur dolor velit, facilisis faucibus arcu nec, elementum tempus arcu. Donec non dui finibus, luctus neque vel, vehicula nulla. Sed feugiat est ligula, id luctus nunc convallis sit amet.',
'2018-01-09');

--Inserting transition from one WorkItemType to another
	--example of user story creating a feature
INSERT INTO FeatureUserstoryTaskBug(WorkItemId,ChildWorkItemId) VALUES (1,2);

--Creating a feature (The ChildWorkItemId of the FUTBId is the WorkItemID of the feature
INSERT INTO Feature(FUTBId,NotificationDate,ReleaseDate) VALUES (1,'2018-01-30','2018-02-09');

--Creating Software Release (1.1.8 in this case)
INSERT INTO SoftwareRelease(ReleaseNumberFirst,ReleaseNumberSecond,ReleaseNumberThird) VALUES (1,1,8);

--Inserting into SoftwareVersionFeature which shows all the features in a version of software
INSERT INTO SoftwareVersionFeature(FeatureId,SoftwareVersionId) VALUES (1,1);
INSERT INTO SoftwareVersionFeature(FeatureId,SoftwareVersionId) VALUES (1,2);

--Creating a Software Version (In this case we are making software version 1.1.8.1 and 1.1.8.2 with the features of SoftwareVersionFeatureId 1 the previous bridge table
INSERT INTO SoftwareVersion(SoftwareReleaseId,VersionMinor) VALUES (1,1);
INSERT INTO SoftwareVersion(SoftwareReleaseId,VersionMinor) VALUES (1,2);



-- VIEWS

-- Showing all the full software vesrion numbers
SELECT
    ReleaseNumberFirst,
    ReleaseNumberSecond,
    ReleaseNumberThird,
	VersionMinor
	FROM
    SoftwareRelease sr
INNER JOIN SoftwareVersion sv
    ON sr.SoftwareReleaseId = sv.SoftwareReleaseId
ORDER BY
    sr.SoftwareReleaseId DESC;


-- Showing development data for a WorkItem
SELECT
    WorkItemType,
	MyState,
	MyPriority,
	Activity,
	Title, Description, CreatedDate,
	Email, FirstName, LastName
	FROM
    WorkItem wi INNER JOIN WorkItemType wit ON wi.WorkItemTypeId = wit.WorkItemTypeId
				INNER JOIN MyState ms ON wi.MyStateId = ms.MyStateId
				INNER JOIN MyPriority mp ON wi.MyPriorityId = mp.MyPriorityId
				INNER JOIN Activity ac ON wi.ActivityId = ac.ActivityId
				INNER JOIN AssignedEmployee ae ON wi.AssignedEmployeeId = ae.AssignedEmployeeId

-- Show all features that are available in a software version, sorted by date (I only have 1 feature and 2 versions have that feature, so it shows that feature twice)
SELECT
    f.FeatureId,
	ReleaseDate,
	VersionMinor
	FROM
    SoftwareVersionFeature svf INNER JOIN SoftwareVersion sv ON svf.SoftwareVersionId = sv.SoftwareVersionId
							   INNER JOIN Feature f ON f.FeatureId = svf.FeatureId
ORDER BY
    ReleaseDate DESC;