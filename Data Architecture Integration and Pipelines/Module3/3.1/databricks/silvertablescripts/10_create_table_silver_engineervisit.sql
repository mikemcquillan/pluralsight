CREATE TABLE IF NOT EXISTS globodata.silver.engineervisit
(
  SourceSystem              VARCHAR(100),
  Country                   VARCHAR(20),
  SystemVisitId             INTEGER,
  Action                    VARCHAR(30),
  UserName                  VARCHAR(40),
  CustomerRef               VARCHAR(30),
  VisitStartDate            TIMESTAMP,
  VisitEndDate              TIMESTAMP,
  Engineer                  VARCHAR(50),
  Vehicle                   VARCHAR(50),
  VisitNotes                VARCHAR(500),
  EntryDate                 TIMESTAMP,
  LastImportDate            TIMESTAMP
);

