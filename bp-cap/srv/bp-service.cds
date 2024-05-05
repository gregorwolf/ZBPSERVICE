using {csw.bp as my} from '../db/schema';

@(path: '/ZBP_SRV')
service BusinessPartnerService {

  entity BPAddressSet    as projection on my.BPAddressSet;
  entity BPAttachmentSet as projection on my.BPAttachmentSet;
  entity CountryVHSet    as projection on my.CountryVHSet;

}
