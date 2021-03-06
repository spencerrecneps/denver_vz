--------------------------------------------------------------
-- create new table with space to store pertinent data
--------------------------------------------------------------
--DROP TABLE IF EXISTS generated.denver_streets;
--DROP TABLE IF EXISTS generated.denver_streets_intersections;
CREATE TABLE generated.denver_streets (
    road_id SERIAL PRIMARY KEY,
    intersection_from INTEGER,
    intersection_to INTEGER,
    z_from INTEGER DEFAULT 0,
    z_to INTEGER DEFAULT 0,
    tdg_id VARCHAR(36) DEFAULT (uuid_generate_v4())::TEXT,
    geom geometry(linestring,2231),
    seg_length INTEGER,
    tdgid_denver_street_centerline VARCHAR(36),
    tdgid_denver_bicycle_facilities VARCHAR(36),
    tdgid_drcog_bicycle_facility_inventory VARCHAR(36),
    tdgid_cdot_highways VARCHAR(36),
    tdgid_cdot_major_roads VARCHAR(36),
    tdgid_cdot_local_roads VARCHAR(36),
    road_name TEXT,
    corridor_name TEXT,
    functional_class TEXT,
    volclass TEXT,
    class_order INTEGER,
    class_description TEXT,
    one_way VARCHAR(2),
    speed_limit INTEGER,
    speed_limit_source TEXT,
    aadt INTEGER,
    aadt_source TEXT,
    nhs BOOLEAN DEFAULT FALSE,
    nhs_source TEXT,
    divided BOOLEAN,
    divided_source TEXT,
    median_type TEXT,
    median_type_source TEXT,
    median_width_ft INTEGER,
    median_width_ft_source TEXT,
    travel_lanes INTEGER,
    travel_lanes_source TEXT,
    bike_facility TEXT,
    bike_facility_source TEXT
);

-- add base road segments from denver centerlines
INSERT INTO generated.denver_streets (
    geom,
    seg_length,
    tdgid_denver_street_centerline,
    z_from,
    z_to
)
SELECT  geom,
        ST_Length(geom),
        tdg_id,
        f_zlev,
        t_zlev
FROM    received.denver_street_centerline;

-- add indexes
CREATE INDEX sidx_denstreetsgeom ON generated.denver_streets USING GIST (geom);
CREATE INDEX idx_denstreetctrlntdgid ON generated.denver_streets (tdgid_denver_street_centerline);
ANALYZE generated.denver_streets;

-- create temporary buffers
ALTER TABLE generated.denver_streets ADD COLUMN tmp_buffers geometry(multipolygon,2231);
UPDATE  generated.denver_streets
SET     tmp_buffers = ST_Multi(
            ST_Buffer(
                ST_Buffer(geom,42,'endcap=flat'),
                -2
            )
        );
CREATE INDEX tsidx_dnvrstrtstmpbuff ON generated.denver_streets USING GIST (tmp_buffers);
ANALYZE generated.denver_streets (tmp_buffers);


--------------------
-- meld highways
--------------------
-- first pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_cdot_highways',
    'geom',
    'received.cdot_highways',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 'f'
);

-- second pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_cdot_highways',
    'geom',
    'received.cdot_highways',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    min_target_length_ := 300,
    min_shared_length_pct_ := 0.5,
    only_nulls_ := 't'
);

-- third pass
SELECT  tdg.tdgMeldAzimuths(
    'generated.denver_streets',
    'tdgid_cdot_highways',
    'geom',
    'received.cdot_highways',
    'tdg_id',
    'geom',
    tolerance_ := 100,
    --buffer_geom_ := 'tmp_buffers',
    max_angle_diff_ := 10,
    only_nulls_ := 't'
);

-- filter out non arterial matches
UPDATE  denver_streets
SET     tdgid_cdot_highways = NULL
FROM    received.denver_street_centerline ds
WHERE   ds.tdg_id = tdgid_denver_street_centerline
AND     tdgid_cdot_highways IS NOT NULL
AND     volclass IN ('LOCAL','COLLECTOR');

