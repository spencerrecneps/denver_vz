-- create table
DROP TABLE IF EXISTS generated.crash_aggregates;
CREATE TABLE generated.crash_aggregates (
    int_id INTEGER PRIMARY KEY,
    geom geometry(point,2231),
    veh_careless INTEGER,
    veh_careless_rank INTEGER,
    veh_reckless INTEGER,
    veh_reckless_rank INTEGER,
    veh_failstopsignal INTEGER,
    veh_failstopsignal_rank INTEGER,
    veh_failyieldrow INTEGER,
    veh_failyieldrow_rank INTEGER,
    veh_singveh_highspeed INTEGER,
    veh_singveh_highspeed_rank INTEGER,
    veh_singveh_influence INTEGER,
    veh_singveh_influence_rank INTEGER,
    veh_singveh_fatal INTEGER,
    veh_singveh_fatal_rank INTEGER,
    veh_singveh_injury INTEGER,
    veh_singveh_injury_rank INTEGER,
    veh_multveh_rearend INTEGER,
    veh_multveh_rearend_rank INTEGER,
    veh_multveh_rightangle INTEGER,
    veh_multveh_rightangle_rank INTEGER,
    veh_multveh_headon INTEGER,
    veh_multveh_headon_rank INTEGER,
    veh_multveh_fatal INTEGER,
    veh_multveh_fatal_rank INTEGER,
    veh_allfatal INTEGER,
    veh_allfatal_rank INTEGER,
    veh_allinjury INTEGER,
    veh_allinjury_rank INTEGER,
    veh_top10 INTEGER,
    veh_num1s INTEGER,
    veh_num2s INTEGER,
    veh_num3s INTEGER,
    veh_num4s INTEGER,
    veh_num5s INTEGER,
    veh_num6s INTEGER,
    veh_num7s INTEGER,
    veh_num8s INTEGER,
    veh_num9s INTEGER,
    veh_num10s INTEGER,
    ped_carelessreckless INTEGER,
    ped_carelessreckless_rank INTEGER,
    ped_failyieldrow INTEGER,
    ped_failyieldrow_rank INTEGER,
    ped_disregardsigns INTEGER,
    ped_disregardsigns_rank INTEGER,
    ped_highspeed INTEGER,
    ped_highspeed_rank INTEGER,
    ped_affected_influence INTEGER,
    ped_affected_influence_rank INTEGER,
    ped_affected_distracted INTEGER,
    ped_affected_distracted_rank INTEGER,
    ped_straightgrade INTEGER,
    ped_straightgrade_rank INTEGER,
    ped_lefthook_xwalk INTEGER,
    ped_lefthook_xwalk_rank INTEGER,
    ped_lefthook_noxwalk INTEGER,
    ped_lefthook_noxwalk_rank INTEGER,
    ped_midblock INTEGER,
    ped_midblock_rank INTEGER,
    ped_carstraight_xwalk INTEGER,
    ped_carstraight_xwalk_rank INTEGER,
    ped_carstraight_noxwalk INTEGER,
    ped_carstraight_noxwalk_rank INTEGER,
    ped_righthook INTEGER,
    ped_righthook_rank INTEGER,
    ped_entermidblock INTEGER,
    ped_entermidblock_rank INTEGER,
    ped_againstsignal INTEGER,
    ped_againstsignal_rank INTEGER,
    ped_walkinroad INTEGER,
    ped_walkinroad_rank INTEGER,
    ped_enterintersection INTEGER,
    ped_enterintersection_rank INTEGER,
    ped_allfatal INTEGER,
    ped_allfatal_rank INTEGER,
    ped_allinjury INTEGER,
    ped_allinjury_rank INTEGER,
    ped_top10 INTEGER,
    ped_num1s INTEGER,
    ped_num2s INTEGER,
    ped_num3s INTEGER,
    ped_num4s INTEGER,
    ped_num5s INTEGER,
    ped_num6s INTEGER,
    ped_num7s INTEGER,
    ped_num8s INTEGER,
    ped_num9s INTEGER,
    ped_num10s INTEGER
);
INSERT INTO generated.crash_aggregates SELECT int_id, geom FROM denver_streets_intersections;
CREATE INDEX sidx_crashagggeom ON generated.crash_aggregates USING GIST (geom);

