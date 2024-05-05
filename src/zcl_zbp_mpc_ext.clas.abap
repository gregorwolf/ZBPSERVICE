CLASS zcl_zbp_mpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zbp_mpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS: define REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zbp_mpc_ext IMPLEMENTATION.

  METHOD define.

    super->define( ).

    DATA(lo_entity_type) = model->get_entity_type( iv_entity_name = gc_bpattachment ).
    IF lo_entity_type IS BOUND.
      lo_entity_type->set_is_media( iv_is_media = abap_true ).
      DATA(lo_property) = lo_entity_type->get_property( iv_property_name = 'Mimetype' ).
      lo_property->set_as_content_type( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
