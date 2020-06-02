Recipe for a vanilla for SAP Digital Payments with B2C Accelerator and a B2B Accelerator running on the same platform. In order to create the B2B Accelerator, b2bacceleratoraddon and commerceorgaddon are installed on a yb2bacceleratorstorefront extension which is generated with extgen using the yacceleratorstorefront template.

The storefronts also have Assisted Services, Customer Ticketing, Textfield Configurator and Commerce Organzation, Live Edit and Smart Edit, Order Management, Order Selfservice, Consignmant Tracking, SAP Digital Payment addons.

The promotionengine is installed by default with coupons functionality available.

Required Configurations:
* For features that require a Google API key (such as the Store Locator, which uses Google Maps), you need to set the “googleApiKey”. For information on generating your API Key: https://developers.google.com/maps/documentation/javascript/tutorial#api_key
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.
