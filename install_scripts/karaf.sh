##############
# Apache Karaf
##############

echo "Installing Apache Karaf"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

if [ ! -f "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz" ]; then
  echo -n "Downloading Apache Karaf..."
  wget -q -O "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz" "http://mirror.csclub.uwaterloo.ca/apache/karaf/"$KARAF_VERSION"/apache-karaf-"$KARAF_VERSION".tar.gz"
  echo " done"
fi

if [ ! -d "/opt/apache-karaf-$KARAF_VERSION" ]; then
    if [ ! -d "$HOME_DIR/apache-karaf-$KARAF_VERSION" ]; then
        echo -n "Extracting Apache Karaf..."
        tar zxf "$DOWNLOAD_DIR/apache-karaf-$KARAF_VERSION.tar.gz"
        echo " done"
    fi
    if [ ! -d "/opt/apache-karaf-$KARAF_VERSION" ]; then
        echo "Deploying Apache Karaf... "
        mv "$HOME_DIR/apache-karaf-$KARAF_VERSION" /opt
        echo " done"
    fi
fi

if [ -L "/opt/karaf" ]; then
    rm /opt/karaf
fi
echo "Symlinking Apache Karaf... "
ln -s "/opt/apache-karaf-$KARAF_VERSION" /opt/karaf 
echo " done"

if [ ! -L "/etc/init.d/karaf-service" ]; then
    echo "Installing Karaf as a service... "
    # Run a setup script to add some feature repos and prepare it for running as a service
    /opt/karaf/bin/start
    sleep 60
    /opt/karaf/bin/client < $SHARED_DIR/install_scripts/karaf_service.script
    /opt/karaf/bin/stop

    # Add it as a Linux service
    ln -s /opt/karaf/bin/karaf-service /etc/init.d/
    update-rc.d karaf-service defaults
    echo " done"
fi

# Add the vagrant user's maven repository
if ! grep -q "$HOME_DIR/.m2/repository" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg ; then
    echo "Adding vagrant user's Maven repository... "
    sed -i "s|#org.ops4j.pax.url.mvn.localRepository=|org.ops4j.pax.url.mvn.localRepository=$HOME_DIR/.m2/repository|" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg
    echo " done"
fi

# Start it
echo "Starting Karaf as a service... "
service karaf-service start
sleep 60
echo " done"
