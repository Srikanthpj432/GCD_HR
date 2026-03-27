@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Job'
define view entity ZI_HR_Job as select from hrp1000 {
  key plvar as PlanVersion,
  key otype as ObjectType,
  key objid as JobId,
  key begda as Begda,
  key endda as Endda,
  langu as Language,
  stext as JobName,
  short as ShortText
}
where otype = 'C'
