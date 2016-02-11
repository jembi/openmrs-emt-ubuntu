Installable packages
========================

Release Notes
=================
* 1.0~trusty fails, you may not have to try it out at all
* 1.0 will yet be available and working

Installation
=================
* Download the .deb from within any of the folders such as 1.0
* Run it locally using
```
sudo dpkg -i downloaded-openmrs-emt.deb
```
* Or else, we are resolving a few issues to have it installable by running
```
sudo add-apt-repository "deb http://ppa.launchpad.net/k-joseph-d/openmrs-emt/ubuntu trusty main"
sudo apt-get update
sudo apt-get install openmrs-emt
```
