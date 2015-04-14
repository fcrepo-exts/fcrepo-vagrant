# fedora4-vm
Fedora 4 Vagrant Virtual Machine 

###Requires
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

###Provides
* Ubuntu 64bit machine with 
  + [Tomcat 7](http://tomcat.apache.org) at *http://localhost:8080*
    * Manager username = "fedora4", password = "fedora4"
  + [Fedora 4.1.0](http://fedora.info/about) at *http://localhost:8080/fcrepo*
    * No authentication configured by default
  + [Solr 4.10.3](http://lucene.apache.org/solr/) at *http://localhost:8080/solr*
    * Installed in "/var/lib/tomcat7/solr"
  + [Fuseki 1.1.2](http://jena.apache.org/documentation/serving_data/index.html) at *http://localhost:3030*
    * Installed in "/usr/share/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/usr/share/fuseki/temp\_data"
  + [Fcrepo-message-consumer 4.1.0](https://github.com/fcrepo4/fcrepo-message-consumer)
    * Installed in Tomcat container

###Usage
* Install Vagrant and VirtualBox
* Clone this repository 
* `cd fcrepo4-vagrant`
* (optional) to enable role-based access control, edit `install_scripts/config` and change the `FEDORA_AUTH` variable to true.
  This will enable three accounts:
  * user account `testuser`, with password `password1`
  * user account `adminuser`, with password `password2`
  * admin account `fedoraAdmin` with the password `secret3`
* `vagrant up`

###Support

If you receive the following error:
```
There are errors in the configuration of this machine, Please fix the following errors and try again:

vm:
* The box 'ubuntu/trusty64' could not be found.
```

Edit the file **Vagrantfile**, find the lines:
```
# Below needed for Vagrant versions < 1.6.x
# config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
```
and un-comment the **config.vm.box\_url** line, save the file and retry.

###Thanks
This VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install)
