import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
/**
 * @namespace csw.bpfreestyle.controller
 */
export default class BusinessPartnerDetail extends Controller {
  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {
    const oOC = this.getOwnerComponent() as UIComponent;
    const oRouter = oOC.getRouter();
    oRouter
      .getRoute("RouteBusinessPartnerDetail")
      .attachPatternMatched(this._onRouteMatched, this);
  }

  public onTakePicture(): void {
    // eslint-disable-next-line no-console
    console.log("Take Picture");
    var oPicPreviewID = this.createId("picPreview");
    //trigger click event for the input field to open camera
    var image = document.getElementById(this.createId("file"));
    image.addEventListener("change", function () {
      //check if there is an image
      if (this.files && this.files[0]) {
        var previewPic = document.getElementById(oPicPreviewID);
        var reader = new FileReader();
        reader.onload = function (e) {
          previewPic.src = e.target.result;
          pictureObj = e.target.result;
        };

        reader.readAsDataURL(this.files[0]);
      }
    });
    image.click();
  }

  private _onRouteMatched(event: Route$PatternMatchedEvent): void {
    this.getView().bindElement({
      path:
        "/BPAddressSet('" +
        window.decodeURIComponent(
          (<any>event.getParameter("arguments")).Partner
        ) +
        "')",
      parameters: {
        expand: "to_Attachments",
      },
    });
  }
}
