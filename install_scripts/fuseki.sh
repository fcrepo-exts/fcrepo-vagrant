echo "Installing Fuseki"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -d $FUSEKI_BASE ]; then
  mkdir -p $FUSEKI_BASE/configuration
  chown -hR tomcat7:tomcat7 $FUSEKI_BASE
fi

if [ ! -f "$DOWNLOAD_DIR/apache-jena-fuseki-$FUSEKI_VERSION-distribution.tar.gz" ]; then
  echo -n "Downloading Fuseki..."
  wget -q -O "$DOWNLOAD_DIR/apache-jena-fuseki-$FUSEKI_VERSION-distribution.tar.gz" "http://www.us.apache.org/dist/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/apache-jena-fuseki-$FUSEKI_VERSION-distribution.tar.gz" /tmp
tar -xzvf apache-jena-fuseki-"$FUSEKI_VERSION"-distribution.tar.gz
cd apache-jena-fuseki-"$FUSEKI_VERSION"
mv -v fuseki.war $FUSEKI_DEPLOY
chown -hR tomcat7:tomcat7 $FUSEKI_DEPLOY/fuseki.war
service tomcat7 restart
# Need to sleep for a bit while Fuseki deploys for the first time.
sleep 20
cp $SHARED_DIR/config/shiro.ini $FUSEKI_BASE
cp $SHARED_DIR/config/test.ttl $FUSEKI_BASE/configuration
service tomcat7 restart
