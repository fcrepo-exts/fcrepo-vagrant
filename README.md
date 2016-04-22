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
  * [Fedora 4.x](http://fedorarepository.org)
    * Available at: [http://localhost:8080/fcrepo](http://localhost:8080/fcrepo)
    * Authentication/Authorization configuration detailed below
  * [Solr 4.10.3](http://lucene.apache.org/solr/)
    * Available at: [http://localhost:8080/solr](http://localhost:8080/solr), for indexing & searching your content.
    * Installed in `/var/lib/tomcat7/solr`
  * [Apache Karaf](http://karaf.apache.org/)
    * Installed in `/opt/karaf`
    * Installed as a service `apache-karaf` 
  * [Fuseki 2.3.1](http://jena.apache.org/documentation/fuseki2/)
    * Available at: [http://localhost:8080/fuseki](http://localhost:8080/fuseki), for querying and updating.
    * Installed in `/etc/fuseki`
    * Dataset Path name `/test`
    * Persistent storage `/etc/fuseki/databases/test\_data`
  * [Fcrepo-camel-toolbox 4.x](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox)
    * Installed in karaf

### Fedora Configuration

* By default, WebAC authorization is enabled on this Fedora installation.
  * Three Fedora user accounts are available:
    * user account `testuser`, with password `password1`
    * user account `adminuser`, with password `password2`
    * admin account `fedoraAdmin` with the password `secret3`
* To disable access control, edit [install_scripts/config](install_scripts/config) and change the `FEDORA_AUTH` variable to false.
* To disable Fedora internal audit capability, edit [install_scripts/config](install_scripts/config) and change the FEDORA_AUDIT variable to false. The FEDORA_AUDIT_LOCATION can also be changed from its default "/audit", if necessary.

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

## Maintainers

Current maintainers:

* [Nick Ruest](https://github.com/ruebot)
* [Jared Whiklo](https://github.com/whikloj)

## Thanks

This VM setup was heavily influenced (read: stolen) from [Islandora 2.x VM](https://github.com/Islandora-Labs/islandora/tree/7.x-2.x/install).
