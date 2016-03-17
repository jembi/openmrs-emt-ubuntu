OpenMRS MoH EMR Rwanda back-end packaging
========================
This projects contains the backend support for the MoH OpenMRS Rwanda EMR server monitoring tool, see also https://github.com/jembi/openmrs-module-emtfrontend 

Installation & Usage
====================
* Ensure that you have a healthy OpenMRS/MoH EMR instance running on your server
* Ensure that mysql is installed and accessible on command line; if you installed MySQL through external packages like XAMPP, run;
```
export MYSQL_BIN=/Applications/XAMPP/bin
export PATH=$PATH:$MYSQL_BIN
```
* Download the latest .deb file from; https://github.com/jembi/openmrs-emt-ubuntu/releases
* Change Directory to downloads directory
* Run
```
1. sudo dpkg -i openmrs-emt_1.0_all.deb
2. sudo openmrs-emt openmrs /var/lib/OpenMRS http://localhost:8080
3. sudo openmrs-emt -pushToDHIS
4. sudo openmrs-emt -generateLocalReport 20140501 20160131 emt.pdf
5. sudo openmrs-emt -copyLocalReportsTo <path/to/directory/to/copy/to>
6. sudo openmrs-emt -status
7. sudo openmrs-emt -reconfigure openmrs /var/lib/OpenMRS http://localhost:8080
```
* To install a new instance to monitor, run 2. replacing openmrs with OpenMRS appname or war file name, /var/lib/OpenMRS (Full Path Name) with OpenMRS data directory and http://localhost:8080 with the URL to tomcat's Root
* To push data to a remote dhisinstance run 3. will be lateron updated not to be hardcoded
* To generate a local PDF reports, run command 4 replacing with start, end dates and name of exported pdf file
* To Backup the previously exported emt reports run command 5
* To get a simple dislay of the EMT tool status, run command 6
* To re-configure or setup an already configured openmrs instance, run commmand 7 which technically removes the previous configuration and creates a new one using the details provided

NOTE: to run these commands for anon sudoer user exlude sudo from commands 2 to 5 after making both /usr/local/bin and /usr/local/share/etc readable and writable by your current logged in user 


Building .deb package
========================
* run command 
```
sudo apt-get install devscripts dh-make;
./buildDeb.sh
```
