@AbapCatalog.sqlViewName: 'ZV_I_FLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight  - Composite View'


@Search.searchable: true
@ObjectModel:{

     writeActivePersistence: 'SFLIGHT',
     createEnabled: true,
     deleteEnabled: true,
     updateEnabled: true,
     usageType:{
        serviceQuality: #X,
        sizeCategory: #S,
        dataClass: #MIXED
     }
}

define view zcds_i_flight
  as select from zcds_b_flight
  association [1] to zcds_i_schedule as _Schedule on  $projection.Carrid = _Schedule.Carrid
                                                  and $projection.Connid = _Schedule.Connid
  association [1] to scurx           as _Scurx    on  $projection.Currency = _Scurx.currkey
  association [1] to saplane         as _Saplane  on  $projection.Planetype = _Saplane.planetype
{

      @ObjectModel.readOnly: true
  key Carrid,
      @ObjectModel.readOnly: true
  key Connid,

      @Search.defaultSearchElement: true
      @ObjectModel:{
                    mandatory: true,
                    readOnly: 'EXTERNAL_CALCULATION'
                    }
  key Fldate,

      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel.mandatory: true
      Price,

      @ObjectModel.mandatory: true
      @Consumption.valueHelpDefinition: [{association: '_Scurx' }]
      Currency,


      @ObjectModel.mandatory: true
      @Consumption.valueHelpDefinition: [{association: '_Saplane' }]
      Planetype,

      @ObjectModel:{
                    mandatory: true,
                    readOnly: 'EXTERNAL_CALCULATION'
                    }
      Seatsmax,

      @ObjectModel.mandatory: true
      Seatsocc,

      @Semantics.amount.currencyCode: 'Currency'
      @ObjectModel. mandatory: true
      Paymentsum,

      @ObjectModel:{
                    mandatory: true,
                    readOnly: 'EXTERNAL_CALCULATION'
                    }
      Seatsmax_B,

      @ObjectModel.mandatory: true
      Seatsocc_B,

      @ObjectModel:{
                    mandatory: true,
                    readOnly: 'EXTERNAL_CALCULATION'
                    }
      Seatsmax_F,

      @ObjectModel.mandatory: true
      Seatsocc_F,


      @ObjectModel.association.type: [#TO_COMPOSITION_PARENT, #TO_COMPOSITION_ROOT]
      _Schedule,
      _Scurx,
      _Saplane
}
