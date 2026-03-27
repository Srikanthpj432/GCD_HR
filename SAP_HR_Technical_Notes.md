
# SAP HR Technical Notes - GCD System

## 1. System Details
- System ID: GCD
- SAP Version: S/4HANA 2020
- abapGit Repo: https://github.com/Srikanthpj432/GCD_HR.git
- User: CE02
- Test PERNR Range: 90000002 - 90000052

---

## 2. Objects Created

### ABAP Programs
| Program | Description |
|---------|-------------|
| Z_HR_SAMPLE_DATA | Insert 1 employee (90000002) with all linked data |
| Z_HR_SAMPLE_DATA_50 | Insert 50 employees (90000003-90000052) across 5 departments |

### CDS Views (19 total)
| View | Source Table | Type |
|------|-------------|------|
| ZI_HR_Employee | PA0000 + PA0001 + PA0002 | Parent (joined) |
| ZI_HR_Address | PA0006 | Child via PERNR |
| ZI_HR_PayrollStatus | PA0003 | Child via PERNR |
| ZI_HR_WorkingTime | PA0007 | Child via PERNR |
| ZI_HR_BasicPay | PA0008 | Child via PERNR |
| ZI_HR_BankDetail | PA0009 | Child via PERNR |
| ZI_HR_RecurringPay | PA0014 | Child via PERNR |
| ZI_HR_AdditionalPay | PA0015 | Child via PERNR |
| ZI_HR_Family | PA0021 | Child via PERNR |
| ZI_HR_InternalCtrl | PA0032 | Child via PERNR |
| ZI_HR_Communication | PA0105 | Child via PERNR |
| ZI_HR_HealthPlan | PA0167 | Child via PERNR |
| ZI_HR_Benefit | PA0171 | Child via PERNR |
| ZI_HR_Absence | PA2001 | Child via PERNR |
| ZI_HR_Attendance | PA2002 | Child via PERNR |
| ZI_HR_LeaveQuota | PA2006 | Child via PERNR |
| ZI_HR_OrgUnit | HRP1000 (otype=O) | Association via ORGEH |
| ZI_HR_Position | HRP1000 (otype=S) | Association via PLANS |
| ZI_HR_Job | HRP1000 (otype=C) | Association via STELL |

### Service Objects
| Object | Type | Description |
|--------|------|-------------|
| ZSD_HR_EMPLOYEE | SRVD | Service Definition (created manually in ADT) |
| ZSB_HR_EMPLOYEE_V2 | SRVB | Service Binding OData V2 - Web API (created manually in ADT) |

---

## 3. OData Service URLs

### V2 Service (active)
```
Base:     /sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2
Metadata: /sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/$metadata

All employees:
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/Employee?$format=json

Single employee:
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/Employee?$filter=Pernr eq '90000002'&$format=json

Expand all children:
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/Employee?$filter=Pernr eq '90000002'&$expand=to_Address,to_BasicPay,to_OrgUnit,to_Position&$format=json

Individual entities:
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/Address?$format=json
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/BasicPay?$format=json
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/Family?$format=json
/sap/opu/odata/sap/ZSB_HR_EMPLOYEE_V2/OrgUnit?$format=json
```

### V4 Service (SICF path not auto-created in 2020)
```
/sap/opu/odata4/sap/zsd_hr_employee_v4/ — needs manual SICF setup
V4 returns clean date format: "2025-01-01"
V2 returns /Date(timestamp)/ format
```

---

## 4. Date Format Handling (V2 vs V4)

### V2 JSON Output
```json
"Begda" : "/Date(1735689600000)/"
"DateOfBirth" : "/Date(632361600000)/"
```

### V4 JSON Output
```json
"Begda" : "2025-01-01"
"DateOfBirth" : "1990-01-15"
```

### Workarounds for V2 date format
1. Add request header `sap-dateformat: 7` → returns YYYYMMDD
2. Use XML format (no `$format=json`) → returns 2025-01-01T00:00:00
3. Parse on client side:
```javascript
let ts = "/Date(1735689600000)/";
let date = new Date(parseInt(ts.match(/\d+/)[0]));
// → 2025-01-01
```

---

## 5. Technical Issues Resolved

### PA table INFTY field
- PA structures (PA0000, PA0001 etc.) do NOT have an INFTY column
- Infotype number is implicit from the table name
- **Fix:** Remove all `ls_paXXXX-infty` lines

### PDATE Conversion Exit
- PA date fields (BEGDA, ENDDA, GBDAT, FGBDT, AEDTM) have PDATE conversion exit
- OData V4 rejects these with error: "Do not use conversion ext PDATE here"
- **Fix:** `cast( field as abap.dats )` in CDS views

