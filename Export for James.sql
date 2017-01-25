-----------------------------
-- ped_export
-----------------------------
-- create table
DROP TABLE IF EXISTS scratch.ped_export;
CREATE TABLE scratch.ped_export (
    id SERIAL PRIMARY KEY,
    geom geometry(point,2231),
    caseid TEXT,
    crashyear INTEGER,
    unittype_one TEXT,
    unittype_two TEXT,
    unittype_three TEXT,
    estvehspeed_one INTEGER,
    estvehspeed_two INTEGER,
    contribfact_one TEXT,
    contribfact_two TEXT,
    driveraction_one TEXT,
    driveraction_two TEXT,
    driveraction_three TEXT,
    flag_injurycrash INTEGER,
    flag_fatalcrash INTEGER,
    flag_non INTEGER,
    fatal_midblock INTEGER,
    flag_sheridan INTEGER
);

-- crashes_ped
INSERT INTO scratch.ped_export (
    caseid, crashyear, unittype_one, unittype_two, unittype_three, estvehspeed_one,
    estvehspeed_two, contribfact_one, contribfact_two, driveraction_one,
    driveraction_two, driveraction_three, flag_injurycrash, flag_fatalcrash,
    flag_non, fatal_midblock, flag_sheridan, geom
)
SELECT  caseid,
        crashyear,
        unittype_one,
        unittype_two,
        unittype_three,
        estvehspeed_one,
        estvehspeed_two,
        contribfact_one,
        contribfact_two,
        driveraction_one,
        driveraction_two,
        driveraction_three,
        injurycrash::INTEGER,
        fatalcrash::INTEGER,
        noinjuryfatality::INTEGER,
        midblockcrossing::INTEGER,
        0,
        geom_int
FROM    received.crashes_ped;

-- crashes_jeffco
INSERT INTO scratch.ped_export (
    caseid, crashyear, unittype_one, unittype_two, unittype_three, estvehspeed_one,
    estvehspeed_two, contribfact_one, contribfact_two, driveraction_one,
    driveraction_two, driveraction_three, flag_injurycrash, flag_fatalcrash,
    flag_non, fatal_midblock, flag_sheridan, geom
)
SELECT  'Sheridan-' || report_id,
        extract(YEAR FROM "date"),
        vehicle_1,
        vehicle_2,
        NULL,
        CASE    WHEN speed_1 = 'UK' THEN NULL
                ELSE speed_1::INTEGER
                END,
        CASE    WHEN speed_2 = 'UK' THEN NULL
                ELSE speed_2::INTEGER
                END,
        factor_1,
        factor_2,
        NULL,
        NULL,
        NULL,
        flag_injury::INTEGER,
        flag_fatal::INTEGER,
        (NOT flag_injury OR flag_fatal)::INTEGER,
        NULL,
        1,
        geom_exact
FROM    received.crashes_jeffco
WHERE   flag_ped;


-----------------------------
-- bike_export
-----------------------------
-- create table
DROP TABLE IF EXISTS scratch.bike_export;
CREATE TABLE scratch.bike_export (
    id SERIAL PRIMARY KEY,
    geom geometry(point,2231),
    caseid TEXT,
    year INTEGER,
    injury INTEGER,
    fatality INTEGER,
    flag_non INTEGER,
    unit1 TEXT,
    unit2 TEXT,
    est_speed1 INTEGER,
    est_speed2 INTEGER,
    driveract1 TEXT,
    driveract2 TEXT,
    contribfact1 TEXT,
    contribfact2 TEXT,
    flag_sheridan INTEGER
);

-- crashes_bike1
INSERT INTO scratch.bike_export (
    geom, caseid, year, injury, fatality, flag_non, unit1, unit2, est_speed1,
    est_speed2, driveract1, driveract2, contribfact1, contribfact2, flag_sheridan
)
SELECT  geom_int,
        caseid,
        year,
        (injurycrash AND NOT fatality)::INTEGER,
        fatality::INTEGER,
        (NOT injurycrash)::INTEGER,
        unittype_one,
        unittype_two,
        estvehspeed_one,
        estvehspeed_two,
        driveract1,
        driveract2,
        contrib_1,
        contrib_2,
        0
FROM    received.crashes_bike1;

