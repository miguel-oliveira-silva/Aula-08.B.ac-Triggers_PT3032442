CREATE TRIGGER dbo.trigger_prevent_assignment_teaches
ON dbo.teaches
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1 FROM (SELECT teaches.ID, teaches.year, 
        COUNT(*) AS total FROM dbo.teaches GROUP BY teaches.ID, teaches.year) AS summary
        INNER JOIN inserted ON summary.ID = inserted.ID AND summary.year = inserted.year WHERE summary.total > 2)
    BEGIN
        ROLLBACK TRANSACTION;
    END
END;
