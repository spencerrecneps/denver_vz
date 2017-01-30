-- create table
DROP TABLE IF EXISTS generated.hin_stats;
CREATE TABLE generated.hin_stats (
    id INTEGER PRIMARY KEY,
    stat_name TEXT,
    stat NUMERIC(20,2)
);

-- create temporary buffer column
ALTER TABLE generated.hin DROP COLUMN IF EXISTS tmp_geom_buffer;
ALTER TABLE generated.hin ADD COLUMN tmp_geom_buffer geometry(polygon,2231);

-- add buffers
UPDATE  generated.hin
SET     tmp_geom_buffer = ST_Buffer(geom,50);

-- index
CREATE INDEX tsidx_hinbuff ON generated.hin USING GIST (tmp_geom_buffer);
ANALYZE generated.hin (tmp_geom_buffer);

--------------------------
-- hin_stats
--------------------------
-- ped
WITH    an AS (SELECT SUM(seg_length) AS net FROM generated.denver_streets),
        pn AS (SELECT SUM(ST_Length(geom)) AS net FROM generated.hin WHERE mode='pedestrian'),
        a AS (
            SELECT  SUM(ped_allcrashes) AS allcrashes,
                    SUM(ped_allinjury) AS allinjury,
                    SUM(ped_allfatal) AS allfatal
            FROM    crash_aggregates
        ),
        p AS (
            SELECT  SUM(ped_allcrashes) AS allcrashes,
                    SUM(ped_allinjury) AS allinjury,
                    SUM(ped_allfatal) AS allfatal
            FROM    crash_aggregates
            WHERE   EXISTS (
                        SELECT  1
                        FROM    generated.hin
                        WHERE   ST_Intersects(hin.tmp_geom_buffer,crash_aggregates.geom)
                        AND     hin.mode = 'pedestrian'
                    )
        )
INSERT INTO generated.hin_stats (id, stat_name, stat)
SELECT  10,
        'Total street network (mi)',
        an.net::FLOAT / 5280
FROM    an
UNION
SELECT  20,
        'Total pedestrian HIN network (mi)',
        pn.net / 5280
FROM    pn
UNION
SELECT  30,
        'Percent pedestrian HIN network',
        100 * pn.net / an.net::FLOAT
FROM    an, pn
UNION
SELECT  40,
        'Pedestrian: all crashes',
        a.allcrashes
FROM    a
UNION
SELECT  50,
        'Pedestrian: all crashes / mi',
        a.allcrashes / (an.net::FLOAT / 5280)
FROM    a, an
UNION
SELECT  60,
        'Pedestrian: all crashes in HIN',
        p.allcrashes
FROM    p
UNION
SELECT  70,
        'Pedestrian: HIN crashes / mi',
        p.allcrashes / (pn.net::FLOAT / 5280)
FROM    p, pn
UNION
SELECT  80,
        'Pedestrian: all crashes, percent in HIN',
        100 * p.allcrashes::FLOAT / a.allcrashes
FROM    a, p
UNION
SELECT  90,
        'Pedestrian: injury crashes',
        a.allinjury
FROM    a
UNION
SELECT  100,
        'Pedestrian: injury crashes in HIN',
        p.allinjury
FROM    p
UNION
SELECT  110,
        'Pedestrian: injury crashes, percent in HIN',
        100 * p.allinjury::FLOAT / a.allinjury
FROM    a, p
UNION
SELECT  120,
        'Pedestrian: fatal crashes',
        a.allfatal
FROM    a
UNION
SELECT  130,
        'Pedestrian: fatal crashes in HIN',
        p.allfatal
FROM    p
UNION
SELECT  140,
        'Pedestrian: fatal crashes, percent in HIN',
        100 * p.allfatal::FLOAT / a.allfatal
FROM    a, p;

-- bike
WITH    an AS (SELECT SUM(seg_length) AS net FROM generated.denver_streets),
        bn AS (SELECT SUM(ST_Length(geom)) AS net FROM generated.hin WHERE mode='bike'),
        a AS (
            SELECT  SUM(bike_allcrashes) AS allcrashes,
                    SUM(bike_allinjury) AS allinjury,
                    SUM(bike_allfatal) AS allfatal
            FROM    crash_aggregates
        ),
        b AS (
            SELECT  SUM(bike_allcrashes) AS allcrashes,
                    SUM(bike_allinjury) AS allinjury,
                    SUM(bike_allfatal) AS allfatal
            FROM    crash_aggregates
            WHERE   EXISTS (
                        SELECT  1
                        FROM    generated.hin
                        WHERE   ST_Intersects(hin.tmp_geom_buffer,crash_aggregates.geom)
                        AND     hin.mode = 'bike'
                    )
        )
