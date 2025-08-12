CLASS zcl_bp_event_handler DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES bi_event_handler_static .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bp_event_handler IMPLEMENTATION.


  METHOD bi_event_handler_static~on_event.
    DATA: businesspartner TYPE bu_partner,
          addressnumber   TYPE ad_addrnum,
          country         TYPE land1.

    " Get the business partner from the event container
    event_container->get(
        EXPORTING
          name  = '_EVT_OBJKEY'
        IMPORTING
          value = businesspartner
    ).
    " Get the latest default address for the business partner
    SELECT SINGLE addressnumber INTO @addressnumber
        FROM i_bplatestdefaultaddress_2
        WHERE businesspartner = @businesspartner.
    " Get the address for the business partner
    SELECT SINGLE country INTO @country
        FROM i_businesspartneraddress
        WHERE businesspartner = @businesspartner AND addressnumber = @addressnumber AND country = 'DE'.
    LOG-POINT ID z_bp_event SUBKEY event FIELDS sender event rectype handler businesspartner addressnumber country.

    IF country IS NOT INITIAL.
      IF event = 'CHANGED'.
        LOG-POINT ID z_bp_event SUBKEY 'Raise Changed' FIELDS sender event rectype handler businesspartner addressnumber country.
        zbp_c_businesspartnerevent=>raise_changed(
            it_events_changed = VALUE #( ( businesspartner = businesspartner  ) ) ).
        LOG-POINT ID z_bp_event SUBKEY 'Raise Changed Sent'.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
