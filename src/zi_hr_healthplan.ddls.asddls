@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Health Plan'
define view entity ZI_HR_HealthPlan as select from pa0167 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  bplan as HealthPlanId
}
