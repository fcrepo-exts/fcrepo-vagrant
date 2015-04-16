#############
# Fedora Camel Toolbox
#############

echo "Installing Fedora Camel Toolbox"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

if [ ! -f "$DOWNLOAD_DIR/audit-triplestore-web-${FEDORA_VERSION}.war" ]; then
  echo -n "Downloading Fedora Camel Toolbox..."
  wget -q -O "$DOWNLOAD_DIR/audit-triplestore-web-${FEDORA_VERSION}.war" "https://github.com/fcrepo4-labs/fcrepo-camel-toolbox/releases/download/fcrepo-camel-toolbox-${FEDORA_TAG}/audit-triplestore-web-${FEDORA_VERSION}.war"
  echo " done"
fi

cp "$DOWNLOAD_DIR/audit-triplestore-web-${FEDORA_VERSION}.war" /var/lib/tomcat7/webapps/audit-triplestore-web.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/audit-triplestore-web.war
service tomcat7 restart
