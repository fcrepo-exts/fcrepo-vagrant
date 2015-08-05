###
# TOMCAT 7
###

# Tomcat
apt-get -y install tomcat7 tomcat7-admin
usermod -a -G tomcat7 vagrant

if ! grep -q "role rolename=\"fedoraAdmin\"" /etc/tomcat7/tomcat-users.xml ; then
  sed -i '$i<role rolename="fedoraUser"/>
  $i<role rolename="fedoraAdmin"/>
  $i<role rolename="manager-gui"/>
  $i<user username="testuser" password="password1" roles="fedoraUser"/>
  $i<user username="adminuser" password="password2" roles="fedoraUser"/>
  $i<user username="fedoraAdmin" password="secret3" roles="fedoraAdmin"/>
  $i<user username="fedora4" password="fedora4" roles="manager-gui"/>' /etc/tomcat7/tomcat-users.xml
fi

if ! grep -q "/usr/lib/jvm/java-8-oracle" /etc/default/tomcat7 ; then
  echo "JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> /etc/default/tomcat7
fi

# Make the ingest directory
mkdir /mnt/ingest
chown -R tomcat7:tomcat7 /mnt/ingest

