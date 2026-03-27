@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Attendance'
define view entity ZI_HR_Attendance as select from pa2002 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr
}
