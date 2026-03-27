*&---------------------------------------------------------------------*
*& Report Z_HR_SAMPLE_DATA
*& Insert 1 employee with all linked data for HCMFAB_EMPLOYEELOOKUP_SRV
*& NON-PRODUCTION USE ONLY
*&---------------------------------------------------------------------*
REPORT z_hr_sample_data.

PARAMETERS: p_pernr TYPE persno DEFAULT '90000002',
            p_mode  TYPE c LENGTH 1 DEFAULT 'I'.
* p_mode: I = Insert, D = Delete

DATA: lv_begda TYPE begda VALUE '20250101',
      lv_endda TYPE endda VALUE '99991231'.

START-OF-SELECTION.

  IF p_mode = 'D'.
    PERFORM delete_all USING p_pernr.
  ELSE.
    PERFORM insert_all USING p_pernr lv_begda lv_endda.
  ENDIF.

*&---------------------------------------------------------------------*
*& Form INSERT_ALL
*&---------------------------------------------------------------------*
FORM insert_all USING iv_pernr TYPE persno
                      iv_begda TYPE begda
                      iv_endda TYPE endda.

  DATA: ls_pa0000 TYPE pa0000,
        ls_pa0001 TYPE pa0001,
        ls_pa0002 TYPE pa0002,
        ls_pa0006 TYPE pa0006,
        ls_pa0105 TYPE pa0105,
        ls_pa0003 TYPE pa0003,
        ls_pa0032 TYPE pa0032,
        ls_hrp1000 TYPE hrp1000,
        ls_hrp1001 TYPE hrp1001.

*=== PA0000: Actions (Employment Status = Active) =====================
  CLEAR ls_pa0000.
  ls_pa0000-mandt  = sy-mandt.
  ls_pa0000-pernr  = iv_pernr.
  ls_pa0000-endda  = iv_endda.
  ls_pa0000-begda  = iv_begda.
  ls_pa0000-seqnr  = '000'.
  ls_pa0000-massn  = '01'.       "Hiring
  ls_pa0000-massg  = '01'.       "New hire
  ls_pa0000-stat2  = '3'.        "Employment status: Active
  ls_pa0000-stat1  = '1'.        "Status: Active
  MODIFY pa0000 FROM ls_pa0000.
  WRITE: / 'PA0000 (Actions):', sy-subrc.

*=== PA0001: Org Assignment (linked to OM objects below) ==============
  CLEAR ls_pa0001.
  ls_pa0001-mandt  = sy-mandt.
  ls_pa0001-pernr  = iv_pernr.
  ls_pa0001-endda  = iv_endda.
  ls_pa0001-begda  = iv_begda.
  ls_pa0001-seqnr  = '000'.
  ls_pa0001-bukrs  = '1000'.     "Company code
  ls_pa0001-werks  = '1000'.     "Personnel area
  ls_pa0001-btrtl  = '0001'.     "Personnel subarea
  ls_pa0001-persg  = '1'.        "Employee group
  ls_pa0001-persk  = '01'.       "Employee subgroup
  ls_pa0001-orgeh  = '50000000'. "Org unit  -> HRP1000 otype=O
  ls_pa0001-plans  = '50000001'. "Position  -> HRP1000 otype=S
  ls_pa0001-stell  = '50000002'. "Job       -> HRP1000 otype=C
  ls_pa0001-kostl  = '1000'.     "Cost center
  ls_pa0001-abkrs  = '01'.       "Payroll area
  MODIFY pa0001 FROM ls_pa0001.
  WRITE: / 'PA0001 (Org Assignment):', sy-subrc.

*=== PA0002: Personal Data ============================================
  CLEAR ls_pa0002.
  ls_pa0002-mandt  = sy-mandt.
  ls_pa0002-pernr  = iv_pernr.
  ls_pa0002-endda  = iv_endda.
  ls_pa0002-begda  = iv_begda.
  ls_pa0002-seqnr  = '000'.
  ls_pa0002-nachn  = 'Kumar'.
  ls_pa0002-vorna  = 'Ravi'.
  ls_pa0002-rufnm  = 'Ravi'.
  ls_pa0002-gesch  = '1'.           "Male
  ls_pa0002-gbdat  = '19900115'.
  ls_pa0002-sprsl  = 'E'.
  ls_pa0002-natio  = 'IN'.
  ls_pa0002-gbort  = 'Hyderabad'.
  MODIFY pa0002 FROM ls_pa0002.
  WRITE: / 'PA0002 (Personal Data):', sy-subrc.

