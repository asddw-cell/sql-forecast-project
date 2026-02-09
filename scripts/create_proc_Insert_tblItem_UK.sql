/*

==============================================================================

Insert item data to tblItem_UK

==============================================================================

Script Purpose:
	This script creates a stored procedure called proc_Insert_tblItem_UK. The procedure deletes all rows in tblItem_UK and inserts
	item and brand data from Finished Goods in the Business Central Item table for Goliath_UK.

*/

USE [Forecast]
GO

CREATE PROCEDURE [dbo].[proc_Insert_tblItem_UK]
AS

BEGIN TRAN;

	DELETE FROM [tblItem_UK];

	INSERT INTO [tblItem_UK]
		(
		[ItemNo],
		[Item],
		[BrandName],
		[BrandCode],
		[Brand],
		[ItemStatus]
		)

	SELECT
		I.[No.],
		CONCAT(I.[No.], ' - ', I.[Description]),
		ISNULL(DV.[Name], ''),
		ISNULL(DV.[Code], ''),
		CASE
			WHEN DV.[Code] IS NOT NULL
				THEN CONCAT(DV.[Code], ' - ', DV.[Name])
			ELSE ''
		END,
		ISNULL(IRD.[Item Status], '')
	FROM [SaaSStageUK].[dbo].[UK_PROD_Item] I
	LEFT OUTER JOIN
		(
		SELECT
			[DW_Account],
			[Code],
			[Name]
		FROM [SaaSStageUK].[dbo].[UK_PROD_Dimension Value]
		WHERE [DW_Account] = 'Goliath_UK'
			AND [Dimension Code] = '2-BRAND'
		) DV ON I.DW_Account = DV.[DW_Account]
			AND I.[Global Dimension 2 Code] = DV.[Code]
	LEFT OUTER JOIN
		(
		SELECT 
			[DW_Account],
			[Item No.],
			[Item Status]
		FROM [SaaSStageUK].[dbo].[UK_PROD_Item Relation Dimension RRF]
		WHERE [DW_Account] = 'Goliath_UK'
			AND [Dimension Level One Code] = 'UK_UK'
		) IRD ON I.[DW_Account] = IRD.[DW_Account]
			AND I.[No.] = IRD.[Item No.]
	WHERE I.[DW_Account] = 'Goliath_UK'
		AND I.[Inventory Posting Group] = 'FINISHED'

COMMIT;
