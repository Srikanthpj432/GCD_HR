@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Working Time'
define view entity ZI_HR_WorkingTime as select from pa0007 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  schkz as WorkScheduleRule,
  empct as EmploymentPercent,
  wkwdy as WeeklyWorkdays,
  arbst as DailyWorkHours
}
