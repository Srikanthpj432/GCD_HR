@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Attendance'
define view entity ZI_HR_Attendance as select from pa2002 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr
}
