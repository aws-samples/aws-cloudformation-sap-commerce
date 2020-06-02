This recipe provides everything you need to install SAP Hybris Commerce Responsive B2C Commerce Accelerator with Captcha, Promotions Engine, Coupons, Commerce Organization, Assisted Services, Customer Ticketing, Event Tracking, Smart Edit, Textfield Configurator, Privacy Overlay, Consignment Tracking, Stock Notification, Customer Interest, Configurable Bundle, yForms addons and Kyma integraion.

Required Configurations:
* For captcha, you must provide your own public/private key.  See https://www.google.com/recaptcha/admin/create 
* For eventtracking you must provide the your own endpoints/urls.  See https://wiki.hybris.com/display/accdoc50to56/hybrisAnalytics+AddOn
* For eventratcking & profile integration is necessary to use yprofileeventrackingws endpoint to enrich the events with the consent reference and others attributes. For this and other settings please see https://wiki.hybris.com/display/yprofile/Settings
* For features that require a Google API key (such as the Store Locator, which uses Google Maps), you need to set the “googleApiKey”. For information on generating your API Key: https://developers.google.com/maps/documentation/javascript/tutorial#api_key
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.
