#!/bin/sh
mysql --user wxprod -p -h diskstation1 weather_production < db/rotate_old_archive_records.sql
