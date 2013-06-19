#!/bin/bash

#echo "running wunder-alerts.sh"

# assume run from rails root (~/apps/wx-services/current)

./script/runner lib/wunder_alerts.rb
