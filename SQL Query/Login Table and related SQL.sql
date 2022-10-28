create database AirlineReservation -- Creating Database

use AirlineReservation -- Using AirlineReservation Databse

-- --------------------------------------------------------------------------------------------------------------------------------

-- Creating login table that stores login information
create table login(
usrname varchar(20),
passwd varchar(20),
rol int,
registerationid int foreign key references registered(id),
);

-- Initial Datas to fill login table are done from C-Sharp by sign up

select * from login

drop table login

-- Stored Procedures for login table ----------------------------------------------------------------------------------------------

GO
-- 1. What role stored procedure that returns the role of a certain usename and password
CREATE or ALTER PROCEDURE whatrole(
@usrname varchar(20),
@passwd varchar(20),
@roleis int OUTPUT
)
AS
BEGIN
if(EXISTS(select * from login where usrname=@usrname and passwd=@passwd))
	select @roleis=rol from login where usrname=@usrname and passwd=@passwd
else 
	set @roleis=0
END

declare @role int
execute whatrole 'subadmin', 'subadmin', @role OUTPUT;
select @role

-- ------------------------------------------------------------------------------------

GO
-- 2. user exist stored procedure that returns the existance of a certain usename
CREATE or ALTER PROCEDURE userexist(
@usrname varchar(20),
@exist int OUTPUT
)
AS
BEGIN
select @exist=count(*) from login where usrname=@usrname
END

declare @existance int
execute userexist 'admin', @existance OUTPUT;
select @existance

-- ------------------------------------------------------------------------------------

GO
-- 4. registrylogin stored procedure that creates a login for a register
CREATE or ALTER PROCEDURE registrylogin(
@usrname varchar(20),
@passwd varchar(20),
@rol int
)
AS
BEGIN
declare @refid int
select @refid=id from registered where usrname=@usrname
Insert into login values(@usrname, @passwd, @rol, @refid)
END

select * from registered
select * from login

-- ------------------------------------------------------------------------------------

GO
-- 5. Set new password stored procedure that updates new password when forgot password
CREATE or ALTER PROCEDURE setnewpasswd(
@usrname varchar(20),
@newpasswd varchar(20)
)
AS
BEGIN
update login set passwd=@newpasswd where usrname=@usrname
END

execute setnewpasswd 'admin', 'admin';

select * from login

-- ------------------------------------------------------------------------------------

GO
-- 6. Set new role stored procedure that updates new role when role change
CREATE or Alter PROCEDURE setnewrole(
@usrname varchar(20),
@newrole int
)
AS
BEGIN
update login set rol=@newrole where usrname=@usrname
END

execute setnewrole 'subadmin', '2';

select * from login


