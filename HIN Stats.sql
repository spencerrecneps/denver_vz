-- create temporary buffer column
ALTER TABLE generated.hin DROP COLUMN IF EXISTS tmp_geom_buffer;
ALTER TABLE generated.hin ADD COLUMN tmp_geom_buffer geometry(polygon,2231);

-- add buffers
UPDATE  generated.hin
SET     tmp_geom_buffer = ST_Buffer(geom,50);

SELECT
