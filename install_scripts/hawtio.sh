######################
# Fedora Camel Toolbox
######################

echo "Installing Hawt.io"

/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:repo-add hawtio 2.5.0"
/opt/karaf/bin/client -u karaf -h localhost -a 8101 "feature:install hawtio"

