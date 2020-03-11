CREATE TABLE [dbo].[Tasks]
(
	[Id] INT NOT NULL PRIMARY KEY Identity(1,1),    --번호
    [Title] NVARCHAR(140) NOT NULL,                 --할 일 제목
    [IsCompleted] BIT,                              --완료 여부
    [CreationDate] DATETIME NULL DEFAULT GetDate()  --등록일
)
