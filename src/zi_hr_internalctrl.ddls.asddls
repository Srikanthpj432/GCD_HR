@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Internal Control'
define view entity ZI_HR_InternalCtrl as select from pa0032 {
  key pernr as Pernr,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  pnalt as PrevPernr,
  wausw as CompanyId,
  waers as Currency,
  gebnr as BuildingNo,
  zimnr as RoomNo,
  tel01 as InHousePhone
}