*=== PA0006: Permanent Address ========================================
  CLEAR ls_pa0006.
  ls_pa0006-mandt  = sy-mandt.
  ls_pa0006-pernr  = iv_pernr.
  ls_pa0006-subty  = '1'.           "Permanent address
  ls_pa0006-endda  = iv_endda.
  ls_pa0006-begda  = iv_begda.
  ls_pa0006-seqnr  = '000'.
  ls_pa0006-anssa  = '1'.
  ls_pa0006-stras  = '123 MG Road'.
  ls_pa0006-ort01  = 'Hyderabad'.
  ls_pa0006-pstlz  = '500001'.
  ls_pa0006-land1  = 'IN'.
  ls_pa0006-state  = '36'.
  MODIFY pa0006 FROM ls_pa0006.
  WRITE: / 'PA0006 (Address):', sy-subrc.

*=== PA0105: Email (subtype 0010) =====================================
  CLEAR ls_pa0105.
  ls_pa0105-mandt  = sy-mandt.
  ls_pa0105-pernr  = iv_pernr.
  ls_pa0105-subty  = '0010'.
  ls_pa0105-endda  = iv_endda.
  ls_pa0105-begda  = iv_begda.
  ls_pa0105-seqnr  = '000'.
  ls_pa0105-usrid  = 'RKUMAR'.
  ls_pa0105-usrid_long = 'ravi.kumar@test.com'.
  MODIFY pa0105 FROM ls_pa0105.
  WRITE: / 'PA0105 (Email):', sy-subrc.

*=== PA0105: SAP User Name (subtype 0001) =============================
  CLEAR ls_pa0105.
  ls_pa0105-mandt  = sy-mandt.
  ls_pa0105-pernr  = iv_pernr.
  ls_pa0105-subty  = '0001'.
  ls_pa0105-endda  = iv_endda.
  ls_pa0105-begda  = iv_begda.
  ls_pa0105-seqnr  = '000'.
  ls_pa0105-usrid  = 'RKUMAR'.
  MODIFY pa0105 FROM ls_pa0105.
  WRITE: / 'PA0105 (SAP User):', sy-subrc.

*=== PA0003: Payroll Status ============================================
  CLEAR ls_pa0003.
  ls_pa0003-mandt  = sy-mandt.
  ls_pa0003-pernr  = iv_pernr.
  ls_pa0003-endda  = iv_endda.
  ls_pa0003-begda  = iv_begda.
  ls_pa0003-seqnr  = '000'.
  ls_pa0003-uname  = sy-uname.      "Last changed by
  ls_pa0003-aedtm  = sy-datum.      "Last changed on
  ls_pa0003-viekn  = '10'.          "Infotype View Indicator: Detail
  MODIFY pa0003 FROM ls_pa0003.
  WRITE: / 'PA0003 (Payroll Status):', sy-subrc.

*=== PA0032: Internal Control ==========================================
  CLEAR ls_pa0032.
  ls_pa0032-mandt  = sy-mandt.
  ls_pa0032-pernr  = iv_pernr.
  ls_pa0032-subty  = ''.
  ls_pa0032-endda  = iv_endda.
  ls_pa0032-begda  = iv_begda.
  ls_pa0032-seqnr  = '000'.
  ls_pa0032-pnalt  = '000000000001'.  "Previous Personnel Number
  ls_pa0032-wausw  = 'COMP1000'.     "Company ID
  ls_pa0032-pkwrg  = '1'.            "Regulation for Taxation of Company Car
  ls_pa0032-pkwwr  = '500000'.       "Car Value
  ls_pa0032-kfzkz  = 'TS09AB1234'.   "License Plate Number
  ls_pa0032-waers  = 'INR'.          "Currency Key
  ls_pa0032-anlnr  = 'AST00001'.     "Car Asset Number
  ls_pa0032-gebnr  = 'B001'.         "Building Number
  ls_pa0032-zimnr  = 'R101'.         "Room Number
  ls_pa0032-tel01  = '12345'.        "In-House Telephone Number
  MODIFY pa0032 FROM ls_pa0032.
  WRITE: / 'PA0032 (Internal Control):', sy-subrc.

