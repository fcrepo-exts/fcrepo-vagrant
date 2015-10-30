#!/bin/bash

# Restores fcrepo home backups created by hot_backup_runner.sh script.
# When NON_INTERACTIVE mode is not included as a command line parameter
# the user will have an opportunity to manually inspect the repository.

NON_INTERACTIVE=false

# Check parameters and print usage
if [ "$#" -ge 1 ]; then
	if [ "$1" != "NON_INTERACTIVE" ] || [ "$#" -gt 1 ]; then
    echo "Usage:"
    echo "./restore_runner.sh [NON_INTERACTIVE](optional)"
    echo "NON_INTERACTIVE mode will skip waiting for user input after completing each restore."
    echo 
    echo "Example:"
    echo "./restore_runner.sh"
    echo "./restore_runner.sh NON_INTERACTIVE"
    exit 1
  fi
  NON_INTERACTIVE=true
fi

# Stop tomcat and backup current state
sudo service tomcat7 stop
sudo mv /var/lib/tomcat7/fcrepo4-data{,.bak}

cd ~/backup_restore

if [ ! -d processed_backups ]; then
	mkdir processed_backups
fi

# Restore and verify successful repository start for each backup in the backups directory 
backup_failed=false
backup_found=false
for backup in $(ls -A backups); do 
	backup_found=true
	echo "Testing backup: $backup"; 
	sudo cp -r backups/$backup  /var/lib/tomcat7/fcrepo4-data
	sudo chown -R tomcat7:tomcat7 /var/lib/tomcat7/fcrepo4-data
	sudo service tomcat7 start
	status=`curl -s -o /dev/null -I -w "%{http_code}" -u fedoraAdmin:secret3 http://localhost:8080/fcrepo/rest`
	new_file_name=$backup
	message="Backup restored successfully!"
	if [ "$status" != "200" ]; then
		backup_failed=true
		new_file_name=$backup"_failed"
		message="Backup restore failed!"
	fi
	echo $message
	mv backups/$backup processed_backups/$new_file_name
	if ! $NON_INTERACTIVE; then
		read -p  "Press ENTER to continue to restore next backup!"
	fi
	sudo service tomcat7 stop
	sudo rm -rf /var/lib/tomcat7/fcrepo4-data
done

if ! $backup_found; then
	echo "No backups found in the ./backups directory!"
fi

if $backup_found; then
	echo "Finished restoring and verifying all backups!"
	echo "All backups are moved to processed_backups directory."
fi

if $backup_failed; then
	echo "Some backups failed to restore the repository!"
	echo "Failed backups are marked with a _failed suffix in the processed_backups directory."
fi

# Restore original repository state
sudo mv /var/lib/tomcat7/fcrepo4-data{.bak,}
sudo service tomcat7 start
status=`curl -s -o /dev/null -I -w "%{http_code}" -u fedoraAdmin:secret3 http://localhost:8080/fcrepo/rest`
message="Restored original fcrepo home and started fcrepo successfully"
if [ "$status" != "200" ]; then
	message="Restoring original fcrepo home failed!"
fi
echo $message
echo
