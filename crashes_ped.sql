-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_ped;
CREATE TABLE received.crashes_ped (
    accidentdate TEXT,
    accidenttime TEXT,
    adverseweather TEXT,
    appovertaketurn TEXT,
    backing TEXT,
    busstoprelated TEXT,
    caseid TEXT,
    circumstance TEXT,
    constructionzone TEXT,
    contribfact_one TEXT,
    contribfact_two TEXT,
    crashday TEXT,
    crashmonth TEXT,
    crashtype TEXT,
    crashyear TEXT,
    darklit_fatal TEXT,
    dirfromint TEXT,
    diroftravel_one TEXT,
    diroftravel_three TEXT,
    diroftravel_two TEXT,
    disabled_st1 TEXT,
    disabled_st2 TEXT,
    driveraction_one TEXT,
    driveraction_three TEXT,
    driveraction_two TEXT,
    estvehspeed1_grp TEXT,
    estvehspeed_one TEXT,
    estvehspeed_two TEXT,
    feetfromint TEXT,
    firstharmful TEXT,
    hour TEXT,
    internamedir TEXT,
    intersection TEXT,
    lightingcondition TEXT,
    location TEXT,
    midlev_ct TEXT,
    mostharmful TEXT,
    movement_one TEXT,
    movement_three TEXT,
    movement_two TEXT,
    node TEXT,
    nonintrsct_fatal TEXT,
    numberinjured TEXT,
    numberoffatalities TEXT,
    ped_action TEXT,
    ped_corridor TEXT,
    ped_cw TEXT,
    ped_location TEXT,
    pedaction_one TEXT,
    pedaction_three TEXT,
    pedaction_two TEXT,
    pedage TEXT,
    pedage1 TEXT,
    pedage2 TEXT,
    pedage3 TEXT,
    pedage_grp TEXT,
    pedinstreet TEXT,
    roadcondition TEXT,
    roadcontour TEXT,
    roaddescription TEXT,
    roaddescription2 TEXT,
    roadsurface TEXT,
    safetyequipsystem_one TEXT,
    safetyequipsystem_three TEXT,
    safetyequipsystem_two TEXT,
    safetyequipuse_one TEXT,
    safetyequipuse_three TEXT,
    safetyequipuse_two TEXT,
    secondharmful TEXT,
    speedlimit1 TEXT,
    speedlimit2 TEXT,
    speedlimit3 TEXT,
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
    veh_movement TEXT,
    vehcomb_one TEXT,
    vehcomb_three TEXT,
    vehcomb_two TEXT,
    midblockcrossing TEXT,
    crossagainstsignal TEXT,
    walkinroad TEXT,
    intersectioncrossing TEXT,
    influence_driver TEXT,
    carelessreckless TEXT,
    failyieldrow TEXT,
    disregardsigns TEXT,
    ped_cw_motoristlt TEXT,
    ped_midblock TEXT,
    ped_cw_motoriststraight TEXT,
    ped_nocw_motoriststraight TEXT,
    ped_motoristRT TEXT,
    ped_nocw_motoristLT TEXT,
    midblock_injuryfatal TEXT,
    distracted_driverfault TEXT,
    distracted_pedfault TEXT,
    straightgrade TEXT,
    ped_highlev_ct TEXT,
    ped_midlevel_ct TEXT,
    highspeed TEXT,
    atfault TEXT,
    fatalcrash TEXT,
    injurycrash TEXT,
    noinjuryfatality TEXT
);
ALTER TABLE received.crashes_ped OWNER TO gis;

-- copy data in
COPY received.crashes_ped FROM '/home/sgardner/GISPed.csv' DELIMITER '|' HEADER QUOTE '"' CSV;

-- add columns
ALTER TABLE received.crashes_ped ADD COLUMN id SERIAL PRIMARY KEY;

