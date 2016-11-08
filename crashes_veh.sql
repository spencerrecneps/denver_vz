-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_veh;
CREATE TABLE received.crashes_veh (
    accidentdate TEXT,
    accidenttime TEXT,
    adverseweather TEXT,
    age TEXT,
    appovertaketurn TEXT,
    caseid TEXT,
    circumstance TEXT,
    constructionzone TEXT,
    contribfact_one TEXT,
    contribfact_three TEXT,
    contribfact_two TEXT,
    crashday TEXT,
    crashmonth TEXT,
    dirfromint TEXT,
    diroftravel_one TEXT,
    diroftravel_three TEXT,
    diroftravel_two TEXT,
    disabled_st1 TEXT,
    disabled_st2 TEXT,
    driveraction_one TEXT,
    driveraction_three TEXT,
    driveraction_two TEXT,
    estvehspeed_one TEXT,
    estvehspeed_three TEXT,
    estvehspeed_two TEXT,
    feetfromint TEXT,
    firstharmful TEXT,
    hour TEXT,
    internamedir TEXT,
    lightingcondition TEXT,
    location TEXT,
    mostharmful TEXT,
    movement_one TEXT,
    movement_three TEXT,
    movement_two TEXT,
    multveh TEXT,
    multveh_crashtype TEXT,
    node TEXT,
    numberinjured TEXT,
    numberoffatalities TEXT,
    posted40 TEXT,
    postvehspd_grp TEXT,
    roadcondition TEXT,
    roadcontour TEXT,
    roaddescription TEXT,
    roadsurface TEXT,
    safetyequipsystem_one TEXT,
    safetyequipsystem_three TEXT,
    safetyequipsystem_two TEXT,
    safetyequipuse_one TEXT,
    safetyequipuse_three TEXT,
    safetyequipuse_two TEXT,
    secondharmful TEXT,
    singveh TEXT,
    speedlimit_one TEXT,
    speedlimit_three TEXT,
    speedlimit_two TEXT,
    street1 TEXT,
    street2 TEXT,
    streetname_st1 TEXT,
    streetname_st2 TEXT,
    totvehs TEXT,
    unitage_one TEXT,
    unitage_three TEXT,
    unitage_two TEXT,
    unittype_one TEXT,
    unittype_three TEXT,
    unittype_two TEXT,
    unrestrained TEXT,
    vehcomb_one TEXT,
    vehcomb_three TEXT,
    vehcomb_two TEXT,
    year TEXT,
    careless TEXT,
    reckless TEXT,
    failstopsignal TEXT,
    failyieldROW TEXT,
    highspeed TEXT,
    veryhighspeed TEXT,
    fatalcrash TEXT,
    injurycrash TEXT,
    noinjuryfatality TEXT,
    rearend TEXT,
    rightangle TEXT,
    parkedcar TEXT,
    headon TEXT,
    sideswipe_samedirec TEXT,
    sideswipe_oppdirec TEXT,
    influence TEXT
);
ALTER TABLE received.crashes_veh OWNER TO gis;

-- copy data in
COPY received.crashes_veh FROM '/home/sgardner/DVZ_VehicleCrashes.csv' DELIMITER '|' HEADER QUOTE '"' CSV ENCODING 'WIN1252';

-- add columns
ALTER TABLE received.crashes_veh ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_veh ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_veh ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_veh ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_veh ADD COLUMN int_id INTEGER;

-- update column types
ALTER TABLE received.crashes_veh ALTER COLUMN accidentdate TYPE DATE USING accidentdate::DATE;
ALTER TABLE received.crashes_veh ALTER COLUMN accidenttime TYPE TIME USING accidenttime::TIME;
ALTER TABLE received.crashes_veh ALTER COLUMN circumstance TYPE BOOLEAN USING circumstance::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN crashmonth TYPE INTEGER USING crashmonth::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN estvehspeed_one TYPE INTEGER USING estvehspeed_one::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN estvehspeed_two TYPE INTEGER USING estvehspeed_two::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN feetfromint TYPE INTEGER USING feetfromint::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN hour TYPE TIME USING hour::TIME;
ALTER TABLE received.crashes_veh ALTER COLUMN multveh TYPE BOOLEAN USING multveh::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN node TYPE INTEGER USING node::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN numberinjured TYPE INTEGER USING numberinjured::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN numberoffatalities TYPE INTEGER USING numberoffatalities::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN posted40 TYPE INTEGER USING posted40::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN singveh TYPE BOOLEAN USING singveh::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN speedlimit_one TYPE INTEGER USING speedlimit_one::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN speedlimit_three TYPE INTEGER USING speedlimit_three::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN speedlimit_two TYPE INTEGER USING speedlimit_two::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN street1 TYPE INTEGER USING street1::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN street2 TYPE INTEGER USING street2::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN totvehs TYPE INTEGER USING totvehs::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN unitage_one TYPE INTEGER USING unitage_one::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN unitage_two TYPE INTEGER USING unitage_two::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN unitage_three TYPE INTEGER USING unitage_three::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN unrestrained TYPE BOOLEAN USING unrestrained::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN year TYPE INTEGER USING year::INTEGER;
ALTER TABLE received.crashes_veh ALTER COLUMN careless TYPE BOOLEAN USING careless::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN reckless TYPE BOOLEAN USING reckless::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN failstopsignal TYPE BOOLEAN USING failstopsignal::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN failyieldROW TYPE BOOLEAN USING failyieldROW::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN highspeed TYPE BOOLEAN USING highspeed::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN veryhighspeed TYPE BOOLEAN USING veryhighspeed::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN fatalcrash TYPE BOOLEAN USING fatalcrash::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN injurycrash TYPE BOOLEAN USING injurycrash::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN noinjuryfatality TYPE BOOLEAN USING noinjuryfatality::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN rearend TYPE BOOLEAN USING rearend::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN rightangle TYPE BOOLEAN USING rightangle::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN parkedcar TYPE BOOLEAN USING parkedcar::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN headon TYPE BOOLEAN USING headon::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN sideswipe_samedirec TYPE BOOLEAN USING sideswipe_samedirec::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN sideswipe_oppdirec TYPE BOOLEAN USING sideswipe_oppdirec::BOOLEAN;
ALTER TABLE received.crashes_veh ALTER COLUMN influence TYPE BOOLEAN USING influence::BOOLEAN;
