CREATE TABLE [dbo].[Maxims]
(
	[Id] INT NOT NULL PRIMARY KEY Identity(1,1), 
    [Name] NVARCHAR(25) NOT NULL,   --작성자
    [Content] NVARCHAR(255) NULL,   --명언 내용
    [CreationDate] DATETIME NULL DEFAULT GetDate()
)
