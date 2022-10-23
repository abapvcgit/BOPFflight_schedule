CLASS zcl_cds_d_set_sf_conid DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_d_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_determination~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS : m_check_connid IMPORTING iv_connid TYPE s_conn_id
                             EXPORTING ev_connid TYPE s_conn_id.
ENDCLASS.



CLASS zcl_cds_d_set_sf_conid IMPLEMENTATION.


  METHOD /bobf/if_frw_determination~execute.
    DATA lv_counter TYPE s_conn_id.
    DATA(lt_schedules) = VALUE ztcds_i_schedule( ).

    io_read->retrieve(
      EXPORTING
        iv_node                 =  is_ctx-node_key                 " Node Name
        it_key                  =   it_key               " Key Table
*        iv_before_image         = abap_false       " Data Element for Domain BOOLE: TRUE (="X") and FALSE (=" ")
*        iv_fill_data            = abap_true        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
*        it_requested_attributes =                  " List of Names (e.g. Fieldnames)
      IMPORTING
*        eo_message              =                  " Message Object
        et_data                 =  lt_schedules                " Data Return Structure
*        et_failed_key           =                  " Key Table
*        et_node_cat             =                  " Node Category Assignment
    ).

    LOOP AT lt_schedules REFERENCE INTO DATA(lo_schedule) WHERE connid IS INITIAL.

      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'                " Number range number
          object                  = 'ZSF_CONID'                 " Name of number range object
        IMPORTING
          number                  = lv_counter                " free number
        EXCEPTIONS
          interval_not_found      = 1                " Interval not found
          number_range_not_intern = 2                " Number range is not internal
          object_not_found        = 3                " Object not defined in TNRO
          quantity_is_0           = 4                " Number of numbers requested must be > 0
          quantity_is_not_1       = 5                " Number of numbers requested must be 1
          interval_overflow       = 6                " Interval used up. Change not possible.
          buffer_overflow         = 7                " Buffer is full
          OTHERS                  = 8.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
      me->m_check_connid(
        EXPORTING
          iv_connid = lv_counter
          IMPORTING
            ev_connid = lo_schedule->connid
      ).

      io_modify->update(
        EXPORTING
          iv_node           = is_ctx-node_key                 " Node
          iv_key            = lo_schedule->key                 " Key
*          iv_root_key       =                  " NodeID
          is_data           =  lo_schedule                " Data
          it_changed_fields =  VALUE #(
                                          ( zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-connid  )
                                        )                " List of Names (e.g. Fieldnames)
      ).

      CLEAR: lv_counter.
    ENDLOOP.

    io_modify->end_modify( iv_process_immediately = abap_true ).

  ENDMETHOD.

  METHOD m_check_connid.

    ev_connid = iv_connid.

    DO .
      SELECT connid UP TO 1 ROWS
      INTO @DATA(lv_connid)
      FROM spfli
      WHERE connid EQ @ev_connid.
      ENDSELECT.
      IF sy-subrc EQ 0.
        ADD 1 TO ev_connid.
      ELSE.
        EXIT.
      ENDIF.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
