using {csw.bp as my} from '../db/schema';

annotate my.BPAddressSet with @(
  Common.SemanticKey: [Partner],
  UI                : {
    Identification : [{Value: NameOrg1}],
    SelectionFields: [],
    LineItem       : [
      {Value: Partner},
      {Value: NameOrg1},
      {Value: Country},
    ]
  }
) {};

annotate my.BPAddressSet with @(UI: {HeaderInfo: {
  TypeName      : '{i18n>BusinessPartner}',
  TypeNamePlural: '{i18n>BussinessPartners}',
  Title         : {Value: NameOrg1},
  Description   : {Value: Partner}
}, });
