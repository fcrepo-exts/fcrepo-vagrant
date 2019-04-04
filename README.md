# fcrepo4-vagrant
Fedora 4 Vagrant Virtual Machine 

## Requirements

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

## Usage

1. Install Vagrant and VirtualBox
2. `git clone https://github.com/fcrepo4-exts/fcrepo4-vagrant.git`
3. `cd fcrepo4-vagrant`
4. `vagrant up`

You can shell into the machine with `vagrant ssh` or `ssh -p 2222 vagrant@localhost`

## Environment

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](http://tomcat.apache.org)
    * Available at:  [http://localhost:8080/manager/html](http://localhost:8080/manager/html)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 5.x](http://fedorarepository.org)
    * Available at: [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * Authentication/Authorization configuration detailed below
  * [Solr 4.10.3](http://lucene.apache.org/solr/)
    * Available at: [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in `/var/lib/tomcat7/solr`
  * [Apache Karaf 4.0.5](http://karaf.apache.org/)
    * Installed in `/opt/karaf`
    * Installed as a service `apache-karaf` 
  * [Fuseki 2.3.1](http://jena.apache.org/documentation/fuseki2/)
    * Available at: [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in `/etc/fuseki`
    * Dataset Path name `/test`
    * Persistent storage `/etc/fuseki/databases/test\_data`
  * [Fcrepo-camel-toolbox 5.x](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox)
    * Installed in karaf
  * [Hawtio 2.5.0](https://hawt.io/)
    * Available at [http://localhost:8181/hawtio](http://localhost:8181/hawtio)
    * Access via username = "karaf", password = "karaf"
    * Installed in karaf

### Fedora Configuration
WebAC authorization is enabled on this Fedora installation.  
The following three Fedora user accounts are available:
 * user account `testuser`, with password `password1`
 * user account `adminuser`, with password `password2`
 * admin account `fedoraAdmin` with the password `secret3`

### Using the backup and restore scripts
The scripts at the ~/backup_restore directory can be used to test backing up and restoring the Fedora repository for consistency.

The following command will cause 50 parallel processes to load data to the repository while creating snapshots of fcrepo home directory every 2 seconds.

```
cd ~/backup_restore/
./hot_backup_runner.sh 50 /var/lib/tomcat7/fcrepo4-data 2
```

This will restore the backups created from the `hot_backup_runner.sh` and test if the repository starts successfully.

```
./restore_runner.sh NON_INTERACTIVE
```

To manually inspect the state of the repository, the command can be run without the NON_INTERACTIVE option. This
will cause the script to pause for user input after each restore operation.

```
./restore_runner.sh
``` 
## Customizations

The applications installed on this Vagrant box have been customized to showcase features. Some of the configuration of these applications may not be recommended for production installations.
Application customizations are found in the [install_scripts](install_scripts) directory.

### Fedora Customizations

Beyond the configuration noted in the [Fedora Configuration](#fedora-configuration) section, the installed Fedora application is standard.

### Camel Toolbox Customizations

The following services have been configured with Fedora credentials:
* Solr indexer
* Triplestore indexer
* Fixity service
* Serialization service
* Reindexing service

The Solr indexer has been configured to communicate with Solr running on port 8080, instead of the default 8983.

The triplestore indexer has been configured to NOT include any `Prefer` headers. The production default is to limit the triples to be indexed by omitting `ldp:contains` triples.

The reindexing service has been configured to bind to the host, `0.0.0.0`, instead of the default `localhost`. This allows the reindexing service to be accessible from outside of the Vagrant VM, i.e. from the host machine. See [camel-jetty documentation](http://camel.apache.org/jetty.html), search for: "Usage of localhost".

### Hawtio

Hawtio is a pluggable management console for Java stuff which supports any kind of JVM, any kind of container (Tomcat, Jetty, Wildfly, Karaf, etc), and any kind of Java technology and middleware. It has a Camel plugin, that allows you to gain insight into your running Camel applications.

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

#### Port 9080 (reindexing service) unavailable after vagrant up

It might happen that during the first `vagrant up` the reindexing service is not installed and the port 9080 is inaccessible (try `telnet localhost 9080`). To fix this run `vagrant provision` and check again. If it still does not work, install the services manually:
```
vagrant ssh
cd /opt/karaf/bin
./client </vagrant/install_scripts/fedora_camel_toolbox.script
```

#### Windows Troubleshooting

If you receive errors involving `\r` (end of line):

Edit the global `.gitconfig` file, find the line:
```
autocrlf = true
```
and change it to
```
autocrlf = false
```
Remove and clone again. This will prevent Windows git clients from automatically replacing Unix line endings LF with Windows line endings CRLF.


#### Mac OSX Troubleshooting

If you receive an error such as:
```
The box 'fcrepo/fcrepo4-base' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:
URL: ["https://atlas.hashicorp.com/fcrepo/fcrepo4-base"]
Error: 
```
when running `vagrant up`, this is likely the result of the embedded `curl` version in Vagrant 1.8.7 conflicting with the existing binary version in Mac OSX El Capitan or later. To resolve, this remove the embedded `curl` version:

`sudo rm /opt/vagrant/embedded/bin/curl`

#### Boot Troubleshooting

If you encounter authentication errors in the SSH communication between Vagrant and the virtual machine, for example:
```
default: SSH auth method: private key
default: Warning: Remote connection disconnect. Retrying...
default: Warning: Authentication failure. Retrying...
default: Warning: Authentication failure. Retrying...
...
Timed out while waiting for the machine to boot. This means that
Vagrant was unable to communicate with the guest machine within
the configured ("config.vm.boot_timeout" value) time period.
```
First, please check that you are using the latest Vagrant and Virtual Box versions with the following commands:
```
$ vboxmanage --version
$ vagrant -v
```
And, if possible, update your software to the latest version available from [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).  After updating, remove the previously provisioned VM and run the provisioning again:
```
$ vagrant halt
$ vagrant destroy
$ vagrant up
```
Another source of issues is that a previous virtual machine has not shut down cleanly, which can cause conflicts during provisioning leading to VM failure.  To ensure that you have a clean Vagrant environment from which to begin, do:
```
$ vagrant global-status
```
If there are other Vagrant environments running, these can be shut down through the Virutal Box interface, or by referencing the Vagrant by ID as follows (ID is the first column in the output of the global-status subcommand mentioned above):
```
$ vagrant halt [id]
```
and, if desired,
```
$ vagrant destroy [id]
```

## Maintainers

Current maintainers:

* [Nick Ruest](https://github.com/ruebot)
* [Jared Whiklo](https://github.com/whikloj)

## Thanks

This VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install).
