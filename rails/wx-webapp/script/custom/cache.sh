#!/usr/bin/env bash

#echo "running cwop.sh"

# assume run from rails root (~/apps/wx-services/current)
cd ~/apps/weather/current

./script/runner lib/cache.rb
