DROP TABLE IF EXISTS received.crashes_bike2;
CREATE TABLE received.crashes_bike2 (
    accidentdate TEXT,
    accidenttime TEXT,
    adverseweather TEXT,
    appovertaketurn TEXT,
    caseid TEXT,
    constructionzone TEXT,
    contribfact_one TEXT,
    contribfact_two TEXT,
    contribfact_three TEXT,
    dirfromint TEXT,
    diroftravel_one TEXT,
    diroftravel_two TEXT,
    diroftravel_three TEXT,
    disabled_st1 TEXT,
    disabled_st2 TEXT,
    driveraction_one TEXT,
    driveraction_two TEXT,
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
    node TEXT,
    numberinjured TEXT,
    numberoffatalities TEXT,
    roadcontour TEXT,
    roaddescription TEXT,
    roadsurface TEXT,
    rownum TEXT,
    speedlimit_one TEXT,
    speedlimit_two TEXT,
    speedlimit_three TEXT,
    street1 TEXT,
    street2 TEXT,
    streetname_st1 TEXT,
    streetname_st2 TEXT,
    totvehs TEXT,
    unitage_one TEXT,
    unitage_two TEXT,
    unitage_three TEXT,
    vehcomb_one TEXT,
    vehcomb_two TEXT,
    vehcomb_three TEXT,
    unittype_one TEXT,
    unittype_two TEXT,
    unittype_three TEXT,
    movement_one TEXT,
    movement_two TEXT,
    movement_three TEXT,
    circumstance TEXT,
    sw TEXT,
    othercw TEXT,
    motoristplacement TEXT,
    relationshipofplacements TEXT,
    wwswriding TEXT,
    bicyclelane TEXT,
    dooring TEXT,
    bicyclewwstreetriding TEXT,
    crashmonth TEXT,
    crashday TEXT,
    hour TEXT,
    ridinglocation TEXT,
    crashyear TEXT,
    injurycrash TEXT,
    fatalcrash TEXT,
    noinjuryfatality TEXT,
    unit1_veh TEXT,
    unit2_veh TEXT,
    unit1_bike TEXT,
    unit2_bike TEXT,
    intdistance_ft TEXT,
    hrgrp TEXT,
    bicyclist TEXT,
    bikeaction_one TEXT,
    bikeaction_two TEXT,
    newdriveraction_one TEXT,
    newdriveraction_two TEXT,
    bikeaction_one2 TEXT,
    bikeaction_two2 TEXT,
    newbikeaction TEXT,
    newdriveraction_one2 TEXT,
    newdriveraction_two2 TEXT,
    newdriveraction2 TEXT,
    bike_movement TEXT,
    driver_movement TEXT,
    unit1 TEXT,
    unit2 TEXT,
    unit3 TEXT,
    complex TEXT,
    nobike TEXT,
    bike_movement2 TEXT,
    bike_fault TEXT,
    driver_movement2 TEXT,
    crashtype TEXT,
    relationship TEXT,
    ww TEXT,
    xwalk TEXT,
    bikelane TEXT,
    sidewalk TEXT,
    location2 TEXT,
    direction TEXT,
    newcrashtype TEXT,
    bike_s_veh_s_st_p TEXT,
    bike_s_veh_lt_st_od TEXT,
    bike_s_veh_rt_st_p TEXT,
    bike_s_veh_rt_st_sd TEXT,
    bike_s_veh_s_st_sd TEXT,
    bike_s_veh_rt_st_ww_p TEXT,
    highspeed TEXT,
    atfault TEXT,
    influence TEXT,
    distracted_driverfault TEXT,
    aggressive_driverfault TEXT,
    inexperience_bikerfault TEXT,
    aggressive_bikerfault TEXT,
    failyield_driverfault TEXT,
    carereckless_driverfault TEXT,
    disregardsignal_driverfault TEXT,
    failyield_bikerfault TEXT,
    disregardsignal_bikerfault TEXT,
    allothercrashtype TEXT,
    bike_s_veh_rt_sw_ww_p TEXT,
    bike_s_veh_s_sw_ww_p TEXT
);
ALTER TABLE received.crashes_bike2 OWNER TO gis;

-- copy data in
COPY received.crashes_bike2 FROM '/home/sgardner/2013-2015 DVZ Bike crash types.csv' DELIMITER '|' HEADER QUOTE '"' CSV;

-- add columns
ALTER TABLE received.crashes_bike2 ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_bike2 ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_bike2 ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_bike2 ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_bike2 ADD COLUMN at_intersection BOOLEAN;
ALTER TABLE received.crashes_bike2 ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_bike2 ADD COLUMN geom_int geometry(point,2231);
ALTER TABLE received.crashes_bike2 ADD COLUMN geom_midpoint geometry(point,2231);
ALTER TABLE received.crashes_bike2 ADD COLUMN geom_exact geometry(point,2231);