-- crashes_bike2
INSERT INTO scratch.bike_export (
    geom, caseid, year, injury, fatality, flag_non, unit1, unit2, est_speed1,
    est_speed2, driveract1, driveract2, contribfact1, contribfact2, flag_sheridan
)
SELECT  geom_int,
        caseid,
        crashyear,
        injurycrash::INTEGER,
        fatalcrash::INTEGER,
        noinjuryfatality::INTEGER,
        unittype_one,
        unittype_two,
        estvehspeed_one,
        estvehspeed_two,
        driveraction_one,
        driveraction_two,
        contribfact_one,
        contribfact_two,
        0
FROM    received.crashes_bike2;

-- crashes_jeffco
INSERT INTO scratch.bike_export (
    geom, caseid, year, injury, fatality, flag_non, unit1, unit2, est_speed1,
    est_speed2, driveract1, driveract2, contribfact1, contribfact2, flag_sheridan
)
SELECT  geom_exact,
        'Sheridan-' || report_id,
        extract(YEAR FROM "date"),
        flag_injury::INTEGER,
        flag_fatal::INTEGER,
        (NOT flag_injury OR flag_fatal)::INTEGER,
        vehicle_1,
        vehicle_2,
        CASE    WHEN speed_1 = 'UK' THEN NULL
                ELSE speed_1::INTEGER
                END,
        CASE    WHEN speed_2 = 'UK' THEN NULL
                ELSE speed_2::INTEGER
                END,
        NULL,
        NULL,
        factor_1,
        factor_2,
        1
FROM    received.crashes_jeffco
WHERE   flag_bike;


-----------------------------
-- veh_export
-----------------------------
-- create table
DROP TABLE IF EXISTS scratch.veh_export;
CREATE TABLE scratch.veh_export (
    id SERIAL PRIMARY KEY,
    geom geometry(point,2231),
    caseid TEXT,
    crashyear INTEGER,
    unittype_one TEXT,
    unittype_two TEXT,
    unittype_three TEXT,
    estvehspeed_one INTEGER,
    estvehspeed_two INTEGER,
    estvehspeed_three INTEGER,
    contribfact_one TEXT,
    contribfact_two TEXT,
    contribfact_three TEXT,
    driveraction_one TEXT,
    driveraction_two TEXT,
    driveraction_three TEXT,
    flag_injurycrash INTEGER,
    flag_fatalcrash INTEGER,
    flag_non INTEGER,
    flag_sheridan INTEGER
);

-- crashes_veh
INSERT INTO scratch.veh_export (
    geom, caseid, crashyear, unittype_one, unittype_two, unittype_three,
    estvehspeed_one, estvehspeed_two, estvehspeed_three, contribfact_one,
    contribfact_two, contribfact_three, driveraction_one, driveraction_two,
    driveraction_three, flag_injurycrash, flag_fatalcrash, flag_non, flag_sheridan
)
SELECT  geom_int,
        caseid,
        year,
        unittype_one,
        unittype_two,
        unittype_three,
        estvehspeed_one,
        estvehspeed_two,
        estvehspeed_three::INTEGER,
        contribfact_one,
        contribfact_two,
        contribfact_three,
        driveraction_one,
        driveraction_two,
        driveraction_three,
        injurycrash::INTEGER,
        fatalcrash::INTEGER,
        noinjuryfatality::INTEGER,
        0
FROM    received.crashes_veh;

-- crashes_jeffco
INSERT INTO scratch.veh_export (
    geom, caseid, crashyear, unittype_one, unittype_two, unittype_three,
    estvehspeed_one, estvehspeed_two, estvehspeed_three, contribfact_one,
    contribfact_two, contribfact_three, driveraction_one, driveraction_two,
    driveraction_three, flag_injurycrash, flag_fatalcrash, flag_non, flag_sheridan
)
SELECT  geom_exact,
        'Sheridan-' || report_id,
        extract(YEAR FROM "date"),
        vehicle_1,
        vehicle_2,
        NULL,
        CASE    WHEN speed_1 = 'UK' THEN NULL
                ELSE speed_1::INTEGER
                END,
        CASE    WHEN speed_2 = 'UK' THEN NULL
                ELSE speed_2::INTEGER
                END,
        NULL,
        factor_1,
        factor_2,
        NULL,
        NULL,
        NULL,
        NULL,
        flag_injury::INTEGER,
        flag_fatal::INTEGER,
        (NOT flag_injury OR flag_fatal)::INTEGER,
        1
FROM    received.crashes_jeffco
WHERE   flag_veh;
