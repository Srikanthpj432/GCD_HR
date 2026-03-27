
# SAP HR Config Mapping & Mock Data Reference

## 1. Config Tables Used by Z_HR_SAMPLE_DATA Program
| Config Table | Fields Selected | Used In |
|-------------|----------------|---------|
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

---

## 2. HRP1001 Relationship Map (Complete)
| Relat | A direction (RSIGN=A) | B direction (RSIGN=B) |
|-------|----------------------|----------------------|
| 002 | O reports to O | O is line supervisor of O |
| 003 | S belongs to O | O incorporates S |
| 007 | S describes C (Job) | C is described by S |
| 008 | S is held by P | P is holder of S |
| 011 | S is cost center of K | K has cost center S |
| 012 | O has chief position S | S is chief of O |
| 017 | S is successor of S | S succeeded by S |

### Manager Chain Resolution
```
Employee P (PERNR)
  → holds Position S via HRP1001 relat=008 (B008)
    → Position belongs to Org Unit O via HRP1001 relat=003 (A003)
      → Org Unit has Chief Position S via HRP1001 relat=012 (A012)
        → Chief Position held by P = MANAGER via HRP1001 relat=008 (A008)
```

---

## 3. Complete ERD with Config Links

```
Company Code (T001) ──BUKRS──→ Personnel Area (T500P)
                                    │
                               ──WERKS──→ Personnel Subarea (T001P)
                                    │
                               ──→ Employee Group/Subgroup (T503)
                                    │
                                    ▼
                              PA0001 (Org Assignment)
                              ┌─────────┼─────────┐
                              │         │         │
                         BUKRS(T001) WERKS(T500P) KOSTL(CSKS)
                         PERSG(T503) BTRTL(T001P) ABKRS(T549A)
                              │
                    ┌─────────┼──────────┐
                    │         │          │
               ORGEH→O   PLANS→S    STELL→C
              (HRP1000)  (HRP1000)  (HRP1000)
                    │         │          │
                    └────HRP1001─────────┘
                     A003(belongs), A007(describes),
                     A008(holder), A012(chief)

Employee (PERNR) links to:
├── PA0000  Actions
├── PA0001  Org Assignment ── Config: T001,T500P,T001P,T503,CSKS,T549A
├── PA0002  Personal Data ─── Config: T500P (country)
├── PA0003  Payroll Status
├── PA0006  Address ───────── Config: BNKA (country)
├── PA0007  Working Time ──── Config: T508A (schedule rule)
├── PA0008  Basic Pay ─────── Config: T510 (pay scale), T512T (wage types)
├── PA0009  Bank Details ──── Config: BNKA (bank key), T001 (currency)
├── PA0014  Recurring Pay ─── Config: T512T (wage types), T001 (currency)
├── PA0015  Additional Pay ── Config: T512T (wage types), T001 (currency)
├── PA0021  Family Members
├── PA0032  Internal Control ─ Config: T001 (company, currency)
├── PA0105  Communication
├── PA0167  Health Plans
├── PA0171  General Benefits
├── PA2001  Absences ──────── Config: T554S (absence types)
├── PA2002  Attendances ───── Config: T554S (attendance types)
└── PA2006  Leave Quotas ──── Config: T556B (quota types)
```

---

## 4. OM Structure Created by Mock Data

```
O (50000000) IT Department
├── S (50000001) SAP Developer ── held by P (PERNR) via A008
│   └── C (50000002) Software Developer via A007
└── S (50000099) IT Manager ───── Chief Position via A012
    └── C (50000003) IT Manager Job via A007

Manager Chain:
P ──B008──→ S ──A003──→ O ──A012──→ Mgr S ──A008──→ Mgr P
```

---

## 5. Mock Data Summary (Z_HR_SAMPLE_DATA)
- PERNR: 90000002 (default)
- Uses MODIFY (safe for re-run, no dump on duplicates)
- All config values read dynamically via SELECT
- Mode I = Insert, Mode D = Delete (full cleanup)

### Tables Maintained
**PA (18 tables):** PA0000, PA0001, PA0002, PA0003, PA0006, PA0007, PA0008, PA0009, PA0014, PA0015, PA0021, PA0032, PA0105(x2), PA0167, PA0171, PA2001, PA2002, PA2006

**OM Objects (5):** O(50000000), S(50000001), C(50000002), Mgr S(50000099), Mgr C(50000003)

**OM Relationships (11):** A/B003, A007, A/B008, A/B012 + Manager position links

---

## 6. Additional Tables (Not Yet in Mock Data)

### India-Specific
| Table | Description |
|-------|-------------|
| PA0581 | PF Details |
| PA0582 | ESI Details |
| PA0583 | Gratuity |
| PA0584 | Professional Tax |
| PA0585 | Nomination Details |

### Compensation / Bonus
| Table | Description |
|-------|-------------|
| PA0267 | Off-cycle Payments |
| PA0380 | Compensation Adjustment |
| PA0381 | Compensation Eligibility Override |

### Recruitment
| Table | Description |
|-------|-------------|
| PB0001 | Applicant Actions |
| PB0002 | Applicant Personal Data |

### Performance
| Table | Description |
|-------|-------------|
| PA0025 | Appraisals |
| HRHAP | Appraisal Document Header |

### Talent / Succession
| Table | Description |
|-------|-------------|
| HRP5040 | Talent Pool |
| HRP5041 | Talent Pool Assignment |

---

## 7. Recommended Extraction Order
1. Company Structure (T001, T500P, T001P, T503, CSKS)
2. Organization Structure (HRP1000, HRP1001)
3. Employee Master (PA0000, PA0001, PA0002, PA0003, PA0006, PA0032, PA0105)
4. Salary & Payments (PA0007, PA0008, PA0009, PA0014, PA0015)
5. Time Management (PA2001, PA2002, PA2006)
6. Family & Dependents (PA0021)
7. Benefits & Insurance (PA0167, PA0171)
8. Payroll (RGDIR, PCL2)
9. Travel (PTRV_HEAD, PTRV_PERIO, PTRV_DOC)

---

## End of Document
SAP HR Config Mapping & Mock Data Reference - System: GCD
