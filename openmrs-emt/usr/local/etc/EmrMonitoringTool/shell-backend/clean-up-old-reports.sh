#!/bin/bash

## cleans up old pdf reports which have not been generated in the current month as well as DHIS backup datavaluessets saved more than 3 months ago which may take server space

EMT_REPORTS=($(find "$HOME" -name "emtReport_*.pdf"))
DATE_TODAY_YEAR="$(date +'%Y')"
DATE_TODAY_MONTH="$(date +'%m')"
	
for EMT_REPORT in "${EMT_REPORTS[@]}"
do
	REPORT_DATE_YEAR="$(date +'%Y' -r $EMT_REPORT)"
	REPORT_DATE_MONTH="$(date +'%m' -r $EMT_REPORT)"
	
	if [ "$DATE_TODAY_YEAR" == "$REPORT_DATE_YEAR" ] && [ "$DATE_TODAY_MONTH" == "$REPORT_DATE_MONTH" ]
		then
			# don't remove this report since it's for the current month
		else
			rm $EMT_REPORT
	fi
done

cleanUpDHISDataValueSet() {
	DHIS_DATA=$1
	
	if [ -f "$DHIS_DATA" ]; then
		DHIS_DATE_YEAR1="$(date +'%Y' -r $DHIS_DATA)"
		DHIS_DATE_MONTH1="$(date +'%m' -r $DHIS_DATA)"
		MONTH_DIFF=`expr "$DATE_TODAY_MONTH" - "$DHIS_DATE_MONTH1"`
		
		if [ "$DATE_TODAY_YEAR" == "$DHIS_DATE_YEAR1" ] && (( "$MONTH_DIFF" > 3 )); then
			rm $DHIS_DATA
		fi
	fi
}

cleanUpDHISReports() {
	EMT_MAIN_CONFIG=$1
	OMRS_DATA_DIR=`sed '/^\#/d' "$EMT_MAIN_CONFIG" | grep 'openmrs_data_directory=' | tail -n 1 | cut -d "=" -f2-`
	DHISDATAVALUES=$OMRS_DATA_DIR/EmrMonitoringTool/dhis-emt-datasetValueSets.json
	DHISDATADIR=$OMRS_DATA_DIR/EmrMonitoringTool/NotUploadedToDHIS
	
	#cleanUpDHISDataValueSet $DHISDATAVALUES
	
	DHISDATADIR_REPORTS=($(find "$DHISDATADIR" -name "dhis-emt-datasetValueSets_*.json"))

	for DHISDATADIR_REPORT in "${DHISDATADIR_REPORTS[@]}"
	do
		cleanUpDHISDataValueSet "$DHISDATADIR_REPORT"
	done
}

EMT_DIR=/usr/local/etc/EmrMonitoringTool
EMT_CONFIG_FILES=($(find "$EMT_DIR" -name ".*-emt-config.properties"))

for i in "${EMT_CONFIG_FILES[@]}"
do
	cleanUpDHISReports "$i"
done