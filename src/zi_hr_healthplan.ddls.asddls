@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Health Plan'
define view entity ZI_HR_HealthPlan as select from pa0167 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  barea as BenefitArea,
  bengr as BenefitGroup,
  bstat as BenefitStatus
}
