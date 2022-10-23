@AbapCatalog.sqlViewName: 'ZV_VH_FLTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Flight type'

@Search.searchable: true

@ObjectModel:{

  resultSet.sizeCategory: #XS // smal size for dropdow helpvalue
}
define view zcds_hv_fltype as select from    dd07l as FixedValue
    left outer join dd07t as ValueText on  FixedValue.domname    = ValueText.domname
                                       and FixedValue.domvalue_l = ValueText.domvalue_l
                                       and FixedValue.as4local   = ValueText.as4local

{

      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['FltypeT']
  key FixedValue.domvalue_l as DomValue,
      @Semantics.text: true -- identifies the text field
      ValueText.ddtext      as FltypeT
}

where FixedValue.domname   = 'S_FLTYPE'
  and FixedValue.as4local  = 'A' --Active
  and ValueText.ddlanguage = $session.system_language 
