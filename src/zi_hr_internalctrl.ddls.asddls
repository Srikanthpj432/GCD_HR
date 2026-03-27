@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Internal Control'
define view entity ZI_HR_InternalCtrl as select from pa0032 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  cast( pnalt as abap.numc(8) ) as PrevPernr,
  wausw as CompanyId,
  waers as Currency,
  gebnr as BuildingNo,
  zimnr as RoomNo,
  tel01 as InHousePhone
}
