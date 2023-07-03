DECLARE @HerIds TABLE(HerId INTEGER PRIMARY KEY NOT NULL)

SELECT @FileContents=BulkColumn
FROM OPENROWSET(BULK'C:\dev\scripts\SQL\output.txt', SINGLE_BLOB) x


DECLARE @Id INTEGER
WHILE EXISTS (SELECT * FROM @HerIds)
    BEGIN
        
    END

-- IF (SELECT 1 FROM Services WHERE HerId = @herId)


-- SELECT INTO #validDates
-- FROM 

-- UPDATE CollaborationProtocolProfiles
-- SET ValidTo = (SELECT 1 FROM )
