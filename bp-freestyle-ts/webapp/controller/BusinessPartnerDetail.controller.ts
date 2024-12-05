/* eslint-disable linebreak-style */
import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import { BPAddress } from "../../gen/ZbpSrvModel";
import JSONModel from "sap/ui/model/json/JSONModel";
import ODataModel from "sap/ui/model/odata/v2/ODataModel";
import FileUploader, {
  FileUploader$ChangeEvent,
  FileUploader$FileSizeExceedEvent,
  FileUploader$TypeMissmatchEvent,
  FileUploader$UploadStartEvent,
} from "sap/ui/unified/FileUploader";
import FileUploaderParameter from "sap/ui/unified/FileUploaderParameter";
import MessageToast from "sap/m/MessageToast";
import Table from "sap/m/Table";
/**
 * @namespace csw.bpfreestylets.controller
 */
export default class BusinessPartnerDetail extends Controller {
  private viewModel: JSONModel | undefined;
  /*eslint-disable @typescript-eslint/no-empty-function*/
  public onInit(): void {
    const viewSettings = {
      onUploadPictureVisible: false,
    };
    this.viewModel = new JSONModel(viewSettings);
    this.getView()?.setModel(this.viewModel, "view");

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
    const fileuploader = this.byId("fileuploader") as FileUploader;

    fileuploader.removeAllHeaderParameters();
    // fileUpload.removeHeaderParameter("x-csrf-token");
    // Header Token
    const customerHeaderToken = new FileUploaderParameter({
      name: "x-csrf-token",
      value: (this.getView()?.getModel() as ODataModel).getSecurityToken(),
    });
    fileuploader.addHeaderParameter(customerHeaderToken);
    var customerHeaderSlug = new FileUploaderParameter({
      name: "slug",
      value: fileuploader.getValue(),
    });
    fileuploader.addHeaderParameter(customerHeaderSlug);

    fileuploader.upload();
    // eslint-disable-next-line no-console
    console.log("Upload Picture");
  }

  private _onRouteMatched(event: Route$PatternMatchedEvent): void {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-call
    const objectOrUndefined = event.getParameter("arguments") as BPAddress;
    if (objectOrUndefined === undefined) {
      // Handle the case where it's undefined, perhaps by returning early
      return;
    }
    const oObject: BPAddress = objectOrUndefined;
    const path = (this.getView()?.getModel() as ODataModel).createKey(
      "/BPAddressSet",
      {
        Partner: window.decodeURIComponent(oObject.Partner),
      }
    );
    this.getView()?.bindElement({
      path: path,
      parameters: {
        expand: "to_Attachments",
      },
    });
  }
  private handleTypeMissmatch(event: FileUploader$TypeMissmatchEvent) {
    const fileTypes = event.getSource().getFileType();
    const supportedFileTypes = fileTypes
      .map((fileType) => "*." + fileType)
      .join(", ");
    MessageToast.show(
      `Filetype *." ${event.getParameter(
        "fileType"
      )} is not supported. Choose one of the following types: ${supportedFileTypes}`
    );
  }
  private onFileSizeExceed(event: FileUploader$FileSizeExceedEvent) {
    const fileSize = event.getSource().getMaximumFileSize();
    MessageToast.show("Files cannot be larger than " + fileSize + "MB ");
  }
  private onBeforeUploadStarts(event: FileUploader$UploadStartEvent) {
    const fileUpload = event.getSource();
    this.getView()?.setBusy(true);
  }
  private onUploadComplete() {
    const viewModel = this.viewModel as JSONModel;
    viewModel.setProperty("/onUploadPictureVisible", false);
    viewModel.setProperty("/image", "");
    const attachmentTable = this.byId("to_Attachments") as Table;
    attachmentTable.getBinding("items")?.refresh();
    this.getView()?.setBusy(false);
  }
  private onUploadChange(event: FileUploader$ChangeEvent) {
    const viewModel = this.viewModel as JSONModel;
    viewModel.setProperty("/image", "");
    const files = event?.getParameter("files");
    if (files) {
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
