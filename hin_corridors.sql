-- create tables
DROP TABLE IF EXISTS generated.hin_corridor_windows;
DROP TABLE IF EXISTS scratch.denver_streets_corridors;
DROP TABLE IF EXISTS scratch.hin_corridor_ints;
DROP TABLE IF EXISTS generated.hin_corridors_automated;
CREATE TABLE generated.hin_corridor_windows (
    id SERIAL PRIMARY KEY,
    geom geometry(multilinestring,2231),
    int_id INTEGER,
    corridor_name TEXT,
    distance INTEGER,
    all_base_weight INTEGER,
    all_total_weight INTEGER,
    all_avg_weight FLOAT,
    all_median_weight INTEGER,
    all_hilo_total_weight INTEGER,
    all_hilo_avg_weight FLOAT,
    all_weight_per_mile FLOAT,
    all_hilo_weight_per_mile FLOAT,
    all_ints_w_fatals INTEGER,
    all_ints_gt_zero INTEGER,
    all_ints_gt_one INTEGER,
    all_ints_gt_two INTEGER,
    all_ints_gt_three INTEGER,
    ped_base_weight INTEGER,
    ped_total_weight INTEGER,
    ped_avg_weight FLOAT,
    ped_median_weight INTEGER,
    ped_hilo_total_weight INTEGER,
    ped_hilo_avg_weight FLOAT,
    ped_weight_per_mile FLOAT,
    ped_hilo_weight_per_mile FLOAT,
    ped_ints_w_fatals INTEGER,
    ped_ints_gt_zero INTEGER,
    ped_ints_gt_one INTEGER,
    ped_ints_gt_two INTEGER,
    ped_ints_gt_three INTEGER,
    bike_base_weight INTEGER,
    bike_total_weight INTEGER,
    bike_avg_weight FLOAT,
    bike_median_weight INTEGER,
    bike_hilo_total_weight INTEGER,
    bike_hilo_avg_weight FLOAT,
    bike_weight_per_mile FLOAT,
    bike_hilo_weight_per_mile FLOAT,
    bike_ints_w_fatals INTEGER,
    bike_ints_gt_zero INTEGER,
    bike_ints_gt_one INTEGER,
    bike_ints_gt_two INTEGER,
    bike_ints_gt_three INTEGER,
    veh_base_weight INTEGER,
    veh_total_weight INTEGER,
    veh_avg_weight FLOAT,
    veh_median_weight INTEGER,
    veh_hilo_total_weight INTEGER,
    veh_hilo_avg_weight FLOAT,
    veh_weight_per_mile FLOAT,
    veh_hilo_weight_per_mile FLOAT,
    veh_ints_w_fatals INTEGER,
    veh_ints_gt_zero INTEGER,
    veh_ints_gt_one INTEGER,
    veh_ints_gt_two INTEGER,
    veh_ints_gt_three INTEGER,
    veh_ints_gt_five INTEGER,
    veh_ints_gt_ten INTEGER
);
CREATE TABLE scratch.denver_streets_corridors (
    id SERIAL PRIMARY KEY,
    geom geometry(multilinestring,2231),
    corridor_name TEXT
);
CREATE TABLE scratch.hin_corridor_ints (
    id SERIAL PRIMARY KEY,
    geom geometry(point,2231),
    base_int_id INTEGER,
    int_id INTEGER,
    corridor_name TEXT
);
CREATE TABLE generated.hin_corridors_automated (
    id SERIAL PRIMARY KEY,
    geom geometry(multilinestring,2231),
    corridor_name TEXT,
    corridor_mode TEXT
);

-- denver_streets_corridors
INSERT INTO scratch.denver_streets_corridors (corridor_name)
SELECT  ds.corridor_name
FROM    crash_aggregates ca,
        denver_streets_intersections dsi,
        denver_streets ds