-- update column types
ALTER TABLE received.crashes_bike2 ALTER COLUMN accidentdate TYPE DATE USING accidentdate::DATE;
ALTER TABLE received.crashes_bike2 ALTER COLUMN accidenttime TYPE TIME USING accidenttime::TIME;
ALTER TABLE received.crashes_bike2 ALTER COLUMN estvehspeed_one TYPE INTEGER USING estvehspeed_one::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN estvehspeed_two TYPE INTEGER USING estvehspeed_two::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN estvehspeed_three TYPE INTEGER USING estvehspeed_three::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN feetfromint TYPE INTEGER USING feetfromint::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN masterid TYPE INTEGER USING masterid::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN node TYPE INTEGER USING node::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN numberinjured TYPE INTEGER USING numberinjured::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN numberoffatalities TYPE INTEGER USING numberoffatalities::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN rownum TYPE INTEGER USING rownum::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN speedlimit_one TYPE INTEGER USING speedlimit_one::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN speedlimit_two TYPE INTEGER USING speedlimit_two::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN speedlimit_three TYPE INTEGER USING speedlimit_three::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN street1 TYPE INTEGER USING street1::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN street2 TYPE INTEGER USING street2::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN totvehs TYPE INTEGER USING totvehs::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unitage_one TYPE INTEGER USING unitage_one::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unitage_two TYPE INTEGER USING unitage_two::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unitage_three TYPE INTEGER USING unitage_three::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN crashmonth TYPE INTEGER USING crashmonth::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN hour TYPE TIME USING hour::TIME;
ALTER TABLE received.crashes_bike2 ALTER COLUMN crashyear TYPE INTEGER USING crashyear::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN injurycrash TYPE BOOLEAN USING injurycrash::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN fatalcrash TYPE BOOLEAN USING fatalcrash::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN noinjuryfatality TYPE BOOLEAN USING noinjuryfatality::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unit1_veh TYPE BOOLEAN USING unit1_veh::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unit2_veh TYPE BOOLEAN USING unit2_veh::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unit1_bike TYPE BOOLEAN USING unit1_bike::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN unit2_bike TYPE BOOLEAN USING unit2_bike::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bicyclist TYPE BOOLEAN USING bicyclist::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bikeaction_two2 TYPE INTEGER USING bikeaction_two2::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN newdriveraction_two2 TYPE INTEGER USING newdriveraction_two2::INTEGER;
ALTER TABLE received.crashes_bike2 ALTER COLUMN complex TYPE BOOLEAN USING complex::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN nobike TYPE BOOLEAN USING nobike::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_fault TYPE BOOLEAN USING bike_fault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN ww TYPE BOOLEAN USING ww::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN xwalk TYPE BOOLEAN USING xwalk::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN sidewalk TYPE BOOLEAN USING sidewalk::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_s_st_p TYPE BOOLEAN USING bike_s_veh_s_st_p::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_lt_st_od TYPE BOOLEAN USING bike_s_veh_lt_st_od::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_rt_st_p TYPE BOOLEAN USING bike_s_veh_rt_st_p::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_rt_st_sd TYPE BOOLEAN USING bike_s_veh_rt_st_sd::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_s_st_sd TYPE BOOLEAN USING bike_s_veh_s_st_sd::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_rt_st_ww_p TYPE BOOLEAN USING bike_s_veh_rt_st_ww_p::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN highspeed TYPE BOOLEAN USING highspeed::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN influence TYPE BOOLEAN USING influence::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN distracted_driverfault TYPE BOOLEAN USING distracted_driverfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN aggressive_driverfault TYPE BOOLEAN USING aggressive_driverfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN inexperience_bikerfault TYPE BOOLEAN USING inexperience_bikerfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN aggressive_bikerfault TYPE BOOLEAN USING aggressive_bikerfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN failyield_driverfault TYPE BOOLEAN USING failyield_driverfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN carereckless_driverfault TYPE BOOLEAN USING carereckless_driverfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN disregardsignal_driverfault TYPE BOOLEAN USING disregardsignal_driverfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN failyield_bikerfault TYPE BOOLEAN USING failyield_bikerfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN disregardsignal_bikerfault TYPE BOOLEAN USING disregardsignal_bikerfault::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN allothercrashtype TYPE BOOLEAN USING allothercrashtype::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_rt_sw_ww_p TYPE BOOLEAN USING bike_s_veh_rt_sw_ww_p::BOOLEAN;
ALTER TABLE received.crashes_bike2 ALTER COLUMN bike_s_veh_s_sw_ww_p TYPE BOOLEAN USING bike_s_veh_s_sw_ww_p::BOOLEAN;
