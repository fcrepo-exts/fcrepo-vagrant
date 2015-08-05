#############
# Fedora Camel Toolbox
#############

echo "Installing Fedora Camel Toolbox"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

if [ ! -f "$DOWNLOAD_DIR/fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war" ]; then
  echo -n "Downloading Fedora Camel Toolbox..."
  wget -q -O "$DOWNLOAD_DIR/fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war" "https://github.com/fcrepo4-labs/fcrepo-camel-toolbox/releases/download/fcrepo-camel-toolbox-${FEDORA_TAG}/fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war"
  echo " done"
fi
 
cp "$DOWNLOAD_DIR/fcrepo-camel-webapp-at-is-it-rs-${FEDORA_VERSION}.war" /var/lib/tomcat7/webapps/fcrepo-camel-webapp.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo-camel-webapp.war

SOLR_URL_ARG="localhost:8080/solr/collection1"
if ! grep -q ${SOLR_URL_ARG} /etc/default/tomcat7 ; then
  echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dsolr.base.url=${SOLR_URL_ARG}\"" >> /etc/default/tomcat7;
fi

service tomcat7 restart
