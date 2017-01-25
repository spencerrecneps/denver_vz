-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_bike_supplement;
CREATE TABLE received.crashes_bike_supplement (
    caseid TEXT,
    year TEXT,
    injury TEXT,
    fatality TEXT,
    flag_non TEXT,
    unit1 TEXT,
    unit2 TEXT,
    est_speed1 TEXT,
    est_speed2 TEXT,
    driveract1 TEXT,
    driveract2 TEXT,
    contribfact1 TEXT,
    contribfact2 TEXT
);
ALTER TABLE received.crashes_bike_supplement OWNER TO gis;

-- copy data in
COPY received.crashes_bike_supplement FROM '/home/sgardner/Supplemental_bike_2011-2015.csv' DELIMITER '|' HEADER QUOTE '"' CSV;

-- add columns
ALTER TABLE received.crashes_bike_supplement ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN at_intersection BOOLEAN;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_bike_supplement ADD COLUMN geom_int geometry(point,2231);
ALTER TABLE received.crashes_bike_supplement ADD COLUMN geom_midpoint geometry(point,2231);
ALTER TABLE received.crashes_bike_supplement ADD COLUMN geom_exact geometry(point,2231);

-- update column types
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN year TYPE INTEGER USING year::INTEGER;
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN injury TYPE BOOLEAN USING injury::BOOLEAN;
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN fatality TYPE BOOLEAN USING fatality::BOOLEAN;
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN flag_non TYPE BOOLEAN USING flag_non::BOOLEAN;
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN est_speed1 TYPE INTEGER USING est_speed1::INTEGER;
ALTER TABLE received.crashes_bike_supplement ALTER COLUMN est_speed2 TYPE INTEGER USING est_speed2::INTEGER;
