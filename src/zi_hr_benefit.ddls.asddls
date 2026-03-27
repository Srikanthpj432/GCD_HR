@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Benefits'
define view entity ZI_HR_Benefit as select from pa0171 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  bplan as BenefitPlanId
}
