@AbapCatalog.sqlViewName: 'ZV_B_SCHEDULE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Schedule Basic view'
define view zcds_b_schedule
  as select from spfli
{
  key carrid    as Carrid,
  key connid    as Connid,
  countryfr as Countryfr,
  cityfrom  as Cityfrom,
  airpfrom  as Airpfrom,
  countryto as Countryto,
  cityto    as Cityto,
  airpto    as Airpto,
  fltime    as Fltime,
  deptime   as Deptime,
  arrtime   as Arrtime,
  distance  as Distance,
  distid    as Distid,
  fltype    as Fltype,
  period    as Period

}
