#!/bin/bash

# Pushes the previously stored datasetvalues on the file system to a live dhis instance

pushDataToDHIS() {
	EMT_MAIN_CONFIG=$1

	if [ ! -f "$EMT_MAIN_CONFIG" ]; then
		echo "ERROR: $EMT_MAIN_CONFIG must exist to proceed, make sure you successfully run improved-installation.sh first"
		exit 1
	fi

	OMRS_DATA_DIR=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'openmrs_data_directory' | tail -n 1 | cut -d "=" -f2-`
	DHIS_URL=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'dhis_url' | tail -n 1 | cut -d "=" -f2-`
	DHIS_USERNAME=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'dhis_user' | tail -n 1 | cut -d "=" -f2-`
	DHIS_PASS=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'dhis_pass' | tail -n 1 | cut -d "=" -f2-`
	DHISDATAVALUES=$OMRS_DATA_DIR/EmrMonitoringTool/dhis-emt-datasetValueSets.json
	
	if [ "$DHIS_URL" != "" ] && [ "$DHIS_USERNAME" != "" ] && [ "$DHIS_PASS" != "" ]
		then
			curl -d @$DHISDATAVALUES $DHIS_URL -H "Content-Type:application/json" -u $DHIS_USERNAME:$DHIS_PASS
		else
			echo "DHIS Server must first be configured correctly to use this functionality; Login details as well as URL must not be empty"
	fi
}



EMT_DIR=/usr/local/etc/EmrMonitoringTool
EMT_CONFIG_FILES=($(find "$EMT_DIR" -name ".*-emt-config.properties"))

for i in "${EMT_CONFIG_FILES[@]}"
do
	pushDataToDHIS "$i"
done