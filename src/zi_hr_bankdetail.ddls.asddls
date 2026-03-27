@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Bank Details'
define view entity ZI_HR_BankDetail as select from pa0009 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  banks as BankCountry,
  bankl as BankKey,
  bankn as BankAccount,
  bkont as AccountType,
  zlsch as PaymentMethod
}
