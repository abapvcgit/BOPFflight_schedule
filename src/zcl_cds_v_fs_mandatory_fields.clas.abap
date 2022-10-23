CLASS zcl_cds_v_fs_mandatory_fields DEFINITION
  PUBLIC
  INHERITING FROM /bobf/cl_lib_v_supercl_simple
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /bobf/if_frw_validation~execute
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS : m_carrid IMPORTING iv_carrid TYPE s_carr_id
                       EXPORTING ev_msg    TYPE symsg,
      m_cityfrom IMPORTING iv_cityfrom TYPE s_from_cit
                 EXPORTING ev_msg      TYPE symsg..
ENDCLASS.



CLASS zcl_cds_v_fs_mandatory_fields IMPLEMENTATION.


  METHOD /bobf/if_frw_validation~execute.

    DATA(lt_schedules) = VALUE ztcds_i_schedule( ).
    DATA:lv_err_msg TYPE abap_bool.

    IF eo_message IS NOT BOUND.
      eo_message = /bobf/cl_frw_factory=>get_message( ).
    ENDIF.

    io_read->retrieve(
      EXPORTING
        iv_node                 = is_ctx-node_key   " Node Name
        it_key                  = it_key            " Key Table
      IMPORTING
        et_data                 =  lt_schedules     " Data Return Structure

    ).

    LOOP AT lt_schedules REFERENCE INTO DATA(lo_schedule).

*      validate Airline ID
      me->m_carrid(
        EXPORTING
          iv_carrid = lo_schedule->carrid
        IMPORTING
          ev_msg    = DATA(ls_msg)
      ).
      IF ls_msg IS NOT INITIAL.
        eo_message->add_message(
          EXPORTING
            is_msg       = ls_msg            " Message that is to be added to the message object
            iv_node      = is_ctx-node_key   " Node to be used in the origin location
            iv_key       = lo_schedule->key  " Instance key to be used in the origin location
            iv_attribute = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-carrid                 " Attribute to be used in the origin location
*            iv_lifetime  =                  " Lifetime of the message
        ).
        lv_err_msg = abap_true.
        CLEAR ls_msg.
      ENDIF.

*      validate Depart. city
      me->m_cityfrom(
        EXPORTING
          iv_cityfrom = lo_schedule->cityfrom
        IMPORTING
          ev_msg      = ls_msg
      ).
      IF ls_msg IS NOT INITIAL.
        eo_message->add_message(
          EXPORTING
            is_msg       = ls_msg            " Message that is to be added to the message object
            iv_node      = is_ctx-node_key   " Node to be used in the origin location
            iv_key       = lo_schedule->key  " Instance key to be used in the origin location
            iv_attribute = zif_cds_i_schedule_c=>sc_node_attribute-zcds_i_schedule-cityfrom                 " Attribute to be used in the origin location
*            iv_lifetime  =                  " Lifetime of the message
        ).
        lv_err_msg = abap_true.
        CLEAR ls_msg.
      ENDIF.




      IF lv_err_msg EQ abap_true.
        APPEND INITIAL LINE TO et_failed_key ASSIGNING FIELD-SYMBOL(<ls_failed_key>).
        <ls_failed_key>-key = lo_schedule->key.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
  METHOD m_carrid.
    IF iv_carrid IS INITIAL.
      ev_msg = VALUE #(  msgty =  'E'
                  msgid = '00'
                  msgno = '001'
                  msgv1 = 'Airline ID is required' ).
    ELSE.

      SELECT carrid UP TO 1 ROWS
      FROM scarr
      INTO @DATA(lv_carrid)
      WHERE carrid EQ @iv_carrid.
      ENDSELECT.
      IF sy-subrc <> 0.
        ev_msg = VALUE #(  msgty =  'E'
                  msgid = '00'
                  msgno = '001'
                  msgv1 = 'Enter a valide Airline ID' ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD m_cityfrom.
    IF iv_cityfrom IS INITIAL.
      ev_msg = VALUE #(  msgty =  'E'
                 msgid = '00'
                 msgno = '001'
                 msgv1 = 'Depart. city is required' ).
    ELSE.

      SELECT city UP TO 1 ROWS
      INTO @DATA(lv_city)
      FROM sgeocity
      WHERE city EQ @iv_cityfrom.
      ENDSELECT.
      IF sy-subrc <> 0.
        ev_msg = VALUE #(  msgty =  'E'
                  msgid = '00'
                  msgno = '001'
                  msgv1 = 'Enter a valide Depart. city' ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
