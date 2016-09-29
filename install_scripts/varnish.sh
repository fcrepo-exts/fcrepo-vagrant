sudo apt-get update
sudo apt-get install apt-transport-https -y
sudo apt-get install curl -y
sudo curl https://repo.varnish-cache.org/GPG-key.txt | sudo apt-key add -
sudo echo "deb https://repo.varnish-cache.org/ubuntu/ trusty varnish-4.1" | sudo tee -a /etc/apt/sources.list.d/varnish-cache.list
sudo apt-get update -y
sudo apt-get install varnish -y
sudo cp /vagrant/varnish/default.vcl /etc/varnish/default.vcl
sudo service varnish restart
