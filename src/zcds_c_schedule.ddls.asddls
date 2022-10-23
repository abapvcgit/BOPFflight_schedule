@AbapCatalog.sqlViewName: 'ZV_C_FLIGHT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Schedule'

@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel:{
      compositionRoot: true,
      transactionalProcessingDelegated: true,
      createEnabled: true,
      deleteEnabled: true,
       updateEnabled: true,
      semanticKey: ['Connid'],
      usageType:{
         serviceQuality: #X,
         sizeCategory: #S,
         dataClass: #TRANSACTIONAL
      }
}
@OData.publish: true
define view zcds_c_schedule
  as select from zcds_i_schedule
  association [0..*] to zcds_c_flight as _Flight on $projection.Carrid = _Flight.Carrid
                                                and $projection.Connid = _Flight.Connid
{
  key Carrid,
      @Search.defaultSearchElement: true
  key Connid,
      CarrName, // text element for Carrid
      Countryfr,
      Cityfrom,
      Airpfrom,
      AirportFromN, // text element for Airpfrom
      Countryto,
      Cityto,
      Airpto,
      AirportToN, // text element for Airpto
      //      Fltime,
      Deptime,
      Arrtime,
      Distance,
      Distid,
      Fltype,
      FltypeT, // text element for Fltype
      Period,
      /* Associations */
      _Airfrom,
      _Airline,
      _Airto,
      _From,
      _To,
      _Fltype,
      _Distid,
      @ObjectModel.association.type: [#TO_COMPOSITION_CHILD]
      _Flight
}
