--------------------------------------------------------------
-- create new table with space to store pertinent data
--------------------------------------------------------------

DROP TABLE IF EXISTS generated.denver_streets;
CREATE TABLE generated.denver_streets (
    id SERIAL PRIMARY KEY,
    geom geometry(linestring,2231),
    seg_length INT,
    tdgid_denver_street_centerline VARCHAR(36),
    tdgid_denver_bicycle_facilities VARCHAR(36),
    tdgid_drcog_bicycle_facility_inventory VARCHAR(36),
    tdgid_cdot_highways VARCHAR(36),
    tdgid_cdot_major_roads VARCHAR(36),
    tdgid_cdot_local_roads VARCHAR(36),
    speed_limit INTEGER,
    speed_limit_source TEXT
);

-- add base road segments from denver centerlines
INSERT INTO generated.denver_streets (
    geom,
    seg_length,
    tdgid_denver_street_centerline
)
SELECT  geom,
        ST_Length(geom),
        tdg_id
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
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    only_nulls_ := 'f'
);

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
