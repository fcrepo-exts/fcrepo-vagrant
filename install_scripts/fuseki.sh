echo "Installing Fuseki"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ ! -d $FUSEKI_HOME ]; then
  mkdir $FUSEKI_HOME
fi

if [ ! -f "$DOWNLOAD_DIR/jena-fuseki1-$FUSEKI_VERSION-distribution.tar.gz" ]; then
  echo -n "Downloading Fuseki..."
  wget -q -O "$DOWNLOAD_DIR/jena-fuseki1-$FUSEKI_VERSION-distribution.tar.gz" "http://www.apache.org/dist/jena/binaries/jena-fuseki1-"$FUSEKI_VERSION"-distribution.tar.gz"
  echo " done"
fi

cd /tmp
cp "$DOWNLOAD_DIR/jena-fuseki1-$FUSEKI_VERSION-distribution.tar.gz" /tmp
tar -xzvf jena-fuseki1-"$FUSEKI_VERSION"-distribution.tar.gz
cd jena-fuseki1-"$FUSEKI_VERSION"
mv -v * $FUSEKI_HOME
chown -hR tomcat7:tomcat7 $FUSEKI_HOME

mkdir "$FUSEKI_HOME/test_data"
ln -s $FUSEKI_HOME/fuseki /etc/init.d
echo "FUSEKI_HOME=\"$FUSEKI_HOME\"" > /etc/default/fuseki
echo "FUSEKI_ARGS=\"--update --loc=$FUSEKI_HOME/test_data /test\"" >> /etc/default/fuseki
update-rc.d fuseki start 20 3 4 5 . stop 20 0 1 2 6 .

/etc/init.d/fuseki start

