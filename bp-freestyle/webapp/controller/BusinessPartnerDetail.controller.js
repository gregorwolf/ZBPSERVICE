sap.ui.define(
  [
    "sap/ui/core/mvc/Controller",
    "sap/ui/model/json/JSONModel",
    "sap/ui/unified/FileUploaderParameter",
    "sap/m/MessageToast",
  ],
  function (Controller, JSONModel, FileUploaderParameter, MessageToast) {
    "use strict";

    return Controller.extend(
      "csw.bpfreestyle.controller.BusinessPartnerDetail",
      {
        onInit: function () {
          const viewSettings = {
            onUploadPictureVisible: false,
          };
          this.viewModel = new JSONModel(viewSettings);
          this.getView()?.setModel(this.viewModel, "view");

          const oOC = this.getOwnerComponent();
          const oRouter = oOC.getRouter();
          const route = oRouter.getRoute("RouteBusinessPartnerDetail");
          if (route) {
            route.attachPatternMatched(this._onRouteMatched, this);
          } else {
            // console.error('Route "RouteBusinessPartnerDetail" is not defined');
          }
        },

        onUploadPicture: function () {
          const fileuploader = this.byId("fileuploader");

          fileuploader.removeAllHeaderParameters();
          // fileUpload.removeHeaderParameter("x-csrf-token");
          // Header Token
          const customerHeaderToken = new FileUploaderParameter({
            name: "x-csrf-token",
            value: this.getView()?.getModel().getSecurityToken(),
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
        },

        _onRouteMatched: function (event) {
          // eslint-disable-next-line @typescript-eslint/no-unsafe-call
          const objectOrUndefined = event.getParameter("arguments");
          if (objectOrUndefined === undefined) {
            // Handle the case where it's undefined, perhaps by returning early
            return;
          }
          const oObject = objectOrUndefined;
          const path = this.getView()
            ?.getModel()
            .createKey("/BPAddressSet", {
              Partner: window.decodeURIComponent(oObject.Partner),
            });
          this.getView()?.bindElement({
            path: path,
            parameters: {
              expand: "to_Attachments",
            },
          });
        },

        handleTypeMissmatch: function (event) {
          const fileTypes = event.getSource().getFileType();
          const supportedFileTypes = fileTypes
            .map((fileType) => "*." + fileType)
            .join(", ");
          MessageToast.show(
            `Filetype *." ${event.getParameter(
              "fileType"
            )} is not supported. Choose one of the following types: ${supportedFileTypes}`
          );
        },

        onFileSizeExceed: function (event) {
          const fileSize = event.getSource().getMaximumFileSize();
          MessageToast.show("Files cannot be larger than " + fileSize + "MB ");
        },
        onBeforeUploadStarts: function (event) {
          const fileUpload = event.getSource();
          this.getView()?.setBusy(true);
        },

        onUploadComplete: function (event) {
          const viewModel = this.viewModel;
          viewModel.setProperty("/onUploadPictureVisible", false);
          viewModel.setProperty("/image", "");
          const attachmentTable = this.byId("to_Attachments");
          attachmentTable.getBinding("items")?.refresh();
          this.getView()?.setBusy(false);
        },

        onUploadChange: function (event) {
          const viewModel = this.viewModel;
          viewModel.setProperty("/image", "");
          const files = event?.getParameter("files");
          if (files) {
            const file = files[0];
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
        },
      }
    );
  }
);
