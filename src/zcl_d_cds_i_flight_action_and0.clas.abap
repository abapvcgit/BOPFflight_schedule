CLASS zcl_d_cds_i_flight_action_and0 DEFINITION
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



CLASS zcl_d_cds_i_flight_action_and0 IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.

    DATA(lt_flights) = VALUE ztcds_i_flight( ).


    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key                 " Node Name
        it_key                  =  it_key                 " Key Table
*        iv_before_image         = abap_false       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        iv_fill_data            = abap_true        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*        it_requested_attributes =                  " List of Names (e.g. Fieldnames)
      IMPORTING
*        eo_message              =                  " Message Object
        et_data                 =  lt_flights                " Data Return Structure
*        et_failed_key           =                  " Key Table
*        et_node_cat             =                  " Node Category Assignment
    ).

    DATA(lo_helper) = NEW /bobf/cl_lib_h_set_property( io_modify = io_modify
                                                   is_context = is_ctx ).


    LOOP AT lt_flights REFERENCE INTO DATA(lo_fligth).

      lo_helper->set_attribute_read_only(
          iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-fldate
          iv_key            = lo_fligth->key ).

      lo_helper->set_attribute_read_only(
     iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-seatsmax
     iv_key            = lo_fligth->key ).

      lo_helper->set_attribute_read_only(
      iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-seatsmax_b
      iv_key            = lo_fligth->key ).

      lo_helper->set_attribute_read_only(
      iv_attribute_name = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_flight-seatsmax_f
      iv_key            = lo_fligth->key ).


    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
