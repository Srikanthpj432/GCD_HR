@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Additional Payments'
define view entity ZI_HR_AdditionalPay as select from pa0015 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  betrg as Amount,
  waers as Currency
}
