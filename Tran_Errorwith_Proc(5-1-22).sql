
---insert proc

--first Proc
create or alter proc proc1
@code int out,
@name nvarchar(50),
@number int ,
@errorcode int out,
@errormsg nvarchar(50) out
as 
	begin 
		begin try
			set @code=isnull((select max(Code)+ 1 from table1),1);
				--if exists(select * from table1 where table1.Code=@code)
					--begin
						insert into table1 (Code,Sname,Snumber) values (@code,@name,@number);
					--end 
				--else
				--	print('data already inserted')
		end try
		begin catch
		set @errorcode=ERROR_MESSAGE()
		set @errormsg=ERROR_MESSAGE()
		--print ('error')
		end catch
	end

-- second proc

create or alter proc proc2
@newcode int,
@name nvarchar(50),
@number int ,
@errorcode int out,
@errormsg nvarchar(50) out
as 
	begin 
		begin try
			--set @code=isnull((select max(Code)+ 1 from table1),1);
				--if exists(select * from table1 where table1.Code=@code)
					--begin
						insert into table2 (Code,EName,Enumber) values (@newcode,@name,@number);
					--end 
				--else
				--	print('data already inserted')
		end try
		begin catch
		set @errorcode=ERROR_MESSAGE()
		set @errormsg=ERROR_MESSAGE()
		--print ('error')
		end catch
	end

	--exicute
declare @code int=0
declare @errorcode int=0 
declare @errormsg nvarchar(50)

begin tran 
	begin try
		exec proc1 @code out,'update karo',975,@errorcode out,@errormsg out
		if(@errorcode=0)
		begin
			exec proc2 @code,'hello',9452,@errorcode out,@errormsg out
			if(@errorcode=0)
				begin
					commit tran
					print('commit')
				end
			else
				begin
					rollback tran
				end
		end
	end try
	begin catch
		rollback tran
		print ('execute Time Error')
	end catch


select * from table1

select * from table2

---update proc
create or alter proc update_proc
@code int, 
@errorcode int out,
@errormsg nvarchar(50) out
as
	begin
		begin try
			if exists(select * from table1 where table1.Code=@code)
				begin
					update  table1 set Sname='update thai gyu' where Code=@code;			
				end
			else
				print('data not found')
		end try
		begin catch
			set @errorcode=ERROR_NUMBER()
			set @errormsg=ERROR_MESSAGE()
		end catch
	end
--exicute

declare @code int=0
declare @errorcode int=0 
declare @errormsg nvarchar(50)

begin tran 
	begin try
		exec proc1 @code out,'hello',975,@errorcode out,@errormsg out
		if(@errorcode=0)
		begin
			exec update_proc  1,@errorcode out,@errormsg out
			if(@errorcode=0)
				begin
					commit tran
					print('commit')
				end
			else
				begin
					rollback tran
				end
		end
	end try
	begin catch
		rollback tran
		print ('execute Time Error')
	end catch

	delete from table1
	delete from table2
	select * from table1
	select * from table2

	----delete
	create or alter proc delete_proc
	@code int=0, 
	@errorcode int out,
	@errormsg nvarchar(50)

	as
		begin
			begin try
				if exists(select * from table1 where table1.Code=@code)
				begin
					delete from table1 where @code=Code
				end
			end try
			begin catch
				set @errorcode=ERROR_NUMBER()
				set @errormsg=ERROR_MESSAGE()
			end catch
		end

		---exicute delete 

declare @code int
declare @errorcode int
declare @errormsg nvarchar(50)

begin tran 
	begin try
		exec proc1 @code out,'delete',455,@errorcode out,@errormsg out
		if(@errorcode=0)
		begin
			exec delete_proc  2,@errorcode out,@errormsg out
			if(@errorcode=0)
				begin
					commit tran
					print('commit')
				end
			else
				begin
					rollback tran
					print('rollback')
				end
		end
	end try
	begin catch
		rollback tran
		print ('execute Time Error')
	end catch


	select * from table1
	select * from table2