### ALPHA Conversion on PERNR
- PERNR has ALPHA conversion exit
- Can cause padding issues in OData
- **Fix:** `cast( pernr as abap.numc(8) )` in CDS views

### Currency Reference Fields
- PA0008: ANSAL needs ANCUR, BET01 needs WAERS
- PA0014/PA0015: BETRG needs WAERS
- **Fix:** Expose the currency reference field in same CDS view

### OData Entity Name Conflicts
- Field alias cannot match an OData entity type name
- `anssa as AddressType` → conflicts with entity `AddressType`
- **Fix:** Renamed to `anssa as AddrType`

### PA0021 Field Names
- First name = FAVOR (not FNAMR)
- Last name = FANAM (not FAMNA)

### PA0167/PA0171 Fields
- BPLAN does not exist in these tables
- Use BAREA, BENGR, BSTAT instead

### Consumption View (RAP)
- `as projection on` requires RAP root/composition setup
- `redirected to` only works with compositions
- **Fix:** Removed consumption view, exposed ZI_HR_Employee directly in service definition

### abapGit SRVD files
- Service Definition .srvd files may not pull correctly via abapGit
- **Fix:** Create Service Definition and Service Binding manually in ADT
- **Important:** After creating manually, Stage + Push from abapGit to save in repo

### Arithmetic in WHERE clause
- `objid = lv_oid + 1` not allowed in ABAP WHERE clause
- **Fix:** Calculate to temp variable first, then use in WHERE

---

## 6. Config Tables Read by Mock Data Programs

| Config Table | Fields | Used In |
|-------------|--------|---------|
| T001 | BUKRS, WAERS | PA0001, PA0009, PA0014, PA0015, PA0032 |
| T500P | PERSA, MOLGA | PA0001, PA0002 |
| T001P | BTRTL | PA0001 |
| T503 | PERSG, PERSK | PA0001 |
| CSKS | KOSTL | PA0001 |
| T549A | ABKRS | PA0001 |
| T508A | SCHKZ | PA0007 |
| T510 | TRFAR, TRFGB, TRFGR, TRFST | PA0008 |
| T512T | LGART (3 wage types) | PA0008, PA0014, PA0015 |
| BNKA | BANKL, BANKS | PA0009, PA0006 |
| T554S | AWART (2 types) | PA2001, PA2002 |
| T556B | KTART | PA2006 |

### Config Values in GCD
```
Company Code: 0001    Currency: USD
Personnel Area: AR01   Country: 29
Pers Subarea: 0001
Emp Group: 1           Subgroup: A0
Cost Center: 1001111002
Payroll Area: $F
Work Schedule: TH5D
Pay Scale: 20/20/I/23
Wage Types: $369, $36J, ****
Bank: 031319058 (US)
```

---

## 7. Mock Data Structure (50 employees)

### 5 Departments (OM)
| Org Unit | Position | Job | ORGEH | PLANS | STELL |
|----------|----------|-----|-------|-------|-------|
| IT Department | SAP Developer | Software Developer | 50000000 | 50000001 | 50000002 |
| HR Department | HR Specialist | HR Manager | 50000010 | 50000011 | 50000012 |
| Finance Dept | Finance Analyst | Financial Analyst | 50000020 | 50000021 | 50000022 |
| Sales Department | Sales Executive | Sales Manager | 50000030 | 50000031 | 50000032 |
| Operations Dept | Operations Lead | Operations Manager | 50000040 | 50000041 | 50000042 |

### Employee Distribution
- PERNR 90000002: Original test employee (Ravi Kumar)
- PERNR 90000003-90000052: 50 bulk employees
- 10 per department (round-robin)
- 25 unique name combinations
- 10 cities (Hyderabad, Bangalore, Mumbai, Chennai, Delhi, Pune, Kolkata, Jaipur, Kochi, Ahmedabad)
- Salary range: 8,20,000 - 18,00,000
- DOB range: 1980 - 1999

---

## 8. Activation Order (for fresh pull)
1. All 18 child CDS views (no dependencies)
2. Parent CDS: ZI_HR_Employee
3. Service Definition: ZSD_HR_EMPLOYEE (create manually in ADT if not pulled)
4. Service Binding: ZSB_HR_EMPLOYEE_V2 (always create manually in ADT)
5. Publish Service Binding

---

## 9. V4 Service Notes (SAP 2020)
- `/IWFND/V4_ADMIN` transaction NOT available in SAP 2020
- SICF path `/sap/opu/odata4/sap/` exists but sub-nodes not auto-created
- V4 service binding can be created in ADT but needs manual SICF node setup
- **Recommendation:** Use V2 for SAP 2020 systems, V4 for 2023+

---

## End of Document
SAP HR Technical Notes - System: GCD
