#############
# Fedora Message Consumer
#############

echo "Installing Fedora Message Consumer"

HOME_DIR=$1
FEDORA_VERSION=4.1.0

cd $HOME_DIR

echo -n "Downloading Fedora Message Consumer..."
wget -q -O fcrepo-message-consumer.war "https://github.com/fcrepo4/fcrepo-message-consumer/releases/download/fcrepo-message-consumer-${FEDORA_VERSION}/fcrepo-message-consumer-webapp-${FEDORA_VERSION}.war"
echo " done"
mv fcrepo-message-consumer.war /var/lib/tomcat7/webapps
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo-message-consumer.war
service tomcat7 restart

if [ -f "/var/lib/tomcat7/webapps/fcrepo-message-consumer/WEB-INF/classes/spring/indexer-core.xml" ]; then
  sed -i 's|<!--         <ref bean="solrIndexer"/> -->|             <ref bean="solrIndexer"/>|' /var/lib/tomcat7/webapps/fcrepo-message-consumer/WEB-INF/classes/spring/indexer-core.xml
fi

echo 'JAVA_OPTS="$JAVA_OPTS -Dsolr.home=/var/lib/tomcat7/solr -DsolrIndexer.port=8080 -Dsolr.autoSoftCommit.maxTime=10"' >> /etc/default/tomcat7

service tomcat7 restart
