CLASS zcl_zbp_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zbp_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION .
  PROTECTED SECTION.

    METHODS bpaddressset_get_entityset
        REDEFINITION .
    METHODS bpaddressset_get_entity
        REDEFINITION.
    METHODS bpattachmentset_get_entityset
        REDEFINITION .
    METHODS bpattachmentset_delete_entity
        REDEFINITION.
  PRIVATE SECTION.
    METHODS: get_bp_object_reference
      IMPORTING
                partner                 TYPE bu_partner
      RETURNING VALUE(object_reference) TYPE sibflporb.
    METHODS: get_gos_root_folder
      RETURNING VALUE(folder) TYPE soodk.
    METHODS: get_bpaddress
      IMPORTING
                partner           TYPE bu_partner
                addressguid       TYPE bu_address_guid_bapi
      RETURNING VALUE(bp_address) TYPE zcl_zbp_mpc=>ts_bpaddress.
ENDCLASS.



CLASS zcl_zbp_dpc_ext IMPLEMENTATION.

  METHOD get_bpaddress.

    DATA: centraldataorganization TYPE bapibus1006_central_organ,
          addressdata             TYPE bapibus1006_address,
          addressguidout          TYPE bu_address_guid_bapi.

    bp_address-partner = partner.
    addressguidout = addressguid.

    CALL FUNCTION 'BAPI_BUPA_CENTRAL_GETDETAIL'
      EXPORTING
        businesspartner         = partner
        valid_date              = sy-datlo
*       IV_REQ_MASK             = 'X'
      IMPORTING
*       CENTRALDATA             = CENTRALDATA
*       CENTRALDATAPERSON       = CENTRALDATAPERSON
        centraldataorganization = centraldataorganization
*       CENTRALDATAGROUP        = CENTRALDATAGROUP
*       CENTRALDATAVALIDITY     = CENTRALDATAVALIDITY
*       TABLES
*       TELEFONDATANONADDRESS   = TELEFONDATANONADDRESS
*       FAXDATANONADDRESS       = FAXDATANONADDRESS
*       TELETEXDATANONADDRESS   = TELETEXDATANONADDRESS
*       TELEXDATANONADDRESS     = TELEXDATANONADDRESS
*       E_MAILDATANONADDRESS    = E_MAILDATANONADDRESS
*       RMLADDRESSDATANONADDRESS           = RMLADDRESSDATANONADDRESS
*       X400ADDRESSDATANONADDRESS          = X400ADDRESSDATANONADDRESS
*       RFCADDRESSDATANONADDRESS           = RFCADDRESSDATANONADDRESS
*       PRTADDRESSDATANONADDRESS           = PRTADDRESSDATANONADDRESS
*       SSFADDRESSDATANONADDRESS           = SSFADDRESSDATANONADDRESS
*       URIADDRESSDATANONADDRESS           = URIADDRESSDATANONADDRESS
*       PAGADDRESSDATANONADDRESS           = PAGADDRESSDATANONADDRESS
*       COMMUNICATIONNOTESNONADDRESS       = COMMUNICATIONNOTESNONADDRESS
*       COMMUNICATIONUSAGENONADDRESS       = COMMUNICATIONUSAGENONADDRESS
*       RETURN                  = RETURN
      .

    bp_address-name_org1 = centraldataorganization-name1.

    IF addressguid IS INITIAL.
      CALL FUNCTION 'BAPI_BUPA_ADDRESS_GET_NUMBERS'
        EXPORTING
          businesspartner = partner
*         addr_no         = addr_no
*         addressguid     = addressguid
*         externaladdressnumber    = externaladdressnumber
*         valid_date      = valid_date
        IMPORTING
*         addr_no_out     = addr_no_out
          addressguidout  = addressguidout
*         externaladdressnumberout = externaladdressnumberout
*      TABLES
*         return          = return
        .
    ENDIF.

    IF addressguidout IS NOT INITIAL.

      CALL FUNCTION 'BAPI_BUPA_ADDRESS_GETDETAIL'
        EXPORTING
          businesspartner = partner
          addressguid     = addressguidout
*         VALID_DATE      = SY-DATLO
*         RESET_BUFFER    = RESET_BUFFER
        IMPORTING
          addressdata     = addressdata
