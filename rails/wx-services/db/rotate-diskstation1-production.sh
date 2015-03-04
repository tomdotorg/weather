#!/bin/sh
mysql --user wxprod -p -h diskstation weather_production < db/rotate_old_archive_records.sql