-- veh_careless
UPDATE  generated.crash_aggregates
SET     veh_careless = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.careless
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_careless DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_careless_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_reckless
UPDATE  generated.crash_aggregates
SET     veh_reckless = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.reckless
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_reckless DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_reckless_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_failstopsignal
UPDATE  generated.crash_aggregates
SET     veh_failstopsignal = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.failstopsignal
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_failstopsignal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_failstopsignal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_failyieldrow
UPDATE  generated.crash_aggregates
SET     veh_failyieldrow = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.failyieldrow
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_failyieldrow DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_failyieldrow_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_singveh_highspeed
UPDATE  generated.crash_aggregates
SET     veh_singveh_highspeed = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.singveh AND c.veryhighspeed
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_singveh_highspeed DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_singveh_highspeed_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_singveh_influence
UPDATE  generated.crash_aggregates
SET     veh_singveh_influence = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.singveh AND c.influence
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_singveh_influence DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_singveh_influence_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_singveh_fatal
UPDATE  generated.crash_aggregates
SET     veh_singveh_fatal = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.singveh AND c.fatalcrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_singveh_fatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_singveh_fatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_singveh_injury
UPDATE  generated.crash_aggregates
SET     veh_singveh_injury = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.singveh AND c.injurycrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_singveh_injury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_singveh_injury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_multveh_rearend
UPDATE  generated.crash_aggregates
SET     veh_multveh_rearend = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.multveh AND c.rearend
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_multveh_rearend DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_multveh_rearend_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_multveh_rightangle
UPDATE  generated.crash_aggregates
SET     veh_multveh_rightangle = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.multveh AND c.rightangle
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_multveh_rightangle DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_multveh_rightangle_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_multveh_headon
UPDATE  generated.crash_aggregates
SET     veh_multveh_headon = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.multveh AND c.headon
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_multveh_headon DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_multveh_headon_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_multveh_fatal
UPDATE  generated.crash_aggregates
SET     veh_multveh_fatal = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.multveh AND c.fatalcrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_multveh_fatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_multveh_fatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_allfatal
UPDATE  generated.crash_aggregates
SET     veh_allfatal = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.fatalcrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_allfatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_allfatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_allinjury
UPDATE  generated.crash_aggregates
SET     veh_allinjury = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.injurycrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_allinjury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_allinjury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_top10
UPDATE  generated.crash_aggregates
SET     veh_top10 = LEAST(
            veh_careless_rank,
            veh_reckless_rank,
            veh_failstopsignal_rank,
            veh_failyieldrow_rank,
            veh_singveh_highspeed_rank,
            veh_singveh_influence_rank,
            veh_singveh_fatal_rank,
            veh_singveh_injury_rank,
            veh_multveh_rearend_rank,
            veh_multveh_rightangle_rank,
            veh_multveh_headon_rank,
            veh_multveh_fatal_rank,
            veh_allfatal_rank,
            veh_allinjury_rank
        );

-- veh_num1s
UPDATE  generated.crash_aggregates
SET     veh_num1s = (
            (veh_careless_rank = 1)::INTEGER +
            (veh_reckless_rank = 1)::INTEGER +
            (veh_failstopsignal_rank = 1)::INTEGER +
            (veh_failyieldrow_rank = 1)::INTEGER +
            (veh_singveh_highspeed_rank = 1)::INTEGER +
            (veh_singveh_influence_rank = 1)::INTEGER +
            (veh_singveh_fatal_rank = 1)::INTEGER +
            (veh_singveh_injury_rank = 1)::INTEGER +
            (veh_multveh_rearend_rank = 1)::INTEGER +
            (veh_multveh_rightangle_rank = 1)::INTEGER +
            (veh_multveh_headon_rank = 1)::INTEGER +
            (veh_multveh_fatal_rank = 1)::INTEGER +
            (veh_allfatal_rank = 1)::INTEGER +
            (veh_allinjury_rank = 1)::INTEGER
        );

-- veh_num2s
UPDATE  generated.crash_aggregates
SET     veh_num2s = (
            (veh_careless_rank = 2)::INTEGER +
            (veh_reckless_rank = 2)::INTEGER +
            (veh_failstopsignal_rank = 2)::INTEGER +
            (veh_failyieldrow_rank = 2)::INTEGER +
            (veh_singveh_highspeed_rank = 2)::INTEGER +
            (veh_singveh_influence_rank = 2)::INTEGER +
            (veh_singveh_fatal_rank = 2)::INTEGER +
            (veh_singveh_injury_rank = 2)::INTEGER +
            (veh_multveh_rearend_rank = 2)::INTEGER +
            (veh_multveh_rightangle_rank = 2)::INTEGER +
            (veh_multveh_headon_rank = 2)::INTEGER +
            (veh_multveh_fatal_rank = 2)::INTEGER +
            (veh_allfatal_rank = 2)::INTEGER +
            (veh_allinjury_rank = 2)::INTEGER
        );

