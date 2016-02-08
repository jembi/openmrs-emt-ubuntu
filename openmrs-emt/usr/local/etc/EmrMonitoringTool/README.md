EMR-Monitoring-Tool Installation
==================================

1. extract this(emtPackage.zip) archive into your favorite directory

2. Execute improved-installation.sh on command line like: bash improved-installation.sh openmrs167 ~/.OpenMRS http://localhost:8080
	a. openmrs167 is the OpenMRS Application name (name of openmrs war file), it is normally openmrs
	b. ~/.OpenMRS should be replaced with your OpenMRS Data Directory where the modules and runtime properties file are found
	c. http://localhost:8080 should be replaced with the url to your Root tomcat
	d. Make sure the your last message reads; "You have successfully installed EMT"
	
3. You can always execute the scripts installed under your $HOME/EmrMonitoringTool
	a. To generate a report on command line, run generate-example-report.sh or see an example on how to in it
	b. startup-hook.sh, heartbeat.sh and openmrs-heartbeat.sh can be run any time to log more data to show up in the next reports
	
4. The included .omod file is the backend openmrs module which provides a user interface to interact with the tool, you can always use the module 
	without setting up the back end by Copying emt.log from & into your ~/.OpenMRS/EmrMonitoringTool($OpenMRS_DATA_DIR/EmrMonitoringTool) and then using the front end module
	
5. You can always change the settings provided by editing your $HOME/EmrMonitoringTool/.emt-config.properties by replacing the values for each line and not the name


This same process applies for installing a local instance from source code at: https://github.com/kaweesi/openmrs-module-emtfrontend but step 1 is replaced by;
 a. Compile the module, then run from step 2



