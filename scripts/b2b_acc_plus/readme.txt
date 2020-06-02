Ext-gen B2B Accelerator, based on yacceleratorstorefront, with B2B Accelerator, B2B Punchout, Commerce Organization, Secure Portal, Account Summary, Saved Order Forms OCC, Asssted Services, Customer Ticketing, Captcha, Textfield Configurator, Promotions Engine, Coupons addons and Smart Edit addons.

Required Configurations:
* For captcha, you must provide your own public/private key.  See https://www.google.com/recaptcha/admin/create
* For features that require a Google API key (such as the Store Locator, which uses Google Maps), you need to set the “googleApiKey”. For information on generating your API Key: https://developers.google.com/maps/documentation/javascript/tutorial#api_key
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.