-- veh_num3s
UPDATE  generated.crash_aggregates
SET     veh_num3s = (
            (veh_careless_rank = 3)::INTEGER +
            (veh_reckless_rank = 3)::INTEGER +
            (veh_failstopsignal_rank = 3)::INTEGER +
            (veh_failyieldrow_rank = 3)::INTEGER +
            (veh_singveh_highspeed_rank = 3)::INTEGER +
            (veh_singveh_influence_rank = 3)::INTEGER +
            (veh_singveh_fatal_rank = 3)::INTEGER +
            (veh_singveh_injury_rank = 3)::INTEGER +
            (veh_multveh_rearend_rank = 3)::INTEGER +
            (veh_multveh_rightangle_rank = 3)::INTEGER +
            (veh_multveh_headon_rank = 3)::INTEGER +
            (veh_multveh_fatal_rank = 3)::INTEGER +
            (veh_allfatal_rank = 3)::INTEGER +
            (veh_allinjury_rank = 3)::INTEGER
        );

-- veh_num4s
UPDATE  generated.crash_aggregates
SET     veh_num4s = (
            (veh_careless_rank = 4)::INTEGER +
            (veh_reckless_rank = 4)::INTEGER +
            (veh_failstopsignal_rank = 4)::INTEGER +
            (veh_failyieldrow_rank = 4)::INTEGER +
            (veh_singveh_highspeed_rank = 4)::INTEGER +
            (veh_singveh_influence_rank = 4)::INTEGER +
            (veh_singveh_fatal_rank = 4)::INTEGER +
            (veh_singveh_injury_rank = 4)::INTEGER +
            (veh_multveh_rearend_rank = 4)::INTEGER +
            (veh_multveh_rightangle_rank = 4)::INTEGER +
            (veh_multveh_headon_rank = 4)::INTEGER +
            (veh_multveh_fatal_rank = 4)::INTEGER +
            (veh_allfatal_rank = 4)::INTEGER +
            (veh_allinjury_rank = 4)::INTEGER
        );

-- veh_num5s
UPDATE  generated.crash_aggregates
SET     veh_num5s = (
            (veh_careless_rank = 5)::INTEGER +
            (veh_reckless_rank = 5)::INTEGER +
            (veh_failstopsignal_rank = 5)::INTEGER +
            (veh_failyieldrow_rank = 5)::INTEGER +
            (veh_singveh_highspeed_rank = 5)::INTEGER +
            (veh_singveh_influence_rank = 5)::INTEGER +
            (veh_singveh_fatal_rank = 5)::INTEGER +
            (veh_singveh_injury_rank = 5)::INTEGER +
            (veh_multveh_rearend_rank = 5)::INTEGER +
            (veh_multveh_rightangle_rank = 5)::INTEGER +
            (veh_multveh_headon_rank = 5)::INTEGER +
            (veh_multveh_fatal_rank = 5)::INTEGER +
            (veh_allfatal_rank = 5)::INTEGER +
            (veh_allinjury_rank = 5)::INTEGER
        );

-- veh_num6s
UPDATE  generated.crash_aggregates
SET     veh_num6s = (
            (veh_careless_rank = 6)::INTEGER +
            (veh_reckless_rank = 6)::INTEGER +
            (veh_failstopsignal_rank = 6)::INTEGER +
            (veh_failyieldrow_rank = 6)::INTEGER +
            (veh_singveh_highspeed_rank = 6)::INTEGER +
            (veh_singveh_influence_rank = 6)::INTEGER +
            (veh_singveh_fatal_rank = 6)::INTEGER +
            (veh_singveh_injury_rank = 6)::INTEGER +
            (veh_multveh_rearend_rank = 6)::INTEGER +
            (veh_multveh_rightangle_rank = 6)::INTEGER +
            (veh_multveh_headon_rank = 6)::INTEGER +
            (veh_multveh_fatal_rank = 6)::INTEGER +
            (veh_allfatal_rank = 6)::INTEGER +
            (veh_allinjury_rank = 6)::INTEGER
        );

