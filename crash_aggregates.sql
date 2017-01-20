-- create table
DROP TABLE IF EXISTS generated.crash_aggregates;
CREATE TABLE generated.crash_aggregates (
    int_id INTEGER PRIMARY KEY,
    geom geometry(point,2231),
    node INTEGER,
    int_name TEXT,
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
    veh_multveh_influence INTEGER,
    veh_multveh_influence_rank INTEGER,
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
    veh_allfatalinjury INTEGER,
    veh_allfatalinjury_rank INTEGER,
    veh_allcrashes INTEGER,
    veh_allcrashes_rank INTEGER,
    veh_int_weight INTEGER,
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
    ped_allfatalinjury INTEGER,
    ped_allfatalinjury_rank INTEGER,
    ped_allcrashes INTEGER,
    ped_allcrashes_rank INTEGER,
    ped_int_weight INTEGER,
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
    ped_num10s INTEGER,
    bike_driver_aggressive INTEGER,
    bike_driver_aggressive_rank INTEGER,
    bike_driver_failyield INTEGER,
    bike_driver_failyield_rank INTEGER,
    bike_driver_disregardsignal INTEGER,
    bike_driver_disregardsignal_rank INTEGER,
    bike_highspeed INTEGER,
    bike_highspeed_rank INTEGER,
    bike_biker_aggressive INTEGER,
    bike_biker_aggressive_rank INTEGER,
    bike_biker_failyield INTEGER,
    bike_biker_failyield_rank INTEGER,
    bike_biker_disregardsignal INTEGER,
    bike_biker_disregardsignal_rank INTEGER,
    bike_influence INTEGER,
    bike_influence_rank INTEGER,
    bike_driver_distracted INTEGER,
    bike_driver_distracted_rank INTEGER,
    bike_driver_reckless INTEGER,
    bike_driver_reckless_rank INTEGER,
    bike_tbone INTEGER,
    bike_tbone_rank INTEGER,
    bike_opp_lhook INTEGER,
    bike_opp_lhook_rank INTEGER,
    bike_samedir INTEGER,
    bike_samedir_rank INTEGER,
    bike_samedir_rhook1 INTEGER,
    bike_samedir_rhook1_rank INTEGER,
    bike_samedir_rhook2 INTEGER,
    bike_samedir_rhook2_rank INTEGER,
    bike_perp_rhook INTEGER,
    bike_perp_rhook_rank INTEGER,
    bike_perp_rhook_swalk1 INTEGER,
    bike_perp_rhook_swalk1_rank INTEGER,
    bike_perp_rhook_swalk2 INTEGER,
    bike_perp_rhook_swalk2_rank INTEGER,
    bike_tbone_swalk1 INTEGER,
    bike_tbone_swalk1_rank INTEGER,
    bike_tbone_swalk2 INTEGER,
    bike_tbone_swalk2_rank INTEGER,
    bike_allfatal INTEGER,
    bike_allfatal_rank INTEGER,
    bike_allinjury INTEGER,
    bike_allinjury_rank INTEGER,
    bike_injuryfatal INTEGER,
    bike_injuryfatal_rank INTEGER,
    bike_allcrashes INTEGER,
    bike_allcrashes_rank INTEGER,
    bike_int_weight INTEGER,
    bike_top10 INTEGER,
    bike_num1s INTEGER,
    bike_num2s INTEGER,
    bike_num3s INTEGER,
    bike_num4s INTEGER,
    bike_num5s INTEGER,
    bike_num6s INTEGER,
    bike_num7s INTEGER,
    bike_num8s INTEGER,
    bike_num9s INTEGER,
    bike_num10s INTEGER,
    int_weight INTEGER
);
INSERT INTO generated.crash_aggregates SELECT int_id, geom FROM denver_streets_intersections;
CREATE INDEX sidx_crashagggeom ON generated.crash_aggregates USING GIST (geom);
CREATE INDEX idx_crashintid ON generated.crash_aggregates (int_id);
ANALYZE crash_aggregates (int_id);

-- node and int_name
UPDATE  generated.crash_aggregates
SET     node = i.node_denver_centerline,
        int_name = dci."INTERNAME"
FROM    generated.denver_streets_intersections i,
        received.denver_centerline_intersections dci
WHERE   crash_aggregates.int_id = i.int_id
AND     i.node_denver_centerline = dci."MASTERID";

