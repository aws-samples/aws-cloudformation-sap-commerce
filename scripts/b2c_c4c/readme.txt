==================================================
Use the following commands to install the:
B2C Accelerator (vanilla recipe without CIS/OMS integration)
Assisted Service Module (ASM)
Customer Ticketing Add On
C4C Ticketing System REST integration
C4C customer data integration extension
C4C customer data Data Hub WAR and mock WAR file
For Kyma integration + ApiRegistry, event sending is turned off by default by apiregistryservices.events.exporting=false property. Optionally and before initialization, deployment.api.endpoint property should be set to a server url reachable by kyma instead of https://localhost:9002.
Replace './install.sh' with './install.bat' if using windows.

build.gradle has installer 6.3 version syntax, it is supportable for 6.4+ too.
build_installer_6.4.gradle has installer 6.4+ version syntax.
==================================================
1. Setup the hybris platform using command
./install.sh -r b2c_c4c setup
2. Initialize the hybris platform using command 
./install.sh -r b2c_c4c initialize
3. Start the hybris server using command
./install.sh -r b2c_c4c start
==================================================