#!/bin/bash

# Spawns parallel processes to create objects and datastreams using generate_and_load.sh script.
# Create hot backups of the fcrepo home while the data load processes ingest objects and datastreams.

# Check parameters and print usage
if [ "$#" -ne 3 ]; then
    echo "Usage:"
    echo "./hot_backup_runner.sh [Number_of_parallel_dataloads_to_run] /path/to/fcrepo_home [backup_interval_in_seconds]"
    echo "Example:"
    echo "./hot_backup_runner.sh 3 /var/lib/tomcat7/fcrepo_data 10"
    exit 1
fi

# Number of parallel processes to run
BATCHES=$1
# Path of the fcrepo home
FCREPO_HOME=$2
# Backup frequency in seconds (while load scripts run)
BACKUP_INTERVAL=$3

# Has any child load process completed data generation
dataload_started=false
catch_signal_usr1 () { dataload_started=true ;}
trap catch_signal_usr1 USR1

# Kill all child process on control + c
function ctrl_c() {
	for pid in ${pids[@]}; do
		if ps -p $pid &> /dev/null; then
			kill $pid
		fi
	done
	echo "Terminated!"
	exit
}
trap ctrl_c INT

# Backup original fcrepo home
if [ ! -d ~/backup_restore/fcrepo_home.ORIGINAL ]; then
	cp -r $FCREPO_HOME ~/backup_restore/fcrepo_home.ORIGINAL
fi

# Start child processes to load data
i=0
while [[ $i -lt $BATCHES ]]
do
	echo "Creating loader batch $i" >> hot_backup_runner.log
	nohup bash generate_and_load.sh >> hot_backup_runner.log & 

	# Store all child pids in an array
	pids[$i]=$!

	i=$((i + 1))
done

if [ ! -d backups ]; then
	mkdir backups
fi

# Create backups until all the loader child processes have terminated.
first_loop=true
batches_running=true
while [ "$batches_running" = true ] ; do
	batches_running=false
	# Set batches_running to true if any of the child pid still exist
	for pid in ${pids[@]}; do
		if ps -p $pid &> /dev/null; then
			batches_running=true
		fi
	done

	if $first_loop; then
		printf "Waiting for data generation to complete and loading to begin"
	fi

	# Wait for data loading to begin at least in a single child process
	while ! $dataload_started ; do sleep 1; printf "." ; done

	if $first_loop; then
		echo
		echo "Staring backups!"
	fi

	# Copy fcrepo home to backups directory
	if $batches_running ; then
		backup_suffix=`date +"%Y%m%d%H%M%S"`
		start=`date +%s`
		cp -r $FCREPO_HOME ./backups/fcrepo_home.bkp.$backup_suffix
		echo "Backup created: ./backups/fcrepo_home.bkp.$backup_suffix"
		echo "Backup created: ./backups/fcrepo_home.bkp.$backup_suffix" >> hot_backup_runner.log
		end=`date +%s`
		backup_duration=$((END - START))
		sleep $(( BACKUP_INTERVAL - backup_duration )) >> /dev/null 2>&1
	fi
	first_loop=false
done
