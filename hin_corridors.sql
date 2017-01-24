-- create table
DROP TABLE IF EXISTS generated.hin_corridors;
CREATE TABLE generated.hin_corridors (
    id SERIAL PRIMARY KEY,
    geom geometry(linestring,2231),
    base_road_id INTEGER,
    road_id INTEGER,
    weights INTEGER,
    distance INTEGER
);

-- recursively search road network for connected segments
-- and summarize
WITH RECURSIVE windows(base_road_id, road_id, intersection_from, intersection_to, road_name, distance) AS (
    SELECT  road_id,
            road_id,
            intersection_from,
            intersection_to,
            regexp_replace(road_name,'^[E|W|N|S]\s',''),
            ST_Length(geom)
    FROM    denver_streets
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
    AND     windows.distance + ST_Length(ds.geom) < 2640
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
