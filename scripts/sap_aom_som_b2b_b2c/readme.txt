* Asynchronous and synchronous order management for B2B and B2C scenarios with SAP ERP
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.

1. Setup the hybris platform
./install.sh -r sap_aom_som_b2b_b2c 

2. Initialize the hybris platform
./install.sh -r sap_aom_som_b2b_b2c initialize

3. Start the hybris server and datahub
./install.sh -r sap_aom_som_b2b_b2c start

4. Stop the hybris server and datahub
./install.sh -r sap_aom_som_b2b_b2c stop