-- veh_careless
UPDATE  generated.crash_aggregates
SET     veh_careless = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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

-- veh_multveh_influence
UPDATE  generated.crash_aggregates
SET     veh_multveh_influence = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.multveh AND c.influence
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_multveh_influence DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_multveh_influence_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_multveh_rearend
UPDATE  generated.crash_aggregates
SET     veh_multveh_rearend = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
            AND     NOT c.noinjuryfatality
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
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_veh
            AND     jc.flag_fatal
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
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_veh
            AND     jc.flag_injury
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

-- veh_allfatalinjury
UPDATE  generated.crash_aggregates
SET     veh_allfatalinjury = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     (c.injurycrash OR c.fatalcrash)
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_veh
            AND     (jc.flag_injury OR jc.flag_fatal)
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_allfatalinjury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_allfatalinjury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_allcrashes
UPDATE  generated.crash_aggregates
SET     veh_allcrashes = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_veh
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY veh_allcrashes DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     veh_allcrashes_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- veh_int_weight
UPDATE  generated.crash_aggregates
SET     veh_int_weight = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_veh
            AND     flag_injury
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_veh
            AND     flag_fatal
        );

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
            veh_allinjury_rank,
            veh_allfatalinjury_rank,
            veh_allcrashes_rank
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
            (veh_allinjury_rank = 1)::INTEGER +
            (veh_allfatalinjury_rank = 1)::INTEGER +
            (veh_allcrashes_rank = 1)::INTEGER
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
            (veh_allinjury_rank = 2)::INTEGER +
            (veh_allfatalinjury_rank = 2)::INTEGER +
            (veh_allcrashes_rank = 2)::INTEGER
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
            (veh_allinjury_rank = 3)::INTEGER +
            (veh_allfatalinjury_rank = 3)::INTEGER +
            (veh_allcrashes_rank = 3)::INTEGER
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
            (veh_allinjury_rank = 4)::INTEGER +
            (veh_allfatalinjury_rank = 4)::INTEGER +
            (veh_allcrashes_rank = 4)::INTEGER
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
            (veh_allinjury_rank = 5)::INTEGER +
            (veh_allfatalinjury_rank = 5)::INTEGER +
            (veh_allcrashes_rank = 5)::INTEGER
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
            (veh_allinjury_rank = 6)::INTEGER +
            (veh_allfatalinjury_rank = 6)::INTEGER +
            (veh_allcrashes_rank = 6)::INTEGER
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
            (veh_allinjury_rank = 7)::INTEGER +
            (veh_allfatalinjury_rank = 7)::INTEGER +
            (veh_allcrashes_rank = 7)::INTEGER
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
            (veh_allinjury_rank = 8)::INTEGER +
            (veh_allfatalinjury_rank = 8)::INTEGER +
            (veh_allcrashes_rank = 8)::INTEGER
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
            (veh_allinjury_rank = 9)::INTEGER +
            (veh_allfatalinjury_rank = 9)::INTEGER +
            (veh_allcrashes_rank = 9)::INTEGER
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
            (veh_allinjury_rank = 10)::INTEGER +
            (veh_allfatalinjury_rank = 10)::INTEGER +
            (veh_allcrashes_rank = 10)::INTEGER
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
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_ped
            AND     jc.flag_fatal
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
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_ped
            AND     jc.flag_injury
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

