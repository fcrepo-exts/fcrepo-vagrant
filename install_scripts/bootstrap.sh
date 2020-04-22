######################
# Update box
######################

echo "Updating base box configuration"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

if [ -f "/opt/karaf/etc/org.ops4j.pax.url.mvn.cfg" ]; then
  sed -i "s/http:\/\/repo1.maven.org/https:\/\/repo1.maven.org/g" /opt/karaf/etc/org.ops4j.pax.url.mvn.cfg
fi
/etc/init.d/karaf-service restart

