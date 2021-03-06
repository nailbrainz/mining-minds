USE [MMIKATDB_V2_GCH]
GO
/****** Object:  StoredProcedure [dbo].[usp_Add_CreatedRule]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

      
-- =============================================      
-- Author:  <Taqdir Ali>      
-- Create date: <25 March 2015>      
-- Description: SP to add the created rule.      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_Add_CreatedRule]       
      
@RuleTitle varchar(50),  
@Institution varchar(100),    
@RuleDescription  varchar(200),      
@RuleCondition varchar(1000),      
@RuleConclusion varchar(1000),      
@RuleCreatedBy numeric(18, 0),
@SpecialistName varchar(100),          
@RuleTypeID int,      
@RuleID  numeric(18,0) Output      
      
AS      
BEGIN      
      
Insert Into tblRules      
(      
RuleTitle,
Institution,      
RuleDescription,      
RuleCondition,      
RuleConclusion,      
RuleCreatedDate,      
RuleCreatedBy,  
SpecialistName,    
RuleTypeID      
)      
Values      
(      
@RuleTitle, 
@Institution,     
@RuleDescription,      
@RuleCondition,      
@RuleConclusion,      
GETDATE(),      
@RuleCreatedBy,
@SpecialistName,      
@RuleTypeID       
)      
Select @RuleID = IDENT_CURRENT('tblRules')      
      
END 


GO
/****** Object:  StoredProcedure [dbo].[usp_Delete_Rule]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:  <Taqdir Ali>  
-- Create date: <25 March 2015>  
-- Description: SP to delete the selected rule.  
-- =============================================  
Create PROCEDURE [dbo].[usp_Delete_Rule]   
  
@RuleID  numeric(18,0) 
  
AS  
BEGIN  
  
Delete from tblRules Where RuleID =  @RuleID
  
END  


GO
/****** Object:  StoredProcedure [dbo].[usp_Get_AllRulesList]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  <Taqdir Ali>    
-- Create date: <25 March 2015>    
-- Description: SP to get all list of rules.    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_Get_AllRulesList]     
    
AS    
BEGIN    
Select     
RuleID,    
RuleTitle,
Institution,    
RuleDescription,    
RuleCondition,    
RuleConclusion,    
RuleCreatedDate,    
RuleCreatedBy,
SpecialistName,    
RuleUpdatedBy,    
RuleLastUpdatedDate,    
tblRules.RuleTypeID,    
RuleTypeDescription,    
lkptRuleType.RuleTypeDescription,    
tblUsers.UserName  
    
    
From tblRules     
left outer join lkptRuleType on tblRules.RuleTypeID = lkptRuleType.RuleTypeID    
Left Outer Join tblUsers on tblRules.RuleCreatedBy = tblUsers.UserID    
Order By RuleID Desc
    
END 


GO
/****** Object:  StoredProcedure [dbo].[usp_Get_RulesByRuleID]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =============================================    
-- Author:  <Taqdir Ali>    
-- Create date: <25 March 2015>    
-- Description: SP to get rule by rule id.    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_Get_RulesByRuleID]     
 @RuleID numeric(18,0)    
AS    
BEGIN    
Select     
RuleID,    
RuleTitle,
Institution,    
RuleDescription,    
RuleCondition,    
RuleConclusion,    
RuleCreatedDate,    
RuleCreatedBy,    
RuleUpdatedBy, 
SpecialistName,   
RuleLastUpdatedDate,    
tblRules.RuleTypeID,    
RuleTypeDescription,    
lkptRuleType.RuleTypeDescription,    
tblUsers.UserName    
    
    
From tblRules     
left outer join lkptRuleType on tblRules.RuleTypeID = lkptRuleType.RuleTypeID    
Left Outer Join tblUsers on tblRules.RuleCreatedBy = tblUsers.UserID    
Where RuleID = @RuleID    
END 


GO
/****** Object:  StoredProcedure [dbo].[Usp_Get_WellnessConceptsByKey]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:  <Taqdir Ali>  
-- Create date: <25 March 2015>  
-- Description: SP to get wellness immediate concepts by parent concept.  
-- =============================================  
CREATE PROCEDURE [dbo].[Usp_Get_WellnessConceptsByKey] --'Current Activity', ''
@key as varchar(500), 
@query as varchar(500)
AS  
BEGIN  
   Declare @ParentID as numeric(18, 0)
   set @ParentID = 0
   Select @ParentID = WellnessConceptID from tblWellnessConceptsModel Where WellnessConceptDescription like @key
   
   if @ParentID <> 0
   Begin
		Select WellnessConceptsRelationshipID,WellnessConceptID1, C1.WellnessConceptDescription AS WellnessConcept1Description, 116680003 as RELATIONSHIPTYPE, --'Is a' As Relation,    
		WellnessConceptID2, C2.WellnessConceptDescription As WellnessConcept2Description 
		from tblWellnessConceptsRelationships R    
		Inner Join tblWellnessConceptsModel C1 on R.WellnessConceptID1 = C1.WellnessConceptID    
		Inner Join tblWellnessConceptsModel C2 on R.WellnessConceptID2 = C2.WellnessConceptID  
		Where  WellnessConceptID2 = @ParentID and C1.WellnessConceptDescription like '%' + @query + '%'
   End
   Else
   Begin
		Select WellnessConceptsRelationshipID,WellnessConceptID1, C1.WellnessConceptDescription AS WellnessConcept1Description, 116680003 as RELATIONSHIPTYPE, --'Is a' As Relation,    
		WellnessConceptID2, C2.WellnessConceptDescription As WellnessConcept2Description 
		from tblWellnessConceptsRelationships R    
		Inner Join tblWellnessConceptsModel C1 on R.WellnessConceptID1 = C1.WellnessConceptID    
		Inner Join tblWellnessConceptsModel C2 on R.WellnessConceptID2 = C2.WellnessConceptID  
		Where C1.WellnessConceptDescription like '%' + @query + '%'

   End

  
END  


GO
/****** Object:  StoredProcedure [dbo].[usp_Get_WellnessConceptsByParent]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:  <Taqdir Ali>  
-- Create date: <25 March 2015>  
-- Description: SP to get wellness model by parent concept.  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_Get_WellnessConceptsByParent] 
@Parent as varchar(500)  
AS  
BEGIN  
;with CompleteData    
as    
(    
     Select WellnessConceptsRelationshipID,WellnessConceptID1, C1.WellnessConceptDescription AS WellnessConcept1Description, 116680003 as RELATIONSHIPTYPE, 'Is a' As Relation,    
   WellnessConceptID2, C2.WellnessConceptDescription As WellnessConcept2Description 
   from tblWellnessConceptsRelationships R    
   Inner Join tblWellnessConceptsModel C1 on R.WellnessConceptID1 = C1.WellnessConceptID    
   Inner Join tblWellnessConceptsModel C2 on R.WellnessConceptID2 = C2.WellnessConceptID    
    
)    
    
,    
DownwardTraverseCTE (WellnessConceptsRelationshipID,WellnessConceptID1, WellnessConcept1Description,RELATIONSHIPTYPE, Relation,    
 WellnessConceptID2,WellnessConcept2Description, Lvl)    
as    
(    
    Select WellnessConceptsRelationshipID,WellnessConceptID1, WellnessConcept1Description,RELATIONSHIPTYPE, Relation,    
 WellnessConceptID2,WellnessConcept2Description, 1 AS Lvl from CompleteData Where WellnessConcept2Description like @Parent And RELATIONSHIPTYPE = 116680003    
    union all    
    Select CompleteData.WellnessConceptsRelationshipID,CompleteData.WellnessConceptID1, CompleteData.WellnessConcept1Description,CompleteData.RELATIONSHIPTYPE, CompleteData.Relation,    
 CompleteData.WellnessConceptID2,CompleteData.WellnessConcept2Description, Lvl+1 AS Lvl from CompleteData     
        INNER Join DownwardTraverseCTE    
            on DownwardTraverseCTE.WellnessConceptID1 = CompleteData.WellnessConceptID2 And CompleteData.RELATIONSHIPTYPE = 116680003    
)    
    
Select Distinct *, ROW_NUMBER() OVER(ORDER BY WellnessConceptsRelationshipID DESC) AS Row from DownwardTraverseCTE order by Lvl    
  
END  


GO
/****** Object:  StoredProcedure [dbo].[usp_Get_WellnessImmediateConceptsByParent]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


  
-- =============================================  
-- Author:  <Taqdir Ali>  
-- Create date: <25 March 2015>  
-- Description: SP to get wellness immediate concepts by parent concept.  
-- =============================================  
Create PROCEDURE [dbo].[usp_Get_WellnessImmediateConceptsByParent] 
@Parent as varchar(500)  
AS  
BEGIN  
   Declare @ParentID as numeric(18, 0)
   set @ParentID = 0
   Select @ParentID = WellnessConceptID from tblWellnessConceptsModel Where WellnessConceptDescription like @Parent
   
   if @ParentID <> 0
   Begin
		Select WellnessConceptsRelationshipID,WellnessConceptID1, C1.WellnessConceptDescription AS WellnessConcept1Description, 116680003 as RELATIONSHIPTYPE, 'Is a' As Relation,    
		WellnessConceptID2, C2.WellnessConceptDescription As WellnessConcept2Description 
		from tblWellnessConceptsRelationships R    
		Inner Join tblWellnessConceptsModel C1 on R.WellnessConceptID1 = C1.WellnessConceptID    
		Inner Join tblWellnessConceptsModel C2 on R.WellnessConceptID2 = C2.WellnessConceptID  
		Where  WellnessConceptID2 = @ParentID
   End

  
END  


GO
/****** Object:  StoredProcedure [dbo].[usp_IndexReasoner]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Rahman Ali
-- Create date: 01-10-2015
-- Description:	Index Reasoning
-- =============================================
CREATE PROCEDURE [dbo].[usp_IndexReasoner]  
	@IndexName varchar(50)
	
	AS
BEGIN

Select 
RuleID,
RuleTitle,
Institution,
RuleDescription,
RuleCondition,
RuleConclusion,
RuleCreatedDate,
RuleCreatedBy,
SpecialistName,
RuleUpdatedBy,
RuleLastUpdatedDate,
RuleTypeID,
SourceClassName,
tblRules.IndexID

From  tblRules
Inner Join tblIndex on tblRules.IndexID = tblIndex.IndexID
Where tblIndex.IndexName = @IndexName

END


GO
/****** Object:  StoredProcedure [dbo].[usp_SituationBasedReasoner]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MAQBOOL HUSSAIN
-- Create date: 20-10-2015
-- Description:	SITUATION-BASED REASONER
-- =============================================
CREATE PROCEDURE [dbo].[usp_SituationBasedReasoner] 
	-- Example parameter values:
	-- { @situationEventData Format: ( c.ConditionKey = 'Current Activity' AND c.ConditionValueOperator = '=' AND c.ConditionValue = 'Sitting' ) OR ( c.ConditionKey = 'Activity Duration' AND c.ConditionValueOperator = '=' AND c.ConditionValue = '15m' )
	--   @siuationEventCount = 2 }
	@situationEventData varchar(max) = null,
	@siuationEventCount int = 0
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @situationQuery nvarchar(max)


	IF @situationEventData IS NOT null
	BEGIN
				

		--Cursor to find the matched situation events conditions
		SET @situationQuery = 'DECLARE cur_sitEvent CURSOR FOR 
		SELECT s.SituationID , COUNT (s.SituationID) 
		FROM tblSituations s, tblSituationConditions sc, tblConditions c 
		WHERE s.SituationID = sc.SituationID AND sc.ConditionID = c.ConditionID AND ( ' + @situationEventData + ' ) GROUP BY s.SituationID'
		
		Execute sp_executesql @situationQuery		
		
		
		OPEN cur_sitEvent
		
		DECLARE @sitID numeric(18,0), @sitConCount int, @winnersitID numeric(18,0)
		SET @winnersitID = 0

		FETCH NEXT FROM cur_sitEvent
		INTO @sitID, @sitConCount

		--PRINT @sitID
		WHILE @@FETCH_STATUS = 0 
		BEGIN
			
			IF @sitConCount = @siuationEventCount
			BEGIN
				DECLARE @countSE int
				SELECT @countSE = COUNT(*) 
				FROM tblSituations s, tblSituationConditions sc
				WHERE s.SituationID = sc.SituationID and s.SituationID = @sitID

				IF @siuationEventCount = @countSE
				BEGIN
					
					SET @winnersitID = @sitID
					BREAK

				END				
			END
			
			FETCH NEXT FROM cur_sitEvent
			INTO @sitID, @sitConCount

		END	
		
		
		SELECT r.RuleID, r.RuleConclusion, c.ConditionKey, c.ConditionValueOperator, c.ConditionValue, c.ConditionType , rcon.ConclusionKey, rcon.ConclusionOperator, rcon.ConclusionValue 
		FROM tblRules r, tblRulesConditions rc, tblConditions c , tblConclusions rcon
		WHERE r.RuleID = rc.RuleID And rc.ConditionID = c.ConditionID And r.RuleID = rcon.RuleID
		AND r.SituationID = @winnersitID

		Close cur_sitEvent
		Deallocate cur_sitEvent			

	END
    
END


GO
/****** Object:  StoredProcedure [dbo].[usp_Update_CreatedRule]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
-- =============================================    
-- Author:  <Taqdir Ali>    
-- Create date: <25 March 2015>    
-- Description: SP to update the edited rule.    
-- =============================================    
CREATE PROCEDURE [dbo].[usp_Update_CreatedRule]     
@RuleID  numeric(18,0),    
@RuleTitle varchar(50), 
@Institution varchar(100),    
@RuleDescription  varchar(200),    
@RuleCondition varchar(1000),    
@RuleConclusion varchar(1000),    
@RuleUpdatedBy numeric(18, 0), 
@SpecialistName varchar(100),       
@RuleTypeID int    
    
AS    
BEGIN    
    
Update tblRules    
Set    
RuleTitle = @RuleTitle,
Institution = @Institution,   
RuleDescription = @RuleDescription,    
RuleCondition = @RuleCondition,    
RuleConclusion = @RuleConclusion,    
RuleUpdatedBy = @RuleUpdatedBy,    
RuleLastUpdatedDate = GETDATE(),  
SpecialistName = @SpecialistName,  
RuleTypeID = @RuleTypeID    
Where RuleID = @RuleID    
    
END 


GO
/****** Object:  StoredProcedure [dbo].[usp_Validate_User]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
-- =============================================  
-- Author:  <Taqdir Ali>  
-- Create date: <25 March 2015>  
-- Description: SP to validate user by login id and password.  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_Validate_User]   
@LoginID varchar(50),
@Password varchar(50)
  
AS  
BEGIN  
Select   
UserID,
UserName,
LoginID,
[Password],
EmailAddress,
DateOfBirth,
DesignationID,
ActiveYNID
From tblUsers   
Where LoginID = @LoginID and [Password] = @Password
  
END  


GO
/****** Object:  Table [dbo].[lkptDesignation]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkptDesignation](
	[DesignationID] [int] NOT NULL,
	[DesignationDescription] [varchar](50) NULL,
 CONSTRAINT [PK_lkptDesignation] PRIMARY KEY CLUSTERED 
(
	[DesignationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[lkptRuleType]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[lkptRuleType](
	[RuleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[RuleTypeDescription] [varchar](100) NULL,
 CONSTRAINT [PK_lkptRuleType] PRIMARY KEY CLUSTERED 
(
	[RuleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Person]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Person](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[country] [varchar](50) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConclusions]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConclusions](
	[ConclusionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[RuleID] [numeric](18, 0) NULL,
	[ConclusionKey] [varchar](500) NULL,
	[ConclusionValue] [varchar](500) NULL,
	[ConclusionOperator] [varchar](100) NULL,
 CONSTRAINT [PK_tblConclusions] PRIMARY KEY CLUSTERED 
(
	[ConclusionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblConditions]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblConditions](
	[ConditionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[ConditionKey] [varchar](50) NULL,
	[ConditionValue] [varchar](1000) NULL,
	[ConditionType] [varchar](50) NULL,
	[ConditionValueOperator] [varchar](50) NULL,
 CONSTRAINT [PK_tblConditions] PRIMARY KEY CLUSTERED 
(
	[ConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblIndex]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblIndex](
	[IndexID] [numeric](18, 0) NOT NULL,
	[IndexName] [varchar](50) NULL,
 CONSTRAINT [PK_tblIndex] PRIMARY KEY CLUSTERED 
(
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRules]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblRules](
	[RuleID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[RuleTitle] [varchar](50) NULL,
	[Institution] [varchar](100) NULL,
	[RuleDescription] [varchar](200) NULL,
	[RuleCondition] [varchar](1000) NULL,
	[RuleConclusion] [varchar](1000) NULL,
	[RuleCreatedDate] [datetime] NULL,
	[RuleCreatedBy] [numeric](18, 0) NULL,
	[SpecialistName] [varchar](100) NULL,
	[RuleUpdatedBy] [numeric](18, 0) NULL,
	[RuleLastUpdatedDate] [datetime] NULL,
	[RuleTypeID] [int] NULL,
	[SourceClassName] [varchar](50) NULL,
	[SituationID] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tblRules] PRIMARY KEY CLUSTERED 
(
	[RuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblRulesConditions]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblRulesConditions](
	[RulesConditionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[RuleID] [numeric](18, 0) NULL,
	[ConditionID] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tblRulesConditions] PRIMARY KEY CLUSTERED 
(
	[RulesConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblSituationConditions]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSituationConditions](
	[SituationConditionID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SituationID] [numeric](18, 0) NULL,
	[ConditionID] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tblSituationConditions] PRIMARY KEY CLUSTERED 
(
	[SituationConditionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblSituations]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblSituations](
	[SituationID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[SituationDescription] [varchar](max) NULL,
 CONSTRAINT [PK_tblSituations] PRIMARY KEY CLUSTERED 
(
	[SituationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblUsers]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblUsers](
	[UserID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](200) NULL,
	[LoginID] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[EmailAddress] [varchar](50) NULL,
	[DateOfBirth] [datetime] NULL,
	[DesignationID] [int] NULL,
	[ActiveYNID] [int] NULL,
 CONSTRAINT [PK_tblUsers] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWellnessConceptsModel]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblWellnessConceptsModel](
	[WellnessConceptID] [numeric](18, 0) NOT NULL,
	[WellnessConceptDescription] [varchar](200) NULL,
	[ActiveYNID] [int] NULL,
 CONSTRAINT [PK_tblWellnessConceptsModel] PRIMARY KEY CLUSTERED 
(
	[WellnessConceptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblWellnessConceptsRelationships]    Script Date: 12/18/2016 9:24:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWellnessConceptsRelationships](
	[WellnessConceptsRelationshipID] [numeric](18, 0) NOT NULL,
	[WellnessConceptID1] [numeric](18, 0) NULL,
	[RelationshipType] [numeric](18, 0) NULL,
	[WellnessConceptID2] [numeric](18, 0) NULL,
 CONSTRAINT [PK_tblWellnessConceptsRelationships] PRIMARY KEY CLUSTERED 
(
	[WellnessConceptsRelationshipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[tblUsers]  WITH CHECK ADD  CONSTRAINT [FK_tblUsers_lkptDesignation] FOREIGN KEY([DesignationID])
REFERENCES [dbo].[lkptDesignation] ([DesignationID])
GO
ALTER TABLE [dbo].[tblUsers] CHECK CONSTRAINT [FK_tblUsers_lkptDesignation]
GO
ALTER TABLE [dbo].[tblWellnessConceptsRelationships]  WITH CHECK ADD  CONSTRAINT [FK_tblWellnessConceptsRelationships_tblWellnessConceptsModel] FOREIGN KEY([WellnessConceptID1])
REFERENCES [dbo].[tblWellnessConceptsModel] ([WellnessConceptID])
GO
ALTER TABLE [dbo].[tblWellnessConceptsRelationships] CHECK CONSTRAINT [FK_tblWellnessConceptsRelationships_tblWellnessConceptsModel]
GO
ALTER TABLE [dbo].[tblWellnessConceptsRelationships]  WITH CHECK ADD  CONSTRAINT [FK_tblWellnessConceptsRelationships_tblWellnessConceptsModel1] FOREIGN KEY([WellnessConceptID2])
REFERENCES [dbo].[tblWellnessConceptsModel] ([WellnessConceptID])
GO
ALTER TABLE [dbo].[tblWellnessConceptsRelationships] CHECK CONSTRAINT [FK_tblWellnessConceptsRelationships_tblWellnessConceptsModel1]
GO
