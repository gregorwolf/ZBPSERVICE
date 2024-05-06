# ZBPSERVICE - Business Partner OData Service

## Content

- bp-cap - CAP implementation of the Business Partner OData service
- bp-freestyle - SAPUI5 Freestyle implementation of the Business Partner Application
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
