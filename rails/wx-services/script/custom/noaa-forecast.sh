#!/bin/bash

#echo "running noaa-forecast.sh"

export PATH=$PATH:/usr/local/bin

# assume run from rails root (~/apps/wx-services/current)

./script/runner lib/noaa_forecast.rb
