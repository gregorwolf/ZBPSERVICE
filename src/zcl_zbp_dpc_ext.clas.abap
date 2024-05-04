CLASS zcl_zbp_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zbp_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS bpaddressset_get_entityset
        REDEFINITION .
    METHODS bpattachmentset_get_entityset
        REDEFINITION .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zbp_dpc_ext IMPLEMENTATION.


  METHOD bpaddressset_get_entityset.
    DATA: ls_country_filter       TYPE zbp_country_range,
          centraldata             TYPE bapibus1006_central_search,
          addressdata_search      TYPE bapibus1006_addr_search,
          searchresult            TYPE TABLE OF bapibus1006_bp_addr,
          return                  TYPE TABLE OF bapiret2,
          centraldataorganization TYPE bapibus1006_central_organ,
          addressdata             TYPE bapibus1006_address.

    DATA(lt_filter) = io_tech_request_context->get_filter( )->get_filter_select_options( ).

    LOOP AT lt_filter INTO DATA(ls_filter) WHERE property EQ 'COUNTRY'.
      LOOP AT ls_filter-select_options INTO DATA(ls_sel_option).
        CLEAR ls_country_filter.
        MOVE-CORRESPONDING ls_sel_option TO ls_country_filter.
        addressdata_search-countryiso = ls_country_filter-low.
      ENDLOOP.
    ENDLOOP.

    centraldata-partnercategory = 2.

    CALL FUNCTION 'BAPI_BUPA_SEARCH_2'
      EXPORTING
*       TELEPHONE    =
*       EMAIL        =
*       URL          =
        addressdata  = addressdata_search
        centraldata  = centraldata
*       BUSINESSPARTNERROLECATEGORY       =
*       ALL_BUSINESSPARTNERROLES          =
*       BUSINESSPARTNERROLE               =
*       COUNTRY_FOR_TELEPHONE             =
*       FAX_DATA     =
*       VALID_DATE   =
*       OTHERS       =
*       IV_REQ_MASK  = 'X'
      TABLES
        searchresult = searchresult
        return       = return.

    LOOP AT searchresult ASSIGNING FIELD-SYMBOL(<searchresult>).
      APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<bp_address>).
      <bp_address>-partner = <searchresult>-partner.

      CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
        EXPORTING
          businesspartner         = <searchresult>-partner
          valid_date              = sy-datlo
*         IV_REQ_MASK             = 'X'
        IMPORTING
*         CENTRALDATA             = CENTRALDATA
*         CENTRALDATAPERSON       = CENTRALDATAPERSON
          centraldataorganization = centraldataorganization
*         CENTRALDATAGROUP        = CENTRALDATAGROUP
*         CENTRALDATAVALIDITY     = CENTRALDATAVALIDITY
*       TABLES
*         TELEFONDATANONADDRESS   = TELEFONDATANONADDRESS
*         FAXDATANONADDRESS       = FAXDATANONADDRESS
*         TELETEXDATANONADDRESS   = TELETEXDATANONADDRESS
*         TELEXDATANONADDRESS     = TELEXDATANONADDRESS
*         E_MAILDATANONADDRESS    = E_MAILDATANONADDRESS
*         RMLADDRESSDATANONADDRESS           = RMLADDRESSDATANONADDRESS
*         X400ADDRESSDATANONADDRESS          = X400ADDRESSDATANONADDRESS
*         RFCADDRESSDATANONADDRESS           = RFCADDRESSDATANONADDRESS
*         PRTADDRESSDATANONADDRESS           = PRTADDRESSDATANONADDRESS
*         SSFADDRESSDATANONADDRESS           = SSFADDRESSDATANONADDRESS
*         URIADDRESSDATANONADDRESS           = URIADDRESSDATANONADDRESS
*         PAGADDRESSDATANONADDRESS           = PAGADDRESSDATANONADDRESS
*         COMMUNICATIONNOTESNONADDRESS       = COMMUNICATIONNOTESNONADDRESS
*         COMMUNICATIONUSAGENONADDRESS       = COMMUNICATIONUSAGENONADDRESS
*         RETURN                  = RETURN
        .

      <bp_address>-name_org1 = centraldataorganization-name1.

      IF NOT <searchresult>-addressguid IS INITIAL.


        CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
          EXPORTING
            businesspartner = <searchresult>-partner
            addressguid     = <searchresult>-addressguid
*           VALID_DATE      = SY-DATLO
*           RESET_BUFFER    = RESET_BUFFER
          IMPORTING
            addressdata     = addressdata
