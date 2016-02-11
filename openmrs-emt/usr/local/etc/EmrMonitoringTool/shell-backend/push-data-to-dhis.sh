#!/bin/bash

# Pushes the previously stored datasetvalues on the file system to a live dhis instance

pushDataToDHIS() {
	EMT_MAIN_CONFIG=$1
   
	if [ ! -f $EMT_MAIN_CONFIG ]; then
		echo "ERROR: $EMT_MAIN_CONFIG must exist to proceed, make sure you successfully run improved-installation.sh first"
		exit 1
	fi

	OMRS_DATA_DIR=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'openmrs_data_directory' | tail -n 1 | cut -d "=" -f2-`
	DHISDATAVALUES=$OMRS_DATA_DIR/EmrMonitoringTool/dhis-emt-datasetValueSets.json
	
	curl -d @$DHISDATAVALUES "http://82.196.9.250:8080/api/dataValueSets" -H "Content-Type:application/json" -u admin:district
}



EMT_DIR=/usr/local/etc/EmrMonitoringTool
EMT_CONFIG_FILES=($(ls -a $EMT_DIR/.*-emt-config.properties))

for i in "${EMT_CONFIG_FILES[@]}"
do
	pushDataToDHIS "$i"
done