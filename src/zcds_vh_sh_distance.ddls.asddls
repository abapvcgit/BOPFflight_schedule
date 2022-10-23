@AbapCatalog.sqlViewName: 'ZV_VH_DISTSH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Flight Schedule Distance Value Help'

@Search.searchable: true


@ObjectModel:{

  resultSet.sizeCategory: #XS // smal size for dropdow helpvalue
}
define view zcds_vh_sh_distance
  as select from    t006
    left outer join t006a on t006.msehi = t006a.msehi
{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['msehl']
  key t006.msehi,
      @Semantics.text: true -- identifies the text field
      t006a.msehl

}
where
      t006.dimid  like 'LENGTH'
  and t006a.spras = $session.system_language
