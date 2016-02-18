############
# Ruby 2.2
############
echo "Installing build tools."
apt-get install build-essential
echo "Installing Ruby 2.2."
apt-add-repository ppa:brightbox/ruby-ng
apt-get update
apt-get -y install ruby2.2 ruby-switch
ruby-switch --set ruby2.2
RUBYVERSION=`ruby --version`
echo "Installed ${RUBYVERSION}"
echo "Installing Ruby 2.2 dev tools."
apt-get -y install ruby2.2-dev zlib1g-dev
echo "Installing sqlite."
apt-get -y install libsqlite3-dev
echo "Installing the bundler gem at system."
gem install bundler