-- veh_num7s
UPDATE  generated.crash_aggregates
SET     veh_num7s = (
            (veh_careless_rank = 7)::INTEGER +
            (veh_reckless_rank = 7)::INTEGER +
            (veh_failstopsignal_rank = 7)::INTEGER +
            (veh_failyieldrow_rank = 7)::INTEGER +
            (veh_singveh_highspeed_rank = 7)::INTEGER +
            (veh_singveh_influence_rank = 7)::INTEGER +
            (veh_singveh_fatal_rank = 7)::INTEGER +
            (veh_singveh_injury_rank = 7)::INTEGER +
            (veh_multveh_rearend_rank = 7)::INTEGER +
            (veh_multveh_rightangle_rank = 7)::INTEGER +
            (veh_multveh_headon_rank = 7)::INTEGER +
            (veh_multveh_fatal_rank = 7)::INTEGER +
            (veh_allfatal_rank = 7)::INTEGER +
            (veh_allinjury_rank = 7)::INTEGER
        );

-- veh_num8s
UPDATE  generated.crash_aggregates
SET     veh_num8s = (
            (veh_careless_rank = 8)::INTEGER +
            (veh_reckless_rank = 8)::INTEGER +
            (veh_failstopsignal_rank = 8)::INTEGER +
            (veh_failyieldrow_rank = 8)::INTEGER +
            (veh_singveh_highspeed_rank = 8)::INTEGER +
            (veh_singveh_influence_rank = 8)::INTEGER +
            (veh_singveh_fatal_rank = 8)::INTEGER +
            (veh_singveh_injury_rank = 8)::INTEGER +
            (veh_multveh_rearend_rank = 8)::INTEGER +
            (veh_multveh_rightangle_rank = 8)::INTEGER +
            (veh_multveh_headon_rank = 8)::INTEGER +
            (veh_multveh_fatal_rank = 8)::INTEGER +
            (veh_allfatal_rank = 8)::INTEGER +
            (veh_allinjury_rank = 8)::INTEGER
        );

-- veh_num9s
UPDATE  generated.crash_aggregates
SET     veh_num9s = (
            (veh_careless_rank = 9)::INTEGER +
            (veh_reckless_rank = 9)::INTEGER +
            (veh_failstopsignal_rank = 9)::INTEGER +
            (veh_failyieldrow_rank = 9)::INTEGER +
            (veh_singveh_highspeed_rank = 9)::INTEGER +
            (veh_singveh_influence_rank = 9)::INTEGER +
            (veh_singveh_fatal_rank = 9)::INTEGER +
            (veh_singveh_injury_rank = 9)::INTEGER +
            (veh_multveh_rearend_rank = 9)::INTEGER +
            (veh_multveh_rightangle_rank = 9)::INTEGER +
            (veh_multveh_headon_rank = 9)::INTEGER +
            (veh_multveh_fatal_rank = 9)::INTEGER +
            (veh_allfatal_rank = 9)::INTEGER +
            (veh_allinjury_rank = 9)::INTEGER
        );

-- veh_num10s
UPDATE  generated.crash_aggregates
SET     veh_num10s = (
            (veh_careless_rank = 10)::INTEGER +
            (veh_reckless_rank = 10)::INTEGER +
            (veh_failstopsignal_rank = 10)::INTEGER +
            (veh_failyieldrow_rank = 10)::INTEGER +
            (veh_singveh_highspeed_rank = 10)::INTEGER +
            (veh_singveh_influence_rank = 10)::INTEGER +
            (veh_singveh_fatal_rank = 10)::INTEGER +
            (veh_singveh_injury_rank = 10)::INTEGER +
            (veh_multveh_rearend_rank = 10)::INTEGER +
            (veh_multveh_rightangle_rank = 10)::INTEGER +
            (veh_multveh_headon_rank = 10)::INTEGER +
            (veh_multveh_fatal_rank = 10)::INTEGER +
            (veh_allfatal_rank = 10)::INTEGER +
            (veh_allinjury_rank = 10)::INTEGER
        );

