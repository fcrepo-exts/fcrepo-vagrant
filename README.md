# fedora4-vm

Fedora 4 Vagrant Virtual Machine 

## Requirements

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

## Usage

1. `git clone git@github.com:fcrepo4-labs/fcrepo4-vagrant.git`
2. `fcrepo4-vagrant`
3. `vagrant up`

You can shell into the machine with `vagrant ssh` or `ssh -p 2222 vagrant@localhost`

## Environment

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](http://tomcat.apache.org) at [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.1.1](http://fedora.info/about) at [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](http://lucene.apache.org/solr/) at [http://localhost:8080/solr](http://localhost:8080/solr)
    * Installed in "/var/lib/tomcat7/solr"
  * [Fuseki 1.1.2](http://jena.apache.org/documentation/serving_data/index.html) at [http://localhost:3030](http://localhost:3030)
    * Installed in "/usr/share/fuseki"
    * Dataset Path name "/test"
    * Persistent storage "/usr/share/fuseki/temp\_data"
  * [Fcrepo-message-consumer 4.1.1](https://github.com/fcrepo4/fcrepo-message-consumer)
    * Installed in Tomcat container

Solr: is an enterprise search platform. In this deployment you can point your application at [http://localhost:8080/solr](http://localhost:8080/solr), and index & search your content.

Fuseki: is a SPARQL server. In this deployment you can point your application at [http://localhost:3030](http://localhost:3030) for querying and updating.

fcrepo-message-consumer: is a fcrepo 4.x indexer that listens to the Fedora JMS topic, retrieves a message including pid and eventType, looks up object properties, gets and passes the transformed or untransformed properties on to any number of registered handlers.

## Support

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

## Thanks

This VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install)
