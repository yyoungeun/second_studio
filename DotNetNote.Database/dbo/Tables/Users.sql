CREATE TABLE [dbo].[Users]
(
	[UID] INT Identity(1,1) NOT NULL PRIMARY KEY, 
    [UserID] NVARCHAR(25) NOT NULL, 
    [Password] NVARCHAR(20) NOT NULL
    --필요한 항목이 있으면, 언제든 추가
 
)
