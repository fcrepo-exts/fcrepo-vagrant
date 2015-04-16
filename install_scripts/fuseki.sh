echo "Installing Fuseki"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -d $FUSEKI_BASE ]; then
  mkdir $FUSEKI_BASE
  chown -hR tomcat7:tomcat7 $FUSEKI_BASE
fi

if [ ! -f "$DOWNLOAD_DIR/apache-jena-fuseki-"$FUSEKI_VERSION".tar.gz" ]; then
  echo -n "Downloading Fuseki..."
  wget -q -O "$DOWNLOAD_DIR/apache-jena-fuseki-"$FUSEKI_VERSION".tar.gz" "http://www.apache.org/dist/jena/binaries/apache-jena-fuseki-"$FUSEKI_VERSION".tar.gz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/apache-jena-fuseki-"$FUSEKI_VERSION".tar.gz" /tmp
tar -xzvf apache-jena-fuseki-"$FUSEKI_VERSION".tar.gz
cd apache-jena-fuseki-"$FUSEKI_VERSION"
mv -v fuseki.war $FUSEKI_DEPLOY
chown -hR tomcat7:tomcat7 $FUSEKI_DEPLOY/fuseki.war
service tomcat7 restart
sleep 20
sed -i 's|\/$\/\*\* = localhost|\#\/$\/\*\* = localhost|g' $FUSEKI_BASE/shiro.ini
service tomcat7 restart
