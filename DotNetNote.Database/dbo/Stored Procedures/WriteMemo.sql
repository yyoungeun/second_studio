Create Procedure dbo.WriteMemo
(
	@Name NVarChar(25),
	@Email NVarChar(100),
	@Title NVarChar(150),
	@PostIP NVarChar(15)
)
AS
	Insert Memos(Name, Email, Title, PostIP) Values(@Name, @Email, @Title, @PostIP)
