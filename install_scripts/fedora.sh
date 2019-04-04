############
# Fedora 
############

echo "Installing Fedora."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

WEBAPP="fcrepo-webapp-${FEDORA_VERSION}.war"
RELEASES="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FEDORA_TAG}"

cd $HOME_DIR

mkdir /var/lib/tomcat7/fcrepo4-data
chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data
chmod g-w /var/lib/tomcat7/fcrepo4-data

if [ ! -f "$DOWNLOAD_DIR/$WEBAPP" ]; then
  echo -n "Downloading Fedora... $RELEASES/$WEBAPP"
  curl -L -s -o "$DOWNLOAD_DIR/$WEBAPP" "$RELEASES/$WEBAPP"
  echo " done"
fi

cp "$DOWNLOAD_DIR/$WEBAPP" /var/lib/tomcat7/webapps/fcrepo.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo.war

if [ "${FEDORA_JDBC_STORE}" = "mysql" ]; then
   . $SHARED_DIR/install_scripts/mysql.sh
fi


if [ -z "${MODESHAPE_CONFIG}" ]; then
  MODESHAPE_CONFIG="classpath:/config/servlet-auth/repository.json"
fi

if ! grep -q "fcrepo.modeshape.configuration" /etc/default/tomcat7 ; then
  echo $'\n' >>  /etc/default/tomcat7;
  echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.modeshape.configuration=${MODESHAPE_CONFIG}\"" >> /etc/default/tomcat7;
fi

if [ ! -f "$HOME_DIR/external-content-allowed-paths.txt" ]; then
  cp "$SHARED_DIR/install_scripts/external-content-allowed-paths.txt" $HOME_DIR
fi

echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.external.content.allowed=${HOME_DIR}/external-content-allowed-paths.txt\"" >> /etc/default/tomcat7;
echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.properties.management=relaxed\"" >> /etc/default/tomcat7;

if [ ! -f "$HOME_DIR/fcrepo-config.xml" ]; then
  cp "$SHARED_DIR/install_scripts/fcrepo-config.xml" $HOME_DIR
fi

if ! grep -q "fcrepo.spring.configuration" /etc/default/tomcat7 ; then
  echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.spring.configuration=file://${HOME_DIR}/fcrepo-config.xml\"" >> /etc/default/tomcat7;
fi

service tomcat7 restart
