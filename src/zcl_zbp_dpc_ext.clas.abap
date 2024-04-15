class ZCL_ZBP_DPC_EXT definition
  public
  inheriting from ZCL_ZBP_DPC
  create public .

public section.
protected section.

  methods BPADDRESSSET_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZBP_DPC_EXT IMPLEMENTATION.


  METHOD bpaddressset_get_entityset.
    DATA: ls_country_filter       TYPE zbp_country_range,
          centraldata             TYPE bapibus1006_central_search,
          addressdata_search             TYPE bapibus1006_addr_search,
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
ENDCLASS.
