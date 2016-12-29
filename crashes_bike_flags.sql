-- Must be run as superuser.
-- Assumes CSV has header rows and is separated by pipe.
-- File must be copied to the server and given read permission for all users
DROP TABLE IF EXISTS received.crashes_bike_flags;
CREATE TABLE received.crashes_bike_flags (
    caseid TEXT,
    year TEXT,
    injury TEXT,
    fatality TEXT,
    flag_non TEXT,
    node TEXT,
    bike_s_veh_s_st_p TEXT,
    bike_s_veh_lt_St_od TEXT,
    bike_s_veh_rt_St_p TEXT,
    bike_s_veh_rt_St_sd TEXT,
    bike_s_veh_s_st_sd TEXT,
    bike_s_veh_rt_St_WW_p TEXT,
    bike_s_veh_s_sW_WW_p TEXT,
    bike_s_veh_rt_SW_WW_p TEXT
);
ALTER TABLE received.crashes_bike_flags OWNER TO gis;

-- copy data in
COPY received.crashes_bike_flags FROM '/home/sgardner/B004.05_2011_15_Bikedata_Injuries_Crashtypes.csv' DELIMITER ',' CSV HEADER;

-- add columns
ALTER TABLE received.crashes_bike_flags ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE received.crashes_bike_flags ADD COLUMN tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT;
ALTER TABLE received.crashes_bike_flags ADD COLUMN road_id1 INTEGER;
ALTER TABLE received.crashes_bike_flags ADD COLUMN road_id2 INTEGER;
ALTER TABLE received.crashes_bike_flags ADD COLUMN at_intersection BOOLEAN;
ALTER TABLE received.crashes_bike_flags ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_bike_flags ADD COLUMN geom_int geometry(point,2231);
ALTER TABLE received.crashes_bike_flags ADD COLUMN geom_midpoint geometry(point,2231);
ALTER TABLE received.crashes_bike_flags ADD COLUMN geom_exact geometry(point,2231);

-- update column types
ALTER TABLE received.crashes_bike_flags ALTER COLUMN year TYPE INTEGER USING year::INTEGER;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN injury TYPE BOOLEAN USING injury::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN fatality TYPE BOOLEAN USING fatality::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN flag_non TYPE BOOLEAN USING flag_non::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN node TYPE INTEGER USING node::INTEGER;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_s_st_p TYPE BOOLEAN USING bike_s_veh_s_st_p::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_lt_St_od TYPE BOOLEAN USING bike_s_veh_lt_St_od::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_rt_St_p TYPE BOOLEAN USING bike_s_veh_rt_St_p::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_rt_St_sd TYPE BOOLEAN USING bike_s_veh_rt_St_sd::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_s_st_sd TYPE BOOLEAN USING bike_s_veh_s_st_sd::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_rt_St_WW_p TYPE BOOLEAN USING bike_s_veh_rt_St_WW_p::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_s_sW_WW_p TYPE BOOLEAN USING bike_s_veh_s_sW_WW_p::BOOLEAN;
ALTER TABLE received.crashes_bike_flags ALTER COLUMN bike_s_veh_rt_SW_WW_p TYPE BOOLEAN USING bike_s_veh_rt_SW_WW_p::BOOLEAN;
