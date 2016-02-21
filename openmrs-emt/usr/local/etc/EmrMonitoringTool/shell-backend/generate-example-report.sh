#!/bin/bash

# Convenience script to generate a test report

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TODAY="$(date +'%Y%m%d')"

$BASEDIR/generate-report.sh 20140501 "${TODAY}" emtReport_"${TODAY}".pdf
