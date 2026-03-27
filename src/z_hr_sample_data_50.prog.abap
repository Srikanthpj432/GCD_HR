*&---------------------------------------------------------------------*
*& Report Z_HR_SAMPLE_DATA_50
*& Insert 50 employees with varied data - config from existing tables
*& NON-PRODUCTION USE ONLY - System: GCD
*&---------------------------------------------------------------------*
REPORT z_hr_sample_data_50.

PARAMETERS: p_start TYPE persno DEFAULT '90000003',
            p_count TYPE i DEFAULT 50,
            p_mode  TYPE c LENGTH 1 DEFAULT 'I'.
* p_mode: I = Insert, D = Delete

DATA: lv_begda TYPE begda VALUE '20250101',
      lv_endda TYPE endda VALUE '99991231'.

*--- Config values from existing tables ---
DATA: BEGIN OF gs_cfg,
        bukrs  TYPE bukrs,
        waers  TYPE waers,
        werks  TYPE persa,
        molga  TYPE molga,
        btrtl  TYPE btrtl,
        persg  TYPE persg,
        persk  TYPE persk,
        kostl  TYPE kostl,
        abkrs  TYPE abkrs,
        schkz  TYPE pa0007-schkz,
        trfar  TYPE trfar,
        trfgb  TYPE trfgb,
        trfgr  TYPE trfgr,
        trfst  TYPE trfst,
        lgart1 TYPE lgart,
        lgart2 TYPE lgart,
        lgart3 TYPE lgart,
        bankl  TYPE bankk,
        banks  TYPE banks,
        awart  TYPE awart,
        atart  TYPE awart,
        ktart  TYPE ktart,
      END OF gs_cfg.

*--- Name pools for varied data ---
TYPES: BEGIN OF ty_name,
         fname TYPE char40,
         lname TYPE char40,
       END OF ty_name.

DATA: lt_names TYPE TABLE OF ty_name,
      lt_cities TYPE TABLE OF char40.

DATA: lv_pernr  TYPE persno,
      lv_idx    TYPE i,
      lv_dob    TYPE dats,
      lv_gender TYPE pa0002-gesch,
      lv_city   TYPE char40,
      lv_sal    TYPE pa0008-ansal,
      lv_wage   TYPE pa0008-bet01,
      lv_hra    TYPE pa0014-betrg,
      lv_bonus  TYPE pa0015-betrg,
      lv_orgeh  TYPE hrobjid,
      lv_plans  TYPE hrobjid,
      lv_stell  TYPE hrobjid.

START-OF-SELECTION.

  IF p_mode = 'D'.
    PERFORM delete_all.
    RETURN.
  ENDIF.

  PERFORM read_config.

  IF gs_cfg-bukrs IS INITIAL.
    WRITE: / 'ERROR: No company code in T001.'.
    RETURN.
  ENDIF.

  PERFORM build_name_pools.
  PERFORM print_config.
  PERFORM insert_all.