WHERE   ca.int_id = dsi.int_id
AND     dsi.int_id = ds.intersection_from
AND     ca.int_weight > 2
UNION
SELECT  ds.corridor_name
FROM    crash_aggregates ca,
        denver_streets_intersections dsi,
        denver_streets ds
WHERE   ca.int_id = dsi.int_id
AND     dsi.int_id = ds.intersection_to
AND     ca.int_weight > 2;
UPDATE  scratch.denver_streets_corridors
SET     geom = (
            SELECT  ST_Multi(ST_Union(ds.geom))
            FROM    generated.denver_streets ds
            WHERE   denver_streets_corridors.corridor_name = ds.corridor_name
        );
CREATE INDEX idx_tmpcsn ON scratch.denver_streets_corridors (corridor_name);
CREATE INDEX sidx_dscgeom ON scratch.denver_streets_corridors USING GIST (geom);
ANALYZE scratch.denver_streets_corridors;

-- hin_corridor_ints
INSERT INTO scratch.hin_corridor_ints (
    base_int_id, int_id, corridor_name
)
SELECT  dsi.int_id,
        windows.node,
        denver_streets_corridors.corridor_name
FROM    denver_streets_intersections dsi,
        hin_exclusion,
        scratch.denver_streets_corridors,
        pgr_drivingdistance('
            SELECT  road_id AS id,
                    intersection_from AS source,
                    intersection_to AS target,
                    seg_length AS cost,
                    seg_length AS reverse_cost
            FROM    denver_streets, hin_exclusion
            WHERE   corridor_name = '||quote_literal(denver_streets_corridors.corridor_name)||'
            AND     ST_Disjoint(denver_streets.geom,hin_exclusion.geom)',
            dsi.int_id,
            2640,
            directed:=FALSE
        ) windows
WHERE   ST_Disjoint(dsi.geom,hin_exclusion.geom)
AND     EXISTS (
            SELECT  1
            FROM    denver_streets ds
            WHERE   dsi.int_id IN (ds.intersection_from,ds.intersection_to)
            AND     ds.corridor_name = denver_streets_corridors.corridor_name
        );
CREATE INDEX idx_cinm ON scratch.hin_corridor_ints (corridor_name);
CREATE INDEX idx_cibsint ON scratch.hin_corridor_ints (base_int_id);
CREATE INDEX idx_ciint ON scratch.hin_corridor_ints (int_id);
ANALYZE scratch.hin_corridor_ints (corridor_name,base_int_id,int_id);
UPDATE  scratch.hin_corridor_ints
SET     geom = i.geom
FROM    generated.denver_streets_intersections i
WHERE   i.int_id = hin_corridor_ints.int_id;
CREATE INDEX sidx_hincorrgeom ON hin_corridor_ints USING GIST (geom);
ANALYZE scratch.hin_corridor_ints (geom);

-- window geoms
INSERT INTO generated.hin_corridor_windows (
    geom, int_id, corridor_name
)
SELECT      ST_Multi(ST_Union(ds.geom)),
            i1.base_int_id,
            i1.corridor_name
FROM        generated.denver_streets ds,
            scratch.hin_corridor_ints i1,
            scratch.hin_corridor_ints i2
WHERE       ds.corridor_name = i1.corridor_name
AND         i1.corridor_name = i2.corridor_name
AND         i1.base_int_id = i2.base_int_id
AND         i1.int_id IN (ds.intersection_from,ds.intersection_to)
AND         i2.int_id IN (ds.intersection_from,ds.intersection_to)
GROUP BY    i1.base_int_id,
            i1.corridor_name;

-- index
CREATE INDEX idx_hincw_intid ON generated.hin_corridor_windows (int_id);
CREATE INDEX idx_hincw_crnam ON generated.hin_corridor_windows (corridor_name);
CREATE INDEX sidx_hincw_geom ON generated.hin_corridor_windows USING GIST (geom);
ANALYZE generated.hin_corridor_windows;

