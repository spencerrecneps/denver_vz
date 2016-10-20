--------------------------------------------------------------
-- create new table with space to store pertinent data
--------------------------------------------------------------

DROP TABLE IF EXISTS generated.denver_streets;
CREATE TABLE generated.denver_streets (
    id SERIAL PRIMARY KEY,
    geom geometry(linestring,2231),
    seg_length INT,
    tdgid_denver_street_centerline VARCHAR(36),
    tdgid_cdot_highways VARCHAR(36),
    tdgid_cdot_major_roads VARCHAR(36),
    tdgid_cdot_local_roads VARCHAR(36)
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

--------------------
-- meld highways
--------------------
-- create temporary buffers
ALTER TABLE generated.denver_streets ADD COLUMN tmp_buffers geometry(multipolygon,2231);
UPDATE generated.denver_streets SET tmp_buffers = ST_Multi(ST_Buffer(geom,40,'endcap=flat'));
CREATE INDEX tsidx_dnvrstrtstmpbuff ON generated.denver_streets USING GIST (tmp_buffers);
ANALYZE generated.denver_streets (tmp_buffers);

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
    tolerance_ := 40,
    buffer_geom_ := 'tmp_buffers',
    max_angle_diff_ := 10,
    only_nulls_ := 't'
);

-- filter to where volclass = arterial in denver centerlines and nullify others





-- remove false positives
UPDATE  generated.denver_streets
SET     tdgid_cdot_highways = NULL
WHERE   EXISTS (
            SELECT  1
            FROM    generated.cdot_highways_false_positives fp
            WHERE   fp.tdgid_denver_street_centerline = denver_streets.tdgid_denver_street_centerline
        );

-- -- fill remaining gaps
-- UPDATE  generated.denver_streets
-- SET     tdgid_cdot_highways = (
--             SELECT      cdot_highways.tdg_id
--             FROM        cdot_highways
--             WHERE       NOT EXISTS (
--                             SELECT  1
--                             FROM    generated.denver_streets s
--                             WHERE   cdot_highways.tdg_id = s.tdgid_cdot_highways
--                         )
--             AND         ST_DWithin(denver_streets.geom,cdot_highways.geom,50)
--             AND         tdg.tdgCompareLines(cdot_highways.geom,denver_streets.geom,10) < 50
--             ORDER BY    tdg.tdgCompareLines(cdot_highways.geom,denver_streets.geom,10) ASC
--             LIMIT       1
--         )
-- WHERE   denver_streets.tdgid_cdot_highways IS NULL;


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






-- drop temporary bufffers
ALTER TABLE generated.denver_streets DROP COLUMN tmp_buffers;
