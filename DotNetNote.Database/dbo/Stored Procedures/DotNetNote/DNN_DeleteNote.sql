CREATE PROCEDURE [dbo].[DeleteNote]
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
Go