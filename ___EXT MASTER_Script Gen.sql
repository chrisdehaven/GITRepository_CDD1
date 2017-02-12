TPTST
----------
Table: EXT00100 - No Blank Keys exist.
 
Table: EXT00100 - Missing Keys exists from the EXT00103. Run the following scripts and return the results to eOne for further review:  
				
				select 'insert into TPTST..EXT00100 Values ('''+rtrim(a.PT_Window_ID)+''','''+rtrim(a.PT_UD_Key)+''','''+rtrim(a.PT_UD_Key)+''','''+''','''+''','''+''','''+''')' 
					from TPTST.dbo.EXT00103 a LEFT OUTER JOIN TPTST.dbo.EXT00100 b on b.PT_Window_ID=a.PT_Window_ID and b.PT_UD_Key=a.PT_UD_Key where b.PT_UD_Key is NULL								
				
				select a.PT_Window_ID, a.FIELDNAM from TPTST.dbo.EXT40101 a LEFT OUTER JOIN TPTST.dbo.EXT00103 b on a.PT_Window_ID=b.PT_Window_ID 
					LEFT OUTER JOIN TPTST.dbo.EXT00100 c on b.PT_Window_ID=c.PT_Window_ID and b.PT_UD_Key=c.PT_UD_Key where c.PT_UD_Key is NULL
 
Table: EXT00151 - No Blank Keys exist.
 
Table: EXT00180 - There are no Missing Keys.
 
Table: EXT00185 - No Blank Keys exist.
 
Table: EXT00185 - There are no Missing Keys.
 
Table: EXT00200 - No Blank Keys exist.
 
Table: EXT00200 - Missing Keys exists from the EXT00201, EXT00202 and EXT00203. Run the following script and return the results to eOne for further review:  
				
				select a.Extender_Form_ID, b.UD_Form_Field_ID from TPTST.dbo.EXT40300 a LEFT OUTER JOIN TPTST.dbo.EXT00201 b on a.Extender_Form_ID=b.Extender_Form_ID 
					LEFT OUTER JOIN TPTST.dbo.EXT00200 c on b.Extender_Form_ID=c.Extender_Form_ID and b.UD_Form_Field_ID=c.UD_Form_Field_ID where c.UD_Form_Field_ID is NULL
 
Table: EXT00500 - No Blank Keys exist.
 
Table: EXT00500 - There are no Missing Keys.
 
Table: EXT00700 - No Blank Keys exist.
 
Table: EXT00700 - Missing Keys exists from the EXT00701. Run the following script and return the results to eOne for further review:  
		
		select a.Extender_Form_ID, b.UD_Form_Field_ID from TPTST.dbo.EXT43100 a LEFT OUTER JOIN TPTST.dbo.EXT00701 b on a.Extender_Form_ID=b.Extender_Form_ID 
			LEFT OUTER JOIN TPTST.dbo.EXT00700 c on b.Extender_Form_ID=c.Extender_Form_ID and b.UD_Form_Field_ID=c.UD_Form_Field_ID where c.UD_Form_Field_ID is NULL
 
Table: EXT00750 - No Blank Keys exist.
 
Table: EXT00750 - Missing Keys exists from the EXT00721. Run the following script and return the results to eOne for further review:  
		
		select a.Extender_Form_ID, b.UD_Form_Field_ID, b.LNITMSEQ from TPTST.dbo.EXT43100 a LEFT OUTER JOIN TPTST.dbo.EXT00721 b on a.Extender_Form_ID=b.Extender_Form_ID 
			LEFT OUTER JOIN TPTST.dbo.EXT00750 c on b.Extender_Form_ID=c.Extender_Form_ID and b.UD_Form_Field_ID=c.UD_Form_Field_ID and c.LNITMSEQ=b.LNITMSEQ where c.UD_Form_Field_ID is NULL
 