-- ped_allfatalinjury
UPDATE  generated.crash_aggregates
SET     ped_allfatalinjury = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     (c.injurycrash OR c.fatalcrash)
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_ped
            AND     (jc.flag_injury OR jc.flag_fatal)
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_allfatalinjury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_allfatalinjury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_allcrashes
UPDATE  generated.crash_aggregates
SET     ped_allcrashes = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_ped
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY ped_allcrashes DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     ped_allcrashes_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- ped_int_weight
UPDATE  generated.crash_aggregates
SET     ped_int_weight = (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_ped
            AND     flag_injury
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_ped
            AND     flag_fatal
        );

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
            ped_allinjury_rank,
            ped_allfatalinjury_rank,
            ped_allcrashes_rank
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
            (ped_allinjury_rank = 1)::INTEGER +
            (ped_allfatalinjury_rank = 1)::INTEGER +
            (ped_allcrashes_rank = 1)::INTEGER
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
            (ped_allinjury_rank = 2)::INTEGER +
            (ped_allfatalinjury_rank = 2)::INTEGER +
            (ped_allcrashes_rank = 2)::INTEGER
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
            (ped_allinjury_rank = 3)::INTEGER +
            (ped_allfatalinjury_rank = 3)::INTEGER +
            (ped_allcrashes_rank = 3)::INTEGER
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
            (ped_allinjury_rank = 4)::INTEGER +
            (ped_allfatalinjury_rank = 4)::INTEGER +
            (ped_allcrashes_rank = 4)::INTEGER
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
            (ped_allinjury_rank = 5)::INTEGER +
            (ped_allfatalinjury_rank = 5)::INTEGER +
            (ped_allcrashes_rank = 5)::INTEGER
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
            (ped_allinjury_rank = 6)::INTEGER +
            (ped_allfatalinjury_rank = 6)::INTEGER +
            (ped_allcrashes_rank = 6)::INTEGER
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
            (ped_allinjury_rank = 7)::INTEGER +
            (ped_allfatalinjury_rank = 7)::INTEGER +
            (ped_allcrashes_rank = 7)::INTEGER
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
            (ped_allinjury_rank = 8)::INTEGER +
            (ped_allfatalinjury_rank = 8)::INTEGER +
            (ped_allcrashes_rank = 8)::INTEGER
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
            (ped_allinjury_rank = 9)::INTEGER +
            (ped_allfatalinjury_rank = 9)::INTEGER +
            (ped_allcrashes_rank = 9)::INTEGER
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
            (ped_allinjury_rank = 10)::INTEGER +
            (ped_allfatalinjury_rank = 10)::INTEGER +
            (ped_allcrashes_rank = 10)::INTEGER
        );

-- bike_driver_aggressive
UPDATE  generated.crash_aggregates
SET     bike_driver_aggressive = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.aggressive_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_driver_aggressive DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_driver_aggressive_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_driver_failyield
UPDATE  generated.crash_aggregates
SET     bike_driver_failyield = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.failyield_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_driver_failyield DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_driver_failyield_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_driver_disregardsignal
UPDATE  generated.crash_aggregates
SET     bike_driver_disregardsignal = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.disregardsignal_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_driver_disregardsignal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_driver_disregardsignal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_highspeed
UPDATE  generated.crash_aggregates
SET     bike_highspeed = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.highspeed
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_highspeed DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_highspeed_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_biker_aggressive
UPDATE  generated.crash_aggregates
SET     bike_biker_aggressive = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.aggressive_bikerfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_biker_aggressive DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_biker_aggressive_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_biker_failyield
UPDATE  generated.crash_aggregates
SET     bike_biker_failyield = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.failyield_bikerfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_biker_failyield DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_biker_failyield_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_biker_disregardsignal
UPDATE  generated.crash_aggregates
SET     bike_biker_disregardsignal = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.disregardsignal_bikerfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_biker_disregardsignal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_biker_disregardsignal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_influence
UPDATE  generated.crash_aggregates
SET     bike_influence = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.influence
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_influence DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_influence_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_driver_distracted
UPDATE  generated.crash_aggregates
SET     bike_driver_distracted = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.distracted_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_driver_distracted DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_driver_distracted_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_driver_reckless
UPDATE  generated.crash_aggregates
SET     bike_driver_reckless = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.carereckless_driverfault
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_driver_reckless DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_driver_reckless_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_tbone
UPDATE  generated.crash_aggregates
SET     bike_tbone = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_st_p
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_st_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_tbone DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_tbone_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_opp_lhook
UPDATE  generated.crash_aggregates
SET     bike_opp_lhook = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_lt_st_od
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_lt_st_od
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_opp_lhook DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_opp_lhook_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_samedir
UPDATE  generated.crash_aggregates
SET     bike_samedir = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_st_sd
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_st_sd
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_samedir DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_samedir_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_samedir_rhook1
UPDATE  generated.crash_aggregates
SET     bike_samedir_rhook1 = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_st_sd
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_samedir_rhook1 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_samedir_rhook1_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_samedir_rhook2
UPDATE  generated.crash_aggregates
SET     bike_samedir_rhook2 = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_st_sd
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_samedir_rhook2 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_samedir_rhook2_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_perp_rhook
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_st_p
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_st_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_perp_rhook DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_perp_rhook_swalk1
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook_swalk1 = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_sw_ww_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_perp_rhook_swalk1 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook_swalk1_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_perp_rhook_swalk2
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook_swalk2 = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_rt_sw_ww_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_perp_rhook_swalk2 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_perp_rhook_swalk2_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_tbone_swalk
UPDATE  generated.crash_aggregates
SET     bike_tbone_swalk1 = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_sw_ww_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_tbone_swalk1 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_tbone_swalk1_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_tbone_swalk
UPDATE  generated.crash_aggregates
SET     bike_tbone_swalk2 = (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.bike_s_veh_s_sw_ww_p
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_tbone_swalk2 DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_tbone_swalk2_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_allfatal
UPDATE  generated.crash_aggregates
SET     bike_allfatal = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.fatality
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_bike
            AND     jc.flag_fatal
            --AND     EXTRACT(YEAR FROM "date") >= 2013
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_allfatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_allfatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_allinjury
UPDATE  generated.crash_aggregates
SET     bike_allinjury = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.injury
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     c.injurycrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_bike
            AND     jc.flag_injury
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_allinjury DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_allinjury_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_injuryfatal
UPDATE  generated.crash_aggregates
SET     bike_injuryfatal = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     (c.injury OR c.fatality)
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     (c.injurycrash OR c.fatalcrash)
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_bike
            AND     (jc.flag_injury OR jc.flag_fatal)
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_injuryfatal DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_injuryfatal_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_allcrashes
UPDATE  generated.crash_aggregates
SET     bike_allcrashes = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco jc
            WHERE   jc.int_id = crash_aggregates.int_id
            AND     jc.flag_bike
        );
