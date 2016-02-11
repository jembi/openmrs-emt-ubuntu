OpenMRS MoH EMR Rwanda back-end packaging
========================
This projects contains the backend support for the MoH OpenMRS Rwanda EMR server monitoring tool, see also https://github.com/jembi/openmrs-module-emtfrontend 

Installation
==============
* Download .deb from; packages/1.0
* Change to downloads directory
* Run
```
1. sudo dpkg -i openmrs-emt_1.0_all.deb
2. sudo openmrs-emt openmrs /var/lib/OpenMRS http://localhost:8080
3. sudo openmrs-emt -pushToDHIS
```
To install a new instance to monitor, run 2. replacing openmrs with OpenMRS appname or war file name, /var/lib/OpenMRS (Full Path Name) with OpenMRS data directory and http://localhost:8080 with the URL to tomcat's Root
To push data to a remote dhisinstance run 3. will be lateron updated not to be hardcoded
