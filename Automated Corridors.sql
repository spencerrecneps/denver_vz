-- tables
-- DROP TABLE IF EXISTS scratch.tmp_street_lines;

-- CREATE TABLE scratch.tmp_street_lines (
--     id SERIAL PRIMARY KEY,
--     geom geometry(linestring,2231)
-- );



-- DROP TABLE IF EXISTS scratch.tmp_topints;
-- CREATE TABLE scratch.tmp_topints (
--     id SERIAL PRIMARY KEY,
--     geom geometry(point,2231),
--     int_id INTEGER,
--     int_weight INTEGER,
--     percent FLOAT
-- );
--
--
--
-- -- tmp_topints
-- WITH cad AS (
--     SELECT  SUM(int_weight) AS int_weight
--     FROM    generated.crash_aggregates
-- )
-- INSERT INTO scratch.tmp_topints (int_id, int_weight, geom, percent)
-- SELECT  int_id,
--         crash_aggregates.int_weight,
--         geom,
--         100.0 * SUM(crash_aggregates.int_weight) OVER (ORDER BY crash_aggregates.int_weight DESC)
--             / cad.int_weight
-- FROM    generated.crash_aggregates, cad;
--
-- -- indexes
-- CREATE INDEX sidx_geomtopints ON tmp_topints USING GIST (geom);
-- ANALYZE tmp_topints;


DROP TABLE IF EXISTS scratch.street_corrs;
CREATE TABLE scratch.street_corrs (
    id SERIAL PRIMARY KEY,
    geom geometry(multilinestring,2231),
    corridor_name TEXT
);

-- insert corridors
INSERT INTO street_corrs (corridor_name)
SELECT DISTINCT regexp_replace(road_name,'^[E|W|N|S]\s','') FROM generated.denver_streets;

-- add geoms
UPDATE  street_corrs
SET     geom = (
            SELECT  ST_Multi(ST_Union(geom))
            FROM    denver_streets ds
            WHERE   regexp_replace(road_name,'^[E|W|N|S]\s','') = corridor_name
        );

-- indexes
CREATE INDEX sidx_strtcorrsgeom ON scratch.street_corrs USING GIST (geom);
ANALYZE scratch.street_corrs;
