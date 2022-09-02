--2
CREATE TABLE angajati
(
nume VARCHAR(15) NOT NULL,
prenume VARCHAR(20) NOT NULL,
nr_legitimatie NUMBER(6) PRIMARY KEY CHECK(nr_legitimatie >99999)
);
CREATE TABLE computer
(
nr_legitimatie NUMBER(6) REFERENCES angajati(nr_legitimatie),
descriere VARCHAR(40) NOT NULL,
nr_Inventar INTEGER PRIMARY KEY
);
CREATE TABLE licente
(
nr_Inventar INTEGER NOT NULL,
tip_licenta VARCHAR(30) NOT NULL,
produs VARCHAR(30) NOT NULL,
producator VARCHAR(30) NOT NULL,
valoare INTEGER,
document VARCHAR(40) NOT NULL
);
--3
SET AUTOCOMMIT ON;
SET SERVEROUTPUT ON;
SELECT sysdate FROM dual;
ALTER session SET nls_date_format=’DD-MM-YYYY’;
INSERT INTO angajati VALUES('popa', 'ion',123456);
INSERT INTO angajati VALUES('adam', 'gheorghe',123457);
INSERT INTO angajati VALUES('pop', 'george',123458);
INSERT INTO computer VALUES(123456, 'Pentium 4',1000);
INSERT INTO computer VALUES (123457, 'Athlon',1001);
INSERT INTO computer VALUES(123456, 'Celeron',1002);
INSERT INTO computer VALUES(123458, 'Celeron',1003);
INSERT INTO licente VALUES(1000, 'OEM', 'Windows XP', 'Microsoft', 500,'34/20.01.2006');
INSERT INTO licente VALUES(1001, 'Retail', 'Office XP', 'Microsoft', 1200,'234/11.01.2007');
INSERT INTO licente VALUES(1000, 'Free', 'openOffice’, 'XXX', 0, 'NA');
INSERT INTO licente VALUES(1002, 'OPEN', 'Windows 2000', 'Microsoft', 400,'23/02.02.2003');
INSERT INTO licente VALUES(1003, 'Free', '7zip’, 'XXX', 0, 'NA');

--4

CREATE or REPLACE procedure alocare(nr_leg integer, nr_inv integer)
AS
C1 integer;
C2 integer;
C3 integer;
D varchar(40) DEFAULT 'computer nou';
BEGIN
SELECT COUNT(nr_legitimatie) INTO C1 FROM angajati WHERE angajati.nr_legitimatie=nr_leg;
SELECT COUNT(nr_inventar) INTO C2 FROM computer WHERE computer.nr_Inventar=nr_inv;
IF length(nr_leg)=6 THEN
C3:=1;
ELSE
C3:=0;

END IF;
If C1=0 OR C2=1 OR C3=0 THEN
IF C1=0 THEN
DBMS_OUTPUT.PUT_LINE('Angajat inexistent');
END IF;
IF C2=1 THEN
DBMS_OUTPUT.PUT_LINE('Numar inventar este deja alocat!');
END IF;
IF C3=0 THEN
DBMS_OUTPUT.PUT_LINE('Numar legitimatie incorect!');
END IF;
ELSE
INSERT INTO computer VALUES(nr_leg,D,nr_inv);
DBMS_OUTPUT.PUT_LINE('Computer alocat!');
END IF;
END;
/
exec alocare(123456,2000) ;
exec alocare(999999,1000);


--5
SELECT producator, COUNT(*) as numar_licente, SUM(valoare) as
valoare_totala from licente
GROUP BY producator;

--6
SELECT producator, COUNT(*) as numar_licente, tip_licenta , SUM(valoare)
as valoare_totala from licente
GROUP BY producator, tip_licenta
ORDER BY producator, tip_licenta;

--7
CREATE or REPLACE trigger t BEFORE DELETE on computer
FOR EACH ROW
BEGIN
DELETE FROM licente WHERE :OLD.nr_inventar=licente.nr_inventar AND
tip_licenta='OEM';
END;
/
DELETE FROM computer WHERE nr_inventar=1000;

--8
CREATE or REPLACE function valoareTotala(p varchar)
RETURN integer as
v integer;
BEGIN
SELECT SUM(valoare) INTO v FROM licente WHERE produs=p;
RETURN v;
END;
/
select valoareTotala ('Office XP') from dual;


--9
SELECT c.nr_inventar, a.nume, a.prenume, a.nr_legitimatie, l.produs
FROM angajati a, computer c, licente l
WHERE a.nr_legitimatie=c.nr_legitimatie AND c.nr_inventar=l.nr_inventar
GROUP BY a.nume, a.prenume, a.nr_legitimatie, c.nr_inventar, l.produs
HAVING (produs NOT LIKE 'Office%' AND produs NOT LIKE 'Windows%');

--10
SELECT a.nume, a.prenume, a.nr_legitimatie, (SUM(l.valoare))as valoare_totala
FROM licente l, angajati a, computer c
WHERE a.nr_legitimatie=c.nr_legitimatie AND c.nr_inventar=l.nr_inventar
HAVING SUM(l.valoare)=(SELECT MAX(SUM(l.valoare)) FROM licente l, angajati a, computer c
WHERE a.nr_legitimatie=c.nr_legitimatie AND c.nr_inventar=l.nr_inventar
GROUP BY a.nume, a.prenume, a.nr_legitimatie)
GROUP BY a.nume, a.prenume, a.nr_legitimatie;