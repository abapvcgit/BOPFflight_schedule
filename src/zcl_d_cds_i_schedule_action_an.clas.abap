CLASS zcl_d_cds_i_schedule_action_an DEFINITION
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



CLASS zcl_d_cds_i_schedule_action_an IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA(lt_schedules) = VALUE ztcds_i_schedule( ).

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key                 " Node Name
        it_key                  = it_key                 " Key Table
*        iv_before_image         = abap_false       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        iv_fill_data            = abap_true        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*        it_requested_attributes =                  " List of Names (e.g. Fieldnames)
      IMPORTING
*        eo_message              =                  " Message Object
        et_data                 =    lt_schedules              " Data Return Structure
*        et_failed_key           =                  " Key Table
*        et_node_cat             =                  " Node Category Assignment
    ).


    DATA(lo_helper_carrid) = NEW /bobf/cl_lib_h_set_property( io_modify = io_modify
                                                   is_context = is_ctx ).
    DATA(lo_helper_cityfrom) = NEW /bobf/cl_lib_h_set_property( io_modify = io_modify
                                                  is_context = is_ctx ).

    LOOP AT lt_schedules REFERENCE INTO DATA(lo_schedule).

      lo_helper_carrid->set_attribute_read_only(
           iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-carrid
           iv_key            = lo_schedule->key ).



*      lo_helper_carrid->set_attribute_read_only(
*           iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-cityfrom
*           iv_key            = lo_schedule->key ).
*      lo_helper_carrid->set_attribute_read_only(

*
*      lo_helper_carrid->set_attribute_read_only(
*           iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-airpfrom
*           iv_key            = lo_schedule->key ).
*
*      lo_helper_carrid->set_attribute_read_only(
*           iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-airpto
*           iv_key            = lo_schedule->key ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
