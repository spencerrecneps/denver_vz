--------------------------
-- This script only work on the existing hin layer,
-- which must already have been created.
--------------------------
ALTER TABLE generated.hin DROP COLUMN IF EXISTS ped_crashes_all;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS ped_crashes_injury;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS ped_crashes_fatal;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS bike_crashes_all;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS bike_crashes_injury;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS bike_crashes_fatal;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS veh_crashes_all;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS veh_crashes_injury;
ALTER TABLE generated.hin DROP COLUMN IF EXISTS veh_crashes_fatal;

ALTER TABLE generated.hin ADD COLUMN ped_crashes_all INTEGER;
ALTER TABLE generated.hin ADD COLUMN ped_crashes_injury INTEGER;
ALTER TABLE generated.hin ADD COLUMN ped_crashes_fatal INTEGER;
ALTER TABLE generated.hin ADD COLUMN bike_crashes_all INTEGER;
ALTER TABLE generated.hin ADD COLUMN bike_crashes_injury INTEGER;
ALTER TABLE generated.hin ADD COLUMN bike_crashes_fatal INTEGER;
ALTER TABLE generated.hin ADD COLUMN veh_crashes_all INTEGER;
ALTER TABLE generated.hin ADD COLUMN veh_crashes_injury INTEGER;
ALTER TABLE generated.hin ADD COLUMN veh_crashes_fatal INTEGER;

-- add crash data
UPDATE  generated.hin
SET     ped_crashes_all = (
            SELECT  SUM(ped_allcrashes)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        ped_crashes_injury = (
            SELECT  SUM(ped_allinjury)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        ped_crashes_fatal = (
            SELECT  SUM(ped_allfatal)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        bike_crashes_all = (
                    SELECT  SUM(bike_allcrashes)
                    FROM    crash_aggregates a
                    WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        bike_crashes_injury = (
            SELECT  SUM(bike_allinjury)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        bike_crashes_fatal = (
            SELECT  SUM(bike_allfatal)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        veh_crashes_all = (
                    SELECT  SUM(veh_allcrashes)
                    FROM    crash_aggregates a
                    WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        veh_crashes_injury = (
            SELECT  SUM(veh_allinjury)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        ),
        veh_crashes_fatal = (
            SELECT  SUM(veh_allfatal)
            FROM    crash_aggregates a
            WHERE   ST_DWithin(a.geom,hin.geom,50)
        );
