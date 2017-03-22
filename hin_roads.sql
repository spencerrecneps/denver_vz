DROP TABLE IF EXISTS scratch.hin_roads;
CREATE TABLE scratch.hin_roads (
    id SERIAL PRIMARY KEY,
    geom geometry(linestring,2231),
    road_id INTEGER,
    road_name TEXT,
    fnode_ INTEGER,
    tnode_ INTEGER,
    ped_hin INTEGER,
    bike_hin INTEGER,
    vehicle_hin INTEGER
);

INSERT INTO scratch.hin_roads (
    road_id,
    road_name,
    geom
)
SELECT  ds.road_id,
        ds.road_name,
        ds.geom
FROM    denver_streets ds,
        denver_streets_intersections dsi1,
        denver_streets_intersections dsi2
WHERE   dsi1.int_id IN (ds.intersection_to, ds.intersection_from)
AND     dsi2.int_id IN (ds.intersection_to, ds.intersection_from)
AND     dsi1.int_id != dsi2.int_id
AND     EXISTS (
            SELECT  1
            FROM    hin
            WHERE   ST_Intersects(hin.tmp_geom_buffer, dsi1.geom)
            AND     ST_Intersects(hin.tmp_geom_buffer, dsi2.geom)
        );

UPDATE  scratch.hin_roads
SET     ped_hin = COALESCE((
            SELECT  1
            FROM    hin,
                    denver_streets ds,
                    denver_streets_intersections dsi1,
                    denver_streets_intersections dsi2
            WHERE   hin_roads.road_id = ds.road_id
            AND     dsi1.int_id IN (ds.intersection_to, ds.intersection_from)
            AND     dsi2.int_id IN (ds.intersection_to, ds.intersection_from)
            AND     ST_Intersects(hin.tmp_geom_buffer, dsi1.geom)
            AND     ST_Intersects(hin.tmp_geom_buffer, dsi2.geom)
            AND     hin.ped
            LIMIT   1
        ),0),
        bike_hin = COALESCE((
                    SELECT  1
                    FROM    hin,
                            denver_streets ds,
                            denver_streets_intersections dsi1,
                            denver_streets_intersections dsi2
                    WHERE   hin_roads.road_id = ds.road_id
                    AND     dsi1.int_id IN (ds.intersection_to, ds.intersection_from)
                    AND     dsi2.int_id IN (ds.intersection_to, ds.intersection_from)
                    AND     ST_Intersects(hin.tmp_geom_buffer, dsi1.geom)
                    AND     ST_Intersects(hin.tmp_geom_buffer, dsi2.geom)
                    AND     hin.bike
                    LIMIT   1
                ),0),
        vehicle_hin = COALESCE((
                    SELECT  1
                    FROM    hin,
                            denver_streets ds,
                            denver_streets_intersections dsi1,
                            denver_streets_intersections dsi2
                    WHERE   hin_roads.road_id = ds.road_id
                    AND     dsi1.int_id IN (ds.intersection_to, ds.intersection_from)
                    AND     dsi2.int_id IN (ds.intersection_to, ds.intersection_from)
                    AND     ST_Intersects(hin.tmp_geom_buffer, dsi1.geom)
                    AND     ST_Intersects(hin.tmp_geom_buffer, dsi2.geom)
                    AND     hin.veh
                    LIMIT   1
                ),0);

UPDATE  scratch.hin_roads
SET     fnode_ = i.node_denver_centerline
FROM    denver_streets ds,
        denver_streets_intersections i
WHERE   hin_roads.road_id = ds.road_id
AND     ds.intersection_from = i.int_id;

UPDATE  scratch.hin_roads
SET     tnode_ = i.node_denver_centerline
FROM    denver_streets ds,
        denver_streets_intersections i
WHERE   hin_roads.road_id = ds.road_id
AND     ds.intersection_to = i.int_id;
