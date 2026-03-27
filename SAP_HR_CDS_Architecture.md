
# SAP HR CDS Service Architecture - Parent/Child Entity Model

## Overview
Custom OData V4 service for complete HR data extraction.
Parent-child entity design with associations via PERNR.

System: GCD
PERNR: 90000002 (test data)

---

## 1. Entity Structure

### Parent Entity: ZI_HR_Employee
Source: PA0000 + PA0001 + PA0002 (joined)
Key: PERNR, BEGDA, ENDDA

| Field | Source | Description |
|-------|--------|-------------|
| Pernr | PA0001 | Personnel Number |
| Begda | PA0001 | Start Date |
| Endda | PA0001 | End Date |
| Stat2 | PA0000 | Employment Status |
| Massn | PA0000 | Action Type |
| Bukrs | PA0001 | Company Code (from T001) |
| Werks | PA0001 | Personnel Area (from T500P) |
| Btrtl | PA0001 | Personnel Subarea (from T001P) |
| Persg | PA0001 | Employee Group (from T503) |
| Persk | PA0001 | Employee Subgroup (from T503) |
| Orgeh | PA0001 | Org Unit → HRP1000 |
| Plans | PA0001 | Position → HRP1000 |
| Stell | PA0001 | Job → HRP1000 |
| Kostl | PA0001 | Cost Center (from CSKS) |
| Abkrs | PA0001 | Payroll Area (from T549A) |
| Nachn | PA0002 | Last Name |
| Vorna | PA0002 | First Name |
| Gbdat | PA0002 | Date of Birth |
| Gesch | PA0002 | Gender |
| Natio | PA0002 | Nationality |

### Child Entities

#### ZI_HR_Address (PA0006)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Address Type (1=Permanent) |
| Begda / Endda | Validity |
| Stras | Street |
| Ort01 | City |
| Pstlz | Postal Code |
| Land1 | Country |
| State | State/Region |

#### ZI_HR_PayrollStatus (PA0003)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Begda / Endda | Validity |
| Uname | Last Changed By |
| Aedtm | Last Changed On |
| Viekn | Infotype View Indicator |

#### ZI_HR_WorkingTime (PA0007)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Begda / Endda | Validity |
| Schkz | Work Schedule Rule |
| Empct | Employment Percentage |
| Wkwdy | Weekly Workdays |
| Arbst | Daily Working Hours |

#### ZI_HR_BasicPay (PA0008)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Begda / Endda | Validity |
| Trfar | Pay Scale Type |
| Trfgb | Pay Scale Area |
| Trfgr | Pay Scale Group |
| Trfst | Pay Scale Level |
| Ansal | Annual Salary |
| Bet01 | Wage Amount |
| Lga01 | Wage Type |

#### ZI_HR_BankDetail (PA0009)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Bank Type (0=Main) |
| Begda / Endda | Validity |
| Banks | Bank Country |
| Bankl | Bank Key |
| Bankn | Account Number |
| Zlsch | Payment Method |

#### ZI_HR_RecurringPay (PA0014)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Wage Type |
| Begda / Endda | Validity |
| Betrg | Amount |
| Waers | Currency |

#### ZI_HR_AdditionalPay (PA0015)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Wage Type |
| Begda / Endda | Validity |
| Betrg | Amount |
| Waers | Currency |

#### ZI_HR_Family (PA0021)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Relationship (1=Spouse, 2=Child) |
| Begda / Endda | Validity |
| Favor | First Name |
| Fanam | Last Name |
| Fgbdt | Date of Birth |

#### ZI_HR_InternalCtrl (PA0032)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Begda / Endda | Validity |
| Pnalt | Previous Personnel Number |
| Wausw | Company ID |
| Waers | Currency |
| Gebnr | Building Number |
| Zimnr | Room Number |
| Tel01 | In-House Telephone |

#### ZI_HR_Communication (PA0105)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Type (0001=SAP User, 0010=Email) |
| Begda / Endda | Validity |
| Usrid | User ID |
| UsridLong | Email Address |

