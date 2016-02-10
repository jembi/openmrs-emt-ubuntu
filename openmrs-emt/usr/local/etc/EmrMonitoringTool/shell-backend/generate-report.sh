#!/bin/bash

# Generates a report

if [ "$#" -ne 3 ]; then
    echo "Illegal number of parameters"
    echo "Usage example: generate-report.sh 20140501 20140531 emt.pdf"
    exit 1
fi


generateReportForConfig() {
	EMT_MAIN_CONFIG= $4
   
	if [ ! -f $EMT_MAIN_CONFIG ]; then
		echo "ERROR: $EMT_MAIN_CONFIG must exist to proceed, make sure you successfully run improved-installation.sh first"
		exit 1
	fi

	OMRS_DATA_DIR=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'openmrs_data_directory' | tail -n 1 | cut -d "=" -f2-`
	LOGFILE=$OMRS_DATA_DIR/EmrMonitoringTool/emt.log
	DHISDATAVALUESETS=$OMRS_DATA_DIR/EmrMonitoringTool/dhis-emt-datasetValueSets.json
	STARTDATE=$1
	ENDDATE=$2
	OUTPUTPDF=$3

	BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	java -cp "$BASEDIR/lib/*" org.openmrs.module.emtfrontend.Emt $STARTDATE $ENDDATE $LOGFILE $OUTPUTPDF $DHISDATAVALUESETS
}



EMT_DIR=/usr/local/etc/EmrMonitoringTool
EMT_CONFIG_FILES=($(ls -a $EMT_DIR | egrep '^\..*-emt-config.properties$'))

for i in "${EMT_CONFIG_FILES[@]}"
do
	generateReportForConfig $1 $2 $3 "$EMT_DIR/$i"
done