@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Leave Quota'
define view entity ZI_HR_LeaveQuota as select from pa2006 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  anzhl as EntitledDays
}
