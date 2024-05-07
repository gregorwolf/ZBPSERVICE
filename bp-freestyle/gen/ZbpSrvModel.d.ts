import { DeferredContent } from "@odata2ts/odata-core";
export interface BPAddress {
    /**
     * **Key Property**: This is a key property used to identify the entity.<br/>**Managed**: This property is managed on the server side and cannot be edited.
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Partner` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Partner: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `PartnerGuid` |
     * | Type | `Edm.Guid` |
     * | Nullable | `false` |
     */
    PartnerGuid: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `NameOrg1` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    NameOrg1: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Country` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Country: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `to_Attachments` |
     * | Type | `Collection(ZBP_SRV.BPAttachment)` |
     */
    to_Attachments: Array<BPAttachment> | DeferredContent;
}
export type BPAddressId = string | {
    Partner: string;
};
export interface EditableBPAddress extends Pick<BPAddress, "PartnerGuid" | "NameOrg1" | "Country"> {
}
export interface CountryVH {
    /**
     * **Key Property**: This is a key property used to identify the entity.<br/>**Managed**: This property is managed on the server side and cannot be edited.
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Country` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Country: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `CountryDescription` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    CountryDescription: string;
}
export type CountryVHId = string | {
    Country: string;
};
export interface EditableCountryVH extends Pick<CountryVH, "CountryDescription"> {
}
export interface BPAttachment {
    /**
     * **Key Property**: This is a key property used to identify the entity.
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Partner` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Partner: string;
    /**
     * **Key Property**: This is a key property used to identify the entity.
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `DocId` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    DocId: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Mimetype` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Mimetype: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Filename` |
     * | Type | `Edm.String` |
     * | Nullable | `false` |
     */
    Filename: string;
    /**
     *
     * OData Attributes:
     * |Attribute Name | Attribute Value |
     * | --- | ---|
     * | Name | `Content` |
     * | Type | `Edm.Binary` |
     * | Nullable | `false` |
     */
    Content: string;
}
export type BPAttachmentId = {
    Partner: string;
    DocId: string;
};
export interface EditableBPAttachment extends Pick<BPAttachment, "Partner" | "DocId" | "Mimetype" | "Filename" | "Content"> {
}