WITH ranks AS (
    SELECT  int_id,
            rank() OVER (ORDER BY bike_allcrashes DESC) AS rank
    FROM    crash_aggregates
)
UPDATE  generated.crash_aggregates
SET     bike_allcrashes_rank = ranks.rank
FROM    ranks
WHERE   crash_aggregates.int_id = ranks.int_id;

-- bike_int_weight
UPDATE  generated.crash_aggregates
SET     bike_int_weight = (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatality
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_bike
            AND     flag_injury
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_bike
            AND     flag_fatal
        );

-- bike_top10
UPDATE  generated.crash_aggregates
SET     bike_top10 = LEAST(
            bike_driver_aggressive_rank,
            bike_driver_failyield_rank,
            bike_driver_disregardsignal_rank,
            bike_highspeed_rank,
            bike_biker_aggressive_rank,
            bike_biker_failyield_rank,
            bike_biker_disregardsignal_rank,
            bike_tbone_rank,
            bike_opp_lhook_rank,
            bike_samedir_rank,
            bike_samedir_rhook1_rank,
            bike_samedir_rhook2_rank,
            bike_perp_rhook_rank,
            bike_perp_rhook_swalk1_rank,
            bike_perp_rhook_swalk2_rank,
            bike_tbone_swalk1_rank,
            bike_tbone_swalk2_rank,
            bike_allfatal_rank,
            bike_allinjury_rank,
            bike_injuryfatal_rank,
            bike_allcrashes_rank
        );

-- bike_num1s
UPDATE  generated.crash_aggregates
SET     bike_num1s = (
            (bike_driver_aggressive_rank = 1)::INTEGER +
            (bike_driver_failyield_rank = 1)::INTEGER +
            (bike_driver_disregardsignal_rank = 1)::INTEGER +
            (bike_highspeed_rank = 1)::INTEGER +
            (bike_biker_aggressive_rank = 1)::INTEGER +
            (bike_biker_failyield_rank = 1)::INTEGER +
            (bike_biker_disregardsignal_rank = 1)::INTEGER +
            (bike_tbone_rank = 1)::INTEGER +
            (bike_opp_lhook_rank = 1)::INTEGER +
            (bike_samedir_rank = 1)::INTEGER +
            (bike_samedir_rhook1_rank = 1)::INTEGER +
            (bike_samedir_rhook2_rank = 1)::INTEGER +
            (bike_perp_rhook_rank = 1)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 1)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 1)::INTEGER +
            (bike_tbone_swalk1_rank = 1)::INTEGER +
            (bike_tbone_swalk2_rank = 1)::INTEGER +
            (bike_allfatal_rank = 1)::INTEGER +
            (bike_allinjury_rank = 1)::INTEGER +
            (bike_injuryfatal_rank = 1)::INTEGER +
            (bike_allcrashes_rank = 1)::INTEGER
        );

