CREATE PROCEDURE [dbo].[SearchNotes]
	@Page Int,
	@SearchField NVarChar(25),
	@SearchQuery NVarChar(25)
AS
	With DotNetNoteOrderedLists
	As
	(
		Select
			[Id], [Name], [Email], [Title], [PostDate], [ReadCount], [Ref], [Step], [RefOrder], [AnswerNum], [ParentNum], [CommentCount], [FileName], [FileSize], [DownCount], ROW_NUMBER() Over(Order By Ref Desc, RefOrder Asc)
			As 'RowNumber'
		From Notes
		Where (
				Case @SearchField When 'Name' Then [Name] 
								  When 'Title' Then Title
								  When 'Content' Then Content 
								  Else 
								  @SearchQuery
	   End
	   ) Like '%' + @SearchQuery + '%')
	   Select [Id], [Name], [Email], [Title], [PostDate], [ReadCount], [Ref], [Step], [RefOrder], [AnswerNum], [ParentNum], [CommentCount], [FileName], [FileSize], [DownCount], [RowNumber]
	   From DotNetNoteOrderedLists
	   Where RowNumber Between (@Page -1) * 10 + 1 And (@page *10)
	   Order By Id Desc
	   Go