*         ADDRESS_DEP_ATTR_DATA       = ADDRESS_DEP_ATTR_DATA
*       TABLES
*         BAPIADTEL       = BAPIADTEL
*         BAPIADFAX       = BAPIADFAX
*         BAPIADTTX       = BAPIADTTX
*         BAPIADTLX       = BAPIADTLX
*         BAPIADSMTP      = BAPIADSMTP
*         BAPIADRML       = BAPIADRML
*         BAPIADX400      = BAPIADX400
*         BAPIADRFC       = BAPIADRFC
*         BAPIADPRT       = BAPIADPRT
*         BAPIADSSF       = BAPIADSSF
*         BAPIADURI       = BAPIADURI
*         BAPIADPAG       = BAPIADPAG
*         BAPIAD_REM      = BAPIAD_REM
*         BAPICOMREM      = BAPICOMREM
*         ADDRESSUSAGE    = ADDRESSUSAGE
*         BAPIADVERSORG   = BAPIADVERSORG
*         BAPIADVERSPERS  = BAPIADVERSPERS
*         BAPIADUSE       = BAPIADUSE
*         RETURN          = RETURN
        .
      bp_address-country = addressdata-country.
    ENDIF.
  ENDMETHOD.

  METHOD bpaddressset_get_entity.
    DATA: partner TYPE bu_partner.

    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) WITH KEY name = 'Partner'.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = <fs_key>-value
      IMPORTING
        output = partner.

    er_entity = get_bpaddress(
            partner     = partner
            addressguid = '' ).

  ENDMETHOD.

  METHOD bpaddressset_get_entityset.
    DATA: ls_country_filter  TYPE zbp_country_range,
          centraldata        TYPE bapibus1006_central_search,
          addressdata_search TYPE bapibus1006_addr_search,
          searchresult       TYPE TABLE OF bapibus1006_bp_addr,
          return             TYPE TABLE OF bapiret2.

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
      <bp_address> = get_bpaddress(
          partner     = <searchresult>-partner
          addressguid = <searchresult>-addressguid ).
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
      gs_object = get_bp_object_reference( partner ).

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

  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    DATA: gs_object   TYPE sibflporb,
          value_tab TYPE solix_tab
          , attachment TYPE zcl_zbp_mpc=>ts_bpattachment
          , filename TYPE string
          , extension TYPE string
          , gs_doc_info TYPE sofolenti1
          , gs_objtgt   TYPE sibflporb
    , gs_doc_data TYPE sodocchgi1
   , gd_doc_type TYPE soodk-objtp
 ,         length    TYPE i.

    IF NOT it_key_tab IS INITIAL.
      READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) WITH KEY name = 'Partner'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_key>-value
        IMPORTING
          output = attachment-partner.

      " Fill Busines Object ID
      gs_object = get_bp_object_reference( attachment-partner ).

      "
      DATA(folder) = get_gos_root_folder( ).
      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = is_media_resource-value
*         append_to_table = space
        IMPORTING
          output_length = length
        TABLES
          binary_tab    = value_tab.

      gs_doc_data-doc_size = length.

      gs_doc_data-obj_name = iv_slug.
      attachment-filename = iv_slug.

      CALL FUNCTION 'CRM_EMAIL_SPLIT_FILENAME'
        EXPORTING
          iv_path      = iv_slug
        IMPORTING
          ev_filename  = filename
          ev_extension = extension
*         ev_mimetype  = ev_mimetype
        .
      gs_doc_data-obj_descr = filename.
      gd_doc_type = extension.
      TRANSLATE gd_doc_type TO UPPER CASE.

      " Create Document
      CALL FUNCTION 'SO_DOCUMENT_INSERT_API1'
        EXPORTING
          folder_id     = folder
          document_data = gs_doc_data
          document_type = gd_doc_type
        IMPORTING
          document_info = gs_doc_info
        TABLES
          contents_hex  = value_tab.

      CONCATENATE folder gs_doc_info-object_id
            INTO gs_objtgt-instid RESPECTING BLANKS.
      gs_objtgt-typeid  = 'MESSAGE'.
      gs_objtgt-catid   = 'BO'.
      attachment-doc_id = gs_objtgt-instid.
      TRY.
          " Create link
          cl_binary_relation=>create_link(
            EXPORTING
              is_object_a = gs_object
              is_object_b = gs_objtgt
              ip_reltype  = 'ATTA' ).
          COMMIT WORK AND WAIT.
          " er_entity
        CATCH cx_obl_parameter_error cx_obl_model_error cx_obl_internal_error.
      ENDTRY.
      copy_data_to_ref(
        EXPORTING
          is_data = attachment
        CHANGING
          cr_data = er_entity ).
    ENDIF.

  ENDMETHOD.

  METHOD get_gos_root_folder.
    " Get Root-Folder of GOS
    CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
      EXPORTING
        region    = 'B'
      IMPORTING
        folder_id = folder.
  ENDMETHOD.

  METHOD bpattachmentset_delete_entity.
    DATA: partner  TYPE bu_partner,
          object_b TYPE sibflporb.
    READ TABLE it_key_tab ASSIGNING FIELD-SYMBOL(<fs_key>) WITH KEY name = 'DocId'.
    IF <fs_key> IS ASSIGNED.
      DATA(doc_id) = CONV so_entryid( <fs_key>-value ).
      READ TABLE it_key_tab ASSIGNING <fs_key> WITH KEY name = 'Partner'.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_key>-value
        IMPORTING
          output = partner.

      DATA(object_a) = get_bp_object_reference( partner ).

      object_b-instid = doc_id.
      object_b-typeid  = 'MESSAGE'.
      object_b-catid   = 'BO'.
      TRY.
          cl_binary_relation=>delete_link(
            is_object_a = object_a
*        ip_logsys_a = ip_logsys_a
            is_object_b = object_b
*        ip_logsys_b = ip_logsys_b
            ip_reltype  = 'ATTA'
          ).
        CATCH cx_obl_parameter_error.
        CATCH cx_obl_internal_error.
        CATCH cx_obl_model_error.
      ENDTRY.
      CALL FUNCTION 'SO_DOCUMENT_DELETE_API1'
        EXPORTING
          document_id                = doc_id
*         unread_delete              = unread_delete
*         put_in_trash               = 'X'
        EXCEPTIONS
          document_not_exist         = 1
          operation_no_authorization = 2
          parameter_error            = 3
          x_error                    = 4
          enqueue_error              = 5.
      IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_bp_object_reference.
    object_reference-instid  = partner.
    object_reference-typeid  = 'BUS1006'.
    object_reference-catid   = 'BO'.
  ENDMETHOD.

ENDCLASS.
