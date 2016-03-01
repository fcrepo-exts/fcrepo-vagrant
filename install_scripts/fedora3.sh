############
# Fedora 3
############

echo "Installing Fedora 3."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

RELEASES="https://github.com/fcrepo3/fcrepo/releases/download/v3.8.1"
INSTALLER="fcrepo-installer-3.8.1.jar"

cd $HOME_DIR

mkdir /var/lib/tomcat7/fcrepo3-home
export FEDORA_HOME=/var/lib/tomcat7/fcrepo3-home
chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo3-home
chmod g-w /var/lib/tomcat7/fcrepo3-home
if [ ! -f "$DOWNLOAD_DIR/$INSTALLER" ]; then
  echo -n "Downloading Fedora 3 Installer... $RELEASES/$INSTALLER"
  curl -L -s -o "$DOWNLOAD_DIR/$INSTALLER" "$RELEASES/$INSTALLER"
  echo " done"
fi

java -jar $DOWNLOAD_DIR/$INSTALLER /vagrant/fcrepo3/install.properties

chown -R tomcat7:tomcat7 /var/lib/tomcat7/fcrepo3-home/*

# unpack the war
service tomcat7 restart
# remove a conflicting jar
rm /var/lib/tomcat7/webapps/fedora-3.8.1/WEB-INF/lib/log4j-over-slf4j-1.7.2.jar
service tomcat7 restart