*           ADDRESS_DEP_ATTR_DATA       = ADDRESS_DEP_ATTR_DATA
*       TABLES
*           BAPIADTEL       = BAPIADTEL
*           BAPIADFAX       = BAPIADFAX
*           BAPIADTTX       = BAPIADTTX
*           BAPIADTLX       = BAPIADTLX
*           BAPIADSMTP      = BAPIADSMTP
*           BAPIADRML       = BAPIADRML
*           BAPIADX400      = BAPIADX400
*           BAPIADRFC       = BAPIADRFC
*           BAPIADPRT       = BAPIADPRT
*           BAPIADSSF       = BAPIADSSF
*           BAPIADURI       = BAPIADURI
*           BAPIADPAG       = BAPIADPAG
*           BAPIAD_REM      = BAPIAD_REM
*           BAPICOMREM      = BAPICOMREM
*           ADDRESSUSAGE    = ADDRESSUSAGE
*           BAPIADVERSORG   = BAPIADVERSORG
*           BAPIADVERSPERS  = BAPIADVERSPERS
*           BAPIADUSE       = BAPIADUSE
*           RETURN          = RETURN
          .
        <bp_address>-country = addressdata-country.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD bpattachmentset_get_entityset.
    " IV_ENTITY_NAME
    " IV_ENTITY_SET_NAME
    " IT_FILTER_SELECT_OPTIONS
    " IT_KEY_TAB
    DATA: partner TYPE bu_partner.

    DATA:
        " Business-Object Key
        gs_object   TYPE sibflporb
        " Links to Object
      , gt_links    TYPE obl_t_link
        " Attachment Options
      , gt_relopt   TYPE obl_t_relt
      , gs_relopt   TYPE obl_s_relt
       " Document Metadata
     , document_data TYPE sofolenti1
     , extension TYPE string
      .
    IF NOT it_key_tab IS INITIAL.
      READ TABLE it_key_tab WITH KEY name = 'Partner' ASSIGNING FIELD-SYMBOL(<fs_key>).
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_key>-value
        IMPORTING
          output = partner.

      " Fill Busines Object ID
      gs_object-instid  = partner.
      gs_object-typeid  = 'BUS1006'.
      gs_object-catid   = 'BO'.

      " Attachment Options
      gs_relopt-sign = 'I'.
      gs_relopt-option = 'EQ'.
      " Attachments
      gs_relopt-low = 'ATTA'.
      APPEND gs_relopt TO gt_relopt.
      " Notes
      gs_relopt-low = 'NOTE'.
      APPEND gs_relopt TO gt_relopt.
      " URLs
      gs_relopt-low = 'URL'.
      APPEND gs_relopt TO gt_relopt.


      cl_binary_relation=>read_links_of_binrels(
         EXPORTING
           is_object           = gs_object
           it_relation_options = gt_relopt
           ip_role             = 'GOSAPPLOBJ'
         IMPORTING
           et_links            = gt_links ).
      LOOP AT gt_links ASSIGNING FIELD-SYMBOL(<links>) WHERE typeid_b = 'MESSAGE'.
        APPEND INITIAL LINE TO et_entityset ASSIGNING FIELD-SYMBOL(<entity>).
        <entity>-partner = <fs_key>-value.
        <entity>-doc_id = <links>-instid_b.
        CALL FUNCTION 'SO_DOCUMENT_READ_API1'
          EXPORTING
            document_id                = <entity>-doc_id
*           filter                     = 'X '
          IMPORTING
            document_data              = document_data
          EXCEPTIONS
            document_id_not_exist      = 1
            operation_no_authorization = 2
            x_error                    = 3.
        IF sy-subrc <> 0.
*          MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*            WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
        CASE document_data-obj_type.
          WHEN 'PDF'.
            <entity>-mimetype = 'application/pdf'.
            extension = '.pdf'.
          WHEN 'JPG'.
            <entity>-mimetype = 'image/jpeg'.
            extension = '.jpg'.
          WHEN 'PNG'.
            <entity>-mimetype = 'image/png'.
            extension = '.png'.
          WHEN OTHERS.
        ENDCASE.
        <entity>-filename = document_data-obj_descr && extension.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA: ls_stream TYPE ty_s_media_resource
      , ls_upld   TYPE zexcel_du_entity
      , document_data TYPE sofolenti1
      , contents_hex TYPE solix_tab
      , extension TYPE string
      , input_length TYPE i
      , ls_header TYPE ihttpnvp.

    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) WITH KEY name = 'DocId'.
    IF <fs_key> IS ASSIGNED.
      DATA(doc_id) = CONV so_entryid( <fs_key>-value ).
      TRY.
          CALL FUNCTION 'SO_DOCUMENT_READ_API1'
            EXPORTING
              document_id   = doc_id
*             filter        = 'X '
            IMPORTING
              document_data = document_data
            TABLES
*             object_header = object_header
*             object_content             = object_content
*             object_para   = object_para
*             object_parb   = object_parb
*             attachment_list            = attachment_list
*             receiver_list = receiver_list
              contents_hex  = contents_hex
*  EXCEPTIONS
*             document_id_not_exist      = 1
*             operation_no_authorization = 2
*             x_error       = 3
            .
          IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.
        CATCH cx_root INTO DATA(lo_ex).
          RAISE EXCEPTION NEW /iwbep/cx_mgw_busi_exception( previous = lo_ex ).
      ENDTRY.
      IF document_data IS NOT INITIAL.
        CASE document_data-obj_type.
          WHEN 'PDF'.
            ls_stream-mime_type = 'application/pdf'.
            extension = '.pdf'.
          WHEN 'JPG'.
            ls_stream-mime_type = 'image/jpeg'.
            extension = '.jpg'.
          WHEN 'PNG'.
            ls_stream-mime_type = 'image/png'.
            extension = '.png'.
          WHEN OTHERS.
        ENDCASE.
        ls_header-name = 'Content-Disposition'.
        CONCATENATE 'attachment; filename="' document_data-obj_descr extension INTO ls_header-value.
        set_header( ls_header ).

        input_length = document_data-doc_size.
        CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
          EXPORTING
            input_length = input_length
          IMPORTING
            buffer       = ls_stream-value
          TABLES
            binary_tab   = contents_hex
          EXCEPTIONS
            failed       = 1.
        IF sy-subrc <> 0.
*         MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*           WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
        copy_data_to_ref( EXPORTING is_data = ls_stream   CHANGING  cr_data = er_stream ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