-- bike_num2s
UPDATE  generated.crash_aggregates
SET     bike_num2s = (
            (bike_driver_aggressive_rank = 2)::INTEGER +
            (bike_driver_failyield_rank = 2)::INTEGER +
            (bike_driver_disregardsignal_rank = 2)::INTEGER +
            (bike_highspeed_rank = 2)::INTEGER +
            (bike_biker_aggressive_rank = 2)::INTEGER +
            (bike_biker_failyield_rank = 2)::INTEGER +
            (bike_biker_disregardsignal_rank = 2)::INTEGER +
            (bike_tbone_rank = 2)::INTEGER +
            (bike_opp_lhook_rank = 2)::INTEGER +
            (bike_samedir_rank = 2)::INTEGER +
            (bike_samedir_rhook1_rank = 2)::INTEGER +
            (bike_samedir_rhook2_rank = 2)::INTEGER +
            (bike_perp_rhook_rank = 2)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 2)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 2)::INTEGER +
            (bike_tbone_swalk1_rank = 2)::INTEGER +
            (bike_tbone_swalk2_rank = 2)::INTEGER +
            (bike_allfatal_rank = 2)::INTEGER +
            (bike_allinjury_rank = 2)::INTEGER +
            (bike_injuryfatal_rank = 2)::INTEGER +
            (bike_allcrashes_rank = 2)::INTEGER
        );

-- bike_num3s
UPDATE  generated.crash_aggregates
SET     bike_num3s = (
            (bike_driver_aggressive_rank = 3)::INTEGER +
            (bike_driver_failyield_rank = 3)::INTEGER +
            (bike_driver_disregardsignal_rank = 3)::INTEGER +
            (bike_highspeed_rank = 3)::INTEGER +
            (bike_biker_aggressive_rank = 3)::INTEGER +
            (bike_biker_failyield_rank = 3)::INTEGER +
            (bike_biker_disregardsignal_rank = 3)::INTEGER +
            (bike_tbone_rank = 3)::INTEGER +
            (bike_opp_lhook_rank = 3)::INTEGER +
            (bike_samedir_rank = 3)::INTEGER +
            (bike_samedir_rhook1_rank = 3)::INTEGER +
            (bike_samedir_rhook2_rank = 3)::INTEGER +
            (bike_perp_rhook_rank = 3)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 3)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 3)::INTEGER +
            (bike_tbone_swalk1_rank = 3)::INTEGER +
            (bike_tbone_swalk2_rank = 3)::INTEGER +
            (bike_allfatal_rank = 3)::INTEGER +
            (bike_allinjury_rank = 3)::INTEGER +
            (bike_injuryfatal_rank = 3)::INTEGER +
            (bike_allcrashes_rank = 3)::INTEGER
        );

-- bike_num4s
UPDATE  generated.crash_aggregates
SET     bike_num4s = (
            (bike_driver_aggressive_rank = 4)::INTEGER +
            (bike_driver_failyield_rank = 4)::INTEGER +
            (bike_driver_disregardsignal_rank = 4)::INTEGER +
            (bike_highspeed_rank = 4)::INTEGER +
            (bike_biker_aggressive_rank = 4)::INTEGER +
            (bike_biker_failyield_rank = 4)::INTEGER +
            (bike_biker_disregardsignal_rank = 4)::INTEGER +
            (bike_tbone_rank = 4)::INTEGER +
            (bike_opp_lhook_rank = 4)::INTEGER +
            (bike_samedir_rank = 4)::INTEGER +
            (bike_samedir_rhook1_rank = 4)::INTEGER +
            (bike_samedir_rhook2_rank = 4)::INTEGER +
            (bike_perp_rhook_rank = 4)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 4)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 4)::INTEGER +
            (bike_tbone_swalk1_rank = 4)::INTEGER +
            (bike_tbone_swalk2_rank = 4)::INTEGER +
            (bike_allfatal_rank = 4)::INTEGER +
            (bike_allinjury_rank = 4)::INTEGER +
            (bike_injuryfatal_rank = 4)::INTEGER +
            (bike_allcrashes_rank = 4)::INTEGER
        );

