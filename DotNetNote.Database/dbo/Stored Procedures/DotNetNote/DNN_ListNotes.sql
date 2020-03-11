CREATE PROCEDURE [dbo].[ListNotes]
	@Page Int
AS
	With DotNetNoteOrderedLists
	As
	(
	Select [Id], [Name], [Email], [Title], [PostDate], [ReadCount], [Ref], [Step], [RefOrder], 
			[AnswerNum], [ParentNum], [CommentCount], [FileName], [FileSize], [DownCount], 
			ROW_NUMBER() Over(Order By Ref Desc, RefOrder Asc)
	As 'RowNumber'
	From Notes
	)
	Select *
	From DotNetNoteOrderedLists
	Where RowNumber Between @Page * 10 + 1 And (@page +1) *10
	Go
