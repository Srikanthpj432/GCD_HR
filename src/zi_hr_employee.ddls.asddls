@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Employee Master'
define view entity ZI_HR_Employee
  as select from pa0001
  inner join   pa0000 on pa0000.pernr = pa0001.pernr
                      and pa0000.endda = pa0001.endda
                      and pa0000.begda = pa0001.begda
  inner join   pa0002 on pa0002.pernr = pa0001.pernr
                      and pa0002.endda = pa0001.endda
                      and pa0002.begda = pa0001.begda

  association [0..*] to ZI_HR_Address       as _Address       on _Address.Pernr       = $projection.Pernr
  association [0..*] to ZI_HR_PayrollStatus as _PayrollStatus on _PayrollStatus.Pernr = $projection.Pernr
  association [0..*] to ZI_HR_WorkingTime   as _WorkingTime   on _WorkingTime.Pernr   = $projection.Pernr
  association [0..*] to ZI_HR_BasicPay      as _BasicPay      on _BasicPay.Pernr      = $projection.Pernr
  association [0..*] to ZI_HR_BankDetail    as _BankDetail    on _BankDetail.Pernr    = $projection.Pernr
  association [0..*] to ZI_HR_RecurringPay  as _RecurringPay  on _RecurringPay.Pernr  = $projection.Pernr
  association [0..*] to ZI_HR_AdditionalPay as _AdditionalPay on _AdditionalPay.Pernr = $projection.Pernr
  association [0..*] to ZI_HR_Family        as _Family        on _Family.Pernr        = $projection.Pernr
  association [0..*] to ZI_HR_InternalCtrl  as _InternalCtrl  on _InternalCtrl.Pernr  = $projection.Pernr
  association [0..*] to ZI_HR_Communication as _Communication on _Communication.Pernr = $projection.Pernr
  association [0..*] to ZI_HR_HealthPlan    as _HealthPlan    on _HealthPlan.Pernr    = $projection.Pernr
  association [0..*] to ZI_HR_Benefit       as _Benefit       on _Benefit.Pernr       = $projection.Pernr
  association [0..*] to ZI_HR_Absence       as _Absence       on _Absence.Pernr       = $projection.Pernr
  association [0..*] to ZI_HR_Attendance    as _Attendance    on _Attendance.Pernr    = $projection.Pernr
  association [0..*] to ZI_HR_LeaveQuota    as _LeaveQuota    on _LeaveQuota.Pernr    = $projection.Pernr
  association [0..1] to ZI_HR_OrgUnit       as _OrgUnit       on _OrgUnit.OrgUnitId   = $projection.Orgeh
  association [0..1] to ZI_HR_Position      as _Position      on _Position.PositionId = $projection.Plans
  association [0..1] to ZI_HR_Job           as _Job           on _Job.JobId           = $projection.Stell

{
      -- Key fields
  key pa0001.pernr as Pernr,
  key pa0001.endda as Endda,
  key pa0001.begda as Begda,

      -- Actions (PA0000)
      pa0000.stat2 as EmploymentStatus,
      pa0000.massn as ActionType,
      pa0000.massg as ActionReason,

      -- Org Assignment (PA0001)
      pa0001.bukrs as CompanyCode,
      pa0001.werks as PersonnelArea,
      pa0001.btrtl as PersonnelSubarea,
      pa0001.persg as EmployeeGroup,
      pa0001.persk as EmployeeSubgroup,
      pa0001.orgeh as Orgeh,
      pa0001.plans as Plans,
      pa0001.stell as Stell,
      pa0001.kostl as CostCenter,
      pa0001.abkrs as PayrollArea,

      -- Personal Data (PA0002)
      pa0002.nachn as LastName,
      pa0002.vorna as FirstName,
      pa0002.rufnm as KnownAs,
      pa0002.gbdat as DateOfBirth,
      pa0002.gesch as Gender,
      pa0002.natio as Nationality,
      pa0002.gbort as BirthPlace,

      -- Associations
      _Address,
      _PayrollStatus,
      _WorkingTime,
      _BasicPay,
      _BankDetail,
      _RecurringPay,
      _AdditionalPay,
      _Family,
      _InternalCtrl,
      _Communication,
      _HealthPlan,
      _Benefit,
      _Absence,
      _Attendance,
      _LeaveQuota,
      _OrgUnit,
      _Position,
      _Job
}
