#!/bin/bash

if [ "$#" -ne 2 ]; then
echo "Illegal number of parameters"
echo ""
echo "Usage example: configure.sh $HOME/EmrMonitoringTool /val/lib/OpenMRS"
echo ""
exit 1
fi

#$1 contains emt backend directory and $2 openmrs data directory
EMT_INSTALL_DIR=$1
OPENMRS_INSTALL_DIR=$2
LOG=$OPENMRS_INSTALL_DIR/EmrMonitoringTool/emt.log
PATIENT_LOG=$OPENMRS_INSTALL_DIR/EmrMonitoringTool/emt-patient.log
CONFIG=$OPENMRS_INSTALL_DIR/EmrMonitoringTool/emt.properties
DHIS=$OPENMRS_INSTALL_DIR/EmrMonitoringTool/dhis-emt-datasetValueSets.json
SYSTEM_ID=`hostname`-`ifconfig eth0 | grep HWaddr | awk '{ print $NF}' | sed 's/://g'`
NOW=`date +%Y%m%d-%H%M%S`

# remove old cronjobs
crontab -l | grep -v heartbeat.sh | crontab -
crontab -l | grep -v openmrs-heartbeat.sh | crontab -
crontab -l | grep -v startup-hook.sh | crontab -
crontab -l | grep -v generate-example-report.sh | crontab -
crontab -l | grep -v push-data-to-dhis.sh | crontab -
crontab -l | grep -v clean-up-old-reports.sh | crontab -

## adding new fresh clone jobs
# runs every hour at h+1 h+16, h+31 and h+46 minutes
(crontab -l ; echo "1,16,31,46 * * * * $EMT_INSTALL_DIR/shell-backend/heartbeat.sh") | crontab -
# runs every hour at h+2 h+17, h+32 and h+47 minutes
(crontab -l ; echo "2,17,32,47 * * * * $EMT_INSTALL_DIR/shell-backend/openmrs-heartbeat.sh") | crontab -
# runs on every reboot
(crontab -l ; echo "@reboot $EMT_INSTALL_DIR/shell-backend/startup-hook.sh") | crontab -
# run daily at reboot, 11:15, 16:15, 23:15
(crontab -l ; echo "@reboot $EMT_INSTALL_DIR/shell-backend/generate-example-report.sh") | crontab -
(crontab -l ; echo "15 11 * * * $EMT_INSTALL_DIR/shell-backend/generate-example-report.sh") | crontab -
(crontab -l ; echo "15 16 * * * $EMT_INSTALL_DIR/shell-backend/generate-example-report.sh") | crontab -
(crontab -l ; echo "15 23 * * * $EMT_INSTALL_DIR/shell-backend/generate-example-report.sh") | crontab -
# runs daily at 11:20, 14:20, 23:20 since DHIS will run uploaded data to show up at midnight
(crontab -l ; echo "20 11 * * * $EMT_INSTALL_DIR/shell-backend/push-data-to-dhis.sh") | crontab -
(crontab -l ; echo "20 14 * * * $EMT_INSTALL_DIR/shell-backend/push-data-to-dhis.sh") | crontab -
(crontab -l ; echo "20 23 * * * $EMT_INSTALL_DIR/shell-backend/push-data-to-dhis.sh") | crontab -
#runs on the first day of every month at 11:25, 16:25, 23:25
(crontab -l ; echo "25 11 1 * * $EMT_INSTALL_DIR/shell-backend/clean-up-old-reports.sh") | crontab -
(crontab -l ; echo "25 14 1 * * $EMT_INSTALL_DIR/shell-backend/clean-up-old-reports.sh") | crontab -
(crontab -l ; echo "25 23 1 * * $EMT_INSTALL_DIR/shell-backend/clean-up-old-reports.sh") | crontab -

# create log file if necessary
if [ ! -f "$LOG" ]; then
	touch $LOG
	chmod 666 $LOG
fi
if [ ! -f "$PATIENT_LOG" ]; then
	touch $PATIENT_LOG
	chmod 666 $PATIENT_LOG
fi

echo "$NOW;$SYSTEM_ID;EMT-INSTALL;0.5" >> $LOG

#creating and setting read&write for $DHIS
if [ ! -f "$DHIS" ]; then
	touch $DHIS
	chmod 666 $DHIS
fi

# create properties file if necessary
if [ ! -f "$CONFIG" ]; then
  echo ""
  echo "Creating default config file for clinic times"
  echo "clinicStart=800" >> $CONFIG
  echo "clinicEnd=1700" >> $CONFIG
  echo "clinicDays=Mo,Tu,We,Th,Fr" >> $CONFIG
  chmod 666 $CONFIG
fi

# Check system time
echo ""
echo "ATTENTION: Please check the date and time of this system!"
echo "           Current date and time are: `date`"
echo ""
echo "           If this does NOT match the current real time, please report this!"
echo "           (Any difference of more than 5 minutes)"

# Check write permission for tomcat6 in modules directory
# TODO remove this check if proved un-necessary
MODULES_OWNER=`stat -c '%U' $OPENMRS_INSTALL_DIR/modules | tail`
if [ "$MODULES_OWNER" != "tomcat6" ]; then
  echo ""
  echo "WARNING: OpenMRS modules most likely can NOT be uploaded with OpenMRS!" 
fi

## Running the scripts right now to make some data logging
$EMT_INSTALL_DIR/shell-backend/heartbeat.sh
$EMT_INSTALL_DIR/shell-backend/openmrs-heartbeat.sh
sleep 60
$EMT_INSTALL_DIR/shell-backend/generate-example-report.sh
