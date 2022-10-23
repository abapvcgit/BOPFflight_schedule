CLASS zcl_cds_d_fs_sets_keys DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_cds_d_fs_sets_keys IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA(lt_fligths) =  VALUE ztcds_i_flight( ).
    DATA(lt_schedules) = VALUE ztcds_i_schedule( ).

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key   " Node Name
        it_key                  = it_key            " Key Table
*        iv_before_image         = abap_false       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        iv_fill_data            = abap_true        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*        it_requested_attributes =                  " List of Names (e.g. Fieldnames)
      IMPORTING
*        eo_message              =                  " Message Object
        et_data                 = lt_fligths                 " Data Return Structure
*        et_failed_key           =                  " Key Table
*        et_node_cat             =                  " Node Category Assignment
    ).

    io_read->retrieve_by_association(
      EXPORTING
        iv_node                 = zif_cds_i_schedule_c=>sc_node-zcds_i_flight                 " Node Name
        it_key                  = it_key                 " Key Table
        iv_association          = zif_cds_i_schedule_c=>sc_association-zcds_i_flight-to_root                 " Name of Association
*        is_parameters           =
*        it_filtered_attributes  =                  " List of Names (e.g. Fieldnames)
        iv_fill_data            = abap_true       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        iv_before_image         = abap_false       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        it_requested_attributes =                  " List of Names (e.g. Fieldnames)
      IMPORTING
*        eo_message              =                  " Message Object
        et_data                 =  lt_schedules                " Data Return Structure
*        et_key_link             =                  " Key Link
*        et_target_key           =                  " Key Table
*        et_failed_key           =                  " Key Table
    ).
    READ TABLE lt_schedules REFERENCE INTO DATA(lo_schedule) INDEX 1.
    IF sy-subrc EQ 0.

      LOOP AT lt_fligths REFERENCE INTO DATA(lo_fligth) WHERE connid IS INITIAL
                                                        AND carrid IS INITIAL.
        lo_fligth->carrid = lo_schedule->carrid.
        lo_fligth->connid = lo_schedule->connid.

        io_modify->update(
          EXPORTING
            iv_node           = is_ctx-node_key                 " Node
            iv_key            = lo_fligth->key                 " Key
*          iv_root_key       =                  " NodeID
            is_data           = lo_fligth                 " Data
            it_changed_fields =   VALUE #(
                                        ( zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-carrid )
                                         ( zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-connid )
                                       )               " List of Names (e.g. Fieldnames)
        ).
      ENDLOOP.
      io_modify->end_modify( iv_process_immediately = abap_true ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
