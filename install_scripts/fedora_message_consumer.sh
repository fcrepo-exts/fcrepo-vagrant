#############
# Fedora Message Consumer
#############

echo "Installing Fedora Message Consumer"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

if [ ! -f "$DOWNLOAD_DIR/fcrepo-message-consumer-webapp-${FEDORA_VERSION}.war" ]; then
  echo -n "Downloading Fedora Message Consumer..."
  wget -q -O "$DOWNLOAD_DIR/fcrepo-message-consumer-webapp-${FEDORA_VERSION}.war" "https://github.com/fcrepo4/fcrepo-message-consumer/releases/download/fcrepo-message-consumer-${FEDORA_VERSION}/fcrepo-message-consumer-webapp-${FEDORA_VERSION}.war"
  echo " done"
fi

cp "$DOWNLOAD_DIR/fcrepo-message-consumer-webapp-${FEDORA_VERSION}.war" /var/lib/tomcat7/webapps/fcrepo-message-consumer.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo-message-consumer.war
service tomcat7 restart

if [ -f "/var/lib/tomcat7/webapps/fcrepo-message-consumer/WEB-INF/classes/spring/indexer-core.xml" ]; then
  sed -i 's|<!--         <ref bean="solrIndexer"/> -->|             <ref bean="solrIndexer"/>|' /var/lib/tomcat7/webapps/fcrepo-message-consumer/WEB-INF/classes/spring/indexer-core.xml
fi

echo 'JAVA_OPTS="$JAVA_OPTS -Dsolr.home=/var/lib/tomcat7/solr -DsolrIndexer.port=8080 -Dsolr.autoSoftCommit.maxTime=10"' >> /etc/default/tomcat7

service tomcat7 restart