-- ped_carelessreckless
UPDATE  generated.crash_aggregates
SET     ped_carelessreckless = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.carelessreckless
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_carelessreckless DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_carelessreckless_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_failyieldrow
UPDATE  generated.crash_aggregates
SET     ped_failyieldrow = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.failyieldrow
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_failyieldrow DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_failyieldrow_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_disregardsigns
UPDATE  generated.crash_aggregates
SET     ped_disregardsigns = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.disregardsigns
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_disregardsigns DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_disregardsigns_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_highspeed
UPDATE  generated.crash_aggregates
SET     ped_highspeed = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.highspeed
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_highspeed DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_highspeed_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_affected_influence
UPDATE  generated.crash_aggregates
SET     ped_affected_influence = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.influence_driver
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_affected_influence DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_affected_influence_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_affected_distracted
UPDATE  generated.crash_aggregates
SET     ped_affected_distracted = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.distracted_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_affected_distracted DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_affected_distracted_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_straightgrade
UPDATE  generated.crash_aggregates
SET     ped_straightgrade = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.straightgrade
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_straightgrade DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_straightgrade_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_lefthook_xwalk
UPDATE  generated.crash_aggregates
SET     ped_lefthook_xwalk = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_cw_motoristlt
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_lefthook_xwalk DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_lefthook_xwalk_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_lefthook_noxwalk
UPDATE  generated.crash_aggregates
SET     ped_lefthook_noxwalk = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_nocw_motoristLT
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_lefthook_noxwalk DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_lefthook_noxwalk_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_midblock
UPDATE  generated.crash_aggregates
SET     ped_midblock = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_midblock
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_midblock DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_midblock_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_carstraight_xwalk
UPDATE  generated.crash_aggregates
SET     ped_carstraight_xwalk = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_cw_motoriststraight
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_carstraight_xwalk DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_carstraight_xwalk_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_carstraight_noxwalk
UPDATE  generated.crash_aggregates
SET     ped_carstraight_noxwalk = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_nocw_motoriststraight
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_carstraight_noxwalk DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_carstraight_noxwalk_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_righthook
UPDATE  generated.crash_aggregates
SET     ped_righthook = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.ped_motoristRT
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_righthook DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_righthook_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_entermidblock
UPDATE  generated.crash_aggregates
SET     ped_entermidblock = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.midblockcrossing
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_entermidblock DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_entermidblock_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_againstsignal
UPDATE  generated.crash_aggregates
SET     ped_againstsignal = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.crossagainstsignal
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_againstsignal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_againstsignal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_walkinroad
UPDATE  generated.crash_aggregates
SET     ped_walkinroad = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.walkinroad
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_walkinroad DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_walkinroad_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_enterintersection
UPDATE  generated.crash_aggregates
SET     ped_enterintersection = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.intersectioncrossing
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_enterintersection DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_enterintersection_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_allfatal
UPDATE  generated.crash_aggregates
SET     ped_allfatal = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.fatalcrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_allfatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_allfatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_allinjury
UPDATE  generated.crash_aggregates
SET     ped_allinjury = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.injurycrash
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_allinjury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_allinjury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_top10
UPDATE  generated.crash_aggregates
SET     ped_top10 = LEAST(
            ped_carelessreckless_rank,
            ped_failyieldrow_rank,
            ped_disregardsigns_rank,
            ped_highspeed_rank,
            ped_affected_influence_rank,
            ped_affected_distracted_rank,
            ped_straightgrade_rank,
            ped_lefthook_xwalk_rank,
            ped_lefthook_noxwalk_rank,
            ped_midblock_rank,
            ped_carstraight_xwalk_rank,
            ped_carstraight_noxwalk_rank,
            ped_righthook_rank,
            ped_entermidblock_rank,
            ped_againstsignal_rank,
            ped_walkinroad_rank,
            ped_enterintersection_rank,
            ped_allfatal_rank,
            ped_allinjury_rank
        );

-- ped_num1s
UPDATE  generated.crash_aggregates
SET     ped_num1s = (
            (ped_carelessreckless_rank = 1)::INTEGER +
            (ped_failyieldrow_rank = 1)::INTEGER +
            (ped_disregardsigns_rank = 1)::INTEGER +
            (ped_highspeed_rank = 1)::INTEGER +
            (ped_affected_influence_rank = 1)::INTEGER +
            (ped_affected_distracted_rank = 1)::INTEGER +
            (ped_straightgrade_rank = 1)::INTEGER +
            (ped_lefthook_xwalk_rank = 1)::INTEGER +
            (ped_lefthook_noxwalk_rank = 1)::INTEGER +
            (ped_midblock_rank = 1)::INTEGER +
            (ped_carstraight_xwalk_rank = 1)::INTEGER +
            (ped_carstraight_noxwalk_rank = 1)::INTEGER +
            (ped_righthook_rank = 1)::INTEGER +
            (ped_entermidblock_rank = 1)::INTEGER +
            (ped_againstsignal_rank = 1)::INTEGER +
            (ped_walkinroad_rank = 1)::INTEGER +
            (ped_enterintersection_rank = 1)::INTEGER +
            (ped_allfatal_rank = 1)::INTEGER +
            (ped_allinjury_rank = 1)::INTEGER
        );

