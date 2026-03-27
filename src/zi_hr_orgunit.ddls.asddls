@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Org Unit'
define view entity ZI_HR_OrgUnit as select from hrp1000 {
  key plvar as PlanVersion,
  key otype as ObjectType,
  key objid as OrgUnitId,
  key begda as Begda,
  key endda as Endda,
  langu as Language,
  stext as OrgUnitName,
  short as ShortText
}
where otype = 'O'
