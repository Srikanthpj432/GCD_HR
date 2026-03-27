@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Recurring Payments'
define view entity ZI_HR_RecurringPay as select from pa0014 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  betrg as Amount,
  waers as Currency
}
