#!/bin/bash

if [ $# -lt 1 ]; then
        echo 'Usage:chg file path '
        exit
fi

#/WebContent/tiles/js/alarms.js
FILEPATH=$1
FILENAME=$2
echo "$FILEPATH$FILENAME"



