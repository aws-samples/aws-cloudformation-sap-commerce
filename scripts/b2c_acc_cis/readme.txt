This recipe provides everything you need to install SAP Hybris Commerce Responsive B2C Commerce Accelerator with Smart Edit, Promotions Engine, Coupons, Textfield Configurator, Assisted Services, Customer Ticketing addons and CIS adding using mock implementation.

Required Configurations:
* For features that require a Google API key (such as the Store Locator, which uses Google Maps), you need to set the “googleApiKey”. For information on generating your API Key: https://developers.google.com/maps/documentation/javascript/tutorial#api_key
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.

B2C Accelerator with CIS 
 Platform Setup:
   1. Setup platform using command ./install.sh -r b2c_acc_cis setup
   2. Initialize platform using command ./install.sh -r b2c_acc_cis initialize
   3. Start platform using command ./install.sh -r b2c_acc_cis start