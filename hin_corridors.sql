-- create table
DROP TABLE IF EXISTS generated.hin_corridors;
CREATE TABLE generated.hin_corridors (
    id SERIAL PRIMARY KEY,
    geom geometry(multipoint,2231),
    int_id INTEGER,
    weights INTEGER,
    distance INTEGER
);

-- recursively search road network for connected segments
-- and summarize
                        -- not working. maybe try using pgrouting?
WITH RECURSIVE corridors(base_int_id, int_id, road_name, distance) AS (
    SELECT  int_id,
            int_id,
            ds.road_name,
            0
    FROM    denver_streets_intersections,
            denver_streets ds
    WHERE   int_id IN (ds.intersection_from,ds.intersection_to)
    --and road_name = 'N LOGAN ST'
    UNION
    SELECT  corridors.base_int_id,
            corridors.int_id,
            ds.road_name,
            ST_Length(ds.geom)::INTEGER + corridors.distance
    FROM    denver_streets ds,
            corridors
    WHERE   ds.road_name = corridors.road_name
    AND     corridors.int_id IN (ds.intersection_from,ds.intersection_to)
    AND     ST_Length(ds.geom) + corridors.distance < 2000
)
INSERT INTO generated.hin_corridors (
    int_id, geom
)
SELECT      corridors.base_int_id,
            ST_Multi(ST_Union(ints.geom))
FROM        corridors,
            denver_streets_intersections ints
WHERE       corridors.int_id = ints.int_id
GROUP BY    corridors.base_int_id;
