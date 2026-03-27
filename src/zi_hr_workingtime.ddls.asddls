@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Working Time'
define view entity ZI_HR_WorkingTime as select from pa0007 {
  key pernr as Pernr,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  schkz as WorkScheduleRule,
  empct as EmploymentPercent,
  wkwdy as WeeklyWorkdays,
  arbst as DailyWorkHours
}
