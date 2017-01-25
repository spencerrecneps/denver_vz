#!/bin/bash

#echo 'Processing denver_streets.sql'
#psql -h 192.168.40.225 -U gis -d denver_vz -f denver_streets.sql
echo 'Processing crashes_veh.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_veh.sql
echo 'Processing crashes_ped.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_ped.sql
echo 'Processing crashes_bike1.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike1.sql
echo 'Processing crashes_bike2.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike2.sql
echo 'Processing crashes_bike_supplement.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike_supplement.sql
echo 'Processing crashes_jeffco.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_jeffco.sql
echo 'Processing crashes_jeffco.sql'
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike_flags.sql
echo 'Processing process_crashes.sql'
psql -h 192.168.40.225 -U gis -d denver_vz -f process_crashes.sql
echo 'Processing crash_aggregates.sql'
psql -h 192.168.40.225 -U gis -d denver_vz -f crash_aggregates.sql
echo 'Processing denver_intersection_characteristics.sql'
psql -h 192.168.40.225 -U gis -d denver_vz -f denver_intersection_characteristics.sql
