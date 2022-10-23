@AbapCatalog.sqlViewName: 'ZV_I_SCHEDULE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Schedule - Composite  View'


@Search.searchable: true
@ObjectModel:{
    compositionRoot: true,
    transactionalProcessingEnabled: true,
    writeActivePersistence: 'spfli',
    createEnabled: true,
    deleteEnabled: true,
     updateEnabled: true,
    semanticKey: ['Connid'],
    usageType:{
       serviceQuality: #X,
       sizeCategory: #S,
       dataClass: #MIXED
    }
}

define view zcds_i_schedule
  as select from zcds_b_schedule

  association [0..*] to zcds_i_flight       as _Flight  on  $projection.Carrid = _Flight.Carrid
                                                        and $projection.Connid = _Flight.Connid
  association [1]    to scarr               as _Airline on  $projection.Carrid = _Airline.carrid
  association [1]    to sgeocity            as _From    on  $projection.Countryfr = _From.country
                                                        and $projection.Cityfrom  = _From.city
  association [1]    to sairport            as _Airfrom on  $projection.Airpfrom = _Airfrom.id
  association [1]    to sgeocity            as _To      on  $projection.Countryto = _To.country
                                                        and $projection.Cityto    = _To.city
  association [1]    to sairport            as _Airto   on  $projection.Airpto = _Airto.id

  association [1]    to zcds_hv_fltype      as _Fltype  on  $projection.Fltype = _Fltype.DomValue
  association [1]    to zcds_vh_sh_distance as _Distid  on  $projection.Distid = _Distid.msehi
{
      @Consumption.valueHelpDefinition: [{association: '_Airline' }]
      @ObjectModel:{
                        mandatory:  true ,
                        readOnly: 'EXTERNAL_CALCULATION' ,
                        text.element: ['CarrName'] }
  key Carrid,
      @Search.defaultSearchElement: true
  key Connid,

      _Airline.carrname as CarrName,


      @ObjectModel:{ foreignKey.association: '_From'  }
      Countryfr,

      @Consumption.valueHelpDefinition: [{association: '_From' }]
      @ObjectModel:{ mandatory: true }
      Cityfrom,

      @Consumption.valueHelpDefinition: [{association: '_Airfrom' }]
      @ObjectModel:{
                    text.element: ['AirportFromN'],
                    mandatory: true
                    }
      Airpfrom,
      _Airfrom.name     as AirportFromN,


      @ObjectModel.foreignKey.association: '_To'
      Countryto,

      @Consumption.valueHelpDefinition: [{association: '_To' }]
      @ObjectModel:{ mandatory: true }
      Cityto,

      @Consumption.valueHelpDefinition: [{association: '_Airto' }]
      @ObjectModel:{
                        text.element: ['AirportToN'],
                        mandatory: true
                        }
      Airpto,
      _Airto.name       as AirportToN,
      //      Fltime,

      @ObjectModel.mandatory: true
      Deptime,
      @ObjectModel.mandatory: true
      Arrtime,

      @ObjectModel.mandatory: true
      @Semantics.quantity.unitOfMeasure: 'Distid'
      Distance,

      @ObjectModel.mandatory: true
      @Consumption.valueHelpDefinition: [{association: '_Distid' }]
      Distid,

      @Consumption.valueHelpDefinition: [{association: '_Fltype'  }]
      @ObjectModel:{
                    text.element: ['FltypeT'],
                    mandatory: true }
      Fltype,
      _Fltype.FltypeT      as FltypeT,

      @ObjectModel.mandatory: true
      Period,

      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      _Flight,
      _Airline,
      _From,
      _Airfrom,
      _To,
      _Airto,
      _Fltype,
      _Distid

}
