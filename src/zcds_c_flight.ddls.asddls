@AbapCatalog.sqlViewName: 'ZV_C_SFLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flights'

@Metadata.allowExtensions: true

@Search.searchable: true
@ObjectModel:{
      createEnabled: true,
      deleteEnabled: true,
      updateEnabled: true,
      usageType:{
         serviceQuality: #X,
         sizeCategory: #S,
         dataClass: #TRANSACTIONAL
      }
}

define view zcds_c_flight
  as select from zcds_i_flight

  association [1] to zcds_c_schedule as _Schedule on  $projection.Carrid = _Schedule.Carrid
                                                  and $projection.Connid = _Schedule.Connid
{
  key Carrid,
  key Connid,
      @Search.defaultSearchElement: true
  key Fldate,
      Price,
      Currency,
      Planetype,
      Seatsmax,
      Seatsocc,
      Paymentsum,
      Seatsmax_B,
      Seatsocc_B,
      Seatsmax_F,
      Seatsocc_F,
      /* Associations */
      _Saplane,
      @ObjectModel.association.type: [#TO_COMPOSITION_ROOT,#TO_COMPOSITION_PARENT]
      _Schedule,
      _Scurx
}
