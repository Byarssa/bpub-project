CREATE SCHEMA BPUB;
USE BPUB;

CREATE TABLE COURSE
(COURSENUM varchar(15) not null,
COURSETITLE varchar(50) not null,
INSTRUCTORFNAME varchar(35) not null,
INSTRUCTORLNAME varchar(35) not null,
CONSTRAINT COURSE_PK Primary Key (COURSENUM));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Course.csv' INTO TABLE COURSE FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE BOOK
(ISBN varchar(13) not null,
TITLE varchar(50) not null,
EDITION numeric(2) not null,
AUTHORFNAME varchar(50) not null,
AUTHORLNAME varchar (50) not null,
AUTHORSUFFIX varchar(5),
COURSENUM varchar(15) not null,
CONSTRAINT BOOK_PK Primary Key (ISBN),
CONSTRAINT BOOK_FK Foreign Key (COURSENUM) References COURSE (COURSENUM));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Book.csv' INTO TABLE BOOK FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE BOOKCOPY
(SSID varchar(11) not null,
ISBN varchar(13) not null,
ASKINGPRICE decimal (4,2) not null,
DATECONTRACTED date,
BOOKTYPE char (1) not null,
CONSTRAINT BOOKCOPY_PK Primary Key (SSID, ISBN));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Book_Copy.csv' INTO TABLE BOOKCOPY FIELDS TERMINATED BY ',' ENCLOSED BY '"'LINES terminated by '\r\n' IGNORE 1 LINES
(SSID,ISBN,@var1,@var2,BOOKTYPE)
SET ASKINGPRICE = replace(@var1, '$',''),
DATECONTRACTED = str_to_date(@var2, '%m/%d/%Y');

CREATE TABLE STUDENT
(SID varchar(11) not null,
STUDENTFNAME varchar (50) not null,
STUDENTLNAME varchar (50) not null,
STUDENTSUFFIX varchar (3),
SSTREET varchar (255) not null,
SCITY varchar (255) not null,
SSTATE char (2) not null,
SZIP numeric (5) not null,
SELLER boolean not null,
BUYER boolean not null,
CONSTRAINT STUDENT_PK Primary Key (SID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Student.csv' INTO TABLE STUDENT FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE SELLER
(SSID varchar(15) not null,
CONSTRAINT SELLER_PK Primary Key (SSID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Seller.csv' INTO TABLE SELLER FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE BUYER
(BSID varchar(11) not null,
CONSTRAINT BUYER_PK Primary Key (BSID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Buyer.csv' INTO TABLE BUYER FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE DISTRIBUTOR
(DID varchar(5),
DNAME varchar (100),
DSTREET varchar (100),
DCITY varchar (35),
DSTATE char (5),
DZIP varchar (5),
CONSTRAINT DISTRIBUTOR_PK Primary Key (DID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Distributor.csv' INTO TABLE DISTRIBUTOR FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

CREATE TABLE UNRETRIEVEDBOOK
(SUID varchar(11) not null,
ISBN varchar(13) not null,
SELLINGPRICE decimal(5,2) not null,
DID varchar(5) not null,
CONSTRAINT UNRETRIEVEDBOOK_PK Primary Key (SUID, ISBN),
CONSTRAINT UNRETRIEVEDBOOK_FK Foreign Key (DID) References DISTRIBUTOR(DID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Unretrieved_Book.csv' INTO TABLE UNRETRIEVEDBOOK FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES
(SUID,ISBN, @var1, DID)
SET SELLINGPRICE = replace(@var1, '$','');

CREATE TABLE RETRIEVEDBOOK
(SRBID varchar(11) not null,
ISBN varchar(13) not null,
DATERETRIEVED date not null,
CONSTRAINT RETRIEVEDBOOK_PK Primary Key (SRBID, ISBN));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Retrieved_Book.csv' INTO TABLE RETRIEVEDBOOK FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES
(SRBID,ISBN,@var1)
SET DATERETRIEVED = str_to_date(@var1, '%m/%d/%Y');

CREATE TABLE PAYMENT
(CHECKNUM varchar (5) not null,
PAYMENTDATE date not null,
SSID varchar(15) not null,
CONSTRAINT PAYMENT_PK Primary Key (CHECKNUM),
CONSTRAINT PAYMENT_FK Foreign Key (SSID) References SELLER(SSID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Payment.csv' INTO TABLE PAYMENT FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES
(CHECKNUM,@var1,SSID)
SET PAYMENTDATE = str_to_date(@var1, '%m/%d/%Y');

CREATE TABLE SALE
(SALENUM varchar(5) not null, 
SALEDATE date not null,
BSID varchar(11) not null,
CONSTRAINT SALE_PK Primary Key (SALENUM),
CONSTRAINT SALE_FK Foreign Key (BSID) References BUYER(BSID));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Sale.csv' INTO TABLE SALE FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES
(SALENUM,@var1,BSID)
SET SALEDATE = str_to_date(@var1, '%m/%d/%Y');

CREATE TABLE SOLDBOOK
(SSBID varchar(11) not null,
ISBN varchar(13) not null,
CHECKNUM varchar(5) not null,
SALENUM varchar(5) not null,
CONSTRAINT SOLDBOOK_PK Primary Key (SSBID, ISBN),
CONSTRAINT SOLDBOOK_FK1 Foreign Key (CHECKNUM) References PAYMENT(CHECKNUM),
CONSTRAINT SOLDBOOK_FK2 Foreign Key (SALENUM) References SALE(SALENUM));

LOAD DATA LOCAL INFILE 'C:/Users/Steven/Dropbox/BPUB Project/CSV Files/Sold_Book.csv' INTO TABLE SOLDBOOK FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES terminated by '\r\n' IGNORE 1 LINES;

UPDATE UnretrievedBook SET SUID = '223-74-9855' WHERE SUID = '223-74-9845';
UPDATE BookCopy SET SSID = '556-10-2389' WHERE SSID = '556-102389';