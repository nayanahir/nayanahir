alter table mstaddressdetail add sequenceno int null

--1)create sequenceno using select
select mstAddressDetail.Code,
		mstAddressDetail.HeaderCode,
		mstAddressDetail.sequenceno,
		(
			select count(*)
			from mstAddressDetail as aliasdetail
			where aliasdetail.HeaderCode=mstAddressDetail.HeaderCode
			and aliasdetail.code <= mstAddressDetail.Code
		)
from mstAddressDetail
order by HeaderCode,code

--2)create sequenceno using update
update mstAddressDetail
	set mstaddressdetail.sequenceno = (
		select count(*)
			from mstAddressDetail as aliasdetail
			where aliasdetail.HeaderCode=mstAddressDetail.HeaderCode
			and aliasdetail.code <= mstAddressDetail.Code
		)


--3)drop sequence and create again sequence no using cursor
-- declare cursor
DECLARE cursor_mstAddressDetail CURSOR FOR
	select Code,HeaderCode,sequenceno
		from mstAddressDetail
			order by HeaderCode,code
-- open cursor
OPEN cursor_mstAddressDetail
 
-- loop through a cursor
FETCH NEXT FROM cursor_mstAddressDetail 
WHILE (@@FETCH_STATUS = 0)
    BEGIN
		update mstAddressDetail
	set mstaddressdetail.sequenceno = (
		select count(*)
			from mstAddressDetail as aliasdetail
			where aliasdetail.HeaderCode=mstAddressDetail.HeaderCode
			and aliasdetail.code <= mstAddressDetail.Code
		)
		
    FETCH NEXT FROM cursor_mstAddressDetail
    END;
 
-- close and deallocate cursor
CLOSE cursor_mstAddressDetail
DEALLOCATE cursor_mstAddressDetail


-------------------------------










declare @code int
declare @headercode int
declare @previous_header int = 0
declare @sequ_no int = 1
declare @obj_type int 

DECLARE cursor_mstAddress CURSOR FOR
	select Code,HeaderCode,mstAddressDetail.ObjectType
		from mstAddressDetail
	where mstAddressDetail.ObjectType=1 
	order by HeaderCode
OPEN cursor_mstAddress
 
		FETCH NEXT FROM cursor_mstAddress into @code, @headercode
WHILE (@@FETCH_STATUS = 0)
    BEGIN

		if (@previous_header=@headercode and @previous_header=@obj_type)
				set @sequ_no += 1
		else
				set @sequ_no = 1
	update mstAddressDetail
		set mstAddressDetail.sequenceno = @sequ_no
			where mstAddressDetail.Code = @code
	set @previous_header=1
		FETCH NEXT FROM cursor_mstAddress into @code, @headercode
	END
CLOSE cursor_mstAddress
DEALLOCATE cursor_mstAddress
 
 select * from  mstAddressDetail

