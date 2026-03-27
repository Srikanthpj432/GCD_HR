@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Leave Quota'
define view entity ZI_HR_LeaveQuota as select from pa2006 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  anzhl as EntitledDays
}