*&---------------------------------------------------------------------*
*& Form READ_CONFIG
*&---------------------------------------------------------------------*
FORM read_config.
  SELECT SINGLE bukrs waers FROM t001 INTO (gs_cfg-bukrs, gs_cfg-waers).
  SELECT SINGLE persa molga FROM t500p INTO (gs_cfg-werks, gs_cfg-molga) WHERE molga <> ''.
  IF sy-subrc <> 0. SELECT SINGLE persa molga FROM t500p INTO (gs_cfg-werks, gs_cfg-molga). ENDIF.
  SELECT SINGLE btrtl FROM t001p INTO gs_cfg-btrtl WHERE werks = gs_cfg-werks.
  IF sy-subrc <> 0. SELECT SINGLE btrtl FROM t001p INTO gs_cfg-btrtl. ENDIF.
  SELECT SINGLE persg persk FROM t503 INTO (gs_cfg-persg, gs_cfg-persk).
  SELECT SINGLE kostl FROM csks INTO gs_cfg-kostl WHERE bukrs = gs_cfg-bukrs.
  IF sy-subrc <> 0. SELECT SINGLE kostl FROM csks INTO gs_cfg-kostl. ENDIF.
  SELECT SINGLE abkrs FROM t549a INTO gs_cfg-abkrs.
  SELECT SINGLE schkz FROM t508a INTO gs_cfg-schkz.
  SELECT SINGLE trfar trfgb trfgr trfst FROM t510 INTO (gs_cfg-trfar, gs_cfg-trfgb, gs_cfg-trfgr, gs_cfg-trfst).
  SELECT lgart FROM t512t INTO gs_cfg-lgart1 UP TO 1 ROWS WHERE sprsl = sy-langu. ENDSELECT.
  IF gs_cfg-lgart1 IS INITIAL. SELECT lgart FROM t512t INTO gs_cfg-lgart1 UP TO 1 ROWS. ENDSELECT. ENDIF.
  SELECT lgart FROM t512t INTO gs_cfg-lgart2 UP TO 1 ROWS WHERE sprsl = sy-langu AND lgart > gs_cfg-lgart1. ENDSELECT.
  SELECT lgart FROM t512t INTO gs_cfg-lgart3 UP TO 1 ROWS WHERE sprsl = sy-langu AND lgart > gs_cfg-lgart2. ENDSELECT.
  SELECT SINGLE bankl banks FROM bnka INTO (gs_cfg-bankl, gs_cfg-banks).
  SELECT SINGLE awart FROM t554s INTO gs_cfg-awart.
  SELECT SINGLE awart FROM t554s INTO gs_cfg-atart WHERE awart <> gs_cfg-awart.
  SELECT SINGLE ktart FROM t556b INTO gs_cfg-ktart.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form BUILD_NAME_POOLS
*&---------------------------------------------------------------------*
FORM build_name_pools.
  DATA: ls_name TYPE ty_name.

  ls_name-fname = 'Ravi'.     ls_name-lname = 'Kumar'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Priya'.    ls_name-lname = 'Sharma'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Amit'.     ls_name-lname = 'Reddy'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Sunita'.   ls_name-lname = 'Patel'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Vikram'.   ls_name-lname = 'Nair'.      APPEND ls_name TO lt_names.
  ls_name-fname = 'Anjali'.   ls_name-lname = 'Rao'.       APPEND ls_name TO lt_names.
  ls_name-fname = 'Suresh'.   ls_name-lname = 'Singh'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Deepa'.    ls_name-lname = 'Gupta'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Rajesh'.   ls_name-lname = 'Iyer'.      APPEND ls_name TO lt_names.
  ls_name-fname = 'Kavitha'.  ls_name-lname = 'Joshi'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Arun'.     ls_name-lname = 'Verma'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Meena'.    ls_name-lname = 'Pillai'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Sanjay'.   ls_name-lname = 'Mishra'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Lakshmi'.  ls_name-lname = 'Menon'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Kiran'.    ls_name-lname = 'Das'.       APPEND ls_name TO lt_names.
  ls_name-fname = 'Divya'.    ls_name-lname = 'Bose'.      APPEND ls_name TO lt_names.
  ls_name-fname = 'Manoj'.    ls_name-lname = 'Chatterjee'.APPEND ls_name TO lt_names.
  ls_name-fname = 'Pooja'.    ls_name-lname = 'Saxena'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Ramesh'.   ls_name-lname = 'Mehta'.     APPEND ls_name TO lt_names.
  ls_name-fname = 'Swathi'.   ls_name-lname = 'Agarwal'.   APPEND ls_name TO lt_names.
  ls_name-fname = 'Naveen'.   ls_name-lname = 'Thakur'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Sneha'.    ls_name-lname = 'Pandey'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Rohit'.    ls_name-lname = 'Kapoor'.    APPEND ls_name TO lt_names.
  ls_name-fname = 'Anitha'.   ls_name-lname = 'Malhotra'.  APPEND ls_name TO lt_names.
  ls_name-fname = 'Ganesh'.   ls_name-lname = 'Tiwari'.    APPEND ls_name TO lt_names.

  APPEND 'Hyderabad' TO lt_cities.
  APPEND 'Bangalore' TO lt_cities.
  APPEND 'Mumbai'    TO lt_cities.
  APPEND 'Chennai'   TO lt_cities.
  APPEND 'Delhi'     TO lt_cities.
  APPEND 'Pune'      TO lt_cities.
  APPEND 'Kolkata'   TO lt_cities.
  APPEND 'Jaipur'    TO lt_cities.
  APPEND 'Kochi'     TO lt_cities.
  APPEND 'Ahmedabad' TO lt_cities.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PRINT_CONFIG
