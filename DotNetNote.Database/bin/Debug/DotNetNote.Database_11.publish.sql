/*
DotNetNote의 배포 스크립트

이 코드는 도구를 사용하여 생성되었습니다.
파일 내용을 변경하면 잘못된 동작이 발생할 수 있으며, 코드를 다시 생성하면
변경 내용이 손실됩니다.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "DotNetNote"
:setvar DefaultFilePrefix "DotNetNote"
:setvar DefaultDataPath "C:\Users\송영은\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"
:setvar DefaultLogPath "C:\Users\송영은\AppData\Local\Microsoft\Microsoft SQL Server Local DB\Instances\MSSQLLocalDB\"

GO
:on error exit
GO
/*
SQLCMD 모드가 지원되지 않으면 SQLCMD 모드를 검색하고 스크립트를 실행하지 않습니다.
SQLCMD 모드를 설정한 후에 이 스크립트를 다시 사용하려면 다음을 실행합니다.
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'이 스크립트를 실행하려면 SQLCMD 모드를 사용하도록 설정해야 합니다.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'[dbo].[DeleteNote] 변경 중...';


GO
ALTER PROCEDURE [dbo].[DeleteNote]
	@Id INt,
	@Password NVarChar(30) --암호 매개변수 추가
AS
	Declare @cnt Int
	Select @cnt = Count(*) 
	From Notes
	Where Id = @Id And Password = @Password

	If @Cnt = 0
	Begin
		Return 0 --번호와 암호가 맞는게 없으면 0을 반환
	End

	Declare @AnswerNum Int
	Declare @RefOrder Int
	Declare @Ref Int
	Declare @ParentNum Int

	Select	@AnswerNum = AnswerNum, @RefOrder = RefOrder, @Ref = Ref, @ParentNum = ParentNum
	From Notes
	Where Id = @Id

	If @AnswerNum = 0
	Begin
		if @RefOrder > 0
		Begin
			UPDATE Notes 
			SET RefOrder = RefOrder - 1
			WHERE Ref = @Ref AND RefOrder > @RefOrder
			UPDATE Notes 
			SET AnswerNum = AnswerNum - 1
			WHERE Id = @ParentNum
		End
	Delete Notes WHERE Id= @Id
	Delete Notes WHERE ID= @ParentNum AND ModifyIp = N'((DELETED))' AND AnswerNum = 0
End
Else
Begin
	Update Notes
	Set
		Name = N'(Unknown)', Email='', Password='',
		Title = N'(삭제된 글입니다.)',
		Content = N'(삭제된 글입니다.' + N'현재 답변이 포함되어 있기 때문에 내용만 삭제되었습니다.)',ModifyIp = N'((DELETED))', FileName='', FileSize=0, CommentCount = 0
		Where Id= @Id
End
GO
PRINT N'[dbo].[ListNotes] 변경 중...';


GO
ALTER PROCEDURE [dbo].[ListNotes]
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
GO
PRINT N'[dbo].[SearchNotes] 변경 중...';


GO
ALTER PROCEDURE [dbo].[SearchNotes]
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
								  Else @SearchQuery
	   End
	   ) Like '%' + @SearchQuery + '%')
	   Select [Id], [Name], [Email], [Title], [PostDate], [ReadCount], [Ref], [Step], [RefOrder], [AnswerNum], [ParentNum], [CommentCount], [FileName], [FileSize], [DownCount], [RowNumber]
	   From DotNetNoteOrderedLists
	   Where RowNumber Between @Page * 10 + 1 And (@page +1) *10
	   Order By Id Desc
GO
PRINT N'업데이트가 완료되었습니다.';


GO
