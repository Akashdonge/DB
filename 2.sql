CREATE TABLE Supplier (
    SID NUMBER PRIMARY KEY,
    SNAME VARCHAR2(50),
    SADDR VARCHAR2(100)
);

CREATE TABLE Part (
    PID NUMBER PRIMARY KEY,
    PNAME VARCHAR2(50),
    PCOLOR VARCHAR2(20)
);

CREATE TABLE Shipment (
    ShipmentID NUMBER PRIMARY KEY,
    SID NUMBER,
    PID NUMBER,
    Quantity NUMBER,
    FOREIGN KEY (SID) REFERENCES Supplier(SID) ON DELETE CASCADE,
    FOREIGN KEY (PID) REFERENCES Part(PID) ON DELETE CASCADE
);

INSERT INTO Supplier VALUES (1, 'Supplier A', '123 Main St');
INSERT INTO Supplier VALUES (2, 'Supplier B', '456 Elm St');

INSERT INTO Part VALUES (101, 'Part X', 'Red');
INSERT INTO Part VALUES (102, 'Part Y', 'Blue');

INSERT INTO Shipment VALUES (1001, 1, 101, 50);
INSERT INTO Shipment VALUES (1002, 2, 102, 30);

1.Obtain the details of parts supplied by supplier #SNAME.
SELECT p.*
FROM Part p
JOIN Shipment s ON p.PID = s.PID
JOIN Supplier sup ON s.SID = sup.SID
WHERE sup.SNAME = 'Supplier A';

2.Obtain the Names of suppliers who supply #PNAME.
SELECT sup.SNAME
FROM Supplier sup
JOIN Shipment s ON sup.SID = s.SID
JOIN Part p ON s.PID = p.PID
WHERE p.PNAME = 'Part X';

3.Delete the parts which are in #PCOLOR.
DELETE FROM Part
WHERE PCOLOR = :PCOLOR;

#Mongo DB
>db.createCollection("warehouse1")
>db.warehouse1.insertOne({"P_ID":1947,"P_Name":'bolts',"Colour":'black',"S_No":1234,"S_Name":'
ABC',"Address":'bangaluru'})
>db.warehouse1.insertOne({"P_ID":2867,"P_Name":'nuts',"Colour":'grey',"S_No":5678,"S_Name":'X
YZ',"Address":'davangere'})
>db.warehouse1.insertOne({"P_ID":9462,"P_Name":'screw',"Colour":'green',"S_No":6320,"S_Name"
:'LKF',"Address":'hubli'})
>db.warehouse1.updateOne({"P_ID":1947}, {$set: {"P_ID":8888}})
>db.warehouse1.find().pretty()
>db.warehouse1.find({"P_ID":9462}).pretty()


    
create table part1(pno int,pname char(20),colour char(20),primary key(pno)); 
create table copy_part1(pno int,pname char(20),colour char(20),primary key(pno)); 
create table shipment (ShipmentID int, pno int, QuantityShipped int,primary 
key(ShipmentID),foreign key(pno) references part1(pno)); 
 
insert into part1 values(10,'nuts','black'); 
insert into part1 values(20,'bolts','grey'); 
insert into part1 values(30,'screw','green'); 
 
insert into shipment values(1,10,100); 
insert into shipment values (2,20,200); 
insert into shipment values(3,30,300); 
 
SET SERVEROUTPUT ON;

DECLARE 
    CURSOR curr IS 
        SELECT * FROM part1;

    CURSOR shipments_cursor IS 
        SELECT shipmentid, pno, quantityshipped 
        FROM shipment;

    counter INT;
    rows part1%ROWTYPE; 
BEGIN 
    -- Copy data from part1 to copy_part1
    OPEN curr; 
    LOOP 
        FETCH curr INTO rows; 
        EXIT WHEN curr%NOTFOUND; 
        INSERT INTO copy_part1 VALUES(rows.pno, rows.pname, rows.colour); 
    END LOOP; 
    counter := curr%ROWCOUNT; 
    CLOSE curr; 
    DBMS_OUTPUT.PUT_LINE(counter || ' rows inserted into the table copy_part1'); 

    -- Update the shipment quantities
    FOR shipment IN shipments_cursor LOOP 
        UPDATE shipment 
        SET quantityshipped = quantityshipped * 1.05 
        WHERE shipmentid = shipment.shipmentid; 
    END LOOP; 

    DBMS_OUTPUT.PUT_LINE('Update complete.'); 
END; 
/

