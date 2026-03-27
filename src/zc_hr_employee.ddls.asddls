@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Employee - Consumption'
@Metadata.allowExtensions: true
define view entity ZC_HR_Employee
  as projection on ZI_HR_Employee
{
      -- Key fields
  key Pernr,
  key Endda,
  key Begda,

      -- Actions
      EmploymentStatus,
      ActionType,
      ActionReason,

      -- Org Assignment
      CompanyCode,
      PersonnelArea,
      PersonnelSubarea,
      EmployeeGroup,
      EmployeeSubgroup,
      Orgeh,
      Plans,
      Stell,
      CostCenter,
      PayrollArea,

      -- Personal Data
      LastName,
      FirstName,
      KnownAs,
      DateOfBirth,
      Gender,
      Nationality,
      BirthPlace,

      -- Associations
      _Address       : redirected to ZI_HR_Address,
      _PayrollStatus : redirected to ZI_HR_PayrollStatus,
      _WorkingTime   : redirected to ZI_HR_WorkingTime,
      _BasicPay      : redirected to ZI_HR_BasicPay,
      _BankDetail    : redirected to ZI_HR_BankDetail,
      _RecurringPay  : redirected to ZI_HR_RecurringPay,
      _AdditionalPay : redirected to ZI_HR_AdditionalPay,
      _Family        : redirected to ZI_HR_Family,
      _InternalCtrl  : redirected to ZI_HR_InternalCtrl,
      _Communication : redirected to ZI_HR_Communication,
      _HealthPlan    : redirected to ZI_HR_HealthPlan,
      _Benefit       : redirected to ZI_HR_Benefit,
      _Absence       : redirected to ZI_HR_Absence,
      _Attendance    : redirected to ZI_HR_Attendance,
      _LeaveQuota    : redirected to ZI_HR_LeaveQuota,
      _OrgUnit       : redirected to ZI_HR_OrgUnit,
      _Position      : redirected to ZI_HR_Position,
      _Job           : redirected to ZI_HR_Job
}
