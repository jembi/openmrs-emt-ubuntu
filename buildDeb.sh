#!/bin/bash

if [ ! -d "target" ]
	then
		mkdir target
	else
		rm -r target
		mkdir target
fi

cp -r openmrs-emt/ target
cd target/openmrs-emt
rm README.md
NEWRULES=`sed "5s/.*/\tdh \\$@/" debian/rules`
echo "$NEWRULES" | tee debian/rules
echo ""
echo "Enter launchpad.net OpenPGP key: "; read KEY

if [ "$KEY" == "" ]
	then
		echo "Run gpg --gen-key to first generate a GPA key and gpg --send-keys <GPAKEY> to send it to keyserver, verify if your key is received at http://keys.gnupg.net and try again"
		echo "";echo "No, Idon't want to use a GPA key at all";read NOGPA
		
		if [ "$NOGPA" == "y" ] || [ "$NOGPA" == "Y" ] || [ "$NOGPA" == "yes" ] || [ "$NOGPA" == "YES" ] || [ "$NOGPA" == "Yes" ]; then
			debuild
		fi
	else
		debuild "-k$KEY"
fi
echo ""
echo "Final .deb package to use for installation and PPA files saved under target; run ls target to see them"