-- update column types
ALTER TABLE received.crashes_ped ALTER COLUMN accidentdate TYPE DATE USING accidentdate::DATE;
ALTER TABLE received.crashes_ped ALTER COLUMN accidenttime TYPE TIME USING accidenttime::TIME;
ALTER TABLE received.crashes_ped ALTER COLUMN backing TYPE BOOLEAN USING backing::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN crashmonth TYPE INTEGER USING crashmonth::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN crashyear TYPE INTEGER USING crashyear::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN darklit_fatal TYPE BOOLEAN USING darklit_fatal::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN estvehspeed_one TYPE INTEGER USING estvehspeed_one::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN estvehspeed_two TYPE INTEGER USING estvehspeed_two::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN feetfromint TYPE INTEGER USING feetfromint::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN hour TYPE TIME USING hour::TIME;
ALTER TABLE received.crashes_ped ALTER COLUMN intersection TYPE BOOLEAN USING intersection::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN midlev_ct TYPE INTEGER USING midlev_ct::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN node TYPE INTEGER USING node::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN nonintrsct_fatal TYPE BOOLEAN USING nonintrsct_fatal::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN numberinjured TYPE INTEGER USING numberinjured::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN numberoffatalities TYPE INTEGER USING numberoffatalities::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_cw TYPE BOOLEAN USING ped_cw::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN pedage TYPE INTEGER USING pedage::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN pedage1 TYPE INTEGER USING pedage1::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN pedage2 TYPE INTEGER USING pedage2::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN pedage3 TYPE INTEGER USING pedage3::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN pedinstreet TYPE BOOLEAN USING pedinstreet::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN speedlimit1 TYPE INTEGER USING (CASE WHEN speedlimit1='.' THEN NULL ELSE speedlimit1 END)::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN speedlimit2 TYPE INTEGER USING (CASE WHEN speedlimit2='.' THEN NULL ELSE speedlimit2 END)::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN speedlimit3 TYPE INTEGER USING speedlimit3::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN speedlimit_three TYPE INTEGER USING (CASE WHEN speedlimit_three='.' THEN NULL ELSE speedlimit_three END)::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN speedlimit_two TYPE INTEGER USING speedlimit_two::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN street1 TYPE INTEGER USING street1::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN street2 TYPE INTEGER USING street2::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN totvehs TYPE INTEGER USING totvehs::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN unitage_one TYPE INTEGER USING (CASE WHEN unitage_one='.' THEN NULL ELSE unitage_one END)::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN unitage_two TYPE INTEGER USING unitage_two::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN unitage_three TYPE INTEGER USING unitage_three::INTEGER;
ALTER TABLE received.crashes_ped ALTER COLUMN midblockcrossing TYPE BOOLEAN USING midblockcrossing::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN crossagainstsignal TYPE BOOLEAN USING crossagainstsignal::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN walkinroad TYPE BOOLEAN USING walkinroad::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN intersectioncrossing TYPE BOOLEAN USING intersectioncrossing::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN influence_driver TYPE BOOLEAN USING influence_driver::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN carelessreckless TYPE BOOLEAN USING carelessreckless::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN failyieldrow TYPE BOOLEAN USING failyieldrow::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN disregardsigns TYPE BOOLEAN USING disregardsigns::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_cw_motoristlt TYPE BOOLEAN USING ped_cw_motoristlt::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_midblock TYPE BOOLEAN USING ped_midblock::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_cw_motoriststraight TYPE BOOLEAN USING ped_cw_motoriststraight::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_nocw_motoriststraight TYPE BOOLEAN USING ped_nocw_motoriststraight::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_motoristRT TYPE BOOLEAN USING ped_motoristRT::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN ped_nocw_motoristLT TYPE BOOLEAN USING ped_nocw_motoristLT::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN midblock_injuryfatal TYPE BOOLEAN USING midblock_injuryfatal::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN distracted_driverfault TYPE BOOLEAN USING distracted_driverfault::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN distracted_pedfault TYPE BOOLEAN USING distracted_pedfault::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN straightgrade TYPE BOOLEAN USING straightgrade::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN highspeed TYPE BOOLEAN USING highspeed::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN fatalcrash TYPE BOOLEAN USING fatalcrash::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN injurycrash TYPE BOOLEAN USING injurycrash::BOOLEAN;
ALTER TABLE received.crashes_ped ALTER COLUMN noinjuryfatality TYPE BOOLEAN USING noinjuryfatality::BOOLEAN;
