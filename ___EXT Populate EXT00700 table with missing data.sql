select a.Extender_Form_ID, b.UD_Form_Field_ID from TPTST.dbo.EXT43100 a LEFT OUTER JOIN TPTST.dbo.EXT00701 b on a.Extender_Form_ID=b.Extender_Form_ID 
			LEFT OUTER JOIN TPTST.dbo.EXT00700 c on b.Extender_Form_ID=c.Extender_Form_ID and b.UD_Form_Field_ID=c.UD_Form_Field_ID where c.UD_Form_Field_ID is NULL
 

INSERT INTO [TPTST].[dbo].[EXT00700]
           ([Extender_Form_ID]
           ,[UD_Form_Field_ID]
           ,[UD_Form_Field_Desc]
           ,[CREATDDT]
           ,[CRUSRID]
           ,[MDFUSRID]
           ,[MODIFDT]
           ,[NOTEINDX])
     VALUES
           (<Extender_Form_ID, char(15),>
           ,<UD_Form_Field_ID, char(15),>
           ,<UD_Form_Field_Desc, char(65),>
           ,<CREATDDT, datetime,>
           ,<CRUSRID, char(15),>
           ,<MDFUSRID, char(15),>
           ,<MODIFDT, datetime,>
           ,<NOTEINDX, numeric(19,5),>)
GO


