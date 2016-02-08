OpenMRS MoH EMR Rwanda packaging
========================

Ubuntu packaging scripts. Currently supports:
* 14.04 Trusty

Packaging Process
=================
Building a .deb file 
```
dpkg -b openmrs-emt/ openmrs-emt.deb
```
This works when openmrs-emt/debain is renamed to DEBIAN

Building source files/PPA
=================
```
cd openmrs-emt;
debuild
```

