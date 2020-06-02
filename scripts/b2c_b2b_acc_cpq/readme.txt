Recipe for a B2C Accelerator and a B2B Accelerator, both with CPQ enabled, running on the same platform. 
In order to create the B2B Accelerator, b2bacceleratoraddon and commerceorgaddon are installed on a yb2bacceleratorstorefront extension which is generated with extgen using the yacceleratorstorefront template.
The promotionengine is installed by default.
For features that require a Google API key (such as the Store Locator, which uses Google Maps), you need to set the “googleApiKey”. For information on generating your API Key: https://developers.google.com/maps/documentation/javascript/tutorial#api_key
For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.

Prerequisites:
Before you can use this recipe, you must install SAP CPQ Configuration Runtime Engine (also referred to as SSC) as described in the installation guide (especially sections “Downloading the Software”, “Configuration Runtime”, and “Data Loader”). You can find the installation guide for SAP Configure, Price, and Quote for product configuration under https://help.hybris.com/<your_version>/hcd/31df5d559c9c0d30e10000000a441470.html
For version 6.4, see https://help.hybris.com/6.4.0/hcd/31df5d559c9c0d30e10000000a441470.html

Note: Do not confuse this installation guide with the similar one for SAP Configure, Price, and Quote for solution sales configuration (SAP CPQ SOL. SALES CONFIG).
