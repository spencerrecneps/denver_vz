-- create tables
DROP TABLE IF EXISTS generated.hin_corridor_windows;
DROP TABLE IF EXISTS tmp_corridors;
DROP TABLE IF EXISTS tmp_corridor_ints;
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
    ped_base_weight INTEGER,
    ped_total_weight INTEGER,
    ped_avg_weight FLOAT,
    ped_median_weight INTEGER,
    ped_hilo_total_weight INTEGER,
    ped_hilo_avg_weight FLOAT,
    ped_weight_per_mile FLOAT,
    ped_hilo_weight_per_mile FLOAT,
    ped_ints_w_fatals INTEGER,
    bike_base_weight INTEGER,
    bike_total_weight INTEGER,
    bike_avg_weight FLOAT,
    bike_median_weight INTEGER,
    bike_hilo_total_weight INTEGER,
    bike_hilo_avg_weight FLOAT,
    bike_weight_per_mile FLOAT,
    bike_hilo_weight_per_mile FLOAT,
    bike_ints_w_fatals INTEGER,
    veh_base_weight INTEGER,
    veh_total_weight INTEGER,
    veh_avg_weight FLOAT,
    veh_median_weight INTEGER,
    veh_hilo_total_weight INTEGER,
    veh_hilo_avg_weight FLOAT,
    veh_weight_per_mile FLOAT,
    veh_hilo_weight_per_mile FLOAT,
    veh_ints_w_fatals INTEGER,
);
CREATE TEMPORARY TABLE tmp_corridors (
    id SERIAL PRIMARY KEY,
    corridor_name TEXT
);
CREATE TEMPORARY TABLE tmp_corridor_ints (
    id SERIAL PRIMARY KEY,
    base_int_id INTEGER,
    int_id INTEGER,
    corridor_name TEXT
);

-- tmp_corridors
INSERT INTO tmp_corridors (corridor_name)
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
CREATE INDEX tidx_tmpcsn ON tmp_corridors (corridor_name);
ANALYZE tmp_corridors;

-- tmp_corridor_ints
INSERT INTO tmp_corridor_ints (
    base_int_id, int_id, corridor_name
)
SELECT  dsi.int_id,
        windows.node,
        tmp_corridors.corridor_name
FROM    denver_streets_intersections dsi,
        tmp_corridors,
        pgr_drivingdistance('
            SELECT  road_id AS id,
                    intersection_from AS source,
                    intersection_to AS target,
                    seg_length AS cost,
                    seg_length AS reverse_cost
            FROM    denver_streets
            WHERE   corridor_name = '||quote_literal(tmp_corridors.corridor_name),
            dsi.int_id,
            2640,
            directed:=FALSE
        ) windows
WHERE   EXISTS (
            SELECT  1
            FROM    denver_streets ds
            WHERE   dsi.int_id IN (ds.intersection_from,ds.intersection_to)
            AND     ds.corridor_name = tmp_corridors.corridor_name
        );
CREATE INDEX tidx_cinm ON tmp_corridor_ints (corridor_name);
CREATE INDEX tidx_cibsint ON tmp_corridor_ints (base_int_id);
CREATE INDEX tidx_ciint ON tmp_corridor_ints (int_id);
ANALYZE tmp_corridor_ints (corridor_name,base_int_id,int_id);

-- window geoms
INSERT INTO generated.hin_corridor_windows (
    geom, int_id, corridor_name
)
SELECT      ST_Multi(ST_Union(ds.geom)),
            i1.base_int_id,
            i1.corridor_name
FROM        generated.denver_streets ds,
            tmp_corridor_ints i1,
            tmp_corridor_ints i2
WHERE       ds.corridor_name = i1.corridor_name
AND         i1.corridor_name = i2.corridor_name
AND         i1.base_int_id = i2.base_int_id
AND         i1.int_id IN (ds.intersection_from,ds.intersection_to)
AND         i2.int_id IN (ds.intersection_from,ds.intersection_to)
GROUP BY    i1.base_int_id,
            i1.corridor_name;

-- index
CREATE INDEX sidx_hincw_geom ON generated.hin_corridor_windows USING GIST (geom);
ANALYZE generated.hin_corridor_windows (geom);

-- window weights and distance
UPDATE  generated.hin_corridor_windows
SET     distance = ST_Length(geom),
        -- all
        all_total_weight = (
            SELECT  SUM(agg.int_weight)
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        all_avg_weight = (
            SELECT  AVG(agg.int_weight)
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        all_median_weight = (
            SELECT  quantile(agg.int_weight, 0.5)
            FROM    tmp_corridor_ints i,
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
                                        FROM        tmp_corridor_ints i,
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
                                        FROM        tmp_corridor_ints i,
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
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.veh_allfatal + agg.ped_allfatal + agg.bike_allfatal > 0
        ),
        --ped
        ped_total_weight = (
            SELECT  SUM(agg.ped_int_weight)
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        ped_avg_weight = (
            SELECT  AVG(agg.ped_int_weight)
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
        ),
        ped_median_weight = (
            SELECT  quantile(agg.ped_int_weight, 0.5)
            FROM    tmp_corridor_ints i,
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
                                        FROM        tmp_corridor_ints i,
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
                                        FROM        tmp_corridor_ints i,
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
            FROM    tmp_corridor_ints i,
                    crash_aggregates agg
            WHERE   hin_corridor_windows.int_id = i.base_int_id
            AND     hin_corridor_windows.corridor_name = i.corridor_name
            AND     i.int_id = agg.int_id
            AND     agg.ped_allfatal > 0
        ),
        --bike
        
        --veh
        ;

-- per mile weights
UPDATE  generated.hin_corridor_windows
SET     all_weight_per_mile = all_total_weight / (distance::FLOAT / 5280),
        all_all_hilo_weight_per_mile = all_hilo_total_weight / (distance::FLOAT / 5280);