INSERT INTO generated.hin_stats (id, stat_name, stat)
SELECT  150,
        'Total bike HIN network (mi)',
        bn.net / 5280
FROM    bn
UNION
SELECT  160,
        'Percent bike HIN network',
        100 * bn.net / an.net::FLOAT
FROM    an, bn
UNION
SELECT  170,
        'Bike: all crashes',
        a.allcrashes
FROM    a
UNION
SELECT  180,
        'Bike: all crashes / mi',
        a.allcrashes / (an.net::FLOAT / 5280)
FROM    a, an
UNION
SELECT  190,
        'Bike: all crashes in HIN',
        b.allcrashes
FROM    b
UNION
SELECT  200,
        'Bike: HIN crashes / mi',
        b.allcrashes / (bn.net / 5280)
FROM    b, bn
UNION
SELECT  210,
        'Bike: all crashes, percent in HIN',
        100 * b.allcrashes::FLOAT / a.allcrashes
FROM    a, b
UNION
SELECT  220,
        'Bike: injury crashes',
        a.allinjury
FROM    a
UNION
SELECT  230,
        'Bike: injury crashes in HIN',
        b.allinjury
FROM    b
UNION
SELECT  240,
        'Bike: injury crashes, percent in HIN',
        100 * b.allinjury::FLOAT / a.allinjury
FROM    a, b
UNION
SELECT  250,
        'Bike: fatal crashes',
        a.allfatal
FROM    a
UNION
SELECT  260,
        'Bike: fatal crashes in HIN',
        b.allfatal
FROM    b
UNION
SELECT  270,
        'Bike: fatal crashes, percent in HIN',
        100 * b.allfatal::FLOAT / a.allfatal
FROM    a, b;

-- veh
WITH    an AS (SELECT SUM(seg_length) AS net FROM generated.denver_streets),
        vn AS (SELECT SUM(ST_Length(geom)) AS net FROM generated.hin WHERE mode='vehicle'),
        a AS (
            SELECT  SUM(bike_allcrashes) AS allcrashes,
                    SUM(bike_allinjury) AS allinjury,
                    SUM(bike_allfatal) AS allfatal
            FROM    crash_aggregates
        ),
        v AS (
            SELECT  SUM(bike_allcrashes) AS allcrashes,
                    SUM(bike_allinjury) AS allinjury,
                    SUM(bike_allfatal) AS allfatal
            FROM    crash_aggregates
            WHERE   EXISTS (
                        SELECT  1
                        FROM    generated.hin
                        WHERE   ST_Intersects(hin.tmp_geom_buffer,crash_aggregates.geom)
                        AND     hin.mode = 'vehicle'
                    )
        )
INSERT INTO generated.hin_stats (id, stat_name, stat)
SELECT  280,
        'Total vehicle HIN network (mi)',
        vn.net / 5280
FROM    vn
UNION
SELECT  290,
        'Percent vehicle HIN network',
        100 * vn.net / an.net::FLOAT
FROM    an, vn
UNION
SELECT  300,
        'Vehicle: all crashes',
        a.allcrashes
FROM    a
UNION
SELECT  310,
        'Vehicle: all crashes / mi',
        a.allcrashes / (an.net::FLOAT / 5280)
FROM    a, an
UNION
SELECT  320,
        'Vehicle: all crashes in HIN',
        v.allcrashes
FROM    v
UNION
SELECT  330,
        'Vehicle: HIN crashes / mi',
        v.allcrashes / (vn.net::FLOAT / 5280)
FROM    v, vn
UNION
SELECT  340,
        'Vehicle: all crashes, percent in HIN',
        100 * v.allcrashes::FLOAT / a.allcrashes
FROM    a, v
UNION
SELECT  350,
        'Vehicle: injury crashes',
        a.allinjury
