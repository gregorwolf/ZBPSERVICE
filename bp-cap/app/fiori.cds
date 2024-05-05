using {BusinessPartnerService} from '../srv/bp-service';

annotate BusinessPartnerService.BPAddressSet with @(
  UI.FieldGroup #address: {
    $Type: 'UI.FieldGroupType',
    Data : [{
      $Type: 'UI.DataField',
      Value: Country,
      Label: '{i18n>Country}',
    }],
  },
  UI.Facets             : [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'Address',
      Label : '{i18n>Address}',
      Target: '@UI.FieldGroup#address',
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'Attachments',
      Label : '{i18n>Attachments}',
      Target: 'to_Attachments/@UI.LineItem',
    },
  ]
);
