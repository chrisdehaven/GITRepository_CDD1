USE TPSPT;
GO

DECLARE @item      VARCHAR(100)
      , @loc       VARCHAR(100)
      , @ItemExist INT;

DECLARE TablePositionCursor CURSOR
FOR SELECT itemnmbr
    FROM IV00101 i;

OPEN TablePositionCursor;

FETCH NEXT FROM TablePositionCursor INTO @item;

WHILE @@fetch_status<>-1
BEGIN
DECLARE TablePositionCursor2 CURSOR
FOR SELECT locncode
    FROM IV40700
    WHERE LOCNCODE IN('9D1'
                    , '3CA'
                    , '3GA'
                    , '3IL'
                    , '3OR'
                    , '3TX'
                    , '3VA'
                    , '5CA'
                    , '6P5'
                    , '2IN'
                    , '5GA'
                    , '5IN'
                    , '2VA'
                    , '1IN'
                    , '1GA'
                    , '1MT'
                    , '1TX'
                    , '1VA'
                    , '0CA'
                    , '0GA'
                    , '0IN'
                    , '0BR'
                    , '0MT'
                    , '0OR'
                    , '0TX'
                    , '0VA'
                    , '8IN'
                    , '3T1'
                    , '3T2'
                    , '9T1');
OPEN TablePositionCursor2;
FETCH NEXT FROM TablePositionCursor2 INTO @loc;
WHILE @@fetch_status<>-1
BEGIN
SELECT @ItemExist=ISNULL(COUNT(*), 0)
FROM IV00102
WHERE ITEMNMBR=@item
  AND LOCNCODE=@loc;
IF @ItemExist=0
BEGIN
INSERT INTO iv00102
VALUES(
@item, 
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
0,
0,
0
);
END;
FETCH NEXT FROM TablePositionCursor2 INTO @loc;
END;
DEALLOCATE TablePositionCursor2;
FETCH NEXT FROM TablePositionCursor INTO @item;
END;

DEALLOCATE TablePositionCursor;