@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HR Communication'
define view entity ZI_HR_Communication as select from pa0105 {
  key pernr as Pernr,
  key subty as Subty,
  key endda as Endda,
  key begda as Begda,
  seqnr as Seqnr,
  usrid as UserId,
  usrid_long as EmailAddress
}
