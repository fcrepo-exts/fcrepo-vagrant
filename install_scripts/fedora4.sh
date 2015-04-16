############
# Fedora 4
############

echo "Installing Fedora."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ "${FEDORA_AUTH}" = "true" ]; then
  WEBAPP="fcrepo-webapp-plus-rbacl-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-labs/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
else
  WEBAPP="fcrepo-webapp-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FEDORA_TAG}"
fi

cd $HOME_DIR

mkdir /var/lib/tomcat7/fcrepo4-data
chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data
chmod g-w /var/lib/tomcat7/fcrepo4-data

if [ ! -f "$DOWNLOAD_DIR/$WEBAPP" ]; then
  echo -n "Downloading Fedora 4... ${FEDORA_VERSION}"
  curl -L -s -o "$DOWNLOAD_DIR/$WEBAPP" "$RELEASES/$WEBAPP"
  echo " done"
fi
cp "$DOWNLOAD_DIR/$WEBAPP" /var/lib/tomcat7/webapps/fcrepo.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo.war
service tomcat7 restart