-- remove false positives
UPDATE  generated.denver_streets
SET     tdgid_cdot_highways = NULL
WHERE   EXISTS (
            SELECT  1
            FROM    generated.cdot_highways_false_positives fp
            WHERE   fp.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- grab stragglers
UPDATE  generated.denver_streets
SET     tdgid_cdot_highways = (
            SELECT      cdot_highways.tdg_id
            FROM        cdot_highways
            WHERE       NOT EXISTS (
                            SELECT  1
                            FROM    generated.denver_streets s
                            WHERE   cdot_highways.tdg_id = s.tdgid_cdot_highways
                        )
            AND         ST_DWithin(denver_streets.geom,cdot_highways.geom,50)
            AND         tdg.tdgCompareLines(cdot_highways.geom,denver_streets.geom,10) < 50
            ORDER BY    ST_Length(cdot_highways.geom) DESC
            LIMIT       1
        )
WHERE   EXISTS (
            SELECT  1
            FROM    generated.cdot_highways_stragglers stragglers
            WHERE   stragglers.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- index
CREATE INDEX idx_denstreetcdothwytdgid ON generated.denver_streets (tdgid_cdot_highways);


--------------------
-- meld major roads
--------------------
-- first pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_cdot_major_roads',
    'geom',
    'received.cdot_major_roads',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 'f'
);

-- second pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_cdot_major_roads',
    'geom',
    'received.cdot_major_roads',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    min_target_length_ := 300,
    min_shared_length_pct_ := 0.5,
    only_nulls_ := 't'
);

-- third pass
SELECT  tdg.tdgMeldAzimuths(
    'generated.denver_streets',
    'tdgid_cdot_major_roads',
    'geom',
    'received.cdot_major_roads',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    max_angle_diff_ := 10,
    only_nulls_ := 't'
);

-- filter out highway matches
UPDATE  denver_streets
SET     tdgid_cdot_major_roads = NULL
WHERE   tdgid_cdot_major_roads IS NOT NULL
AND     tdgid_cdot_highways IS NOT NULL;

-- remove false positives
UPDATE  generated.denver_streets
SET     tdgid_cdot_major_roads = NULL
WHERE   EXISTS (
            SELECT  1
            FROM    generated.cdot_major_roads_false_positives fp
            WHERE   fp.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- index
CREATE INDEX idx_denstreetcdotmjrrdtdgid ON generated.denver_streets (tdgid_cdot_major_roads);


--------------------
-- meld local roads
--------------------
-- first pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_cdot_local_roads',
    'geom',
    'received.cdot_local_roads',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 'f'
);

-- second pass
SELECT  tdg.tdgMeldAzimuths(
    'generated.denver_streets',
    'tdgid_cdot_local_roads',
    'geom',
    'received.cdot_local_roads',
    'tdg_id',
    'geom',
    tolerance_ := 10,
    buffer_geom_ := 'tmp_buffers',
    max_angle_diff_ := 10,
    only_nulls_ := 't'
);

-- remove false positives
UPDATE  generated.denver_streets
SET     tdgid_cdot_local_roads = NULL
WHERE   EXISTS (
            SELECT  1
            FROM    generated.cdot_local_roads_false_positives fp
            WHERE   fp.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- remove previous matches
UPDATE  denver_streets
SET     tdgid_cdot_local_roads = NULL
FROM    received.denver_street_centerline ds
WHERE   ds.tdg_id = tdgid_denver_street_centerline
AND     tdgid_cdot_local_roads IS NOT NULL
AND     (tdgid_cdot_highways IS NOT NULL OR tdgid_cdot_major_roads IS NOT NULL)
AND     volclass != 'LOCAL';

-- remove matches to locals from the others
UPDATE  denver_streets
SET     tdgid_cdot_major_roads = NULL,
        tdgid_cdot_highways = NULL
FROM    received.denver_street_centerline ds
WHERE   ds.tdg_id = tdgid_denver_street_centerline
AND     tdgid_cdot_local_roads IS NOT NULL
AND     (tdgid_cdot_highways IS NOT NULL OR tdgid_cdot_major_roads IS NOT NULL)
AND     volclass = 'LOCAL';

-- index
CREATE INDEX idx_denstreetcdotlclrdtdgid ON generated.denver_streets (tdgid_cdot_local_roads);


--------------------
-- meld drcog_bicycle_facility_inventory
--------------------
-- first pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_drcog_bicycle_facility_inventory',
    'geom',
    'drcog_bicycle_facility_inventory',
    'tdg_id',
    'geom',
    tolerance_ := 60,
    --buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 'f'
);

-- second pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_drcog_bicycle_facility_inventory',
    'geom',
    'drcog_bicycle_facility_inventory',
    'tdg_id',
    'geom',
    tolerance_ := 60,
    buffer_geom_ := 'tmp_buffers',
    min_target_length_ := 400,
    min_shared_length_pct_ := 0.6,
    only_nulls_ := 't'
);