-- ped_num2s
UPDATE  generated.crash_aggregates
SET     ped_num2s = (
            (ped_carelessreckless_rank = 2)::INTEGER +
            (ped_failyieldrow_rank = 2)::INTEGER +
            (ped_disregardsigns_rank = 2)::INTEGER +
            (ped_highspeed_rank = 2)::INTEGER +
            (ped_affected_influence_rank = 2)::INTEGER +
            (ped_affected_distracted_rank = 2)::INTEGER +
            (ped_straightgrade_rank = 2)::INTEGER +
            (ped_lefthook_xwalk_rank = 2)::INTEGER +
            (ped_lefthook_noxwalk_rank = 2)::INTEGER +
            (ped_midblock_rank = 2)::INTEGER +
            (ped_carstraight_xwalk_rank = 2)::INTEGER +
            (ped_carstraight_noxwalk_rank = 2)::INTEGER +
            (ped_righthook_rank = 2)::INTEGER +
            (ped_entermidblock_rank = 2)::INTEGER +
            (ped_againstsignal_rank = 2)::INTEGER +
            (ped_walkinroad_rank = 2)::INTEGER +
            (ped_enterintersection_rank = 2)::INTEGER +
            (ped_allfatal_rank = 2)::INTEGER +
            (ped_allinjury_rank = 2)::INTEGER
        );

-- ped_num3s
UPDATE  generated.crash_aggregates
SET     ped_num3s = (
            (ped_carelessreckless_rank = 3)::INTEGER +
            (ped_failyieldrow_rank = 3)::INTEGER +
            (ped_disregardsigns_rank = 3)::INTEGER +
            (ped_highspeed_rank = 3)::INTEGER +
            (ped_affected_influence_rank = 3)::INTEGER +
            (ped_affected_distracted_rank = 3)::INTEGER +
            (ped_straightgrade_rank = 3)::INTEGER +
            (ped_lefthook_xwalk_rank = 3)::INTEGER +
            (ped_lefthook_noxwalk_rank = 3)::INTEGER +
            (ped_midblock_rank = 3)::INTEGER +
            (ped_carstraight_xwalk_rank = 3)::INTEGER +
            (ped_carstraight_noxwalk_rank = 3)::INTEGER +
            (ped_righthook_rank = 3)::INTEGER +
            (ped_entermidblock_rank = 3)::INTEGER +
            (ped_againstsignal_rank = 3)::INTEGER +
            (ped_walkinroad_rank = 3)::INTEGER +
            (ped_enterintersection_rank = 3)::INTEGER +
            (ped_allfatal_rank = 3)::INTEGER +
            (ped_allinjury_rank = 3)::INTEGER
        );

-- ped_num4s
UPDATE  generated.crash_aggregates
SET     ped_num4s = (
            (ped_carelessreckless_rank = 4)::INTEGER +
            (ped_failyieldrow_rank = 4)::INTEGER +
            (ped_disregardsigns_rank = 4)::INTEGER +
            (ped_highspeed_rank = 4)::INTEGER +
            (ped_affected_influence_rank = 4)::INTEGER +
            (ped_affected_distracted_rank = 4)::INTEGER +
            (ped_straightgrade_rank = 4)::INTEGER +
            (ped_lefthook_xwalk_rank = 4)::INTEGER +
            (ped_lefthook_noxwalk_rank = 4)::INTEGER +
            (ped_midblock_rank = 4)::INTEGER +
            (ped_carstraight_xwalk_rank = 4)::INTEGER +
            (ped_carstraight_noxwalk_rank = 4)::INTEGER +
            (ped_righthook_rank = 4)::INTEGER +
            (ped_entermidblock_rank = 4)::INTEGER +
            (ped_againstsignal_rank = 4)::INTEGER +
            (ped_walkinroad_rank = 4)::INTEGER +
            (ped_enterintersection_rank = 4)::INTEGER +
            (ped_allfatal_rank = 4)::INTEGER +
            (ped_allinjury_rank = 4)::INTEGER
        );

