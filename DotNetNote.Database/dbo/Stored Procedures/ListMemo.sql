Create Proc dbo.ListMemo
As
	Select Num, Name, Title,PostDate, PostIP
	From Memos
	Order By Num Desc
