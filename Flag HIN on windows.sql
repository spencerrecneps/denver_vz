-- add HIN flag column to windows
ALTER TABLE generated.hin_corridor_windows DROP COLUMN IF EXISTS flag_hin_ped;
ALTER TABLE generated.hin_corridor_windows DROP COLUMN IF EXISTS flag_hin_bike;
ALTER TABLE generated.hin_corridor_windows DROP COLUMN IF EXISTS flag_hin_veh;
ALTER TABLE generated.hin_corridor_windows ADD COLUMN flag_hin_ped BOOLEAN DEFAULT False;
ALTER TABLE generated.hin_corridor_windows ADD COLUMN flag_hin_bike BOOLEAN DEFAULT False;
ALTER TABLE generated.hin_corridor_windows ADD COLUMN flag_hin_veh BOOLEAN DEFAULT False;

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
-- flag_hin
--------------------------
UPDATE  generated.hin_corridor_windows
SET     flag_hin_ped =
            CASE
            WHEN EXISTS (
                SELECT  1
                FROM    generated.hin
                WHERE   ST_Intersects(hin.tmp_geom_buffer,i.geom)
                AND     hin.ped
                AND     ST_Area(
                            ST_Intersection(
                                hin.tmp_geom_buffer,
                                ST_Buffer(hin_corridor_windows.geom,50)
                            )
                        ) > 20000
            ) THEN True
            ELSE False
            END,
        flag_hin_bike =
            CASE
            WHEN EXISTS (
                SELECT  1
                FROM    generated.hin
                WHERE   ST_Intersects(hin.tmp_geom_buffer,i.geom)
                AND     hin.bike
                AND     ST_Area(
                            ST_Intersection(
                                hin.tmp_geom_buffer,
                                ST_Buffer(hin_corridor_windows.geom,50)
                            )
                        ) > 20000
            ) THEN True
            ELSE False
            END,
        flag_hin_veh =
            CASE
            WHEN EXISTS (
                SELECT  1
                FROM    generated.hin
                WHERE   ST_Intersects(hin.tmp_geom_buffer,i.geom)
                AND     hin.veh
                AND     ST_Area(
                            ST_Intersection(
                                hin.tmp_geom_buffer,
                                ST_Buffer(hin_corridor_windows.geom,50)
                            )
                        ) > 20000
            ) THEN True
            ELSE False
            END
FROM    denver_streets_intersections i
WHERE   i.int_id = hin_corridor_windows.int_id
AND     EXISTS (
            SELECT  1
            FROM    generated.hin
            WHERE   ST_Intersects(hin.tmp_geom_buffer,i.geom)
--            AND     (hin.ped OR hin.bike OR hin.veh)
            AND     ST_Area(
                        ST_Intersection(
                            hin.tmp_geom_buffer,
                            ST_Buffer(hin_corridor_windows.geom,50)
                        )
                    ) > 20000
        );


--------------------------
-- indexes
--------------------------
CREATE INDEX idx_hincw_ped ON generated.hin_corridor_windows (flag_hin_ped) WHERE flag_hin_ped = True;
CREATE INDEX idx_hincw_bike ON generated.hin_corridor_windows (flag_hin_bike) WHERE flag_hin_bike = True;
CREATE INDEX idx_hincw_veh ON generated.hin_corridor_windows (flag_hin_veh) WHERE flag_hin_veh = True;
