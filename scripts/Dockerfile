FROM sapmachine/lts

ADD binaries/ /opt/
ADD aspects /opt/aspects
ADD keystore /etc/ssl/certs/hybris/
ADD startup.sh /opt/startup/
RUN chmod +x /opt/startup/startup.sh && \
    chmod +x /opt/tomcat/bin/catalina.sh && \
    chmod +x /opt/ytools/*.sh
ENV CATALINA_SECURITY_OPTS=-Djava.security.egd=file:/dev/./urandom \
    CATALINA_MEMORY_OPTS=-Xms2G\ -Xmx2G \
    HTTPS_PORT=8088 \
    HTTP_PORT=8081 \
    HTTP_CONNECTOR_SECURE=false \
    AJP_PORT=8009 \
    KEYSTORE_LOCATION=/etc/ssl/certs/hybris/keystore \
    KEYSTORE_ALIAS=1 \
    KEYSTORE_PASSWORD=123456 \
    PLATFORM_HOME=/opt/hybris/bin/platform/ \
    WAIT_FOR="" \
    JVM_ROUTE="" \
    PATH="/opt/ytools:${PATH}" \
    HYBRIS_BIN_DIR=/opt/hybris/bin \
    HYBRIS_CONFIG_DIR=/opt/hybris/config \
    HYBRIS_DATA_DIR=/opt/hybris/data \
    HYBRIS_LOG_DIR=/var/log/hybris \
    HYBRIS_TEMP_DIR=/opt/hybris/temp \
    CATALINA_LOG_DIR=${HYBRIS_LOG_DIR}/catalina \
    ACCESS_LOG_DIR=${HYBRIS_LOG_DIR}/tomcat \
    ACCESS_LOG_SUFFIX=.log \
    ACCESS_LOG_PATTERN=combined \
    ACCESS_LOG_PREFIX=access. \
    ERROR_SHOW_REPORT=false \
    ERROR_SHOW_SERVER_INFO=false
ENTRYPOINT ["/opt/startup/startup.sh"]
