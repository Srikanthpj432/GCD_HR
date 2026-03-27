@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Bank Details'
define view entity ZI_HR_BankDetail as select from pa0009 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  banks as BankCountry,
  bankl as BankKey,
  bankn as BankAccount,
  bkont as AccountType,
  zlsch as PaymentMethod
}
