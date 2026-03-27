@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Family Members'
define view entity ZI_HR_Family as select from pa0021 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  favor as FirstName,
  fanam as LastName,
  fgbdt as DateOfBirth
}
