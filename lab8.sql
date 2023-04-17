SET SERVEROUTPUT ON;

----Part 1 Yu Lee
DECLARE
    TYPE bookRecord IS RECORD
    (
        bookId NUMBER(38,0),
        name VARCHAR2(90 BYTE),
        pagecount NUMBER(38,0),
        point NUMBER(38,0),
        authorId NUMBER(38,0),
        typeId NUMBER(38,0)
    );
    
    bookInstance bookRecord;
BEGIN
    bookInstance.bookID:=200;
    bookInstance.name:= 'A Thousand Miles Up the Nile';
    bookInstance.pagecount:=250;
    bookInstance.point:=67;
    bookInstance.authorId:=6;
    bookInstance.typeId:=12;
    
    INSERT INTO BOOKS VALUES(
        bookInstance.bookID,
        bookInstance.name,
        bookInstance.pagecount,
        bookInstance.point,
        bookInstance.authorId,
        bookInstance.typeId
        );
        COMMIT;
END;
/
DECLARE 
    TYPE studentRecord IS RECORD
    (
        studentId NUMBER(38,0),
        name VARCHAR2(20 BYTE),
        surname VARCHAR2(20 BYTE),
        birthdate DATE,
        gender VARCHAR2(10 BYTE),
        class VARCHAR2(7 BYTE),
        point NUMBER(38,0)
   );
   
   studentInstance studentRecord;
BEGIN
    studentInstance.studentID:=600;
    studentInstance.name:='Londy';
    studentInstance.surname:='Scott';
    studentInstance.birthdate:= '25-MAY-99';
    studentInstance.gender:='F';
    studentInstance.class:='10E';
    studentInstance.point:=122;
    
    
    INSERT INTO SUBSCRIBER_STUDENTS VALUES(
        studentInstance.studentId,
        studentInstance.name,
        studentInstance.surname,
        studentInstance.birthdate,
        studentInstance.gender,
        studentInstance.class,
        studentInstance.point
        );
    
    COMMIT;
END;
/

----PART 2 Yu Lee
CREATE OR REPLACE TYPE BODY studentObj2 AS
    MEMBER FUNCTION Count_Num_of_Borrowed_Books RETURN INT IS
        books_count INT := 0;
    BEGIN
        BEGIN
            SELECT COUNT(borrows.borrowID) INTO books_count
                FROM borrows INNER JOIN subscriber_students
                ON subscriber_students.studentid = borrows.studentid
                WHERE borrows.studentid = self.studentID
                GROUP BY name;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                books_count := 0;
        END;
        RETURN books_count;
    END;

    MEMBER PROCEDURE List_Student_Info IS
    num_borrowed_books INT := 0;
BEGIN
    num_borrowed_books := Count_Num_of_Borrowed_Books();
    DBMS_OUTPUT.PUT_LINE('Student ID:  ' || RPAD(self.studentID,20) || '-' || 'Name: ' || RPAD(self.name, 20) || '-' || 'Surname: ' ||RPAD(self.surname, 20) || '-' || 'Class: ' ||RPAD(self.class, 20) || '-' || 'Number of borrowed books: ' ||num_borrowed_books);
END;

END;
/




----Part 3 Yu Lee
CREATE OR REPLACE TYPE studentTableObj AS TABLE OF studentObj2;
/
DECLARE
    studentTableInstance studentTableObj := studentTableObj();
    num_borrowed_books INT := 0;
BEGIN
    SELECT studentObj2(studentID, name, surname, birthdate, gender, class, point)
    BULK COLLECT INTO studentTableInstance
    FROM subscriber_students;
    
    FOR i IN studentTableInstance.FIRST..studentTableInstance.LAST LOOP
        num_borrowed_books := studentTableInstance(i).Count_Num_of_Borrowed_Books();
        IF (num_borrowed_books > 20) THEN
            studentTableInstance(i).List_Student_Info();
        END IF;
    END LOOP;
END;
/

--hi



        
        
    