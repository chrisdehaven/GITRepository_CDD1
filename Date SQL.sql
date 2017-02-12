--First Day in Month

SELECT      DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0),
            'First Day of Previous Month'
UNION ALL
SELECT      DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, GETDATE())) - 1),
            DATEADD(MONTH, -1, GETDATE())),
            'First Day of Previous Month (2)'
UNION ALL
SELECT      DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),
            'First Day of Current Month'
UNION ALL
SELECT      DATEADD(DAY, -(DAY(GETDATE()) - 1), GETDATE()),
            'First Day of Current Month (2)'
UNION ALL
SELECT      DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0),
            'First Day of Next Month'
UNION ALL
SELECT      DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, GETDATE())) - 1),
            DATEADD(MONTH, 1, GETDATE())),
            'First Day of Next Month (2)'




--Last Day In Month
            
SELECT      DATEADD(DAY, -(DAY(GETDATE())), GETDATE()),
            'Last Day of Previous Month'
UNION ALL
SELECT      DATEADD(MILLISECOND, -3,
            DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)),
            'Last Day of Previous Month (2)'
UNION ALL
SELECT      DATEADD(DAY, -(DAY(DATEADD(MONTH, 1, GETDATE()))),
            DATEADD(MONTH, 1, GETDATE())),
            'Last Day of Current Month'
UNION ALL
SELECT      DATEADD(MILLISECOND, -3,
            DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)),
            'Last Day of Current Month (2)'
UNION ALL
SELECT      DATEADD(DAY, -(DAY(DATEADD(MONTH,0,GETDATE()))),
            DATEADD(MONTH, 2, GETDATE())),
            'Last Day of Next Month'
UNION ALL
SELECT      DATEADD(SECOND, -1,
            DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 2, 0)),
            'Last Day of Next Month (2)'