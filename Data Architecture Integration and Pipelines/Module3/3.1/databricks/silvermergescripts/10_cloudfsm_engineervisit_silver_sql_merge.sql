MERGE INTO globodata.silver.engineervisit AS t
USING (
  SELECT
    'CloudFSM' AS SourceSystem,
    'UK' AS Country,
    visitid AS SystemVisitId,
    action AS Action,
    user AS UserName,
    customerref AS CustomerRef,
    visitstart AS VisitStartDate,
    visitend AS VisitEndDate,
    engineer AS Engineer,
    vehicle AS Vehicle,
    notes AS VisitNotes,
    CAST(entrydate AS TIMESTAMP) AS EntryDate,
    CAST(importdate AS TIMESTAMP) AS LastImportDate
  FROM globodata.bronze.cloudfsm_visit
) AS s
ON  t.SourceSystem = s.SourceSystem
AND t.SystemVisitId = s.SystemVisitId
AND t.Country = s.Country

WHEN MATCHED THEN UPDATE SET
  t.Action = s.Action,
  t.UserName = s.UserName,
  t.CustomerRef = s.CustomerRef,
  t.VisitStartDate = s.VisitStartDate,
  t.VisitEndDate = s.VisitEndDate,
  t.Engineer = s.Engineer,
  t.Vehicle = s.Vehicle,
  t.VisitNotes = s.VisitNotes,
  t.EntryDate = s.EntryDate,
  t.LastImportDate = s.LastImportDate

WHEN NOT MATCHED THEN INSERT (
  SourceSystem,
  Country,
  SystemVisitId,
  Action,
  UserName,
  CustomerRef,
  VisitStartDate,
  VisitEndDate,
  Engineer,
  Vehicle,
  VisitNotes,
  EntryDate,
  LastImportDate
) VALUES (
  s.SourceSystem,
  s.Country,
  s.SystemVisitId,
  s.Action,
  s.UserName,
  s.CustomerRef,
  s.VisitStartDate,
  s.VisitEndDate,
  s.Engineer,
  s.Vehicle,
  s.VisitNotes,
  s.EntryDate,
  s.LastImportDate
);