*&---------------------------------------------------------------------*
FORM print_config.
  WRITE: / '=== Config from existing tables ==='.
  WRITE: / 'Company:', gs_cfg-bukrs, 'Currency:', gs_cfg-waers.
  WRITE: / 'Pers Area:', gs_cfg-werks, 'Subarea:', gs_cfg-btrtl.
  WRITE: / 'Emp Group:', gs_cfg-persg, '/', gs_cfg-persk.
  WRITE: / 'Cost Center:', gs_cfg-kostl, 'Payroll:', gs_cfg-abkrs.
  WRITE: / ''.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form INSERT_ALL
*&---------------------------------------------------------------------*
FORM insert_all.

  DATA: ls_name   TYPE ty_name,
        lv_fi     TYPE i,
        lv_ci     TYPE i,
        lv_email  TYPE pa0105-usrid_long,
        lv_userid TYPE pa0105-usrid,
        lv_street TYPE pa0006-stras,
        lv_zip    TYPE pa0006-pstlz,
        lv_acct   TYPE pa0009-bankn,
        lv_numstr TYPE string.

  DATA: ls_pa0000  TYPE pa0000,
        ls_pa0001  TYPE pa0001,
        ls_pa0002  TYPE pa0002,
        ls_pa0003  TYPE pa0003,
        ls_pa0006  TYPE pa0006,
        ls_pa0007  TYPE pa0007,
        ls_pa0008  TYPE pa0008,
        ls_pa0009  TYPE pa0009,
        ls_pa0014  TYPE pa0014,
        ls_pa0015  TYPE pa0015,
        ls_pa0021  TYPE pa0021,
        ls_pa0032  TYPE pa0032,
        ls_pa0105  TYPE pa0105,
        ls_pa0167  TYPE pa0167,
        ls_pa0171  TYPE pa0171,
        ls_pa2001  TYPE pa2001,
        ls_pa2002  TYPE pa2002,
        ls_pa2006  TYPE pa2006,
        ls_hrp1000 TYPE hrp1000,
        ls_hrp1001 TYPE hrp1001.

  lv_pernr = p_start.

  DO p_count TIMES.
    lv_idx = sy-index.

    " Pick name and city
    lv_fi = ( lv_idx MOD 25 ) + 1.
    lv_ci = ( lv_idx MOD 10 ) + 1.
    READ TABLE lt_names INTO ls_name INDEX lv_fi.
    READ TABLE lt_cities INTO lv_city INDEX lv_ci.

    " Vary gender
    IF lv_idx MOD 2 = 0. lv_gender = '2'. ELSE. lv_gender = '1'. ENDIF.

    " Vary DOB: 1980-1999
    lv_dob = '19800101'.
    lv_dob+0(4) = 1980 + ( lv_idx MOD 20 ).
    lv_dob+4(2) = ( lv_idx MOD 12 ) + 1.
    lv_dob+6(2) = ( lv_idx MOD 28 ) + 1.

    " Vary salary
    lv_sal   = 800000 + ( lv_idx * 20000 ).
    lv_wage  = lv_sal / 12.
    lv_hra   = lv_wage * 40 / 100.
    lv_bonus = lv_wage * 2.

    " Vary org unit / position (5 departments)
    CASE lv_idx MOD 5.
      WHEN 0. lv_orgeh = '50000000'. lv_plans = '50000001'. lv_stell = '50000002'. "IT
      WHEN 1. lv_orgeh = '50000010'. lv_plans = '50000011'. lv_stell = '50000012'. "HR
      WHEN 2. lv_orgeh = '50000020'. lv_plans = '50000021'. lv_stell = '50000022'. "Finance
      WHEN 3. lv_orgeh = '50000030'. lv_plans = '50000031'. lv_stell = '50000032'. "Sales
      WHEN 4. lv_orgeh = '50000040'. lv_plans = '50000041'. lv_stell = '50000042'. "Operations
    ENDCASE.

    " Build email and user ID
    lv_numstr = lv_idx.
    CONDENSE lv_numstr NO-GAPS.
    CONCATENATE ls_name-fname '.' ls_name-lname lv_numstr '@test.com' INTO lv_email.
    TRANSLATE lv_email TO LOWER CASE.
    CONDENSE lv_email NO-GAPS.
    CONCATENATE ls_name-fname(3) ls_name-lname(3) lv_numstr INTO lv_userid.
    TRANSLATE lv_userid TO UPPER CASE.
    CONDENSE lv_userid NO-GAPS.

    " Street / zip / account
    CONCATENATE lv_numstr 'Main Street' INTO lv_street SEPARATED BY space.
    lv_zip = 500000 + lv_idx.
    lv_acct = 1000000000 + lv_idx.

    "=== PA0000 ===
    CLEAR ls_pa0000.
    ls_pa0000-mandt = sy-mandt. ls_pa0000-pernr = lv_pernr.
    ls_pa0000-endda = lv_endda. ls_pa0000-begda = lv_begda.
    ls_pa0000-seqnr = '000'. ls_pa0000-massn = '01'. ls_pa0000-massg = '01'.
    ls_pa0000-stat2 = '3'. ls_pa0000-stat1 = '1'.
    MODIFY pa0000 FROM ls_pa0000.

    "=== PA0001 ===
    CLEAR ls_pa0001.
    ls_pa0001-mandt = sy-mandt. ls_pa0001-pernr = lv_pernr.
    ls_pa0001-endda = lv_endda. ls_pa0001-begda = lv_begda. ls_pa0001-seqnr = '000'.
    ls_pa0001-bukrs = gs_cfg-bukrs. ls_pa0001-werks = gs_cfg-werks.
    ls_pa0001-btrtl = gs_cfg-btrtl. ls_pa0001-persg = gs_cfg-persg.
    ls_pa0001-persk = gs_cfg-persk. ls_pa0001-orgeh = lv_orgeh.
    ls_pa0001-plans = lv_plans. ls_pa0001-stell = lv_stell.
    ls_pa0001-kostl = gs_cfg-kostl. ls_pa0001-abkrs = gs_cfg-abkrs.
    MODIFY pa0001 FROM ls_pa0001.

    "=== PA0002 ===
    CLEAR ls_pa0002.
    ls_pa0002-mandt = sy-mandt. ls_pa0002-pernr = lv_pernr.
    ls_pa0002-endda = lv_endda. ls_pa0002-begda = lv_begda. ls_pa0002-seqnr = '000'.
    ls_pa0002-nachn = ls_name-lname. ls_pa0002-vorna = ls_name-fname.
    ls_pa0002-rufnm = ls_name-fname. ls_pa0002-gesch = lv_gender.
    ls_pa0002-gbdat = lv_dob. ls_pa0002-sprsl = 'E'.
    ls_pa0002-natio = gs_cfg-molga. ls_pa0002-gbort = lv_city.
    MODIFY pa0002 FROM ls_pa0002.

    "=== PA0003 ===
    CLEAR ls_pa0003.
    ls_pa0003-mandt = sy-mandt. ls_pa0003-pernr = lv_pernr.
    ls_pa0003-endda = lv_endda. ls_pa0003-begda = lv_begda. ls_pa0003-seqnr = '000'.
    ls_pa0003-uname = sy-uname. ls_pa0003-aedtm = sy-datum. ls_pa0003-viekn = '10'.
    MODIFY pa0003 FROM ls_pa0003.

    "=== PA0006 ===
    CLEAR ls_pa0006.
    ls_pa0006-mandt = sy-mandt. ls_pa0006-pernr = lv_pernr.
    ls_pa0006-subty = '1'. ls_pa0006-endda = lv_endda. ls_pa0006-begda = lv_begda.
    ls_pa0006-seqnr = '000'. ls_pa0006-anssa = '1'.
    ls_pa0006-stras = lv_street. ls_pa0006-ort01 = lv_city.
    ls_pa0006-pstlz = lv_zip. ls_pa0006-land1 = gs_cfg-banks. ls_pa0006-state = '36'.
    MODIFY pa0006 FROM ls_pa0006.

    "=== PA0007 ===
    CLEAR ls_pa0007.
    ls_pa0007-mandt = sy-mandt. ls_pa0007-pernr = lv_pernr.
    ls_pa0007-endda = lv_endda. ls_pa0007-begda = lv_begda. ls_pa0007-seqnr = '000'.
    ls_pa0007-schkz = gs_cfg-schkz. ls_pa0007-empct = '100'.
    ls_pa0007-wkwdy = '5'. ls_pa0007-arbst = '08.00'.
    MODIFY pa0007 FROM ls_pa0007.

    "=== PA0008 ===
    CLEAR ls_pa0008.
    ls_pa0008-mandt = sy-mandt. ls_pa0008-pernr = lv_pernr.
    ls_pa0008-endda = lv_endda. ls_pa0008-begda = lv_begda. ls_pa0008-seqnr = '000'.
    ls_pa0008-trfar = gs_cfg-trfar. ls_pa0008-trfgb = gs_cfg-trfgb.
    ls_pa0008-trfgr = gs_cfg-trfgr. ls_pa0008-trfst = gs_cfg-trfst.
    ls_pa0008-ansal = lv_sal. ls_pa0008-bet01 = lv_wage.
    ls_pa0008-lga01 = gs_cfg-lgart1. ls_pa0008-waers = gs_cfg-waers.
    MODIFY pa0008 FROM ls_pa0008.

    "=== PA0009 ===
    CLEAR ls_pa0009.
    ls_pa0009-mandt = sy-mandt. ls_pa0009-pernr = lv_pernr.
    ls_pa0009-subty = '0'. ls_pa0009-endda = lv_endda. ls_pa0009-begda = lv_begda.
    ls_pa0009-seqnr = '000'. ls_pa0009-banks = gs_cfg-banks.
    ls_pa0009-bankl = gs_cfg-bankl. ls_pa0009-bankn = lv_acct.
    ls_pa0009-bkont = '01'. ls_pa0009-zlsch = 'T'. ls_pa0009-waers = gs_cfg-waers.
    MODIFY pa0009 FROM ls_pa0009.

    "=== PA0014 ===
    CLEAR ls_pa0014.
    ls_pa0014-mandt = sy-mandt. ls_pa0014-pernr = lv_pernr.
    ls_pa0014-subty = gs_cfg-lgart2. ls_pa0014-endda = lv_endda.
    ls_pa0014-begda = lv_begda. ls_pa0014-seqnr = '000'.
    ls_pa0014-betrg = lv_hra. ls_pa0014-waers = gs_cfg-waers.
    MODIFY pa0014 FROM ls_pa0014.

    "=== PA0015 ===
    CLEAR ls_pa0015.
    ls_pa0015-mandt = sy-mandt. ls_pa0015-pernr = lv_pernr.
    ls_pa0015-subty = gs_cfg-lgart3. ls_pa0015-endda = '20250331'.
    ls_pa0015-begda = '20250301'. ls_pa0015-seqnr = '000'.
    ls_pa0015-betrg = lv_bonus. ls_pa0015-waers = gs_cfg-waers.
    MODIFY pa0015 FROM ls_pa0015.

    "=== PA0021 ===
    CLEAR ls_pa0021.
    ls_pa0021-mandt = sy-mandt. ls_pa0021-pernr = lv_pernr.
    ls_pa0021-subty = '1'. ls_pa0021-endda = lv_endda. ls_pa0021-begda = lv_begda.
    ls_pa0021-seqnr = '000'. ls_pa0021-fanam = ls_name-lname.
    ls_pa0021-favor = 'Spouse'. ls_pa0021-fgbdt = lv_dob + 730.
    MODIFY pa0021 FROM ls_pa0021.

    "=== PA0032 ===
    CLEAR ls_pa0032.
    ls_pa0032-mandt = sy-mandt. ls_pa0032-pernr = lv_pernr.
    ls_pa0032-endda = lv_endda. ls_pa0032-begda = lv_begda. ls_pa0032-seqnr = '000'.
    ls_pa0032-wausw = gs_cfg-bukrs. ls_pa0032-waers = gs_cfg-waers.
    ls_pa0032-gebnr = 'B001'. ls_pa0032-zimnr = lv_numstr. ls_pa0032-tel01 = lv_numstr.
    MODIFY pa0032 FROM ls_pa0032.

    "=== PA0105: Email ===
    CLEAR ls_pa0105.
    ls_pa0105-mandt = sy-mandt. ls_pa0105-pernr = lv_pernr.
    ls_pa0105-subty = '0010'. ls_pa0105-endda = lv_endda. ls_pa0105-begda = lv_begda.
    ls_pa0105-seqnr = '000'. ls_pa0105-usrid = lv_userid.
    ls_pa0105-usrid_long = lv_email.
    MODIFY pa0105 FROM ls_pa0105.

    "=== PA0105: SAP User ===
    CLEAR ls_pa0105.
    ls_pa0105-mandt = sy-mandt. ls_pa0105-pernr = lv_pernr.
    ls_pa0105-subty = '0001'. ls_pa0105-endda = lv_endda. ls_pa0105-begda = lv_begda.
    ls_pa0105-seqnr = '000'. ls_pa0105-usrid = lv_userid.
    MODIFY pa0105 FROM ls_pa0105.

    "=== PA0167 ===
    CLEAR ls_pa0167.
    ls_pa0167-mandt = sy-mandt. ls_pa0167-pernr = lv_pernr.
    ls_pa0167-subty = '0001'. ls_pa0167-endda = lv_endda. ls_pa0167-begda = lv_begda.
    ls_pa0167-seqnr = '000'.
    MODIFY pa0167 FROM ls_pa0167.

    "=== PA0171 ===
    CLEAR ls_pa0171.
    ls_pa0171-mandt = sy-mandt. ls_pa0171-pernr = lv_pernr.
    ls_pa0171-subty = '0001'. ls_pa0171-endda = lv_endda. ls_pa0171-begda = lv_begda.
    ls_pa0171-seqnr = '000'.
    MODIFY pa0171 FROM ls_pa0171.

    "=== PA2001 ===
    CLEAR ls_pa2001.
    ls_pa2001-mandt = sy-mandt. ls_pa2001-pernr = lv_pernr.
    ls_pa2001-subty = gs_cfg-awart.
    ls_pa2001-endda = '20250115'. ls_pa2001-begda = '20250113'. ls_pa2001-seqnr = '000'.
    MODIFY pa2001 FROM ls_pa2001.

    "=== PA2002 ===
    CLEAR ls_pa2002.
    ls_pa2002-mandt = sy-mandt. ls_pa2002-pernr = lv_pernr.
    ls_pa2002-subty = gs_cfg-atart.
    ls_pa2002-endda = '20250120'. ls_pa2002-begda = '20250120'. ls_pa2002-seqnr = '000'.
    MODIFY pa2002 FROM ls_pa2002.

    "=== PA2006 ===
    CLEAR ls_pa2006.
    ls_pa2006-mandt = sy-mandt. ls_pa2006-pernr = lv_pernr.
    ls_pa2006-subty = gs_cfg-ktart.
    ls_pa2006-endda = '20251231'. ls_pa2006-begda = '20250101'. ls_pa2006-seqnr = '000'.
    ls_pa2006-anzhl = '24.00'.
    MODIFY pa2006 FROM ls_pa2006.

    "=== HRP1001: P holds S ===
    CLEAR ls_hrp1001.
    ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
    ls_hrp1001-otype = 'P'. ls_hrp1001-objid = lv_pernr.
    ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '008'. ls_hrp1001-istat = '1'.
    ls_hrp1001-begda = lv_begda. ls_hrp1001-endda = lv_endda.
    ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = lv_plans.
    MODIFY hrp1001 FROM ls_hrp1001.

    "=== HRP1001: S held by P ===
    CLEAR ls_hrp1001.
    ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
    ls_hrp1001-otype = 'S'. ls_hrp1001-objid = lv_plans.
    ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '008'. ls_hrp1001-istat = '1'.
    ls_hrp1001-begda = lv_begda. ls_hrp1001-endda = lv_endda.
    ls_hrp1001-sclas = 'P'. ls_hrp1001-sobid = lv_pernr.
    MODIFY hrp1001 FROM ls_hrp1001.

    WRITE: / lv_idx, ':', lv_pernr, ls_name-fname, ls_name-lname, lv_city.
    lv_pernr = lv_pernr + 1.
  ENDDO.

  "=== Create 5 Org Units, Positions, Jobs in HRP1000 ===
  DATA: lt_dept TYPE TABLE OF char40,
        lt_pos  TYPE TABLE OF char40,
        lt_job  TYPE TABLE OF char40,
        lv_dept TYPE char40,
        lv_pos  TYPE char40,
        lv_job  TYPE char40,
        lv_oid  TYPE hrobjid,
        lv_pid  TYPE hrobjid,
        lv_jid  TYPE hrobjid,
        lv_di   TYPE i.

  APPEND 'IT Department'    TO lt_dept.  APPEND 'HR Department'      TO lt_dept.
  APPEND 'Finance Dept'     TO lt_dept.  APPEND 'Sales Department'   TO lt_dept.
  APPEND 'Operations Dept'  TO lt_dept.

  APPEND 'SAP Developer'    TO lt_pos.   APPEND 'HR Specialist'      TO lt_pos.
  APPEND 'Finance Analyst'  TO lt_pos.   APPEND 'Sales Executive'    TO lt_pos.
  APPEND 'Operations Lead'  TO lt_pos.

  APPEND 'Software Developer' TO lt_job. APPEND 'HR Manager'         TO lt_job.
  APPEND 'Financial Analyst'  TO lt_job. APPEND 'Sales Manager'      TO lt_job.
  APPEND 'Operations Manager' TO lt_job.

  lv_di = 0.
  DO 5 TIMES.
    lv_di = lv_di + 1.
    lv_oid = 50000000 + ( ( lv_di - 1 ) * 10 ).
    lv_pid = lv_oid + 1.
    lv_jid = lv_oid + 2.
    READ TABLE lt_dept INTO lv_dept INDEX lv_di.
    READ TABLE lt_pos  INTO lv_pos  INDEX lv_di.
    READ TABLE lt_job  INTO lv_job  INDEX lv_di.

    " Org Unit
    CLEAR ls_hrp1000.
    ls_hrp1000-mandt = sy-mandt. ls_hrp1000-plvar = '01'. ls_hrp1000-otype = 'O'.
    ls_hrp1000-objid = lv_oid. ls_hrp1000-istat = '1'.
    ls_hrp1000-begda = lv_begda. ls_hrp1000-endda = lv_endda.
    ls_hrp1000-langu = sy-langu. ls_hrp1000-stext = lv_dept.
    MODIFY hrp1000 FROM ls_hrp1000.

    " Position
    CLEAR ls_hrp1000.
    ls_hrp1000-mandt = sy-mandt. ls_hrp1000-plvar = '01'. ls_hrp1000-otype = 'S'.
    ls_hrp1000-objid = lv_pid. ls_hrp1000-istat = '1'.
    ls_hrp1000-begda = lv_begda. ls_hrp1000-endda = lv_endda.
    ls_hrp1000-langu = sy-langu. ls_hrp1000-stext = lv_pos.
    MODIFY hrp1000 FROM ls_hrp1000.

    " Job
    CLEAR ls_hrp1000.
    ls_hrp1000-mandt = sy-mandt. ls_hrp1000-plvar = '01'. ls_hrp1000-otype = 'C'.
    ls_hrp1000-objid = lv_jid. ls_hrp1000-istat = '1'.
    ls_hrp1000-begda = lv_begda. ls_hrp1000-endda = lv_endda.
    ls_hrp1000-langu = sy-langu. ls_hrp1000-stext = lv_job.
    MODIFY hrp1000 FROM ls_hrp1000.

    " S belongs to O (A003)
    CLEAR ls_hrp1001.
    ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
    ls_hrp1001-otype = 'S'. ls_hrp1001-objid = lv_pid.
    ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '003'. ls_hrp1001-istat = '1'.
    ls_hrp1001-begda = lv_begda. ls_hrp1001-endda = lv_endda.
    ls_hrp1001-sclas = 'O'. ls_hrp1001-sobid = lv_oid.
    MODIFY hrp1001 FROM ls_hrp1001.

    " O incorporates S (B003)
    CLEAR ls_hrp1001.
    ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
    ls_hrp1001-otype = 'O'. ls_hrp1001-objid = lv_oid.
    ls_hrp1001-rsign = 'B'. ls_hrp1001-relat = '003'. ls_hrp1001-istat = '1'.
    ls_hrp1001-begda = lv_begda. ls_hrp1001-endda = lv_endda.
    ls_hrp1001-sclas = 'S'. ls_hrp1001-sobid = lv_pid.
    MODIFY hrp1001 FROM ls_hrp1001.

    " S describes C (A007)
    CLEAR ls_hrp1001.
    ls_hrp1001-mandt = sy-mandt. ls_hrp1001-plvar = '01'.
    ls_hrp1001-otype = 'S'. ls_hrp1001-objid = lv_pid.
    ls_hrp1001-rsign = 'A'. ls_hrp1001-relat = '007'. ls_hrp1001-istat = '1'.
    ls_hrp1001-begda = lv_begda. ls_hrp1001-endda = lv_endda.
    ls_hrp1001-sclas = 'C'. ls_hrp1001-sobid = lv_jid.
    MODIFY hrp1001 FROM ls_hrp1001.

    WRITE: / 'OM:', lv_oid, lv_dept, '/', lv_pos, '/', lv_job.
  ENDDO.

  COMMIT WORK AND WAIT.

  DATA: lv_end TYPE persno.
  lv_end = p_start + p_count - 1.
  WRITE: / ''.
  WRITE: / '=== Done ==='.
  WRITE: / p_count, 'employees created:', p_start, 'to', lv_end.
  WRITE: / '5 departments: IT, HR, Finance, Sales, Operations'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_ALL
