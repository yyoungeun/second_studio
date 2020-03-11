CREATE TABLE [dbo].[NoteComments]
(
	[Id] INT Identity(1,1) NOT NULL PRIMARY KEY, 
    [BoardName] NVARCHAR(50) NULL, 
    [BoardId] INT NOT NULL, 
    [Name] NVARCHAR(25) NOT NULL, 
    [Opinion] NVARCHAR(4000) NOT NULL, 
    [PostDate] SMALLDATETIME NULL DEFAULT getDate(), 
    [Password] NVARCHAR(20) NOT NULL
)
