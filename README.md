# fcrepo4-vagrant
Fedora 4 Vagrant Virtual Machine 

## Requirements

* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

## Usage

1. `git clone https://github.com/fcrepo4-exts/fcrepo4-vagrant.git`
2. `cd fcrepo4-vagrant`
3. `vagrant up`

You can shell into the machine with `vagrant ssh` or `ssh -p 2222 vagrant@localhost`

## Environment

* Ubuntu 14.04 64-bit machine with: 
  * [Tomcat 7](http://tomcat.apache.org)
    * Available at:  [http://localhost:8080](http://localhost:8080)
    * Manager username = "fedora4", password = "fedora4"
  * [Fedora 4.x](http://fedora.info/about)
    * Available at: [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * No authentication configured
  * [Solr 4.10.3](http://lucene.apache.org/solr/)
    * Available at: [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in `/var/lib/tomcat7/solr`
  * [Apache Karaf](http://karaf.apache.org/)
    * Installed in `/opt/karaf`
    * Installed as a service `apache-karaf` 
  * [Fuseki 2.3.0](http://jena.apache.org/documentation/fuseki2/)
    * Available at: [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in `/etc/fuseki`
    * Dataset Path name `/test`
    * Persistent storage `/etc/fuseki/databases/test\_data`
  * [Fcrepo-camel-toolbox 4.x](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox)
    * Installed in Tomcat container

###Usage

* Install Vagrant and VirtualBox
* Clone this repository 
* `cd fcrepo4-vagrant`
* To disable role-based access control, edit `install_scripts/config` and change the `FEDORA_AUTH` variable to false.
  This will enable three accounts:
  * user account `testuser`, with password `password1`
  * user account `adminuser`, with password `password2`
  * admin account `fedoraAdmin` with the password `secret3`
* To disable fedora internal audit capability, edit `install_scripts/config` and change the FEDORA_AUDIT variable to false. The FEDORA_AUDIT_LOCATION can also be changed from its default "/audit", if necessary.
* `vagrant up`

####Acceptance Testing

One may validate the state of the environment created by the provisioning process using [beaker](https://github.com/puppetlabs/beaker).
Please note that the test suite requires that both [Ruby](https://www.ruby-lang.org) (release 2.2.3 and later are supported) and [Bundler](http://bundler.io) (supporting releases 1.10 and later) to be installed within the working environment.
The acceptance tests (implemented using [server-spec](http://serverspec.org/)) must be executed from outside of the Vagrant Box, using the BASH script `accept.sh`:
* `source spec/accept.sh`

#### Using the backup and restore scripts
The scripts at the ~/backup_restore directory can be used to test backing up and restoring the fedora repository for consistency.

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

## Windows Troubleshooting

If you receive errors involving `\r` (end of line):

Edit the global `.gitconfig` file, find the line:
```
autocrlf = true
```
and change it to
```
autocrlf = false
```
Remove and clone again. This will prevent windows git clients from automatically replacing unix line endings LF with windows line endings CRLF.

## Maintainers

Current maintainers:

* [Nick Ruest](https://github.com/ruebot)
* [Jared Whiklo](https://github.com/whikloj)

## Thanks

This VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install).
