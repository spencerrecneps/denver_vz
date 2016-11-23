-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_jeffco;
CREATE TABLE received.crashes_jeffco (
    hwy TEXT,
    mp TEXT,
    "date" TEXT,
    "time" TEXT,
    severity TEXT,
    agencyname TEXT,
    report_id TEXT,
    location TEXT,
    road_desc TEXT,
    vehicles TEXT,
    contour TEXT,
    condition TEXT,
    lighting TEXT,
    weather TEXT,
    ramp TEXT,
    acctype TEXT,
    dir_1 TEXT,
    vehicle_1 TEXT,
    driver_1 TEXT,
    factor_1 TEXT,
    speed_1 TEXT,
    veh_move_1 TEXT,
    dir_2 TEXT,
    vehicle_2 TEXT,
    driver_2 TEXT,
    factor_2 TEXT,
    speed_2 TEXT,
    veh_move_2 TEXT,
    loc_01 TEXT,
    link TEXT,
    loc_02 TEXT
);
ALTER TABLE received.crashes_jeffco OWNER TO gis;

-- copy data in
COPY received.crashes_jeffco FROM '/home/sgardner/listing-jeffco(2008-15).csv' DELIMITER '|' HEADER QUOTE '"' CSV;

-- remove the stuff we don't care about
DELETE FROM received.crashes_jeffco
WHERE   NOT hwy = '0095A';

-- add columns
ALTER TABLE received.crashes_jeffco ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_jeffco ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_jeffco ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_jeffco ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_jeffco ADD COLUMN at_intersection BOOLEAN;
ALTER TABLE received.crashes_jeffco ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_jeffco ADD COLUMN geom_int geometry(point,2231);
ALTER TABLE received.crashes_jeffco ADD COLUMN geom_midpoint geometry(point,2231);
ALTER TABLE received.crashes_jeffco ADD COLUMN geom_exact geometry(point,2231);

-- update column types
ALTER TABLE received.crashes_jeffco ALTER COLUMN mp TYPE FLOAT USING mp::FLOAT;
ALTER TABLE received.crashes_jeffco ALTER COLUMN "date" TYPE DATE USING "date"::DATE;
ALTER TABLE received.crashes_jeffco ALTER COLUMN "time" TYPE INTEGER USING "time"::INTEGER;
ALTER TABLE received.crashes_jeffco ALTER COLUMN vehicles TYPE INTEGER USING vehicles::INTEGER;

-- remove crashes pre 2011 or post 2015
DELETE FROM received.crashes_jeffco
WHERE   EXTRACT(YEAR FROM "date") < 2011
OR      EXTRACT(YEAR FROM "date") > 2015;
