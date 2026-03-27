@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Communication'
define view entity ZI_HR_Communication as select from pa0105 {
  key cast( pernr as abap.numc(8) ) as Pernr,
  key subty as Subty,
  key cast( endda as abap.dats ) as Endda,
  key cast( begda as abap.dats ) as Begda,
  seqnr as Seqnr,
  usrid as UserId,
  usrid_long as EmailAddress
}
