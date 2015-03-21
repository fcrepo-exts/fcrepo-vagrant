
echo "Installing Solr"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -d $SOLR_HOME ]; then
  mkdir $SOLR_HOME
fi

if [ ! -f "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" ]; then
  echo -n "Downloading Solr..."
  wget -q -O "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" "http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/solr-$SOLR_VERSION.tgz" /tmp
echo "Extracting Solr"
tar -xzf solr-"$SOLR_VERSION".tgz
cp -v /tmp/solr-"$SOLR_VERSION"/dist/solr-"$SOLR_VERSION".war /var/lib/tomcat7/webapps/solr.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/solr.war

if [ ! -f "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" ]; then
  echo -n "Downloading commons-logging..."
  wget -q -O "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" "http://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.2/commons-logging-1.1.2.jar"
  echo " done"
fi

cp "$DOWNLOAD_DIR/commons-logging-1.1.2.jar" /usr/share/tomcat7/lib

cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/slf4j* /usr/share/tomcat7/lib
cp /tmp/solr-"$SOLR_VERSION"/example/lib/ext/log4j* /usr/share/tomcat7/lib

chown -hR tomcat7:tomcat7 /usr/share/tomcat7/lib

cp -Rv /tmp/solr-"$SOLR_VERSION"/example/solr/* $SOLR_HOME

cp $SHARED_DIR/config/schema.xml $SOLR_HOME/collection1/conf

chown -hR tomcat7:tomcat7 $SOLR_HOME

touch /var/lib/tomcat7/velocity.log
chown tomcat7:tomcat7 /var/lib/tomcat7/velocity.log

service tomcat7 restart
