using {ZBP_SRV as external} from './external/ZBP_SRV';

service BPService {

  entity BPAddressSet    as projection on external.BPAddressSet;
  entity CountryVHSet    as projection on external.CountryVHSet;
  entity BPAttachmentSet as projection on external.BPAttachmentSet;

}
