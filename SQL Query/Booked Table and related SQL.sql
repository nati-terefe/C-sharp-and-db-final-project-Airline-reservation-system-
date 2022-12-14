use AirlineReservation -- Using AirlineReservation Databse

-- --------------------------------------------------------------------------------------------------------------------------------

-- Creating bookedtickets table that stores booked tickets information
create table bookedtickets(
id int primary key Identity(1,1),
usrname varchar(20) default null,
fname varchar(20) not null,
lname varchar(20) not null,
age varchar(10) not null,
gender varchar(10) not null,
email varchar(80) not null,
passport varchar(20) not null unique,
dep varchar(30) not null,
dest varchar(30) not null FOREIGN KEY REFERENCES destinations(city),
depdate datetime not null,
fclass varchar(20) not null,
ftype varchar(20) not null,
price money not null,
fidref int FOREIGN KEY REFERENCES flights(id));

select * from bookedtickets

drop table bookedtickets

-- ----------------------------------------------------------------------------------------------------------------
-- Procedure on booked table --------------------------------------------------------------------------------------
GO
-- 1. Addbooking procedure that adds a new booked ticket in booked table
CREATE or ALTER PROCEDURE addbooking(
@usrname varchar(20)=null,
@fname varchar(20),
@lname varchar(20),
@age varchar(10),
@gender varchar(10),
@email varchar(80),
@passport varchar(20),
@dep varchar(30),
@dest varchar(30),
@depdate datetime,
@fclass varchar(20),
@ftype varchar(20),
@price money,
@fidref int
)
AS
BEGIN
Insert into bookedtickets
values(@usrname,@fname,@lname,@age,@gender,@email,@passport,@dep,@dest,@depdate,@fclass,@ftype,@price,@fidref);
END

-- ------------------------------------------------------------------------------------

GO
-- 2. full booking info procedure that returns the full booking information of a ceratin ticket id
CREATE or ALTER PROCEDURE fullbookinginfo(
@ticketid int,
@usrname varchar(20) OUTPUT,
@fname varchar(20) OUTPUT,
@lname varchar(20) OUTPUT,
@age varchar(10) OUTPUT,
@gender varchar(10) OUTPUT,
@email varchar(80) OUTPUT,
@passport varchar(20) OUTPUT,
@dep varchar(30) OUTPUT,
@dest varchar(30) OUTPUT,
@depdate datetime OUTPUT,
@fclass varchar(20) OUTPUT,
@ftype varchar(20) OUTPUT,
@price money OUTPUT,
@fidref int OUTPUT
)
AS
Begin
Select @usrname=usrname ,@fname=fname,@lname=lname,@age=age,@gender=gender,@email=email,@passport=passport,@dep=dep,@dest=dest ,@depdate=depdate,@fclass=fclass ,@ftype=ftype ,@price=price,@fidref=fidref 
from bookedtickets where id=@ticketid
End

select * from bookedtickets

-- ------------------------------------------------------------------------------------

GO
-- 3. Updatebooking procedure that updates changes on booked ticket in booked table
CREATE or ALTER PROCEDURE updatebooking(
@ticketid int,
@fname varchar(20),
@lname varchar(20),
@age varchar(10),
@gender varchar(10),
@email varchar(80),
@passport varchar(20),
@dep varchar(30),
@dest varchar(30),
@depdate datetime,
@fclass varchar(20),
@ftype varchar(20),
@price money,
@fidref int
)
AS
BEGIN
Update bookedtickets
SET fname=@fname,lname=@lname,age=@age,gender=@gender,email=@email,passport=@passport,dep=@dep,dest=@dest,depdate=@depdate,fclass=@fclass,ftype=@ftype,price=@price,fidref=@fidref where id=@ticketid
END

select * from bookedtickets

-- ------------------------------------------------------------------------------------

GO
-- 4. deletebooking procedure that deletes booking info of certain id
CREATE or ALTER PROCEDURE deletebooking(
@ticketid int
)
AS
BEGIN
declare @fid int
select @fid=fidref from bookedtickets where id=@ticketid
delete from bookedtickets where id=@ticketid
update flights
set availseat=availseat+1 where id=@fid
END

select * from bookedtickets


-- ------------------------------------------------------------------------------------

GO
-- 5. bookinghisofusr procedure that returns booking history of certain username
CREATE or ALTER PROCEDURE bookinghisofusr(
@usrname varchar(20)
)
AS
BEGIN
select * from bookedtickets where usrname=@usrname
END


-- ---------------------------------------------------------------------------------------------------------------
-- Function on booked table --------------------------------------------------------------------------------------
GO
-- 1. Last ticket function that returns the last id inserted in booked table
create or alter function lastticketid()
returns int
as
begin
declare @last int
select @last=max(id) from bookedtickets
if(@last=null)
	BEGIN
		set @last=0
	END
return (@last)
end

select dbo.lastticketid()

-- ------------------------------------------------------------------------------------

GO
-- 2. Ticket exist function that returns if a ticket exists
CREATE FUNCTION ticketexist(
@ticketid int)
returns int
as
begin
declare @exist int
select @exist=count(*) from bookedtickets where id=@ticketid
return @exist
end

-- ------------------------------------------------------------------------------------

GO
-- 3. how much paid function that returns how much was paid for a ticket
create function howmuchpaid(
@ticketid int)
returns float
as
begin
declare @price float
set @price=Convert(float,(select price from bookedtickets where id=@ticketid))
return @price
end

select dbo.howmuchpaid(2)

-- ------------------------------------------------------------------------------------

GO
-- 4. Is Ticket Yours function that checks if a ticket is booked by a certain username
create function isticketyours(
@ticketid int, 
@usrname varchar(30))
returns int
as
begin
declare @match int
select @match=count(*) from bookedtickets where id=@ticketid and usrname=@usrname
return @match
end

select dbo.isticketyours(2, 'Non-USER' )

select * from bookedtickets