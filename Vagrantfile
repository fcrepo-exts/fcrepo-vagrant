# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
	
	config.vm.hostname = "fedora4"

	config.vm.box = "ubuntu/trusty64"

	config.vm.network :forwarded_port, guest: 8080, host: 8080 # Tomcat
	config.vm.network :forwarded_port, guest: 3030, host: 3030 # Fuseki

  config.vm.provider "virtualbox" do |v|
  	v.memory = 2048
  end

  home_dir = "/home/vagrant"

	config.vm.provision "shell", path: "./install_scripts/bootstrap.sh", args: home_dir
  config.vm.provision "shell", path: "./install_scripts/java.sh" 
  config.vm.provision "shell", path: "./install_scripts/tomcat7.sh"
  config.vm.provision "shell", path: "./install_scripts/solr.sh"
  config.vm.provision "shell", path: "./install_scripts/fedora4.sh", args: home_dir
  config.vm.provision "shell", path: "./install_scripts/fuseki.sh"
  config.vm.provision "shell", path: "./install_scripts/fedora_message_consumer.sh", args: home_dir

end
