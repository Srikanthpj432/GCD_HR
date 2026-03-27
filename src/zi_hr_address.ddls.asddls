@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Address'
define view entity ZI_HR_Address as select from pa0006 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  anssa as AddrType,
  stras as Street,
  ort01 as City,
  pstlz as PostalCode,
  land1 as Country,
  state as Region
}
