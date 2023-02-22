USE [KazangTransaction]
GO

/****** Object:  StoredProcedure [dbo].[track_primary_account_group_movements_sp_load]    Script Date: 2/22/2023 12:37:12 PM 

Procedure to show the average daily transaction amount based on an account moves to different groups that are associated with levels of commission paid.

******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE  [dbo].[track_primary_account_group_movements_sp_load]
AS
BEGIN
SET NOCOUNT ON
select * 
into #primary_account_movement
from (
select at2.created,at2.id as TransactionJournal_id,
		at2.primary_account_id,gg.id as group_id, SUM(try_cast(at2.transaction_amount as int)) AS daily_sum,
		AVG(Sum(isnull(try_cast(at2.transaction_amount as int),0))) OVER (ORDER BY at2.created ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS transaction_running_average	
from [KazangTransaction].[Dim].[TransactionJournal] at2
inner join [KazangTransaction].[Dim].[GeneralGroup] gg on gg.id = at2.group_id
GROUP BY at2.created,at2.id,at2.primary_account_id,gg.id,at2.transaction_amount
) a

--drop table #primary_account_movement
--select * from #primary_account_movement

;with cc as (
select created,TransactionJournal_id,primary_account_id,
group_id, daily_sum,transaction_running_average,
LEAD(group_id) over (partition by primary_account_id order by created, TransactionJournal_id) NextGroupid
, LAG(CAST(created AS DATETIME2)) over (partition by primary_account_id, group_id order by created, TransactionJournal_id) StartDate
, LEAD(CAST(created AS DATETIME2)) over (partition by primary_account_id order by created, TransactionJournal_id) EndDate
 from #primary_account_movement
)
, c2 as (
  select TransactionJournal_id,primary_account_id,group_id
  , daily_sum,transaction_running_average
  , created
  , NextGroupid
  , StartDate
  , dateadd(day, -1, EndDate) EndDate
from cc
)
, c3 as (
select 
	IsNull(StartDate, CAST(created AS DATETIME2)) as StartDate
	,[TransactionJournal_id]
	,[primary_account_id]
	,[group_id]
	,[daily_sum]
	,[transaction_running_average]
	,IsNull(EndDate, '2999-01-01') as EndDate
from c2
where group_id <> NextGroupid or NextGroupid is null
)

insert into [KazangTransaction].[Dim].[PrimaryAccountGroup](
					[start_date]
					,[TransactionJournal_id]
					,[primary_account_id]
					,[group_id]
					,[daily_sum]
					,[transaction_running_average]
					,[end_date]
		)
select *
from c3
where StartDate <= EndDate

--select * from [KazangTransaction].[Dim].[PrimaryAccountGroup] where primary_account_id = '262072' 

END

GO


