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
    seg_length INT,
    tdgid_denver_street_centerline VARCHAR(36),
    tdgid_denver_bicycle_facilities VARCHAR(36),
    tdgid_drcog_bicycle_facility_inventory VARCHAR(36),
    tdgid_cdot_highways VARCHAR(36),
    tdgid_cdot_major_roads VARCHAR(36),
    tdgid_cdot_local_roads VARCHAR(36),
    road_name TEXT,
    functional_class TEXT,
    functional_class_order INTEGER,
    one_way VARCHAR(2),
    speed_limit INTEGER,
    speed_limit_source TEXT,
    aadt INTEGER,
    aadt_source TEXT,
    nhs BOOLEAN,
    nhs_source TEXT,
    divided BOOLEAN,
    divided_source TEXT,
    median_type TEXT,
    median_type_source TEXT,
    median_width_ft INTEGER,
    median_width_ft_source TEXT,
    funding TEXT,
    funding_source TEXT,
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
ALTER TABLE denver_streets DROP COLUMN IF EXISTS functional_class;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS functional_class_order;
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
ALTER TABLE denver_streets DROP COLUMN IF EXISTS funding;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS funding_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS travel_lanes;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS travel_lanes_source;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS bike_facility;
ALTER TABLE denver_streets DROP COLUMN IF EXISTS bike_facility_source;
ALTER TABLE denver_streets ADD COLUMN road_name TEXT;
ALTER TABLE denver_streets ADD COLUMN functional_class TEXT;
ALTER TABLE denver_streets ADD COLUMN functional_class_order INTEGER;
ALTER TABLE denver_streets ADD COLUMN one_way VARCHAR(2);
ALTER TABLE denver_streets ADD COLUMN speed_limit INTEGER;
ALTER TABLE denver_streets ADD COLUMN speed_limit_source TEXT;
ALTER TABLE denver_streets ADD COLUMN aadt INTEGER;
ALTER TABLE denver_streets ADD COLUMN aadt_source TEXT;
ALTER TABLE denver_streets ADD COLUMN nhs BOOLEAN;
ALTER TABLE denver_streets ADD COLUMN nhs_source TEXT;
ALTER TABLE denver_streets ADD COLUMN divided BOOLEAN;
ALTER TABLE denver_streets ADD COLUMN divided_source TEXT;
ALTER TABLE denver_streets ADD COLUMN median_type TEXT;
ALTER TABLE denver_streets ADD COLUMN median_type_source TEXT;
ALTER TABLE denver_streets ADD COLUMN median_width_ft INTEGER;
ALTER TABLE denver_streets ADD COLUMN median_width_ft_source TEXT;
ALTER TABLE denver_streets ADD COLUMN funding TEXT;
ALTER TABLE denver_streets ADD COLUMN funding_source TEXT;
ALTER TABLE denver_streets ADD COLUMN travel_lanes INTEGER;
ALTER TABLE denver_streets ADD COLUMN travel_lanes_source TEXT;
ALTER TABLE denver_streets ADD COLUMN bike_facility TEXT;
ALTER TABLE denver_streets ADD COLUMN bike_facility_source TEXT;

-- road_name, functional_class, one_way, speed_limit, nhs, divided,
-- travel_lanes from denver_street_centerline
UPDATE  denver_streets
SET     road_name = dsc.fullname,
        functional_class = dsc.funclass,
        functional_class_order = CASE   WHEN dsc.funclass = '11' THEN 1     --interstate urban
                                        WHEN dsc.funclass = '12' THEN 2     --freeway urban
                                        WHEN dsc.funclass = '1' THEN  3     --interstate rural
                                        WHEN dsc.funclass = '14' THEN 4     --other primary arterial urban
                                        WHEN dsc.funclass = '2' THEN  5     --other primary arterial rural
                                        WHEN dsc.funclass = '16' THEN 6     --minor arterial urban
                                        WHEN dsc.funclass = '6' THEN  7     --minor arterial rural
                                        WHEN dsc.funclass = '17' THEN 8     --collector urban
                                        WHEN dsc.funclass = '7' THEN  9     --major collector rural
                                        WHEN dsc.funclass = '8' THEN  10    --minor collector rural
                                        WHEN dsc.funclass = '19' THEN 11    --local urban
                                        WHEN dsc.funclass = '9' THEN  12    --local rural
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

-- aadt, nhs, divided, median_type, median_width_ft, funding, travel_lanes
-- from cdot data
UPDATE  denver_streets
SET     aadt = COALESCE(h.aadt,m.aadt,l.aadt),
        nhs = CASE  WHEN nhs IS FALSE
                        THEN CASE   WHEN COALESCE(h.nhsdesig,m.nhsdesig,l.nhsdesig) = 1
                                        THEN TRUE
                                    END
                    END,
        divided = CASE  WHEN divided IS NULL
                            THEN CASE   WHEN h.isdivided = 'Yes'
                                            THEN TRUE
                                        END
                        END,
        travel_lanes = thrulnqty

FROM    cdot_highways h,
        cdot_major_roads m,
        cdot_local_roads l
WHERE   denver_streets.tdgid_cdot_highways = h.tdg_id
AND     denver_streets.tdgid_cdot_major_roads = m.tdg_id
AND     denver_streets.tdgid_cdot_local_roads = l.tdg_id;
