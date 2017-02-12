--Assign All Items to All Locations

use gican	 

DECLARE
   @item varchar (100) , 
   @loc varchar (100) , 
   @ItemExist int;

DECLARE TablePositionCursor CURSOR
    FOR SELECT itemnmbr
          FROM IV00101 i;
 
OPEN TablePositionCursor;
FETCH NEXT FROM TablePositionCursor INTO @item;
WHILE @@fetch_status
      <>
      -1
    BEGIN

        DECLARE TablePositionCursor2 CURSOR
            FOR SELECT locncode
                  FROM IV40700
                  WHERE LOCNCODE IN ('0IN', '0CA', '2CA', '1IN', '3CA',
'3T1', '2IN', '3IN', '1CA', '0GA', '1GA', '2GA', '0OR', '1OR', '2OR',
'0TX', '1TX', '2TX', '0VA', '1VA', '2VA', '3OR', '3TX','5TX', '3GA', '3VA',
'5IN', '5CA', '0MT', '1MT', '2MT', '3MT', '5MT') ; 


        OPEN TablePositionCursor2;
        FETCH NEXT FROM TablePositionCursor2 INTO @loc;
        WHILE @@fetch_status
              <>
              -1
            BEGIN

                SELECT @ItemExist=ISNULL (COUNT (*) , 0)
                  FROM IV00102
                  WHERE ITEMNMBR=@item
                    AND LOCNCODE=@loc;

                IF @ItemExist=0
                    BEGIN
                        INSERT INTO iv00102
                        VALUES (@item, 
                                @loc, 
                                '', 
                                2, 
                                '', 
                                0, 
                                0, 
                                0, 
                                0, 
                                '01/01/1900', 
                                '', 
                                '01/01/1900', 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                '01/01/1900', 
                                '01/01/1900', 
                                '01/01/1900', 
                                '01/01/1900', 
                                0, 
                                '', 
                                '', 
                                '', 
                                1, 
                                0, 
                                0, 
                                1, 
                                0, 
                                0, 
                                1, 
                                2, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                0, 
                                1, 
                                0, 
                                0, 
                                0, 
                                3, 
                                0, 
                                0, 
                                0, 
                                '', 
                                '', 
                                '', 
                                '', 
                                '', 
                                '', 
                                '', 
                                '', 
                                1, 
                                1, 
                                '', 
                                1, 
                                1, 
                                0, 
                                1, 
                                1, 
                                1, 
                                0, 
                                0, 
                                0, 
                                0 ,
                                0,
                                0
                                
                                ) ;
                    END;
                FETCH NEXT FROM TablePositionCursor2 INTO @loc;
            END;
        DEALLOCATE TablePositionCursor2;

        FETCH NEXT FROM TablePositionCursor INTO @item;
    END;
DEALLOCATE TablePositionCursor;
 

 