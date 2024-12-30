sap.ui.define(["sap/ui/core/mvc/Controller"], function (Controller) {
  "use strict";

  return Controller.extend("csw.bpfreestyle.controller.BusinessPartners", {
    onInit: function () {},
    onSelectionChange: function (oEvent) {
      const oItem = oEvent.getParameter("listItem");
      const oOC = this.getOwnerComponent();
      const oRouter = oOC.getRouter();
      const objectOrUndefined = oItem.getBindingContext()?.getObject();
      if (objectOrUndefined === undefined) {
        // Handle the case where it's undefined, perhaps by returning early
        return;
      }
      const oObject = objectOrUndefined;
      oRouter.navTo("RouteBusinessPartnerDetail", {
        Partner: oObject.Partner,
      });
    },
  });
});
