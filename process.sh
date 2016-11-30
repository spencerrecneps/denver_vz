#!/bin/bash

#psql -h 192.168.40.225 -U gis -d denver_vz -f denver_streets.sql
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_veh.sql
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_ped.sql
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike1.sql
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_bike2.sql
psql -h 192.168.40.225 -U postgres -d denver_vz -f crashes_jeffco.sql
psql -h 192.168.40.225 -U gis -d denver_vz -f process_crashes.sql
psql -h 192.168.40.225 -U gis -d denver_vz -f crash_aggregates.sql
