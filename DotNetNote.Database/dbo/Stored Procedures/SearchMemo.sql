Create Proc dbo.SearchMemo
(
	@SearchField NVarChar(10),
	@SearchQuery NVarChar(50)
)
--With Encryption - 현재 SP문 암호화
AS
	Declare @strSql NVarChar(150) -- 변수 선언
	Set @strSql = 'Select Num, Name, Email, Title, PostDate, PostIP
				   From Memos
				   Where' +@SearchField+'like N"%' + @SearchQuery+'%"
				   Order By Num Desc'
	--Print @strSql
	Exec (@strSql) --완성된 SQL문 실행
