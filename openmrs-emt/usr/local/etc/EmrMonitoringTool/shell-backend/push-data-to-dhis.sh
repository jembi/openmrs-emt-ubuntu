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
	DHIS_NON_UPLOADED=$OMRS_DATA_DIR/EmrMonitoringTool/NotUploadedToDHIS
	
	if [ "$DHIS_URL" != "" ] && [ "$DHIS_USERNAME" != "" ] && [ "$DHIS_PASS" != "" ]
		then
			wget -q --tries=10 --timeout=20 --spider http://google.com
			if [[ "$?" -eq 0 ]]
				then
        			curl -k -d @$DHISDATAVALUES $DHIS_URL -H "Content-Type:application/json" -u $DHIS_USERNAME:$DHIS_PASS
        			
        			if [ -d "$DHIS_NON_UPLOADED" ]; then
        				DHIS_NON_UPLOADED_FILES=($(find "$DHIS_NON_UPLOADED" -name "dhis-emt-datasetValueSets_*.json"))
        				
        				for DHIS_NON_UPLOADED_FILE in "${DHIS_NON_UPLOADED_FILES[@]}"
						do
							curl -k -d @$DHIS_NON_UPLOADED_FILE $DHIS_URL -H "Content-Type:application/json" -u $DHIS_USERNAME:$DHIS_PASS
						done
						rm -r $DHIS_NON_UPLOADED
        			fi
				else
        			if [ ! -d "$DHIS_NON_UPLOADED" ]; then
        				mkdir $DHIS_NON_UPLOADED
        			fi
        			MISSED_DHIS="$DHIS_NON_UPLOADED/dhis-emt-datasetValueSets_$(date +'%Y%m%d-%s').json"
        			
        			cp $DHISDATAVALUES $DHIS_NON_UPLOADED
        			mv $DHIS_NON_UPLOADED/dhis-emt-datasetValueSets.json $MISSED_DHIS
			fi
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
