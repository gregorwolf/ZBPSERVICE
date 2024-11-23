## Application Details

|                                                                                                  |
| ------------------------------------------------------------------------------------------------ |
| **Generation Date and Time**<br>Sat May 04 2024 11:51:04 GMT+0200 (Central European Summer Time) |
| **App Generator**<br>@sap/generator-fiori-elements                                               |
| **App Generator Version**<br>1.13.2                                                              |
| **Generation Platform**<br>Visual Studio Code                                                    |
| **Template Used**<br>List Report Page V2                                                         |
| **Service Type**<br>SAP System (ABAP On Premise)                                                 |

|**Service URL**<br>https://a4h.computerservice-wolf.com:50001/sap/opu/odata/sap/ZBP_SRV
|**Module Name**<br>bp-lrop|
|**Application Title**<br>Business Partner|
|**Namespace**<br>csw|
|**UI5 Theme**<br>sap_horizon|
|**UI5 Version**<br>1.108.22|
|**Enable Code Assist Libraries**<br>True|
|**Enable TypeScript**<br>True|
|**Add Eslint configuration**<br>False|
|**Main Entity**<br>BPAddressSet|
|**Navigation Entity**<br>to_Attachments|

## bp-lrop

Business Partner List Report

### Starting the generated app

- This app has been generated using the SAP Fiori tools - App Generator, as part of the SAP Fiori tools suite. In order to launch the generated app, simply run the following from the generated app root folder:

```
    npm start
```

- It is also possible to run the application using mock data that reflects the OData Service URL supplied during application generation. In order to run the application with Mock Data, run the following from the generated app root folder:

```
    npm run start-mock
```

#### Pre-requisites:

1. Active NodeJS LTS (Long Term Support) version and associated supported NPM version. (See https://nodejs.org)

## Deployment to SAP BTP Appfront

create the file `default-conf.json` with the following content and add the credentials for the services `xsuaa`, `destination` and `connectivity`:

```JSON
{
  "com.sap.service-credentials": {
    "xsuaa": [
      {
        "label": "xsuaa",
        "tags": ["xsuaa"],
        "credentials": {

        }
      }
    ],
    "destination": [
      {
        "label": "destination",
        "tags": ["destination", "conn", "connsvc"],
        "credentials": {

        }
      }
    ],
    "connectivity": [
      {
        "label": "connectivity",
        "tags": ["connectivity", "conn", "connsvc"],
        "credentials": {

        }
      }
    ]
  }
}
```

Run the following command to deploy the app to SAP BTP Appfront:

```bash
npm run build && npm run deploy:appfront
```