-- ped_num5s
UPDATE  generated.crash_aggregates
SET     ped_num5s = (
            (ped_carelessreckless_rank = 5)::INTEGER +
            (ped_failyieldrow_rank = 5)::INTEGER +
            (ped_disregardsigns_rank = 5)::INTEGER +
            (ped_highspeed_rank = 5)::INTEGER +
            (ped_affected_influence_rank = 5)::INTEGER +
            (ped_affected_distracted_rank = 5)::INTEGER +
            (ped_straightgrade_rank = 5)::INTEGER +
            (ped_lefthook_xwalk_rank = 5)::INTEGER +
            (ped_lefthook_noxwalk_rank = 5)::INTEGER +
            (ped_midblock_rank = 5)::INTEGER +
            (ped_carstraight_xwalk_rank = 5)::INTEGER +
            (ped_carstraight_noxwalk_rank = 5)::INTEGER +
            (ped_righthook_rank = 5)::INTEGER +
            (ped_entermidblock_rank = 5)::INTEGER +
            (ped_againstsignal_rank = 5)::INTEGER +
            (ped_walkinroad_rank = 5)::INTEGER +
            (ped_enterintersection_rank = 5)::INTEGER +
            (ped_allfatal_rank = 5)::INTEGER +
            (ped_allinjury_rank = 5)::INTEGER
        );

-- ped_num6s
UPDATE  generated.crash_aggregates
SET     ped_num6s = (
            (ped_carelessreckless_rank = 6)::INTEGER +
            (ped_failyieldrow_rank = 6)::INTEGER +
            (ped_disregardsigns_rank = 6)::INTEGER +
            (ped_highspeed_rank = 6)::INTEGER +
            (ped_affected_influence_rank = 6)::INTEGER +
            (ped_affected_distracted_rank = 6)::INTEGER +
            (ped_straightgrade_rank = 6)::INTEGER +
            (ped_lefthook_xwalk_rank = 6)::INTEGER +
            (ped_lefthook_noxwalk_rank = 6)::INTEGER +
            (ped_midblock_rank = 6)::INTEGER +
            (ped_carstraight_xwalk_rank = 6)::INTEGER +
            (ped_carstraight_noxwalk_rank = 6)::INTEGER +
            (ped_righthook_rank = 6)::INTEGER +
            (ped_entermidblock_rank = 6)::INTEGER +
            (ped_againstsignal_rank = 6)::INTEGER +
            (ped_walkinroad_rank = 6)::INTEGER +
            (ped_enterintersection_rank = 6)::INTEGER +
            (ped_allfatal_rank = 6)::INTEGER +
            (ped_allinjury_rank = 6)::INTEGER
        );

-- ped_num7s
UPDATE  generated.crash_aggregates
SET     ped_num7s = (
            (ped_carelessreckless_rank = 7)::INTEGER +
            (ped_failyieldrow_rank = 7)::INTEGER +
            (ped_disregardsigns_rank = 7)::INTEGER +
            (ped_highspeed_rank = 7)::INTEGER +
            (ped_affected_influence_rank = 7)::INTEGER +
            (ped_affected_distracted_rank = 7)::INTEGER +
            (ped_straightgrade_rank = 7)::INTEGER +
            (ped_lefthook_xwalk_rank = 7)::INTEGER +
            (ped_lefthook_noxwalk_rank = 7)::INTEGER +
            (ped_midblock_rank = 7)::INTEGER +
            (ped_carstraight_xwalk_rank = 7)::INTEGER +
            (ped_carstraight_noxwalk_rank = 7)::INTEGER +
            (ped_righthook_rank = 7)::INTEGER +
            (ped_entermidblock_rank = 7)::INTEGER +
            (ped_againstsignal_rank = 7)::INTEGER +
            (ped_walkinroad_rank = 7)::INTEGER +
            (ped_enterintersection_rank = 7)::INTEGER +
            (ped_allfatal_rank = 7)::INTEGER +
            (ped_allinjury_rank = 7)::INTEGER
        );

