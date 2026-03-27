@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Basic Pay'
define view entity ZI_HR_BasicPay as select from pa0008 {
  key pernr as Pernr,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  trfar as PayScaleType,
  trfgb as PayScaleArea,
  trfgr as PayScaleGroup,
  trfst as PayScaleLevel,
  ansal as AnnualSalary,
  bet01 as WageAmount,
  lga01 as WageType
}
