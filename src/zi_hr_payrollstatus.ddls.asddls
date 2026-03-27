@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Payroll Status'
define view entity ZI_HR_PayrollStatus as select from pa0003 {
  key pernr as Pernr,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  uname as ChangedBy,
  aedtm as ChangedOn,
  viekn as ViewIndicator
}
