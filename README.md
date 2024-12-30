# ZBPSERVICE - Business Partner OData Service

The Business Partner OData service is a simple OData service that provides a query and read functionality for SAP Business Partners. So before you can use the service, you need to have some Business Partners in your system. You can create them in the SAP GUI transaction BP. The service allows to read, add and delete GOS attachments of the Business Partner.

## Content

- bp-cap - CAP implementation of the Business Partner OData service
- bp-freestyle - SAPUI5 Freestyle implementation of the Business Partner Application using JavaScript
- bp-freestyle-ts - SAPUI5 Freestyle implementation of the Business Partner Application using TypeScript
- bp-lrop - SAP Fiori Elements List Report Object Page implementation of the Business Partner Application
- src - ABAP implementation of the Business Partner OData service. Can be installed in an ABAP system using [abapGit](https://abapgit.org)
- tests - REST Client tests for the Business Partner OData service

## Execute the tests

Clone this repository to SAP Business Application Studio or a local System with VS Code and the REST Client Extension installed. Create a `.env` file in the `tests` folder with the following content:

```env
backend_url=http://<Destination Name>.dest
backend_username=<Your Backend Username>
backend_password="<Your Backend Password>"
```

Execute the tests by a click on the "Send Request" text that appears above the HTTP method in the REST Client files.
