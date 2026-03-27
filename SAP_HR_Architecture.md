
# SAP HR Complete Architecture & ERD

## Overview
SAP HR (HCM) consists of the following major modules:
1. Personnel Administration (PA)
2. Organizational Management (OM)
3. Payroll (PY)
4. Time Management (TM)
5. Benefits (BN)
6. Travel Management (TR)
7. Company Structure

Main Keys:
- PERNR (Employee)
- PLANS (Position)
- ORGEH (Org Unit)
- OBJID (OM Object)
- BEGDA / ENDDA (Validity Dates)

---

## 1. Company Structure Tables
| Table | Description |
|------|-------------|
| T001 | Company Code |
| T500P | Personnel Area |
| T001P | Personnel Subarea |
| T501 | Employee Group |
| T503 | Employee Subgroup |
| CSKS | Cost Center |
| T549A | Payroll Area |

Relationship Flow:
Company Code → Personnel Area → Personnel Subarea → Employee Group/Subgroup

---

## 2. Organizational Management (OM)
| Table | Description |
|------|-------------|
| HRP1000 | OM Objects (Org Unit, Position, Job, Person) |
| HRP1001 | OM Relationships (Reports To, Holder, Org Structure) |
| HRP1002 | Descriptions |
| HRP1008 | Account Assignment |

Object Types:
O = Org Unit  
S = Position  
C = Job  
P = Person  

Important Relationships:
A002 = Reports To (Manager)  
A003 = Belongs to Org Unit  
A008 = Holder (Person assigned to Position)  

---

## 3. Personnel Administration (PA)
| Infotype | Table | Description |
|----------|-------|-------------|
| IT0000 | PA0000 | Actions |
| IT0001 | PA0001 | Organizational Assignment |
| IT0002 | PA0002 | Personal Data |
| IT0006 | PA0006 | Address |
| IT0007 | PA0007 | Planned Working Time |
| IT0008 | PA0008 | Basic Pay |
| IT0009 | PA0009 | Bank Details |
| IT0014 | PA0014 | Recurring Payments |
| IT0015 | PA0015 | Additional Payments |
| IT0167 | PA0167 | Benefits |
| IT0171 | PA0171 | Insurance |

All PA tables linked by:
PERNR, BEGDA, ENDDA

---

## 4. Time Management
| Table | Description |
|------|-------------|
| PA2001 | Absences (Leave) |
| PA2002 | Attendances |
| PA2005 | Overtime |
| PA2006 | Leave Quotas |
| TEVEN | Time Events |

---

## 5. Payroll
| Table | Description |
|------|-------------|
| RGDIR | Payroll Result Directory |
| PCL2 | Payroll Results Cluster |
| T512W | Wage Types |
| T549A | Payroll Area |

Flow:
Employee → RGDIR → PCL2

---

## 6. Travel Management
| Table | Description |
|------|-------------|
| PTRV_HEAD | Travel Request Header |
| PTRV_PERIO | Travel Expenses |
| PTRV_DOC | Travel Receipts |
| PTRV_COST | Travel Costs |

---

## 7. Employee Manager Relationship
Flow:
Employee PERNR  
→ PA0001 Position  
→ HRP1001 A002 Reports To  
→ Manager Position  
→ HRP1001 A008 Holder  
→ Manager PERNR  

---

## 8. Complete HR ERD (Text Diagram)
Company Code (T001)
→ Personnel Area (T500P)
→ Personnel Subarea (T001P)
→ Employee Group/Subgroup (T501/T503)
→ PA0000 (Employee Actions)
→ PA0001 (Org Assignment)
→ HRP1000 (Position)
→ HRP1001 (Relationships)
→ Org Unit / Manager / Job

Employee Related Tables:
PA0002 Personal  
PA0006 Address  
PA0008 Salary  
PA0009 Bank  
PA0014 Allowances  
PA0015 Deductions  
PA0167 Benefits  
PA0171 Insurance  

Time:
PA2001 Leave  
PA2002 Attendance  
PA2006 Leave Quota  

Payroll:
RGDIR → PCL2  

Travel:
PTRV_HEAD → PTRV_PERIO → PTRV_DOC  

---

## 9. Core HR Extraction Tables
T001  
T500P  
T001P  
T501  
T503  
CSKS  
HRP1000  
HRP1001  
PA0000  
PA0001  
PA0002  
PA0006  
PA0007  
PA0008  
PA0009  
PA0014  
PA0015  
PA0167  
PA0171  
PA2001  
PA2002  
PA2006  
RGDIR  
PCL2  
PTRV_HEAD  
PTRV_PERIO  
PTRV_DOC  

---

## 10. Recommended Extraction Order
1. Company Structure  
2. Organization Structure  
3. Employee Master  
4. Salary & Payments  
5. Time Management  
6. Payroll  
7. Benefits  
8. Travel  

---

## End of Document
SAP HR Complete Architecture & ERD
