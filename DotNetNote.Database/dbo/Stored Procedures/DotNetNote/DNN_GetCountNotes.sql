CREATE PROCEDURE [dbo].[GetCountNotes]
AS
	SELECT Count(*) From Notes
Go
