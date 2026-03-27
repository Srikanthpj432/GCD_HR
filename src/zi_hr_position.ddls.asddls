@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Position'
define view entity ZI_HR_Position as select from hrp1000 {
  key plvar as PlanVersion,
  key otype as ObjectType,
  key objid as PositionId,
  key begda as Begda,
  key endda as Endda,
  langu as Language,
  stext as PositionName,
  short as ShortText
}
where otype = 'S'
