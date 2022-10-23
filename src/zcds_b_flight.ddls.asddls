@AbapCatalog.sqlViewName: 'ZV_B_FLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flights  - Basic View'
define view zcds_b_flight
  as select from sflight
{
  key carrid     as Carrid,
  key connid     as Connid,
  key fldate     as Fldate,
      price      as Price,
      currency   as Currency,
      planetype  as Planetype,
      seatsmax   as Seatsmax,
      seatsocc   as Seatsocc,
      paymentsum as Paymentsum,
      seatsmax_b as Seatsmax_B,
      seatsocc_b as Seatsocc_B,
      seatsmax_f as Seatsmax_F,
      seatsocc_f as Seatsocc_F
}