-- window weights and distance
UPDATE  generated.hin_corridor_windows
SET     distance = ST_Length(geom),
        -- all
        all_total_weight = (
            SELECT  SUM(agg.int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        all_avg_weight = (
            SELECT  AVG(agg.int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        all_median_weight = (
            SELECT  quantile(agg.int_weight, 0.5)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        all_hilo_total_weight = (
            SELECT  SUM(b.int_weight)
            FROM    (
                        SELECT      a.int_weight
                        FROM        (
                                        SELECT      agg.int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.int_weight ASC
                        OFFSET      1
                    ) b
        ),
        all_hilo_avg_weight = (
            SELECT  AVG(b.int_weight)
            FROM    (
                        SELECT      a.int_weight
                        FROM        (
                                        SELECT      agg.int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.int_weight ASC
                        OFFSET      1
                    ) b
        ),
        all_base_weight = (
            SELECT  int_weight
            FROM    crash_aggregates
            WHERE   hin_corridor_windows.int_id = crash_aggregates.int_id
        ),
        all_ints_w_fatals = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_allfatal + agg.ped_allfatal + agg.bike_allfatal > 0
        ),
        all_ints_gt_zero = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.int_weight > 0
        ),
        all_ints_gt_one = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.int_weight > 1
        ),
        all_ints_gt_two = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.int_weight > 2
        ),
        all_ints_gt_three = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.int_weight > 3
        ),
        --ped
        ped_total_weight = (
            SELECT  SUM(agg.ped_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        ped_avg_weight = (
            SELECT  AVG(agg.ped_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        ped_median_weight = (
            SELECT  quantile(agg.ped_int_weight, 0.5)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        ped_hilo_total_weight = (
            SELECT  SUM(b.ped_int_weight)
            FROM    (
                        SELECT      a.ped_int_weight
                        FROM        (
                                        SELECT      agg.ped_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.ped_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.ped_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        ped_hilo_avg_weight = (
            SELECT  AVG(b.ped_int_weight)
            FROM    (
                        SELECT      a.ped_int_weight
                        FROM        (
                                        SELECT      agg.ped_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.ped_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.ped_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        ped_base_weight = (
            SELECT  ped_int_weight
            FROM    crash_aggregates
            WHERE   hin_corridor_windows.int_id = crash_aggregates.int_id
        ),
        ped_ints_w_fatals = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_allfatal > 0
        ),
        ped_ints_gt_zero = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_int_weight > 0
        ),
        ped_ints_gt_one = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_int_weight > 1
        ),
        ped_ints_gt_two = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_int_weight > 2
        ),
        ped_ints_gt_three = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_int_weight > 3
        ),
        --bike
        bike_total_weight = (
            SELECT  SUM(agg.bike_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        bike_avg_weight = (
            SELECT  AVG(agg.bike_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        bike_median_weight = (
            SELECT  quantile(agg.bike_int_weight, 0.5)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        bike_hilo_total_weight = (
            SELECT  SUM(b.bike_int_weight)
            FROM    (
                        SELECT      a.bike_int_weight
                        FROM        (
                                        SELECT      agg.bike_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.bike_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.bike_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        bike_hilo_avg_weight = (
            SELECT  AVG(b.bike_int_weight)
            FROM    (
                        SELECT      a.bike_int_weight
                        FROM        (
                                        SELECT      agg.bike_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.bike_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.bike_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        bike_base_weight = (
            SELECT  bike_int_weight
            FROM    crash_aggregates
            WHERE   hin_corridor_windows.int_id = crash_aggregates.int_id
        ),
        bike_ints_w_fatals = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.bike_allfatal > 0
        ),
        bike_ints_gt_zero = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.bike_int_weight > 0
        ),
        bike_ints_gt_one = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.bike_int_weight > 1
        ),
        bike_ints_gt_two = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.bike_int_weight > 2
        ),
        bike_ints_gt_three = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.bike_int_weight > 3
        ),
        --veh
        veh_total_weight = (
            SELECT  SUM(agg.veh_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        veh_avg_weight = (
            SELECT  AVG(agg.veh_int_weight)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        veh_median_weight = (
            SELECT  quantile(agg.veh_int_weight, 0.5)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        veh_hilo_total_weight = (
            SELECT  SUM(b.veh_int_weight)
            FROM    (
                        SELECT      a.veh_int_weight
                        FROM        (
                                        SELECT      agg.veh_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.veh_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.veh_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        veh_hilo_avg_weight = (
            SELECT  AVG(b.veh_int_weight)
            FROM    (
                        SELECT      a.veh_int_weight
                        FROM        (
                                        SELECT      agg.veh_int_weight
                                        FROM        scratch.hin_corridor_ints i,
                                                    crash_aggregates agg
                                        WHERE       hin_corridor_windows.int_id = i.base_int_id
                                        AND         hin_corridor_windows.corridor_name = i.corridor_name
                                        AND         i.int_id = agg.int_id
                                        ORDER BY    agg.veh_int_weight DESC
                                        OFFSET      1
                                    ) a
                        ORDER BY    a.veh_int_weight ASC
                        OFFSET      1
                    ) b
        ),
        veh_base_weight = (
            SELECT  veh_int_weight
            FROM    crash_aggregates
            WHERE   hin_corridor_windows.int_id = crash_aggregates.int_id
        ),
        veh_ints_w_fatals = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_allfatal > 0
        ),
        veh_ints_gt_zero = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 0
        ),
        veh_ints_gt_one = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 1
        ),
        veh_ints_gt_two = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 2
        ),
        veh_ints_gt_three = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 3
        ),
        veh_ints_gt_five = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 5
        ),
        veh_ints_gt_ten = (
            SELECT  COUNT(agg.int_id)
            FROM    scratch.hin_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_int_weight > 10
        );

-- per mile weights
UPDATE  generated.hin_corridor_windows
SET     all_weight_per_mile = all_total_weight / (distance::FLOAT / 5280),
        all_hilo_weight_per_mile = all_hilo_total_weight / (distance::FLOAT / 5280),
        ped_weight_per_mile = ped_total_weight / (distance::FLOAT / 5280),
        ped_hilo_weight_per_mile = ped_hilo_total_weight / (distance::FLOAT / 5280),
        bike_weight_per_mile = bike_total_weight / (distance::FLOAT / 5280),
        bike_hilo_weight_per_mile = bike_hilo_total_weight / (distance::FLOAT / 5280),
        veh_weight_per_mile = veh_total_weight / (distance::FLOAT / 5280),
        veh_hilo_weight_per_mile = veh_hilo_total_weight / (distance::FLOAT / 5280);


-------------------------------
-- hin_corridors_automated
-------------------------------
-- ped
INSERT INTO generated.hin_corridors_automated (corridor_mode, geom, corridor_name)
SELECT      'pedestrian',
            ST_Union(ds.geom),
            i1.corridor_name
FROM        hin_corridor_ints i1,
            hin_corridor_ints i2,
            denver_streets ds
WHERE       i1.base_int_id = i2.base_int_id
AND         i1.corridor_name = i2.corridor_name
AND         i1.int_id != i2.int_id
AND         ds.intersection_from = i1.int_id
AND         ds.intersection_to = i2.int_id
AND         ds.corridor_name = i1.corridor_name
AND         EXISTS (
                SELECT  1
                FROM    hin_corridor_windows w
                WHERE   w.int_id = i1.base_int_id
                AND     w.int_id = i2.base_int_id
                AND     w.corridor_name = i1.corridor_name
                AND     w.ped_hilo_weight_per_mile >= 4
                AND     w.ped_ints_gt_one > 2
            )
GROUP BY    i1.corridor_name;

-- bike

-- veh
