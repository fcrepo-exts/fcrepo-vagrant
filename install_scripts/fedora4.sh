############
# Fedora 4
############

echo "Installing Fedora."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ "${FEDORA_AUTH}" = "true" ] && [ "${FEDORA_AUDIT}" = "true" ]; then
  WEBAPP="fcrepo-webapp-plus-rbacl-audit-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
elif [ "${FEDORA_AUTH}" = "true" ]; then
  WEBAPP="fcrepo-webapp-plus-rbacl-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
elif [ "${FEDORA_AUDIT}" = "true" ]; then
  WEBAPP="fcrepo-webapp-plus-audit-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4-exts/fcrepo-webapp-plus/releases/download/fcrepo-webapp-plus-${FEDORA_TAG}"
else 
  WEBAPP="fcrepo-webapp-${FEDORA_VERSION}.war"
  RELEASES="https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FEDORA_TAG}"
fi

cd $HOME_DIR

mkdir /var/lib/tomcat7/fcrepo4-data
chown tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data
chmod g-w /var/lib/tomcat7/fcrepo4-data

if [ ! -f "$DOWNLOAD_DIR/$WEBAPP" ]; then
  echo -n "Downloading Fedora 4... $RELEASES/$WEBAPP"
  curl -L -s -o "$DOWNLOAD_DIR/$WEBAPP" "$RELEASES/$WEBAPP"
  echo " done"
fi

cp "$DOWNLOAD_DIR/$WEBAPP" /var/lib/tomcat7/webapps/fcrepo.war
chown tomcat7:tomcat7 /var/lib/tomcat7/webapps/fcrepo.war

AUDIT_LOCATION_ARG="fcrepo.audit.container"
if [ "${FEDORA_AUDIT}" == "true" ] && ! grep -q "${AUDIT_LOCATION_ARG}" /etc/default/tomcat7 ; then
  echo $'\n' >>  /etc/default/tomcat7;
  echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.audit.container=${FEDORA_AUDIT_LOCATION}\"" >> /etc/default/tomcat7;
fi 

service tomcat7 restart
