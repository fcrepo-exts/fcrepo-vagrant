echo "Installing Fuseki"

FUSEKI_VERSION=1.1.1
FUSEKI_HOME=/usr/share/fuseki

mkdir $FUSEKI_HOME

cd /tmp
echo -n "Downloading Fuseki..."
wget -q http://www.apache.org/dist/jena/binaries/jena-fuseki-"$FUSEKI_VERSION"-distribution.tar.gz
echo " done"
tar -xzvf jena-fuseki-"$FUSEKI_VERSION"-distribution.tar.gz
cd jena-fuseki-"$FUSEKI_VERSION"
mv -v * $FUSEKI_HOME
chown -hR tomcat7:tomcat7 $FUSEKI_HOME
cd $FUSEKI_HOME
./fuseki-server --update --mem /test &
