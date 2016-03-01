echo "Adding Solr core configs."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

cp -r /vagrant/solr/* /var/lib/tomcat7/solr/
chown -R tomcat7:tomcat7 /var/lib/tomcat7/solr

service tomcat7 restart
