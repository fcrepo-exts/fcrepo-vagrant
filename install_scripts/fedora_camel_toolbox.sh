######################
# Fedora Camel Toolbox
######################

echo "Installing Fedora Camel Toolbox"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

/opt/karaf/bin/client < "$SHARED_DIR/install_scripts/fedora_camel_toolbox.script"

sed -i 's|solr.baseUrl=localhost:8983/solr/collection1|solr.baseUrl=localhost:8080/solr/collection1|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg
