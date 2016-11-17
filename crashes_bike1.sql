-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_bike1;
CREATE TABLE received.crashes_bike1 (
    caseid TEXT,
    year TEXT,
    unittype_one TEXT,
    unittype_two TEXT,
    unittype_three TEXT,
    circumstance TEXT,
    primary_contrib TEXT,
    condition_1 TEXT,
    condition_2 TEXT,
    condition_3 TEXT,
    dirfromint TEXT,
    diroftravel_one TEXT,
    diroftravel_two TEXT,
    tdg_directions TEXT,
    dir_key TEXT,
    directions TEXT,
    bike_mvmt TEXT,
    veh_mvmt TEXT,
    comb_mvmt TEXT,
    comb_mvmt_sw TEXT,
    map_code TEXT,
    injury TEXT,
    diroftravel_three TEXT,
    disabled_st1 TEXT,
    disabled_st2 TEXT,
    contrib_1 TEXT,
    contrib_2 TEXT,
    contrib_3 TEXT,
    enteredby TEXT,
    entereddate TEXT,
    estvehspeed_one TEXT,
    estvehspeed_two TEXT,
    estvehspeed_three TEXT,
    feetfromint TEXT,
    firstharmful TEXT,
    mostharmful TEXT,
    secondharmful TEXT,
    internamedir TEXT,
    lightingcondition TEXT,
    location TEXT,
    masterid TEXT,
    precrashmaneuv_1 TEXT,
    precrashmaneuv_2 TEXT,
    precrashmaneuv_3 TEXT,
    node TEXT,
    numberinjured TEXT,
    numberoffatalities TEXT,
    pedaction_one TEXT,
    pedaction_two TEXT,
    pedaction_three TEXT,
    publicproperty TEXT,
    railroadcrossing TEXT,
    roadcondition TEXT,
    roadcontour TEXT,
    roaddescription TEXT,
    roadsurface TEXT,
    safetyequipmenthelmet_one TEXT,
    safetyequipmenthelmet_two TEXT,
    safetyequipmenthelmet_three TEXT,
    safetyequipsystem_one TEXT,
    safetyequipsystem_two TEXT,
    safetyequipsystem_three TEXT,
    safetyequipuse_one TEXT,
    safetyequipuse_two TEXT,
    safetyequipuse_three TEXT,
    speedlimit_one TEXT,
    speedlimit_two TEXT,
    speedlimit_three TEXT,
    street1 TEXT,
    street2 TEXT,
    streetname_st1 TEXT,
    streetname_st2 TEXT,
    street_intersection TEXT,
    totvehs TEXT,
    unitage_one TEXT,
    unitage_two TEXT,
    unitage_three TEXT,
    vehcomb_one TEXT,
    vehcomb_two TEXT,
    vehcomb_three TEXT,
    vehicledefect_one TEXT,
    vehicledefect_two TEXT,
    vehicledefect_three TEXT,
    technicaljudgement TEXT,
    notes TEXT,
    typology TEXT,
    same_dir TEXT,
    opp_dir TEXT,
    perpen TEXT,
    angle TEXT,
    notes2 TEXT,
    sw TEXT,
    ww_sw TEXT,
    cw_dwy_alley TEXT,
    day_week TEXT,
    weekday TEXT,
    trail_access TEXT,
    bike_s_veh_s_st_p TEXT,
    bike_s_veh_lt_St_od TEXT,
    bike_s_veh_rt_St_p TEXT,
    bike_s_veh_rt_St_sd TEXT,
    bike_s_veh_s_st_sd TEXT,
    bike_s_veh_rt_St_WW_p TEXT,
    bike_s_veh_s_sW_WW_p TEXT,
    bike_s_veh_rt_SW_WW_p TEXT,
    highspeed TEXT,
    injurycrash TEXT
);
ALTER TABLE received.crashes_bike1 OWNER TO gis;

-- copy data in
COPY received.crashes_bike1 FROM '/home/sgardner/2011-2012_Crash Data Typed.csv' DELIMITER '|' HEADER QUOTE '"' CSV;

-- add columns
ALTER TABLE received.crashes_bike1 ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_bike1 ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_bike1 ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_bike1 ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_bike1 ADD COLUMN at_intersection BOOLEAN;
ALTER TABLE received.crashes_bike1 ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_bike1 ADD COLUMN geom_int geometry(point,2231);
ALTER TABLE received.crashes_bike1 ADD COLUMN geom_midpoint geometry(point,2231);
ALTER TABLE received.crashes_bike1 ADD COLUMN geom_exact geometry(point,2231);

-- update column types
ALTER TABLE received.crashes_bike1 ALTER COLUMN year TYPE INTEGER USING year::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN dir_key TYPE INTEGER USING dir_key::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN map_code TYPE INTEGER USING map_code::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN injury TYPE BOOLEAN USING injury::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN estvehspeed_one TYPE INTEGER USING estvehspeed_one::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN estvehspeed_two TYPE INTEGER USING estvehspeed_two::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN estvehspeed_three TYPE INTEGER USING estvehspeed_three::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN feetfromint TYPE INTEGER USING feetfromint::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN masterid TYPE INTEGER USING masterid::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN node TYPE INTEGER USING node::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN numberinjured TYPE INTEGER USING numberinjured::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN numberoffatalities TYPE INTEGER USING numberoffatalities::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN speedlimit_one TYPE INTEGER USING speedlimit_one::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN speedlimit_two TYPE INTEGER USING speedlimit_two::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN speedlimit_three TYPE INTEGER USING speedlimit_three::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN street1 TYPE INTEGER USING street1::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN street2 TYPE INTEGER USING street2::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN totvehs TYPE INTEGER USING totvehs::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN unitage_one TYPE INTEGER USING unitage_one::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN unitage_two TYPE INTEGER USING unitage_two::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN unitage_three TYPE INTEGER USING unitage_three::INTEGER;
ALTER TABLE received.crashes_bike1 ALTER COLUMN same_dir TYPE BOOLEAN USING same_dir::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN opp_dir TYPE BOOLEAN USING opp_dir::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN perpen TYPE BOOLEAN USING perpen::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN angle TYPE BOOLEAN USING angle::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_s_st_p TYPE BOOLEAN USING bike_s_veh_s_st_p::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_lt_St_od TYPE BOOLEAN USING bike_s_veh_lt_St_od::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_rt_St_p TYPE BOOLEAN USING bike_s_veh_rt_St_p::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_rt_St_sd TYPE BOOLEAN USING bike_s_veh_rt_St_sd::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_s_st_sd TYPE BOOLEAN USING bike_s_veh_s_st_sd::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_rt_St_WW_p TYPE BOOLEAN USING bike_s_veh_rt_St_WW_p::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_s_sW_WW_p TYPE BOOLEAN USING bike_s_veh_s_sW_WW_p::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN bike_s_veh_rt_SW_WW_p TYPE BOOLEAN USING bike_s_veh_rt_SW_WW_p::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN highspeed TYPE BOOLEAN USING highspeed::BOOLEAN;
ALTER TABLE received.crashes_bike1 ALTER COLUMN injurycrash TYPE BOOLEAN USING injurycrash::BOOLEAN;
