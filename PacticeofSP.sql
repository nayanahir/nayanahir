CREATE OR ALTER proc proc_Insert_Sdata
@Name nvarchar(50),
@address nvarchar(25),
@Code int output
AS
	BEGIN
		begin try
			if not exists(select * from Sdata where SName=@Name)
				begin 
					insert into Sdata(SName,SAddress)values(@Name,@address)
					select @Code=SCOPE_IDENTITY()
				end
			else 
				print'Allready Exists'
		end try
	begin catch
	
	end catch
	end

declare @Code int 
EXEC proc_Insert_Sdata @Code output,'nayan','abdccd'
print 'inserted'