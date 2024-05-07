import Controller from "sap/ui/core/mvc/Controller";
import StandardListItem from "sap/ui/webc/main/StandardListItem";
import Event from "sap/ui/base/Event";
import UIComponent from "sap/ui/core/UIComponent";
import { BPAddress } from "../../gen/ZbpSrvModel";
/**
 * @namespace csw.bpfreestyle.controller
 */
export default class BusinessPartners extends Controller {
  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {}

  // onSelectionChange - Event handler for the selection change event of the table to navigate to the details page
  public onSelectionChange(oEvent: Event): void {
    const oItem = oEvent.getParameter("listItem" as never) as StandardListItem;
    const oOC = this.getOwnerComponent() as UIComponent;
    const oRouter = oOC.getRouter();
    const objectOrUndefined = oItem
      .getBindingContext()
      ?.getObject() as BPAddress;
    if (objectOrUndefined === undefined) {
      // Handle the case where it's undefined, perhaps by returning early
      return;
    }
    const oObject: BPAddress = objectOrUndefined;
    oRouter.navTo("RouteBusinessPartnerDetail", {
      Partner: oObject.Partner,
    });
  }
}
