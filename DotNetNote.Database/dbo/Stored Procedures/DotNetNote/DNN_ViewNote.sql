CREATE PROCEDURE [dbo].[ViewNote]
	@Id Int
AS
	--조회수 카운트 1증가
	Update Notes
	Set ReadCount = ReadCount + 1
	Where Id = @Id

	--모든 항목 조회
	Select *
	From Notes
	Where Id = @Id
Go