-- bike_num5s
UPDATE  generated.crash_aggregates
SET     bike_num5s = (
            (bike_driver_aggressive_rank = 5)::INTEGER +
            (bike_driver_failyield_rank = 5)::INTEGER +
            (bike_driver_disregardsignal_rank = 5)::INTEGER +
            (bike_highspeed_rank = 5)::INTEGER +
            (bike_biker_aggressive_rank = 5)::INTEGER +
            (bike_biker_failyield_rank = 5)::INTEGER +
            (bike_biker_disregardsignal_rank = 5)::INTEGER +
            (bike_tbone_rank = 5)::INTEGER +
            (bike_opp_lhook_rank = 5)::INTEGER +
            (bike_samedir_rank = 5)::INTEGER +
            (bike_samedir_rhook1_rank = 5)::INTEGER +
            (bike_samedir_rhook2_rank = 5)::INTEGER +
            (bike_perp_rhook_rank = 5)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 5)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 5)::INTEGER +
            (bike_tbone_swalk1_rank = 5)::INTEGER +
            (bike_tbone_swalk2_rank = 5)::INTEGER +
            (bike_allfatal_rank = 5)::INTEGER +
            (bike_allinjury_rank = 5)::INTEGER +
            (bike_injuryfatal_rank = 5)::INTEGER +
            (bike_allcrashes_rank = 5)::INTEGER
        );

-- bike_num6s
UPDATE  generated.crash_aggregates
SET     bike_num6s = (
            (bike_driver_aggressive_rank = 6)::INTEGER +
            (bike_driver_failyield_rank = 6)::INTEGER +
            (bike_driver_disregardsignal_rank = 6)::INTEGER +
            (bike_highspeed_rank = 6)::INTEGER +
            (bike_biker_aggressive_rank = 6)::INTEGER +
            (bike_biker_failyield_rank = 6)::INTEGER +
            (bike_biker_disregardsignal_rank = 6)::INTEGER +
            (bike_tbone_rank = 6)::INTEGER +
            (bike_opp_lhook_rank = 6)::INTEGER +
            (bike_samedir_rank = 6)::INTEGER +
            (bike_samedir_rhook1_rank = 6)::INTEGER +
            (bike_samedir_rhook2_rank = 6)::INTEGER +
            (bike_perp_rhook_rank = 6)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 6)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 6)::INTEGER +
            (bike_tbone_swalk1_rank = 6)::INTEGER +
            (bike_tbone_swalk2_rank = 6)::INTEGER +
            (bike_allfatal_rank = 6)::INTEGER +
            (bike_allinjury_rank = 6)::INTEGER +
            (bike_injuryfatal_rank = 6)::INTEGER +
            (bike_allcrashes_rank = 6)::INTEGER
        );

-- bike_num7s
UPDATE  generated.crash_aggregates
SET     bike_num7s = (
            (bike_driver_aggressive_rank = 7)::INTEGER +
            (bike_driver_failyield_rank = 7)::INTEGER +
            (bike_driver_disregardsignal_rank = 7)::INTEGER +
            (bike_highspeed_rank = 7)::INTEGER +
            (bike_biker_aggressive_rank = 7)::INTEGER +
            (bike_biker_failyield_rank = 7)::INTEGER +
            (bike_biker_disregardsignal_rank = 7)::INTEGER +
            (bike_tbone_rank = 7)::INTEGER +
            (bike_opp_lhook_rank = 7)::INTEGER +
            (bike_samedir_rank = 7)::INTEGER +
            (bike_samedir_rhook1_rank = 7)::INTEGER +
            (bike_samedir_rhook2_rank = 7)::INTEGER +
            (bike_perp_rhook_rank = 7)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 7)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 7)::INTEGER +
            (bike_tbone_swalk1_rank = 7)::INTEGER +
            (bike_tbone_swalk2_rank = 7)::INTEGER +
            (bike_allfatal_rank = 7)::INTEGER +
            (bike_allinjury_rank = 7)::INTEGER +
            (bike_injuryfatal_rank = 7)::INTEGER +
            (bike_allcrashes_rank = 7)::INTEGER
        );

