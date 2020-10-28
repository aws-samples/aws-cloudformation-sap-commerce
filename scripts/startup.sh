#!/bin/bash
set -e
export CATALINA_OPTS="-DHYBRIS_LOG_DIR=$HYBRIS_LOG_DIR -DPLATFORM_HOME=$PLATFORM_HOME $CATALINA_SECURITY_OPTS $CATALINA_MEMORY_OPTS -Djava.locale.providers=COMPAT,CLDR -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=de.hybris.tomcat.EnvPropertySource $ADDITIONAL_CATALINA_OPTS"
export ASPECT_NAME=${1:-default}
export CATALINA_BASE="/opt/aspects/$ASPECT_NAME/tomcat"
export HYBRIS_OPT_CONFIG_DIR="/opt/aspects/$ASPECT_NAME/hybris/conf"
yWaitForPort.sh $WAIT_FOR

sed -i  "/db.url=/ c\db.url=jdbc:mysql://${RDS_ENDPOINT}:3306/aurora?verifyServerCertificate=false&useConfigs=maxPerformance&characterEncoding=utf8&sslMode=DISABLED" /opt/aspects/default/hybris/conf/60-local.properties

# exported for JGroups TCP configuration
export y_cluster_broadcast_method_jgroups_tcp_bind__addr=$(hostname)

if [ "$JVM_ROUTE" == "dynamic" ]; then
        export JVM_ROUTE="$(yGenerateUUID.sh)"
        echo "Dynamic jvmRoute has been requested. Using: $JVM_ROUTE"
fi

if [ "$ASPECT_NAME" == "admin" ]; then
        # we use cd because setantenv.sh uses `pwd` to export PLATFORM_HOME
        cd ${PLATFORM_HOME} && source setantenv.sh
        exec ant -Dde.hybris.platform.ant.production.skip.build=true -buildfile $PLATFORM_HOME "${@:2}"
else
        exec /opt/tomcat/bin/catalina.sh ${2:-run}
fi

