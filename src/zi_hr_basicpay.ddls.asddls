@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Basic Pay'
define view entity ZI_HR_BasicPay as select from pa0008 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  trfar as PayScaleType,
  trfgb as PayScaleArea,
  trfgr as PayScaleGroup,
  trfst as PayScaleLevel,
  ancur as AnnualCurrency,
  ansal as AnnualSalary,
  waers as Currency,
  bet01 as WageAmount,
  lga01 as WageType
}