-- third pass
SELECT  tdg.tdgMeldAzimuths(
    'generated.denver_streets',
    'tdgid_drcog_bicycle_facility_inventory',
    'geom',
    'drcog_bicycle_facility_inventory',
    'tdg_id',
    'geom',
    tolerance_ := 20,
    max_angle_diff_ := 5,
    only_nulls_ := 't'
);

-- remove trail matches
UPDATE  generated.denver_streets
SET     tdgid_drcog_bicycle_facility_inventory = NULL
FROM    drcog_bicycle_facility_inventory drcog
WHERE   tdgid_drcog_bicycle_facility_inventory = drcog.tdg_id
AND     (lower(drcog.type_fx) LIKE '%trail%' OR lower(drcog.type_fx) LIKE '%path%');

-- need to remove false positives


-- -- loosen up the buffers
-- UPDATE  generated.denver_streets
-- SET     tmp_buffers = ST_Multi(
--             ST_Buffer(
--                 ST_Buffer(geom,102,'endcap=flat'),
--                 -2
--             )
--         );
-- ANALYZE generated.denver_streets (tmp_buffers);

-- UPDATE  generated.denver_streets
-- SET     tdgid_drcog_bicycle_facility_inventory = (
--             SELECT      drcog_bicycle_facility_inventory.tdg_id
--             FROM        drcog_bicycle_facility_inventory
--             WHERE       ST_Intersects(denver_streets.tmp_buffers,drcog_bicycle_facility_inventory.geom)
--             AND         tdg.tdgCompareLines(denver_streets.geom,drcog_bicycle_facility_inventory.geom,10) < 100
--             ORDER BY    tdg.tdgCompareLines(denver_streets.geom,drcog_bicycle_facility_inventory.geom,10) ASC
--             LIMIT       1
--         )
-- WHERE   ST_Length(geom) > 200;

-- index
CREATE INDEX idx_denstreetdrcogbikestdgid ON generated.denver_streets (tdgid_drcog_bicycle_facility_inventory);


--------------------
-- meld denver bike facilities
--------------------
-- tighten up the buffers
UPDATE  generated.denver_streets
SET     tmp_buffers = ST_Multi(
            ST_Buffer(
                ST_Buffer(geom,12,'endcap=flat'),
                -2
            )
        );
ANALYZE generated.denver_streets (tmp_buffers);

-- first pass
SELECT  tdg.tdgMeldBuffers(
    'generated.denver_streets',
    'tdgid_denver_bicycle_facilities',
    'geom',
    'received.denver_bicycle_facilities',
    'tdg_id',
    'geom',
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 't'
);

-- second pass
SELECT  tdg.tdgMeldAzimuths(
    'generated.denver_streets',
    'tdgid_denver_bicycle_facilities',
    'geom',
    'received.denver_bicycle_facilities',
    'tdg_id',
    'geom',
    tolerance_ := 5,
    buffer_geom_ := 'tmp_buffers',
    max_angle_diff_ := 5,
    only_nulls_ := 't'
);