#### ZI_HR_HealthPlan (PA0167)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Plan Subtype |
| Begda / Endda | Validity |
| Bplan | Health Plan ID |

#### ZI_HR_Benefit (PA0171)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Plan Subtype |
| Begda / Endda | Validity |
| Bplan | Benefit Plan ID |

#### ZI_HR_Absence (PA2001)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Absence Type (from T554S) |
| Begda / Endda | Absence Period |

#### ZI_HR_Attendance (PA2002)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Attendance Type (from T554S) |
| Begda / Endda | Attendance Period |

#### ZI_HR_LeaveQuota (PA2006)
Association: PERNR
| Field | Description |
|-------|-------------|
| Pernr | Personnel Number |
| Subty | Quota Type (from T556B) |
| Begda / Endda | Validity |
| Anzhl | Entitled Days |

#### ZI_HR_OrgUnit (HRP1000 where otype='O')
Association: PA0001-ORGEH = HRP1000-OBJID
| Field | Description |
|-------|-------------|
| Objid | Org Unit ID |
| Stext | Org Unit Name |
| Short | Short Text |
| Begda / Endda | Validity |

#### ZI_HR_Position (HRP1000 where otype='S')
Association: PA0001-PLANS = HRP1000-OBJID
| Field | Description |
|-------|-------------|
| Objid | Position ID |
| Stext | Position Name |
| Short | Short Text |
| Begda / Endda | Validity |

#### ZI_HR_Job (HRP1000 where otype='C')
Association: PA0001-STELL = HRP1000-OBJID
| Field | Description |
|-------|-------------|
| Objid | Job ID |
| Stext | Job Name |
| Short | Short Text |
| Begda / Endda | Validity |

---

## 2. Association Map (Parent → Children)

```
ZI_HR_Employee (PA0000 + PA0001 + PA0002)
│
├── composition [0..*] ZI_HR_Address         via PERNR
├── composition [0..*] ZI_HR_PayrollStatus   via PERNR
├── composition [0..*] ZI_HR_WorkingTime     via PERNR
├── composition [0..*] ZI_HR_BasicPay        via PERNR
├── composition [0..*] ZI_HR_BankDetail      via PERNR
├── composition [0..*] ZI_HR_RecurringPay    via PERNR
├── composition [0..*] ZI_HR_AdditionalPay   via PERNR
├── composition [0..*] ZI_HR_Family          via PERNR
├── composition [0..*] ZI_HR_InternalCtrl    via PERNR
├── composition [0..*] ZI_HR_Communication   via PERNR
├── composition [0..*] ZI_HR_HealthPlan      via PERNR
├── composition [0..*] ZI_HR_Benefit         via PERNR
├── composition [0..*] ZI_HR_Absence         via PERNR
├── composition [0..*] ZI_HR_Attendance      via PERNR
├── composition [0..*] ZI_HR_LeaveQuota      via PERNR
│
├── association [0..1] ZI_HR_OrgUnit         via ORGEH = OBJID
├── association [0..1] ZI_HR_Position        via PLANS = OBJID
└── association [0..1] ZI_HR_Job             via STELL = OBJID
```

---

## 3. Service Layer

