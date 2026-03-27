@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Payroll Status'
define view entity ZI_HR_PayrollStatus as select from pa0003 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  uname as ChangedBy,
  cast( aedtm as abap.dats ) as ChangedOn,
  viekn as ViewIndicator
}