FROM    a
UNION
SELECT  360,
        'Vehicle: injury crashes in HIN',
        v.allinjury
FROM    v
UNION
SELECT  370,
        'Vehicle: injury crashes, percent in HIN',
        100 * v.allinjury::FLOAT / a.allinjury
FROM    a, v
UNION
SELECT  380,
        'Vehicle: fatal crashes',
        a.allfatal
FROM    a
UNION
SELECT  390,
        'Vehicle: fatal crashes in HIN',
        v.allfatal
FROM    v
UNION
SELECT  400,
        'Vehicle: fatal crashes, percent in HIN',
        100 * v.allfatal::FLOAT / a.allfatal
FROM    a, v;

-- combined
WITH    an AS (SELECT SUM(seg_length) AS net FROM generated.denver_streets),
        cn AS (
            SELECT  SUM(ds.seg_length) AS net
            FROM    generated.denver_streets ds,
                    generated.denver_streets_intersections dsif,
                    generated.denver_streets_intersections dsit
            WHERE   ds.intersection_from = dsif.int_id
            AND     ds.intersection_to = dsit.int_id
            AND     EXISTS (
                        SELECT  1
                        FROM    generated.hin
                        WHERE   ST_Intersects(hin.tmp_geom_buffer,dsif.geom)
                        AND     ST_Intersects(hin.tmp_geom_buffer,dsit.geom)
                    )
        ),
        a AS (
            SELECT  SUM(ped_allcrashes) + SUM(bike_allcrashes) + SUM(veh_allcrashes) AS allcrashes,
                    SUM(ped_allinjury) + SUM(bike_allinjury) + SUM(veh_allinjury) AS allinjury,
                    SUM(ped_allfatal) + SUM(bike_allfatal) + SUM(veh_allfatal) AS allfatal
            FROM    crash_aggregates
        ),
        c AS (
            SELECT  SUM(ped_allcrashes) + SUM(bike_allcrashes) + SUM(veh_allcrashes) AS allcrashes,
                    SUM(ped_allinjury) + SUM(bike_allinjury) + SUM(veh_allinjury) AS allinjury,
                    SUM(ped_allfatal) + SUM(bike_allfatal) + SUM(veh_allfatal) AS allfatal
            FROM    crash_aggregates
            WHERE   EXISTS (
                        SELECT  1
                        FROM    generated.hin
                        WHERE   ST_Intersects(hin.tmp_geom_buffer,crash_aggregates.geom)
                    )
        )
INSERT INTO generated.hin_stats (id, stat_name, stat)
SELECT  410,
        'Total combined HIN network (mi)',
        cn.net / 5280
FROM    cn
UNION
SELECT  420,
        'Percent combined HIN network',
        100 * cn.net / an.net::FLOAT
FROM    an, cn
UNION
SELECT  430,
        'Combined: all crashes',
        a.allcrashes
FROM    a
UNION
SELECT  440,
        'Combined: all crashes / mi',
        a.allcrashes / (an.net::FLOAT / 5280)
FROM    a, an
UNION
SELECT  450,
        'Combined: all crashes in HIN',
        c.allcrashes
FROM    c
UNION
SELECT  460,
        'Combined: HIN crashes / mi',
        c.allcrashes / (cn.net::FLOAT / 5280)
FROM    c, cn
UNION
SELECT  470,
        'Combined: all crashes, percent in HIN',
        100 * c.allcrashes::FLOAT / a.allcrashes
FROM    a, c
UNION
SELECT  480,
        'Combined: injury crashes',
        a.allinjury
FROM    a
UNION
SELECT  490,
        'Combined: injury crashes in HIN',
        c.allinjury
FROM    c
UNION
SELECT  500,
        'Combined: injury crashes, percent in HIN',
        100 * c.allinjury::FLOAT / a.allinjury
FROM    a, c
UNION
SELECT  510,
        'Combined: fatal crashes',
        a.allfatal
FROM    a
UNION
SELECT  520,
        'Combined: fatal crashes in HIN',
        c.allfatal
FROM    c
UNION
SELECT  530,
        'Combined: fatal crashes, percent in HIN',
        100 * c.allfatal::FLOAT / a.allfatal
FROM    a, c;


SELECT * FROM generated.hin_stats ORDER BY id;
