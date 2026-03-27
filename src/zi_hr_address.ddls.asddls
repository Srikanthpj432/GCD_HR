@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Address'
define view entity ZI_HR_Address as select from pa0006 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  anssa as AddressType,
  stras as Street,
  ort01 as City,
  pstlz as PostalCode,
  land1 as Country,
  state as Region
}
