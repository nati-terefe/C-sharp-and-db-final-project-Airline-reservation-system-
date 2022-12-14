use AirlineReservation -- Using AirlineReservation Databse

-- --------------------------------------------------------------------------------------------------------------------------------

-- Creating contact messages table that stores users message information
create table contactmessages(
fname varchar(20) not null,
lname varchar(20) not null,
email varchar(80) not null,
suggetion varchar(1000) not null,
sugdate datetime
)

-- Initial Data to fill contactmessages table
Insert into contactmessages(fname, lname, email, suggetion, sugdate)
values('Abebe','Kebede', 'abekebe@gmail.com', 'I like It', FORMAT (getdate(), 'yyyy-MM-dd HH:mm:ss'));

select * from contactmessages

drop table contactmessages

-- --------------------------------------------------------------------------------------------------------
-- Stored Procedures for contactmessage table -------------------------------------------------------------

GO
-- 1. add message stored procedure that insert new message
CREATE or ALTER PROCEDURE addmessage(
@fname varchar(20),
@lname varchar(20),
@email varchar(80),
@suggetion varchar(1000)
)
AS
BEGIN
Insert into contactmessages(fname,lname,email,suggetion,sugdate)
values(@fname,@lname,@email,@suggetion,FORMAT (getdate(), 'yyyy-MM-dd HH:mm:ss'));
END

select * from contactmessages

-- --------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------------------------------------------------

GO
-- backupdb stored procedure that backup databse full or differential
CREATE OR ALTER PROCEDURE backupdb(
@full int,
@backuploc varchar(1000)
)
as
begin
DECLARE @backupdate varchar(30) 
DECLARE @backupname varchar(1000)
set @backupdate=FORMAT (getdate(), 'dd-mm-yyyy hh_mm_ss-tt')
if (@full=0)
	BEGIN
		SET @backuploc += '\Differential Airline Reservation System DB Backup - '
		SET @backupname=CONCAT(@backuploc, @backupdate, ' .bak')
		BACKUP DATABASE AirlineReservation
		TO DISK =  @backupname
		WITH DIFFERENTIAL;
	END
else if (@full=1)
	BEGIN
		SET @backuploc +='\Full Airline Reservation System DB Backup - '
		SET @backupname=CONCAT(@backuploc, @backupdate, '.bak')
		BACKUP DATABASE AirlineReservation
		TO DISK = @backupname
	END
END

Execute backupdb 0, 'C:\Users\redie\Desktop\Airline Reservation System Database Backup'
Execute backupdb 1, 'C:\Users\redie\Desktop\Airline Reservation System Database Backup'
