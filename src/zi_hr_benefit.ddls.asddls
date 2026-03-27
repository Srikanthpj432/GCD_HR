@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Benefits'
define view entity ZI_HR_Benefit as select from pa0171 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  barea as BenefitArea,
  bengr as BenefitGroup,
  bstat as BenefitStatus
}