-- bike_num8s
UPDATE  generated.crash_aggregates
SET     bike_num8s = (
            (bike_driver_aggressive_rank = 8)::INTEGER +
            (bike_driver_failyield_rank = 8)::INTEGER +
            (bike_driver_disregardsignal_rank = 8)::INTEGER +
            (bike_highspeed_rank = 8)::INTEGER +
            (bike_biker_aggressive_rank = 8)::INTEGER +
            (bike_biker_failyield_rank = 8)::INTEGER +
            (bike_biker_disregardsignal_rank = 8)::INTEGER +
            (bike_tbone_rank = 8)::INTEGER +
            (bike_opp_lhook_rank = 8)::INTEGER +
            (bike_samedir_rank = 8)::INTEGER +
            (bike_samedir_rhook1_rank = 8)::INTEGER +
            (bike_samedir_rhook2_rank = 8)::INTEGER +
            (bike_perp_rhook_rank = 8)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 8)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 8)::INTEGER +
            (bike_tbone_swalk1_rank = 8)::INTEGER +
            (bike_tbone_swalk2_rank = 8)::INTEGER +
            (bike_allfatal_rank = 8)::INTEGER +
            (bike_allinjury_rank = 8)::INTEGER +
            (bike_injuryfatal_rank = 8)::INTEGER +
            (bike_allcrashes_rank = 8)::INTEGER
        );

-- bike_num9s
UPDATE  generated.crash_aggregates
SET     bike_num9s = (
            (bike_driver_aggressive_rank = 9)::INTEGER +
            (bike_driver_failyield_rank = 9)::INTEGER +
            (bike_driver_disregardsignal_rank = 9)::INTEGER +
            (bike_highspeed_rank = 9)::INTEGER +
            (bike_biker_aggressive_rank = 9)::INTEGER +
            (bike_biker_failyield_rank = 9)::INTEGER +
            (bike_biker_disregardsignal_rank = 9)::INTEGER +
            (bike_tbone_rank = 9)::INTEGER +
            (bike_opp_lhook_rank = 9)::INTEGER +
            (bike_samedir_rank = 9)::INTEGER +
            (bike_samedir_rhook1_rank = 9)::INTEGER +
            (bike_samedir_rhook2_rank = 9)::INTEGER +
            (bike_perp_rhook_rank = 9)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 9)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 9)::INTEGER +
            (bike_tbone_swalk1_rank = 9)::INTEGER +
            (bike_tbone_swalk2_rank = 9)::INTEGER +
            (bike_allfatal_rank = 9)::INTEGER +
            (bike_allinjury_rank = 9)::INTEGER +
            (bike_injuryfatal_rank = 9)::INTEGER +
            (bike_allcrashes_rank = 9)::INTEGER
        );

-- bike_num10s
UPDATE  generated.crash_aggregates
SET     bike_num10s = (
            (bike_driver_aggressive_rank = 10)::INTEGER +
            (bike_driver_failyield_rank = 10)::INTEGER +
            (bike_driver_disregardsignal_rank = 10)::INTEGER +
            (bike_highspeed_rank = 10)::INTEGER +
            (bike_biker_aggressive_rank = 10)::INTEGER +
            (bike_biker_failyield_rank = 10)::INTEGER +
            (bike_biker_disregardsignal_rank = 10)::INTEGER +
            (bike_tbone_rank = 10)::INTEGER +
            (bike_opp_lhook_rank = 10)::INTEGER +
            (bike_samedir_rank = 10)::INTEGER +
            (bike_samedir_rhook1_rank = 10)::INTEGER +
            (bike_samedir_rhook2_rank = 10)::INTEGER +
            (bike_perp_rhook_rank = 10)::INTEGER +
            (bike_perp_rhook_swalk1_rank = 10)::INTEGER +
            (bike_perp_rhook_swalk2_rank = 10)::INTEGER +
            (bike_tbone_swalk1_rank = 10)::INTEGER +
            (bike_tbone_swalk2_rank = 10)::INTEGER +
            (bike_allfatal_rank = 10)::INTEGER +
            (bike_allinjury_rank = 10)::INTEGER +
            (bike_injuryfatal_rank = 10)::INTEGER +
            (bike_allcrashes_rank = 10)::INTEGER
        );

-- int_weight
UPDATE  generated.crash_aggregates
SET     int_weight = (
            SELECT  COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_veh c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_ped c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_bike1 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatality
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     injurycrash
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_bike2 c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     fatalcrash
        ) + (
            SELECT  COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_injury
        ) + (
            SELECT  3 * COUNT(*)
            FROM    crashes_jeffco c
            WHERE   c.int_id = crash_aggregates.int_id
            AND     flag_fatal
        );
