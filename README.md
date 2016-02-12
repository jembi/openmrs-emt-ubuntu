OpenMRS MoH EMR Rwanda back-end packaging
========================
This projects contains the backend support for the MoH OpenMRS Rwanda EMR server monitoring tool, see also https://github.com/jembi/openmrs-module-emtfrontend 

Installation
==============
* Ensure that you have a healthy OpenMRS/MoH EMR instance running on your server
* Ensure that mysql is installed and accessible on command line; if you installed MySQL through external packages like XAMPP, run;
```
export MYSQL_BIN=/Applications/XAMPP/bin
export PATH=$PATH:$MYSQL_BIN
```
* Download .deb from; packages/1.0
* Change to downloads directory
* Run
```
1. sudo dpkg -i openmrs-emt_1.0_all.deb
2. sudo openmrs-emt openmrs /var/lib/OpenMRS http://localhost:8080
3. sudo openmrs-emt -pushToDHIS
4. sudo openmrs-emt -generateLocalReport 20140501 20160131 emt.pdf
5. sudo openmrs-emt -copyLocalReportsTo <path/to/directory/to/copy/to>
```
* To install a new instance to monitor, run 2. replacing openmrs with OpenMRS appname or war file name, /var/lib/OpenMRS (Full Path Name) with OpenMRS data directory and http://localhost:8080 with the URL to tomcat's Root
* To push data to a remote dhisinstance run 3. will be lateron updated not to be hardcoded
* To generate a local PDF reports, run command 4 replacing with start, end dates and name of exported pdf file
* To Backup the previously exported emt reports run command 5

NOTE: to run these commands for anon sudoer user exlude sudo from commands 2 to 5 after making both /usr/local/bin and /usr/local/share/etc readable and writable by your current logged in user