```
Interface Views (ZI_*)
        │
        ▼
Consumption View: ZC_HR_Employee
  (re-exposes ZI_HR_Employee with all compositions/associations)
        │
        ▼
Service Definition: ZSD_HR_EMPLOYEE
  expose ZC_HR_Employee as Employee;
  expose ZI_HR_Address as Address;
  expose ZI_HR_PayrollStatus as PayrollStatus;
  expose ZI_HR_WorkingTime as WorkingTime;
  expose ZI_HR_BasicPay as BasicPay;
  expose ZI_HR_BankDetail as BankDetail;
  expose ZI_HR_RecurringPay as RecurringPay;
  expose ZI_HR_AdditionalPay as AdditionalPay;
  expose ZI_HR_Family as Family;
  expose ZI_HR_InternalCtrl as InternalControl;
  expose ZI_HR_Communication as Communication;
  expose ZI_HR_HealthPlan as HealthPlan;
  expose ZI_HR_Benefit as Benefit;
  expose ZI_HR_Absence as Absence;
  expose ZI_HR_Attendance as Attendance;
  expose ZI_HR_LeaveQuota as LeaveQuota;
  expose ZI_HR_OrgUnit as OrgUnit;
  expose ZI_HR_Position as Position;
  expose ZI_HR_Job as Job;
        │
        ▼
Service Binding: ZSB_HR_EMPLOYEE_V4
  Type: OData V4
  Service: ZSD_HR_EMPLOYEE
```

---

## 4. OData URLs (after activation)

```
Base: /sap/opu/odata4/sap/zsd_hr_employee/srvd_a2x/sap/zsd_hr_employee/0001

GET /Employee
GET /Employee('90000002')
GET /Employee('90000002')/_Address
GET /Employee('90000002')/_BasicPay
GET /Employee('90000002')/_Family
GET /Employee('90000002')/_OrgUnit
GET /Employee('90000002')/_Position
GET /Employee('90000002')/_Absence
GET /Employee?$expand=_Address,_BasicPay,_OrgUnit,_Position
```

---

## 5. File List (abapGit src/)

| File | Object Type | Description |
|------|-------------|-------------|
| zi_hr_employee.ddls.asddls | DDLS | Parent CDS - Employee |
| zi_hr_address.ddls.asddls | DDLS | Child CDS - Address |
| zi_hr_payrollstatus.ddls.asddls | DDLS | Child CDS - Payroll Status |
| zi_hr_workingtime.ddls.asddls | DDLS | Child CDS - Working Time |
| zi_hr_basicpay.ddls.asddls | DDLS | Child CDS - Basic Pay |
| zi_hr_bankdetail.ddls.asddls | DDLS | Child CDS - Bank Details |
| zi_hr_recurringpay.ddls.asddls | DDLS | Child CDS - Recurring Pay |
| zi_hr_additionalpay.ddls.asddls | DDLS | Child CDS - Additional Pay |
| zi_hr_family.ddls.asddls | DDLS | Child CDS - Family Members |
| zi_hr_internalctrl.ddls.asddls | DDLS | Child CDS - Internal Control |
| zi_hr_communication.ddls.asddls | DDLS | Child CDS - Communication |
| zi_hr_healthplan.ddls.asddls | DDLS | Child CDS - Health Plan |
| zi_hr_benefit.ddls.asddls | DDLS | Child CDS - Benefits |
| zi_hr_absence.ddls.asddls | DDLS | Child CDS - Absence |
| zi_hr_attendance.ddls.asddls | DDLS | Child CDS - Attendance |
| zi_hr_leavequota.ddls.asddls | DDLS | Child CDS - Leave Quota |
| zi_hr_orgunit.ddls.asddls | DDLS | Child CDS - Org Unit |
| zi_hr_position.ddls.asddls | DDLS | Child CDS - Position |
| zi_hr_job.ddls.asddls | DDLS | Child CDS - Job |
| zc_hr_employee.ddls.asddls | DDLS | Consumption View |
| zsd_hr_employee.srvd.srvdsrv | SRVD | Service Definition |
| zsd_hr_employee_v4.srvb.srvbsrv | SRVB | Service Binding (OData V4) |

---

## 6. Build Order
1. Child CDS views (no dependencies)
2. Parent CDS view ZI_HR_Employee (has associations to children)
3. Consumption view ZC_HR_Employee
4. Service Definition ZSD_HR_EMPLOYEE
5. Service Binding ZSB_HR_EMPLOYEE_V4
6. Activate and test in /IWFND/MAINT_SERVICE or Fiori

---

## End of Document
SAP HR CDS Service Architecture - System: GCD