-- ped_num8s
UPDATE  generated.crash_aggregates
SET     ped_num8s = (
            (ped_carelessreckless_rank = 8)::INTEGER +
            (ped_failyieldrow_rank = 8)::INTEGER +
            (ped_disregardsigns_rank = 8)::INTEGER +
            (ped_highspeed_rank = 8)::INTEGER +
            (ped_affected_influence_rank = 8)::INTEGER +
            (ped_affected_distracted_rank = 8)::INTEGER +
            (ped_straightgrade_rank = 8)::INTEGER +
            (ped_lefthook_xwalk_rank = 8)::INTEGER +
            (ped_lefthook_noxwalk_rank = 8)::INTEGER +
            (ped_midblock_rank = 8)::INTEGER +
            (ped_carstraight_xwalk_rank = 8)::INTEGER +
            (ped_carstraight_noxwalk_rank = 8)::INTEGER +
            (ped_righthook_rank = 8)::INTEGER +
            (ped_entermidblock_rank = 8)::INTEGER +
            (ped_againstsignal_rank = 8)::INTEGER +
            (ped_walkinroad_rank = 8)::INTEGER +
            (ped_enterintersection_rank = 8)::INTEGER +
            (ped_allfatal_rank = 8)::INTEGER +
            (ped_allinjury_rank = 8)::INTEGER
        );

-- ped_num9s
UPDATE  generated.crash_aggregates
SET     ped_num9s = (
            (ped_carelessreckless_rank = 9)::INTEGER +
            (ped_failyieldrow_rank = 9)::INTEGER +
            (ped_disregardsigns_rank = 9)::INTEGER +
            (ped_highspeed_rank = 9)::INTEGER +
            (ped_affected_influence_rank = 9)::INTEGER +
            (ped_affected_distracted_rank = 9)::INTEGER +
            (ped_straightgrade_rank = 9)::INTEGER +
            (ped_lefthook_xwalk_rank = 9)::INTEGER +
            (ped_lefthook_noxwalk_rank = 9)::INTEGER +
            (ped_midblock_rank = 9)::INTEGER +
            (ped_carstraight_xwalk_rank = 9)::INTEGER +
            (ped_carstraight_noxwalk_rank = 9)::INTEGER +
            (ped_righthook_rank = 9)::INTEGER +
            (ped_entermidblock_rank = 9)::INTEGER +
            (ped_againstsignal_rank = 9)::INTEGER +
            (ped_walkinroad_rank = 9)::INTEGER +
            (ped_enterintersection_rank = 9)::INTEGER +
            (ped_allfatal_rank = 9)::INTEGER +
            (ped_allinjury_rank = 9)::INTEGER
        );

-- ped_num10s
UPDATE  generated.crash_aggregates
SET     ped_num10s = (
            (ped_carelessreckless_rank = 10)::INTEGER +
            (ped_failyieldrow_rank = 10)::INTEGER +
            (ped_disregardsigns_rank = 10)::INTEGER +
            (ped_highspeed_rank = 10)::INTEGER +
            (ped_affected_influence_rank = 10)::INTEGER +
            (ped_affected_distracted_rank = 10)::INTEGER +
            (ped_straightgrade_rank = 10)::INTEGER +
            (ped_lefthook_xwalk_rank = 10)::INTEGER +
            (ped_lefthook_noxwalk_rank = 10)::INTEGER +
            (ped_midblock_rank = 10)::INTEGER +
            (ped_carstraight_xwalk_rank = 10)::INTEGER +
            (ped_carstraight_noxwalk_rank = 10)::INTEGER +
            (ped_righthook_rank = 10)::INTEGER +
            (ped_entermidblock_rank = 10)::INTEGER +
            (ped_againstsignal_rank = 10)::INTEGER +
            (ped_walkinroad_rank = 10)::INTEGER +
            (ped_enterintersection_rank = 10)::INTEGER +
            (ped_allfatal_rank = 10)::INTEGER +
            (ped_allinjury_rank = 10)::INTEGER
        );



-- -- generic
-- UPDATE  generated.crash_aggregates
-- SET     generic = (
--             SELECT  COUNT(*)
--             FROM    crashes_ped c
--             WHERE   c.int_id = crash_aggregates.int_id
--             AND     c.generic
--         );
-- WITH ranks AS (
--     SELECT  int_id,
--             rank() OVER (ORDER BY generic DESC) AS rank
--     FROM    crash_aggregates
-- )
-- UPDATE  generated.crash_aggregates
-- SET     generic = ranks.rank
-- FROM    ranks
-- WHERE   crash_aggregates.int_id = ranks.int_id;
