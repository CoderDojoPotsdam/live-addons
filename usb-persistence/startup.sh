#!/bin/bash

log="${0%.*}.log"

cd "`dirname \"$0\"`"

./persistence.sh 1>>"$log" 2>>"$log"


