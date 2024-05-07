import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import Route$PatternMatchedEvent from "sap/ui/core/routing/Route";
import { BPAddress } from "../../gen/ZbpSrvModel";
import Image from "sap/m/Image";
/**
 * @namespace csw.bpfreestyle.controller
 */
export default class BusinessPartnerDetail extends Controller {
  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {
    const oOC = this.getOwnerComponent() as UIComponent;
    const oRouter = oOC.getRouter();
    const route = oRouter.getRoute("RouteBusinessPartnerDetail");
    if (route) {
      route.attachPatternMatched(this._onRouteMatched, this);
    } else {
      // console.error('Route "RouteBusinessPartnerDetail" is not defined');
    }
  }

  public onTakePicture(): void {
    // eslint-disable-next-line no-console
    console.log("Take Picture");
    var fileId = this.createId("file");
    var oPicPreviewID = this.createId("picPreview");

    if (oPicPreviewID && fileId) {
      //trigger click event for the input field to open camera
      var image = document.getElementById(fileId);
      if (image !== null) {
        image.addEventListener("change", function () {
          //check if there is an image
          const file = this as HTMLInputElement;
          if (oPicPreviewID && file.files && file.files[0]) {
            var previewPic = document.getElementById(
              oPicPreviewID
            ) as unknown as Image;
            var reader = new FileReader();
            reader.onload = function (e) {
              if (previewPic) {
                if (e.target?.result !== null) {
                  previewPic.setSrc(e.target?.result as string);
                  // pictureObj = e.target.result;
                }
              }
            };

            reader.readAsDataURL(file.files[0]);
          }
        });
        image.click();
      }
    } else {
      // console.error("IDs are not defined");
    }
  }

  private _onRouteMatched(event: Route$PatternMatchedEvent): void {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    const objectOrUndefined = event.getParameter("arguments") as BPAddress;
    if (objectOrUndefined === undefined) {
      // Handle the case where it's undefined, perhaps by returning early
      return;
    }
    const oObject: BPAddress = objectOrUndefined;

    this.getView()?.bindElement({
      path:
        "/BPAddressSet('" + window.decodeURIComponent(oObject.Partner) + "')",
      parameters: {
        expand: "to_Attachments",
      },
    });
  }
}
