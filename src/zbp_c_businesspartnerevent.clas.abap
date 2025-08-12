CLASS zbp_c_businesspartnerevent DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zc_businesspartnerevent.
  PUBLIC SECTION.
    TYPES:  tt_events_created TYPE TABLE FOR EVENT zc_businesspartnerevent~created.
    TYPES:  tt_events_changed TYPE TABLE FOR EVENT zc_businesspartnerevent~changed.
    CLASS-METHODS:
      raise_created
        IMPORTING
          it_events_created TYPE tt_events_created,
      raise_changed
        IMPORTING
          it_events_changed TYPE tt_events_changed.
ENDCLASS.

CLASS zbp_c_businesspartnerevent IMPLEMENTATION.
  METHOD raise_created.

  ENDMETHOD.
  METHOD raise_changed.
    LOG-POINT ID z_bp_event SUBKEY 'BDEV Changed' FIELDS it_events_changed.
    RAISE ENTITY EVENT zc_businesspartnerevent~changed
        FROM VALUE #( FOR <bp> IN it_events_changed ( BusinessPartner = <bp>-businesspartner %param = VALUE #( BusinessPartnerID = <bp>-businesspartner ) ) ).
    LOG-POINT ID z_bp_event SUBKEY 'BDEV Change Sent'.
  ENDMETHOD.

ENDCLASS.