-- remove false positives
UPDATE  generated.denver_streets
SET     tdgid_denver_bicycle_facilities = NULL
WHERE   EXISTS (
            SELECT  1
            FROM    generated.denver_bicycle_facilities_false_positives fp
            WHERE   fp.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- grab stragglers
UPDATE  generated.denver_streets
SET     tdgid_denver_bicycle_facilities = (
            SELECT      denver_bicycle_facilities.tdg_id
            FROM        denver_bicycle_facilities
            WHERE       ST_Intersects(denver_streets.tmp_buffers,denver_bicycle_facilities.geom)
            ORDER BY    tdg.tdgCompareLines(denver_streets.geom,denver_bicycle_facilities.geom,10) ASC
            LIMIT       1
        )
WHERE   EXISTS (
            SELECT  1
            FROM    generated.denver_bicycle_facilities_stragglers stragglers
            WHERE   stragglers.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- index
CREATE INDEX idx_denstreetbcyclfactdgid ON generated.denver_streets (tdgid_denver_bicycle_facilities);






-- drop temporary bufffers
ALTER TABLE generated.denver_streets DROP COLUMN tmp_buffers;


--------------------
-- add trails from denver_bicycle_facilities
--------------------
INSERT INTO generated.denver_streets (
    tdgid_denver_bicycle_facilities, geom
)
SELECT  tdg_id,
        geom
FROM    denver_bicycle_facilities
WHERE   COALESCE(phase,'Existing') = 'Existing'
AND     existing_f IN ('RT','MT','SWBP','SUP');

-- analyze
ANALYZE generated.denver_streets;



--------------------
-- create intersections
--------------------

DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomadddelintersections ON generated.denver_streets;
DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomadddeltable ON generated.denver_streets;
DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomadddelvals ON generated.denver_streets;
DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomupdateintersections ON generated.denver_streets;
DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomupdatetable ON generated.denver_streets;
DROP TRIGGER IF EXISTS tr_tdgdenver_streetsgeomupdatevals ON generated.denver_streets;
UPDATE generated.denver_streets SET intersection_from = NULL, intersection_to = NULL;
SELECT tdg.tdgMakeIntersections('denver_streets','t');

-- add nodes from denver centerlines
ALTER TABLE generated.denver_streets_intersections ADD COLUMN node_denver_centerline INT;
UPDATE  generated.denver_streets_intersections
SET     node_denver_centerline = (
            SELECT  dc.fnode_
            FROM    denver_streets ds,
                    denver_street_centerline dc
            WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
            AND     ds.intersection_from = denver_streets_intersections.int_id
            LIMIT   1
        );
UPDATE  generated.denver_streets_intersections
SET     node_denver_centerline = (
            SELECT  dc.tnode_
            FROM    denver_streets ds,
                    denver_street_centerline dc
            WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
            AND     ds.intersection_to = denver_streets_intersections.int_id
            LIMIT   1
        )
WHERE   node_denver_centerline IS NULL;

-- index
CREATE INDEX idx_dsints_node ON generated.denver_streets_intersections (node_denver_centerline);
ANALYZE generated.denver_streets_intersections (node_denver_centerline);


--------------------
-- add attributes
--------------------

-- temporary field manipulation
ALTER TABLE denver_streets DROP COLUMN IF EXISTS road_name;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS corridor_name;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS functional_class;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS volclass;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS class_order;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS class_description;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS one_way;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS speed_limit;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS speed_limit_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS aadt;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS aadt_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS nhs;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS nhs_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS divided;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS divided_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS median_type;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS median_type_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS median_width_ft;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS median_width_ft_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS travel_lanes;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS travel_lanes_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS bike_facility;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS bike_facility_source;
ALTER TABLE denver_streets ADD COLUMN road_name TEXT;
ALTER TABLE denver_streets ADD COLUMN corridor_name TEXT;
ALTER TABLE denver_streets ADD COLUMN functional_class TEXT;
ALTER TABLE denver_streets ADD COLUMN volclass TEXT;
ALTER TABLE denver_streets ADD COLUMN class_order INTEGER;
ALTER TABLE denver_streets ADD COLUMN class_description TEXT;
ALTER TABLE denver_streets ADD COLUMN one_way VARCHAR(2);
ALTER TABLE denver_streets ADD COLUMN speed_limit INTEGER;
ALTER TABLE denver_streets ADD COLUMN speed_limit_source TEXT;
ALTER TABLE denver_streets ADD COLUMN aadt INTEGER;
ALTER TABLE denver_streets ADD COLUMN aadt_source TEXT;
ALTER TABLE denver_streets ADD COLUMN nhs BOOLEAN DEFAULT FALSE;
ALTER TABLE denver_streets ADD COLUMN nhs_source TEXT;
ALTER TABLE denver_streets ADD COLUMN divided BOOLEAN;
ALTER TABLE denver_streets ADD COLUMN divided_source TEXT;
ALTER TABLE denver_streets ADD COLUMN median_type TEXT;
ALTER TABLE denver_streets ADD COLUMN median_type_source TEXT;
ALTER TABLE denver_streets ADD COLUMN median_width_ft INTEGER;
ALTER TABLE denver_streets ADD COLUMN median_width_ft_source TEXT;
ALTER TABLE denver_streets ADD COLUMN travel_lanes INTEGER;
ALTER TABLE denver_streets ADD COLUMN travel_lanes_source TEXT;
ALTER TABLE denver_streets ADD COLUMN bike_facility TEXT;
ALTER TABLE denver_streets ADD COLUMN bike_facility_source TEXT;

-- road_name, corridor_name,functional_class, volclass, one_way, speed_limit,
-- nhs, divided, travel_lanes from denver_street_centerline
UPDATE  denver_streets
SET     road_name = dsc.fullname,
        corridor_name = regexp_replace(dsc.fullname,'^[E|W|N|S]\s',''),
        functional_class = dsc.funclass,
        volclass = dsc.volclass,
        class_order = CASE  WHEN dsc.funclass = '11' THEN           1   --interstate urban
                            WHEN dsc.funclass = '12' THEN           2   --freeway urban
                            WHEN dsc.funclass = '1' THEN            3   --interstate rural
                            WHEN dsc.volclass = 'ARTERIAL' THEN     4
                            WHEN dsc.volclass = 'COLLECTOR' THEN    5
                            WHEN dsc.volclass = 'LOCAL' THEN        6
                            ELSE NULL
                            END,
        class_description = CASE    WHEN dsc.funclass = '11' THEN           'Urban interstate'
                                    WHEN dsc.funclass = '12' THEN           'Urban freeway'
                                    WHEN dsc.funclass = '1' THEN            'Rural interstate'
                                    WHEN dsc.volclass = 'ARTERIAL' THEN     'Arterial'
                                    WHEN dsc.volclass = 'COLLECTOR' THEN    'Collector'
                                    WHEN dsc.volclass = 'LOCAL' THEN        'Local'
                                    ELSE NULL
                                    END,
        one_way = CASE  WHEN dsc.oneway = 0 THEN NULL
                        ELSE 'ft'   -- we don't really care what direciton it goes
                        END,
        speed_limit = dsc.speedlimit,
        nhs = CASE  WHEN dsc.nhs IN (   'MAJ',
                                        'MAJ/NHS 7',
                                        'NHS 1',
                                        'NHS 4',
                                        'NHS 5',
                                        'NHS 6',
                                        'NHS 7'
                                    )
                        THEN TRUE
                    ELSE FALSE
                    END,
        divided = CASE  WHEN dsc.median = 'Y' THEN TRUE
                        WHEN dsc.median = 'N' THEN FALSE
                        ELSE NULL
                        END,
        travel_lanes = CASE WHEN dsc.travlanes > 0 THEN dsc.travlanes
                            ELSE NULL
                            END
FROM    denver_street_centerline dsc
WHERE   denver_streets.tdgid_denver_street_centerline = dsc.tdg_id;

-- set sources
UPDATE  denver_streets
SET     speed_limit_source = CASE   WHEN speed_limit IS NULL THEN NULL
                                    ELSE 'denver_street_centerline'
                                    END,
        nhs_source = CASE   WHEN nhs IS FALSE THEN NULL
                            ELSE 'denver_street_centerline'
                            END,
        divided_source = CASE   WHEN divided IS NULL THEN NULL
                                ELSE 'denver_street_centerline'
                                END,
        travel_lanes_source = CASE  WHEN travel_lanes IS NULL THEN NULL
                                    ELSE 'denver_street_centerline'
                                    END;

-- aadt, nhs, divided, median_type, median_width_ft, travel_lanes
-- from cdot_highways
UPDATE  denver_streets
SET     aadt = h.aadt,
        nhs = CASE  WHEN nhs IS FALSE
                        THEN CASE   WHEN left(h.nhsdesig,1) = '1'
                                        THEN TRUE
                                    ELSE FALSE
                                    END
                    ELSE nhs
                    END,
        divided = CASE  WHEN divided IS NULL
                            THEN CASE   WHEN h.isdivided = 'Yes'
                                            THEN TRUE
                                        END
                        END,
        median_type = CASE  WHEN left(median,2) = '1 '
                                THEN NULL
                            ELSE median
                            END,
        median_width_ft = CASE  WHEN left(median,2) = '1 '
                                    THEN NULL
                                ELSE medianwd
                                END,
        travel_lanes = CASE WHEN travel_lanes IS NULL
                                THEN h.thrulnqty
                            ELSE travel_lanes
                            END
FROM    cdot_highways h
WHERE   denver_streets.tdgid_cdot_highways = h.tdg_id;

-- sources
UPDATE  denver_streets
SET     aadt_source = CASE  WHEN aadt IS NULL THEN NULL
                            WHEN aadt_source IS NULL THEN 'cdot_highways'
                            ELSE aadt_source
                            END,
        nhs_source = CASE   WHEN nhs IS TRUE AND nhs_source IS NULL
                                THEN 'cdot_highways'
                            END,
        divided_source = CASE   WHEN divided IS NULL THEN NULL
                                WHEN divided_source IS NULL THEN 'cdot_highways'
                                ELSE divided_source
                                END,
        median_type_source = CASE   WHEN median_type IS NULL THEN NULL
                                    ELSE 'cdot_highways'
                                    END,
        median_width_ft_source = CASE   WHEN median_width_ft IS NULL THEN NULL
                                        ELSE 'cdot_highways'
                                        END,
        travel_lanes_source = CASE  WHEN travel_lanes IS NULL THEN NULL
                                    WHEN travel_lanes_source IS NULL
                                        THEN 'cdot_highways'
                                    ELSE travel_lanes_source
                                    END
WHERE   tdgid_cdot_highways IS NOT NULL;

-- aadt, nhs, travel_lanes
-- from cdot_major_roads
UPDATE  denver_streets
SET     aadt = m.aadt,
        nhs = CASE  WHEN nhs IS FALSE
                        THEN CASE   WHEN m.nhsdesig = '1'
                                        THEN TRUE
                                    ELSE FALSE
                                    END
                    ELSE nhs
                    END,
        travel_lanes = CASE WHEN travel_lanes IS NULL
                                THEN m.thrulnqty
                            ELSE travel_lanes
                            END
FROM    cdot_major_roads m
WHERE   denver_streets.tdgid_cdot_major_roads = m.tdg_id;

-- sources
UPDATE  denver_streets
SET     aadt_source = CASE  WHEN aadt IS NULL THEN NULL
                            WHEN aadt_source IS NULL THEN 'cdot_major_roads'
                            ELSE aadt_source
                            END,
        nhs_source = CASE   WHEN nhs IS TRUE AND nhs_source IS NULL
                                THEN 'cdot_major_roads'
                            END,
        travel_lanes_source = CASE  WHEN travel_lanes IS NULL THEN NULL
                                    WHEN travel_lanes_source IS NULL
                                        THEN 'cdot_major_roads'
                                    ELSE travel_lanes_source
                                    END
WHERE   tdgid_cdot_major_roads IS NOT NULL;

-- aadt, nhs, travel_lanes
-- from cdot_local_roads
UPDATE  denver_streets
SET     aadt = l.aadt,
        nhs = CASE  WHEN nhs IS FALSE
                        THEN CASE   WHEN l.nhsdesig = '1'
                                        THEN TRUE
                                    ELSE FALSE
                                    END
                    ELSE nhs
                    END,
        travel_lanes = CASE WHEN travel_lanes IS NULL
                                THEN l.thrulnqty
                            ELSE travel_lanes
                            END
FROM    cdot_local_roads l
WHERE   denver_streets.tdgid_cdot_local_roads = l.tdg_id;

-- sources
UPDATE  denver_streets
SET     aadt_source = CASE  WHEN aadt IS NULL THEN NULL
                            WHEN aadt_source IS NULL THEN 'cdot_local_roads'
                            ELSE aadt_source
                            END,
        nhs_source = CASE   WHEN nhs IS TRUE AND nhs_source IS NULL
                                THEN 'cdot_local_roads'
                            END,
        travel_lanes_source = CASE  WHEN travel_lanes IS NULL THEN NULL
                                    WHEN travel_lanes_source IS NULL
                                        THEN 'cdot_local_roads'
                                    ELSE travel_lanes_source
                                    END
WHERE   tdgid_cdot_local_roads IS NOT NULL;

-- denver_bicycle_facilities
UPDATE  denver_streets
SET     bike_facility = existing_f
FROM    denver_bicycle_facilities bf
WHERE   denver_streets.tdgid_denver_bicycle_facilities = bf.tdg_id;

-- source
UPDATE  denver_streets
SET     bike_facility_source = 'denver_bicycle_facilities'
WHERE   bike_facility IS NOT NULL;

-- drcog_bicycle_facility_inventory
UPDATE  denver_streets
SET     bike_facility = CASE    WHEN bike_facility IS NULL THEN type_fx
                                ELSE bike_facility
                                END
FROM    drcog_bicycle_facility_inventory bf
WHERE   denver_streets.tdgid_drcog_bicycle_facility_inventory = bf.tdg_id;

-- source
UPDATE  denver_streets
SET     bike_facility_source = 'denver_bicycle_facilities'
WHERE   bike_facility_source IS NULL
AND     bike_facility IS NOT NULL;

-- indexes
CREATE INDEX idx_dscorrname ON generated.denver_streets (corridor_name);
ANALYZE generated.denver_streets (corridor_name);
