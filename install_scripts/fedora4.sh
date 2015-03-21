############
# Fedora 4
############

echo "Installing Fedora."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

mkdir /var/lib/tomcat7/fcrepo4-data
chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data
chmod g-w /var/lib/tomcat7/fcrepo4-data

if [ ! -f "$DOWNLOAD_DIR/fcrepo-webapp-$FEDORA_VERSION.war" ]; then
  echo -n "Downloading Fedora 4..."
  wget -q -O "$DOWNLOAD_DIR/fcrepo-webapp-$FEDORA_VERSION.war" "https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-$FEDORA_VERSION/fcrepo-webapp-$FEDORA_VERSION.war"
  echo " done"
fi
cp "$DOWNLOAD_DIR/fcrepo-webapp-$FEDORA_VERSION.war" /var/lib/tomcat7/webapps/fcrepo.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo.war
service tomcat7 restart
