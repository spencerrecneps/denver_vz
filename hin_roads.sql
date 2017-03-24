DROP TABLE IF EXISTS scratch.hin_roads;
CREATE TABLE scratch.hin_roads (
    id SERIAL PRIMARY KEY,
    int_id_f INTEGER,
    int_id_t INTEGER,
    window_ids INTEGER[],
    geom geometry(linestring,2231),
    road_name TEXT,
    fnode_ INTEGER,
    fnode_desc TEXT,
    tnode_ INTEGER,
    tnode_desc TEXT,
    ped_hin INTEGER,
    ped_hilo_weight_per_mile INTEGER,
    ped_ints_gt_zero INTEGER,
    ped_ints_gt_one INTEGER,
    ped_window_weight INTEGER,
    ped_vicinity_weight INTEGER,
    ped_ints_w_fatals INTEGER,
    bike_hin INTEGER,
    bike_hilo_weight_per_mile INTEGER,
    bike_ints_gt_zero INTEGER,
    bike_ints_gt_one INTEGER,
    bike_window_weight INTEGER,
    bike_vicinity_weight INTEGER,
    bike_ints_w_fatals INTEGER,
    vehicle_hin INTEGER,
    veh_hilo_weight_per_mile INTEGER,
    veh_ints_gt_two INTEGER,
    veh_ints_w_fatals INTEGER
);

INSERT INTO scratch.hin_roads (
    road_name,
    int_id_f, int_id_t,
    fnode_, fnode_desc,
    tnode_, tnode_desc,
    geom
)
SELECT  ds.road_name,
        dsi_f.int_id, dsi_t.int_id,
        dsi_f.node_denver_centerline, dci_f."INTERNAME",
        dsi_t.node_denver_centerline, dci_t."INTERNAME",
        ds.geom
FROM    denver_streets ds
JOIN    denver_streets_intersections dsi_f
            ON ds.intersection_from = dsi_f.int_id
JOIN    denver_streets_intersections dsi_t
            ON ds.intersection_to = dsi_t.int_id
JOIN    denver_centerline_intersections dci_f
            ON dsi_f.node_denver_centerline = dci_f."MASTERID"
JOIN    denver_centerline_intersections dci_t
            ON dsi_t.node_denver_centerline = dci_t."MASTERID";

-- indexes
CREATE INDEX sidx_hinrds_geom ON scratch.hin_roads USING GIST (geom);
CREATE INDEX idx_hinrds_intf ON scratch.hin_roads (int_id_f);
CREATE INDEX idx_hinrds_intt ON scratch.hin_roads (int_id_t);
ANALYZE scratch.hin_roads;

-- get window ids
UPDATE  scratch.hin_roads
SET     window_ids = (
            SELECT  array_agg(DISTINCT w.id)
            FROM    hin_corridor_windows w
            WHERE   EXISTS (
                        SELECT  1
                        FROM    hin_corridor_ints i
                        WHERE   w.int_id = i.base_int_id
                        AND     hin_roads.int_id_f = i.int_id
                    )
            AND     EXISTS (
                        SELECT  1
                        FROM    hin_corridor_ints i
                        WHERE   w.int_id = i.base_int_id
                        AND     hin_roads.int_id_t = i.int_id
                    )
        );

-- add window stats
UPDATE  scratch.hin_roads
SET     ped_hilo_weight_per_mile = (
            SELECT  MAX(w.ped_hilo_weight_per_mile)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        ped_ints_gt_zero = (
            SELECT  MAX(w.ped_ints_gt_zero)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        ped_ints_gt_one = (
            SELECT  MAX(w.ped_ints_gt_one)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        ped_window_weight = (
            SELECT  MAX(w.ped_hilo_window_weight)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        ped_vicinity_weight = (
            SELECT  MAX(w.ped_vicinity_weight)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        ped_ints_w_fatals = (
            SELECT  MAX(w.ped_ints_w_fatals)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_hilo_weight_per_mile = (
            SELECT  MAX(w.bike_hilo_avg_weight)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_ints_gt_zero = (
            SELECT  MAX(w.bike_ints_gt_zero)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_ints_gt_one = (
            SELECT  MAX(w.bike_ints_gt_one)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_window_weight = (
            SELECT  MAX(w.bike_window_weight)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_vicinity_weight = (
            SELECT  MAX(w.bike_vicinity_weight)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        bike_ints_w_fatals = (
            SELECT  MAX(w.bike_ints_w_fatals)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        veh_hilo_weight_per_mile = (
            SELECT  MAX(w.veh_hilo_weight_per_mile)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        veh_ints_gt_two = (
            SELECT  MAX(w.veh_ints_gt_two)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        ),
        veh_ints_w_fatals = (
            SELECT  MAX(w.veh_ints_w_fatals)
            FROM    hin_corridor_windows w
            WHERE   w.id = ANY(hin_roads.window_ids)
        );

-- set hins
UPDATE  scratch.hin_roads
SET     ped_hin = COALESCE((
            SELECT  1
            FROM    generated.hin
            WHERE   ST_DWithin(dsi_f.geom,hin.geom,50)
            AND     ST_DWithin(dsi_t.geom,hin.geom,50)
            AND     hin.ped
            LIMIT   1
        ),0),
        bike_hin = COALESCE((
            SELECT  1
            FROM    generated.hin
            WHERE   ST_DWithin(dsi_f.geom,hin.geom,50)
            AND     ST_DWithin(dsi_t.geom,hin.geom,50)
            AND     hin.bike
            LIMIT   1
        ),0),
        vehicle_hin = COALESCE((
            SELECT  1
            FROM    generated.hin
            WHERE   ST_DWithin(dsi_f.geom,hin.geom,50)
            AND     ST_DWithin(dsi_t.geom,hin.geom,50)
            AND     hin.veh
            LIMIT   1
        ),0)
FROM    denver_streets_intersections dsi_f,
        denver_streets_intersections dsi_t
WHERE   int_id_f = dsi_f.int_id
AND     int_id_t = dsi_t.int_id;

-- drop temp columns
ALTER TABLE scratch.hin_roads DROP COLUMN int_id_f;
ALTER TABLE scratch.hin_roads DROP COLUMN int_id_t;
ALTER TABLE scratch.hin_roads DROP COLUMN window_ids;
