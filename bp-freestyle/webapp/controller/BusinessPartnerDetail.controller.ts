/* eslint-disable linebreak-style */
import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import { BPAddress } from "../../gen/ZbpSrvModel";
import JSONModel from "sap/ui/model/json/JSONModel";
import ODataModel from "sap/ui/model/odata/v2/ODataModel";
import FileUploader, { FileUploader$ChangeEvent, FileUploader$UploadStartEvent } from "sap/ui/unified/FileUploader";
import FileUploaderParameter from "sap/ui/unified/FileUploaderParameter";
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
    const fileuploader = (this.byId("fileuploader") as FileUploader);
    
    fileuploader.removeAllHeaderParameters();
    // fileUpload.removeHeaderParameter("x-csrf-token");
    // Header Token
    const customerHeaderToken = new FileUploaderParameter({
      name: "x-csrf-token",
      value: (this.getView()?.getModel() as ODataModel).getSecurityToken()
    });
    fileuploader.addHeaderParameter(customerHeaderToken);
    var customerHeaderSlug = new FileUploaderParameter({
      name: "slug",
      value: fileuploader.getValue()
    });
    fileuploader.addHeaderParameter(customerHeaderSlug);
    
    fileuploader.upload();
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
    const path = (this.getView()?.getModel() as ODataModel).createKey("/BPAddressSet",{
      Partner:window.decodeURIComponent(oObject.Partner)
    });
    this.getView()?.bindElement({
      path:path,
      parameters: {
        expand: "to_Attachments",
      },
    });
  }
  private onBeforeUploadStarts(event:FileUploader$UploadStartEvent) {
    const fileUpload = event.getSource();
    // fileUpload.removeHeaderParameter("slug");
    // Header Slug
    // var customerHeaderSlug = new FileUploaderParameter({
    // 	name: "slug",
    // 	value: oEvent.getParameter("fileName")
    // });
    // fileUpload.addHeaderParameter(customerHeaderSlug);
  
    this.getView()?.setBusy(true);
  }
  private onUploadComplete(){
    this.getView()?.setBusy(false);
  }
  private onUploadChange(event:FileUploader$ChangeEvent) {
    const viewModel = this.getView()?.getModel("view") as JSONModel;
    const files = event?.getParameter("files");
    if(files){
      const file = files[0] as Blob;
      var reader = new FileReader();
      reader.onload = function (e) {
          if (e.target?.result !== null) {
            // pictureObj = e.target.result;
            viewModel.setProperty("/onUploadPictureVisible", true);
            viewModel.setProperty("/image", e.target?.result);
          }
      };

      reader.readAsDataURL(file);
    }
  }
}
