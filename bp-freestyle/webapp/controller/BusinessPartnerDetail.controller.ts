import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import { BPAddress } from "../../gen/ZbpSrvModel";
import JSONModel from "sap/ui/model/json/JSONModel";
/**
 * @namespace csw.bpfreestyle.controller
 */
export default class BusinessPartnerDetail extends Controller {
  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {
    const viewSettings = {
      onUploadPictureVisible: false,
    };
    const viewModel = new JSONModel(viewSettings);
    this.getView()?.setModel(viewModel, "view");

    const oOC = this.getOwnerComponent() as UIComponent;
    const oRouter = oOC.getRouter();
    const route = oRouter.getRoute("RouteBusinessPartnerDetail");
    if (route) {
      route.attachPatternMatched(this._onRouteMatched, this);
    } else {
      // console.error('Route "RouteBusinessPartnerDetail" is not defined');
    }
  }

  public onUploadPicture(): void {
    // eslint-disable-next-line no-console
    console.log("Upload Picture");
  }

  public onTakePicture(): void {
    // eslint-disable-next-line no-console
    console.log("Take Picture");
    var fileId = this.createId("file");
    var oPicPreviewID = this.createId("picPreview");
    const viewModel = this.getView()?.getModel("view") as JSONModel;

    if (oPicPreviewID && fileId) {
      //trigger click event for the input field to open camera
      var image = document.getElementById(fileId);
      if (image !== null) {
        image.addEventListener("change", function () {
          //check if there is an image
          const file = this as HTMLInputElement;
          if (oPicPreviewID && file.files && file.files[0]) {
            // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
            var previewPic = document.getElementById(oPicPreviewID) as any;
            var reader = new FileReader();
            reader.onload = function (e) {
              if (previewPic) {
                if (e.target?.result !== null) {
                  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
                  previewPic.src = e.target?.result;
                  // pictureObj = e.target.result;
                  viewModel.setProperty("/onUploadPictureVisible", true);
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
