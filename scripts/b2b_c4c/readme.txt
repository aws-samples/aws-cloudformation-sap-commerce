C4C Integration for B2B scenarios with SAP ERP for Order Fulfillment.
* For Kyma integration + ApiRegistry, optionally, ccv2.services.api.url.0 property should be set to a server url reachable by kyma instead of https://localhost:9002.

Linux :

1. Setup the hybris platform
./install.sh -r b2b_c4c

2. Initialize the hybris platform
./install.sh -r b2b_c4c initialize

3. Start the hybris server and datahub
./install.sh -r b2b_c4c start

4. Stop the hybris server and datahub
./install.sh -r b2b_c4c stop


Windows :

1. Setup the hybris platform
install.bat -r b2b_c4c

2. Initialize the hybris platform
install.bat -r b2b_c4c initialize

3. Start the hybris server and datahub
install.bat -r b2b_c4c start

4. Stop the hybris server and datahub
install.bat -r b2b_c4c stop