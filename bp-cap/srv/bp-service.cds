using {csw.bp as my} from '../db/schema';

service BusinessPartnerService {

  entity BPAddressSet as projection on my.BPAddressSet;
  entity CountryVHSet as projection on my.CountryVHSet;

}