*=== HRP1000: Org Unit text (O 50000000) ==============================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'O'.          "Org Unit
  ls_hrp1000-objid  = '50000000'.
  ls_hrp1000-istat  = '1'.          "Active
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = 'E'.
  ls_hrp1000-stext  = 'IT Department'.
  ls_hrp1000-short  = 'IT Dept'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Org Unit O 50000000):', sy-subrc.

*=== HRP1000: Position text (S 50000001) ==============================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'S'.          "Position
  ls_hrp1000-objid  = '50000001'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = 'E'.
  ls_hrp1000-stext  = 'SAP Developer'.
  ls_hrp1000-short  = 'SAP Dev'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Position S 50000001):', sy-subrc.

*=== HRP1000: Job text (C 50000002) ===================================
  CLEAR ls_hrp1000.
  ls_hrp1000-mandt  = sy-mandt.
  ls_hrp1000-plvar  = '01'.
  ls_hrp1000-otype  = 'C'.          "Job
  ls_hrp1000-objid  = '50000002'.
  ls_hrp1000-istat  = '1'.
  ls_hrp1000-begda  = iv_begda.
  ls_hrp1000-endda  = iv_endda.
  ls_hrp1000-langu  = 'E'.
  ls_hrp1000-stext  = 'Software Developer'.
  ls_hrp1000-short  = 'SW Dev'.
  MODIFY hrp1000 FROM ls_hrp1000.
  WRITE: / 'HRP1000 (Job C 50000002):', sy-subrc.

*=== HRP1001: Position -> Org Unit (S belongs to O) ===================
* Relationship A003: S 50000001 belongs to O 50000000
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt  = sy-mandt.
  ls_hrp1001-plvar  = '01'.
  ls_hrp1001-otype  = 'S'.
  ls_hrp1001-objid  = '50000001'.
  ls_hrp1001-rsign  = 'A'.          "A = relationship from this object
  ls_hrp1001-relat  = '003'.        "Belongs to
  ls_hrp1001-istat  = '1'.
  ls_hrp1001-begda  = iv_begda.
  ls_hrp1001-endda  = iv_endda.
  ls_hrp1001-sclas  = 'O'.
  ls_hrp1001-sobid  = '50000000'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->O belongs to):', sy-subrc.

*=== HRP1001: Org Unit -> Position (O incorporates S) =================
* Relationship B003: O 50000000 incorporates S 50000001
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt  = sy-mandt.
  ls_hrp1001-plvar  = '01'.
  ls_hrp1001-otype  = 'O'.
  ls_hrp1001-objid  = '50000000'.
  ls_hrp1001-rsign  = 'B'.          "B = reverse relationship
  ls_hrp1001-relat  = '003'.        "Incorporates
  ls_hrp1001-istat  = '1'.
  ls_hrp1001-begda  = iv_begda.
  ls_hrp1001-endda  = iv_endda.
  ls_hrp1001-sclas  = 'S'.
  ls_hrp1001-sobid  = '50000001'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (O->S incorporates):', sy-subrc.

*=== HRP1001: Position -> Job (S describes C) =========================
* Relationship A007: S 50000001 describes C 50000002
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt  = sy-mandt.
  ls_hrp1001-plvar  = '01'.
  ls_hrp1001-otype  = 'S'.
  ls_hrp1001-objid  = '50000001'.
  ls_hrp1001-rsign  = 'A'.
  ls_hrp1001-relat  = '007'.        "Describes
  ls_hrp1001-istat  = '1'.
  ls_hrp1001-begda  = iv_begda.
  ls_hrp1001-endda  = iv_endda.
  ls_hrp1001-sclas  = 'C'.
  ls_hrp1001-sobid  = '50000002'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->C describes job):', sy-subrc.

