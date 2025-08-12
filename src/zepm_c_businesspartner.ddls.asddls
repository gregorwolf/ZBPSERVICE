@AbapCatalog.sqlViewName: 'ZEPMBP'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'EPM Business Partner'

@Search.searchable: true

@UI.headerInfo:{ 
  typeName:       'Business Partner', 
  typeNamePlural: 'Business Partners'
}

define view ZEPM_C_BusinessPartner as 
  select from snwd_bpa as bp
  join snwd_ad as address on bp.address_guid = address.node_key  
{
  @UI: {
      lineItem.position: 10,
      selectionField.position: 10
  }
  key bp.bp_id as BpId,
  @UI: {
    hidden: true
  }
  bp.bp_role, 
  
  bp.email_address, 
  bp.phone_number, 
  bp.fax_number, 
  bp.web_address,
  @UI: {
    identification: {position: 20, importance: #HIGH},   
    lineItem.position: 20,
    selectionField.position: 20
  }
  @Search: { 
      defaultSearchElement: true, 
      ranking: #HIGH, 
      fuzzinessThreshold: 0.8 
  }
  bp.company_name, 
  bp.legal_form, 
  bp.currency_code, 
  @UI: {
    identification: {position: 30, importance: #HIGH},   
    lineItem.position: 50,
    selectionField.position: 50
  }
  address.city, 
  @UI: {
      lineItem.position: 40,
      selectionField.position: 40
  }
  address.postal_code, 
  @UI: {
    lineItem.position: 30
  }
  address.street, 
  @UI: {
    lineItem.position: 35
  }
  address.building, 
  @UI: {
      lineItem.position: 60,
      selectionField.position: 60
  }
  address.country,   
  address.address_type,
  address.val_end_date, 
  address.val_start_date,
  bp.created_by, 
  bp.created_at, 
  bp.changed_by, 
  bp.changed_at, 
  address.latitude, 
  address.longitude
}
