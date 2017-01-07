-- create table
DROP TABLE IF EXISTS generated.denver_intersection_characteristics;
CREATE TABLE generated.denver_intersection_characteristics (
    int_id INTEGER PRIMARY KEY,
    geom geometry(point,2231),
    node INTEGER,
    int_name TEXT,
    class_1 TEXT,                       -- highest classification
    class_2 TEXT,                       -- next highest classification
    nhs BOOLEAN DEFAULT FALSE,          -- at least one leg on national highway system
    speed_limit_1 INTEGER,              -- highest speed limit
    speed_limit_2 INTEGER,              -- next highest speed limit
    divided BOOLEAN DEFAULT FALSE,      -- at least one leg is divided highway
    travel_lanes_1 INTEGER,             -- highest number of travel lanes
    travel_lanes_2 INTEGER,             -- next highest number of travel lanes
    travel_lanes_3 INTEGER,             -- next highest number of travel lanes
    travel_lanes_4 INTEGER              -- next highest number of travel lanes
);
INSERT INTO generated.denver_intersection_characteristics SELECT int_id, geom FROM denver_streets_intersections;
CREATE INDEX sidx_denintcharsgeom ON generated.denver_intersection_characteristics USING GIST (geom);
CREATE INDEX idx_denintcharsintid ON generated.denver_intersection_characteristics (int_id);
ANALYZE denver_intersection_characteristics (int_id);

-- node and int_name
UPDATE  generated.denver_intersection_characteristics
SET     node = i.node_denver_centerline,
        int_name = dci."INTERNAME"
FROM    generated.denver_streets_intersections i,
        received.denver_centerline_intersections dci
WHERE   denver_intersection_characteristics.int_id = i.int_id
AND     i.node_denver_centerline = dci."MASTERID";

-- class_1
UPDATE  generated.denver_intersection_characteristics
SET     class_1 = (
            SELECT      ds.functional_class
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            ORDER BY    ds.functional_class_order ASC
            LIMIT       1
        );

-- class_2
UPDATE  generated.denver_intersection_characteristics
SET     class_2 = (
            SELECT      ds.functional_class
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.functional_class != class_1
            ORDER BY    ds.functional_class_order ASC
            LIMIT       1
        );

-- nhs
UPDATE  generated.denver_intersection_characteristics
SET     nhs = TRUE
WHERE   EXISTS (
            SELECT      1
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.nhs
        );

-- speed_limit_1
UPDATE  generated.denver_intersection_characteristics
SET     speed_limit_1 = (
            SELECT      MAX(ds.speed_limit)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
        );

-- speed_limit_2
UPDATE  generated.denver_intersection_characteristics
SET     speed_limit_2 = (
            SELECT      MAX(ds.speed_limit)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.speed_limit != speed_limit_1
        );

-- divided
UPDATE  generated.denver_intersection_characteristics
SET     divided = TRUE
WHERE   EXISTS (
            SELECT      1
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.divided
        );

-- travel_lanes_1
UPDATE  generated.denver_intersection_characteristics
SET     travel_lanes_1 = (
            SELECT      MAX(ds.travel_lanes)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
        );

-- travel_lanes_2
UPDATE  generated.denver_intersection_characteristics
SET     travel_lanes_2 = (
            SELECT      MAX(ds.travel_lanes)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.travel_lanes < travel_lanes_1
        );

-- travel_lanes_3
UPDATE  generated.denver_intersection_characteristics
SET     travel_lanes_3 = (
            SELECT      MAX(ds.travel_lanes)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.travel_lanes < travel_lanes_2
        );

-- travel_lanes_4
UPDATE  generated.denver_intersection_characteristics
SET     travel_lanes_4 = (
            SELECT      MAX(ds.travel_lanes)
            FROM        denver_streets ds
            WHERE       denver_intersection_characteristics.int_id
                            IN (ds.intersection_from,ds.intersection_to)
            AND         ds.travel_lanes < travel_lanes_3
        );
