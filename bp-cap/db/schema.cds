namespace csw.bp;

entity BPAddressSet {
  key Partner        : Integer;
      PartnerGuid    : UUID;
      price          : Decimal;
      NameOrg1       : String(40);
      Country        : String(3);
      to_Attachments : Association to many BPAttachmentSet
                         on Partner = $self.Partner;
}

entity BPAttachmentSet {
  key Partner  : Integer;
      DocId    : String(32);
      Mimetype : String(255);
      Filename : String(255);

      @Core.MediaType                  : Mimetype
      @Core.ContentDisposition.Filename: Filename
      Content  : LargeBinary;
}

entity CountryVHSet {
  key Country            : String(3);
      CountryDescription : String(80);
}