*&---------------------------------------------------------------------*
FORM delete_all.

  DATA: lv_end TYPE persno.
  lv_pernr = p_start.
  lv_end = p_start + p_count - 1.

  WRITE: / 'Deleting employees', p_start, 'to', lv_end.

  DO p_count TIMES.
    DELETE FROM pa0000 WHERE pernr = lv_pernr.
    DELETE FROM pa0001 WHERE pernr = lv_pernr.
    DELETE FROM pa0002 WHERE pernr = lv_pernr.
    DELETE FROM pa0003 WHERE pernr = lv_pernr.
    DELETE FROM pa0006 WHERE pernr = lv_pernr.
    DELETE FROM pa0007 WHERE pernr = lv_pernr.
    DELETE FROM pa0008 WHERE pernr = lv_pernr.
    DELETE FROM pa0009 WHERE pernr = lv_pernr.
    DELETE FROM pa0014 WHERE pernr = lv_pernr.
    DELETE FROM pa0015 WHERE pernr = lv_pernr.
    DELETE FROM pa0021 WHERE pernr = lv_pernr.
    DELETE FROM pa0032 WHERE pernr = lv_pernr.
    DELETE FROM pa0105 WHERE pernr = lv_pernr.
    DELETE FROM pa0167 WHERE pernr = lv_pernr.
    DELETE FROM pa0171 WHERE pernr = lv_pernr.
    DELETE FROM pa2001 WHERE pernr = lv_pernr.
    DELETE FROM pa2002 WHERE pernr = lv_pernr.
    DELETE FROM pa2006 WHERE pernr = lv_pernr.
    DELETE FROM hrp1001 WHERE otype = 'P' AND objid = lv_pernr.
    lv_pernr = lv_pernr + 1.
  ENDDO.

  " Delete OM objects for 5 departments
  DATA: lv_oid TYPE hrobjid, lv_di2 TYPE i.
  DO 5 TIMES.
    lv_di2 = sy-index.
    lv_oid = 50000000 + ( ( lv_di2 - 1 ) * 10 ).
    DELETE FROM hrp1000 WHERE otype = 'O' AND objid = lv_oid.
    DELETE FROM hrp1000 WHERE otype = 'S' AND objid = lv_oid + 1.
    DELETE FROM hrp1000 WHERE otype = 'C' AND objid = lv_oid + 2.
    DELETE FROM hrp1001 WHERE otype = 'O' AND objid = lv_oid.
    DELETE FROM hrp1001 WHERE otype = 'S' AND objid = lv_oid + 1.
  ENDDO.

  COMMIT WORK AND WAIT.
  WRITE: / 'All deleted.'.

ENDFORM.
