@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Absence'
define view entity ZI_HR_Absence as select from pa2001 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr
}
