#!/bin/bash

echo "Installing MySQL."

apt-get -y update

debconf-set-selections <<< 'mysql-server mysql-server/root_password password fedoraMySQL'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password fedoraMySQL'
apt-get -y install mysql-server
sleep 2
echo 'DROP DATABASE IF EXISTS fcrepo; CREATE DATABASE fcrepo; grant all privileges on fcrepo.* to "fedora_user"@"localhost"; SET PASSWORD for "fedora_user"@"localhost" = PASSWORD("fedora_passwd"); flush privileges;' | mysql -u root -p'fedoraMySQL'

if [ -f "/var/lib/tomcat7/webapps/fcrepo/WEB-INF/classes/config/jdbc-mysql/repository.json" ]; then
  sed -i 's/"org.fcrepo.auth.common.BypassSecurityServletAuthenticationProvider"/"org.fcrepo.auth.common.ServletContainerAuthenticationProvider"/' /var/lib/tomcat7/webapps/fcrepo/WEB-INF/classes/config/jdbc-mysql/repository.json
else 
 print "CAN'T SEE THE REPOSITORY CONFIGURATION FILES!!"
 exit
fi

if ! grep -q "fcrepo.modeshape.configuration" /etc/default/tomcat7 ; then
  echo $'\n' >> /etc/default/tomcat7
  echo "CATALINA_OPTS=\"\${CATALINA_OPTS} -Dfcrepo.mysql.username=fedora_user -Dfcrepo.mysql.password=fedora_passwd -Dfcrepo.mysql.host=localhost -Dfcrepo.mysql.port=3306\"" >> /etc/default/tomcat7
  MODESHAPE_CONFIG="classpath:/config/jdbc-mysql/repository.json"
fi

