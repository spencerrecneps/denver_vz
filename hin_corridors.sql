-- create tables
DROP TABLE IF EXISTS generated.hin_corridors;
DROP TABLE IF EXISTS tmp_streetnames;
CREATE TABLE generated.hin_corridors (
    id SERIAL PRIMARY KEY,
    geom geometry(linestring,2231),
    base_road_id INTEGER,
    road_id INTEGER,
    weights INTEGER,
    distance INTEGER
);
CREATE TEMPORARY TABLE tmp_streetnames (
    id SERIAL PRIMARY KEY,
    road_name TEXT
);

-- add road names that have scores > 2
INSERT INTO tmp_streetnames (road_name)
SELECT  regexp_replace(ds.road_name,'^[E|W|N|S]\s','')
FROM    crash_aggregates ca,
        denver_streets_intersections dsi,
        denver_streets ds
WHERE   ca.int_id = dsi.int_id
AND     dsi.int_id = ds.intersection_from
AND     ca.int_weight > 2
UNION
SELECT  regexp_replace(ds.road_name,'^[E|W|N|S]\s','')
FROM    crash_aggregates ca,
        denver_streets_intersections dsi,
        denver_streets ds
WHERE   ca.int_id = dsi.int_id
AND     dsi.int_id = ds.intersection_to
AND     ca.int_weight > 2;
CREATE INDEX tidx_tmpsn ON tmp_streetnames (road_name);
ANALYZE tmp_streetnames;

-- recursively search road network for connected segments
-- and summarize
WITH RECURSIVE windows(base_road_id, road_id, intersection_from, intersection_to, road_name, distance) AS (
    SELECT  road_id,
            road_id,
            intersection_from,
            intersection_to,
            regexp_replace(denver_streets.road_name,'^[E|W|N|S]\s',''),
            ST_Length(geom)
    FROM    denver_streets,
            tmp_streetnames
    WHERE   tmp_streetnames.road_name = regexp_replace(denver_streets.road_name,'^[E|W|N|S]\s','')
    --AND     denver_streets.road_name LIKE '%COLFAX AVE'
    AND     road_id IN (
                10088,28516,28523,28579,28617,28866,29074,29200,29279,29280,29446,
                29545,29563,29602,29606,29680,29702,29703,29713,29779,29780,29781
            )
    UNION
    SELECT  windows.road_id,
            ds.road_id,
            ds.intersection_from,
            ds.intersection_to,
            regexp_replace(ds.road_name,'^[E|W|N|S]\s',''),
            windows.distance + ST_Length(ds.geom)
    FROM    denver_streets ds,
            windows
    WHERE   windows.road_id != ds.road_id
    AND     windows.distance + ST_Length(ds.geom) < 1320
    AND     (
                ds.intersection_from IN (windows.intersection_from, windows.intersection_to)
            OR  ds.intersection_to IN (windows.intersection_from, windows.intersection_to)
            )
    AND     regexp_replace(ds.road_name,'^[E|W|N|S]\s','') = windows.road_name
)
INSERT INTO generated.hin_corridors (
    base_road_id, road_id, distance
)
SELECT      base_road_id, road_id, distance
FROM        windows;
