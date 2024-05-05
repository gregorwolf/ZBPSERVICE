namespace csw.bp;

entity BPAddressSet {
  key Partner     : Integer;
      PartnerGuid : UUID;
      price       : Decimal;
      NameOrg1    : String(40);
      Country     : String(3);
}

entity CountryVHSet {
  key Country            : String(3);
      CountryDescription : String(80);
}
