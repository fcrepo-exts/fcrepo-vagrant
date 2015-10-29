###########################
#Backup and Restore scripts
###########################

echo "Installing backup restore scripts to ~/backup_restore directory"
mkdir /home/vagrant/backup_restore
cp /vagrant/backup_restore_scripts/* /home/vagrant/backup_restore
chown -R vagrant:vagrant /home/vagrant/backup_restore