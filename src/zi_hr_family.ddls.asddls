@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Family Members'
define view entity ZI_HR_Family as select from pa0021 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  favor as FirstName,
  fanam as LastName,
  cast( fgbdt as abap.dats ) as DateOfBirth
}