*=== HRP1001: Position -> Person (S is held by P) =====================
* Relationship A008: S 50000001 is held by P <pernr>
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt  = sy-mandt.
  ls_hrp1001-plvar  = '01'.
  ls_hrp1001-otype  = 'S'.
  ls_hrp1001-objid  = '50000001'.
  ls_hrp1001-rsign  = 'A'.
  ls_hrp1001-relat  = '008'.        "Holder
  ls_hrp1001-istat  = '1'.
  ls_hrp1001-begda  = iv_begda.
  ls_hrp1001-endda  = iv_endda.
  ls_hrp1001-sclas  = 'P'.
  ls_hrp1001-sobid  = iv_pernr.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (S->P holder):', sy-subrc.

*=== HRP1001: Person -> Position (P is holder of S) ===================
* Relationship B008: P <pernr> holds S 50000001
  CLEAR ls_hrp1001.
  ls_hrp1001-mandt  = sy-mandt.
  ls_hrp1001-plvar  = '01'.
  ls_hrp1001-otype  = 'P'.
  ls_hrp1001-objid  = iv_pernr.
  ls_hrp1001-rsign  = 'B'.
  ls_hrp1001-relat  = '008'.        "Holds
  ls_hrp1001-istat  = '1'.
  ls_hrp1001-begda  = iv_begda.
  ls_hrp1001-endda  = iv_endda.
  ls_hrp1001-sclas  = 'S'.
  ls_hrp1001-sobid  = '50000001'.
  MODIFY hrp1001 FROM ls_hrp1001.
  WRITE: / 'HRP1001 (P->S holds position):', sy-subrc.

  COMMIT WORK AND WAIT.

  WRITE: / ''.
  WRITE: / '=== Summary ==='.
  WRITE: / 'Employee:', iv_pernr, '- Ravi Kumar'.
  WRITE: / 'PA tables: PA0000, PA0001, PA0002, PA0006, PA0105'.
  WRITE: / 'OM tables: HRP1000 (O, S, C), HRP1001 (relationships)'.
  WRITE: / 'Org Unit: 50000000 (IT Department)'.
  WRITE: / 'Position: 50000001 (SAP Developer)'.
  WRITE: / 'Job:      50000002 (Software Developer)'.
  WRITE: / 'Linkage:  P->S->O, S->C (all A/B pairs)'.
  WRITE: / ''.
  WRITE: / 'rc=0 means success, rc=4 means duplicate key (already exists)'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_ALL
*&---------------------------------------------------------------------*
FORM delete_all USING iv_pernr TYPE persno.

  DELETE FROM pa0000 WHERE pernr = iv_pernr.
  WRITE: / 'PA0000 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0001 WHERE pernr = iv_pernr.
  WRITE: / 'PA0001 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0002 WHERE pernr = iv_pernr.
  WRITE: / 'PA0002 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0003 WHERE pernr = iv_pernr.
  WRITE: / 'PA0003 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0032 WHERE pernr = iv_pernr.
  WRITE: / 'PA0032 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0006 WHERE pernr = iv_pernr.
  WRITE: / 'PA0006 deleted:', sy-dbcnt, 'rows'.
  DELETE FROM pa0105 WHERE pernr = iv_pernr.
  WRITE: / 'PA0105 deleted:', sy-dbcnt, 'rows'.

  DELETE FROM hrp1000 WHERE otype = 'O' AND objid = '50000000'.
  DELETE FROM hrp1000 WHERE otype = 'S' AND objid = '50000001'.
  DELETE FROM hrp1000 WHERE otype = 'C' AND objid = '50000002'.
  WRITE: / 'HRP1000 deleted (O, S, C)'.

  DELETE FROM hrp1001 WHERE otype = 'O' AND objid = '50000000'.
  DELETE FROM hrp1001 WHERE otype = 'S' AND objid = '50000001'.
  DELETE FROM hrp1001 WHERE otype = 'P' AND objid = iv_pernr.
  WRITE: / 'HRP1001 deleted (relationships)'.

  COMMIT WORK AND WAIT.
  WRITE: / 'All data deleted for employee', iv_pernr.

ENDFORM.
