######################
# Fedora Camel Toolbox
######################

echo "Installing Fedora Camel Toolbox"

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cd $HOME_DIR

/opt/karaf/bin/client -u karaf -h localhost -a 8101 -f "$SHARED_DIR/install_scripts/fedora_camel_toolbox.script"

# ActiveMQ
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.service.activemq.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-service-activemq"
fi

# Solr indexing
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-solr"
fi
sed -i 's|solr.baseUrl=http://localhost:8983/solr/collection1|solr.baseUrl=http://localhost:8080/solr/collection1|' /opt/karaf/etc/org.fcrepo.camel.indexing.solr.cfg

# Triplestore indexing
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.indexing.triplestore.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-indexing-triplestore"
fi

# Audit service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.audit.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-audit-triplestore"
fi

# Fixity service
sleep 10
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.fixity.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-fixity"
   sleep 10
fi

# Serialization service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.serialization.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-serialization"
fi

# Reindexing service
if [ ! -f "/opt/karaf/etc/org.fcrepo.camel.reindexing.cfg" ]; then
   /opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install fcrepo-reindexing"
fi
sed -i 's|rest.host=localhost$|rest.host=0.0.0.0|' /opt/karaf/etc/org.fcrepo.camel.reindexing.cfg

sed -i 's|fcrepo.authUsername=$|fcrepo.authUsername=fedoraAdmin|' /opt/karaf/etc/org.fcrepo.camel.service.cfg
sed -i 's|fcrepo.authPassword=$|fcrepo.authPassword=secret3|' /opt/karaf/etc/org.fcrepo.camel.service.cfg

/etc/init.d/karaf-service restart
