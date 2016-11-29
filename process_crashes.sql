----------------------------
-- at_intersection
----------------------------
-- ped
UPDATE  crashes_ped
SET     at_intersection = 't'
WHERE   COALESCE(ped_midblock,'f') = 'f';

-- veh
UPDATE  crashes_veh
SET     at_intersection = 't'
WHERE   COALESCE(roaddescription,'nomatch') IN ('Non-Intersection','Driveway Access Related','Parking Lot');


----------------------------
-- int_id and geom
----------------------------
-- ped
UPDATE  crashes_ped
SET     int_id = ints.int_id,
        geom_int = ints.geom
FROM    denver_streets_intersections ints
WHERE   crashes_ped.node = ints.node_denver_centerline;

-- veh
UPDATE  crashes_veh
SET     int_id = ints.int_id,
        geom_int = ints.geom
FROM    denver_streets_intersections ints
WHERE   crashes_veh.node = ints.node_denver_centerline;

-- bike1
UPDATE  crashes_bike1
SET     int_id = ints.int_id,
        geom_int = ints.geom
FROM    denver_streets_intersections ints
WHERE   crashes_bike1.node = ints.node_denver_centerline;

-- bike2
UPDATE  crashes_bike2
SET     int_id = ints.int_id,
        geom_int = ints.geom
FROM    denver_streets_intersections ints
WHERE   crashes_bike2.node = ints.node_denver_centerline;

-- indexes
CREATE INDEX idx_crashpedint ON crashes_ped (int_id);
CREATE INDEX idx_crashpedcareless ON crashes_ped (carelessreckless);
CREATE INDEX idx_crashpedfailyield ON crashes_ped (failyieldrow);
CREATE INDEX idx_crashpeddsrgdsgns ON crashes_ped (disregardsigns);
CREATE INDEX idx_crashpedhispeed ON crashes_ped (highspeed);
CREATE INDEX idx_crashpeddui ON crashes_ped (influence_driver);
CREATE INDEX idx_crashpeddstrctd ON crashes_ped (distracted_driverfault);
CREATE INDEX idx_crashpedstrtgrd ON crashes_ped (straightgrade);
CREATE INDEX idx_crashpedlhxwk ON crashes_ped (ped_cw_motoristlt);
CREATE INDEX idx_crashpedlhnxwk ON crashes_ped (ped_nocw_motoristLT);
CREATE INDEX idx_crashpedmdblk ON crashes_ped (ped_midblock);
CREATE INDEX idx_crashpedcrsxwk ON crashes_ped (ped_cw_motoriststraight);
CREATE INDEX idx_crashpedcrsnxwk ON crashes_ped (ped_nocw_motoriststraight);
CREATE INDEX idx_crashpedrh ON crashes_ped (ped_motoristRT);
CREATE INDEX idx_crashpedentmdblk ON crashes_ped (midblockcrossing);
CREATE INDEX idx_crashpedagnstsgnl ON crashes_ped (crossagainstsignal);
CREATE INDEX idx_crashpedwlkinrd ON crashes_ped (walkinroad);
CREATE INDEX idx_crashpedintxing ON crashes_ped (intersectioncrossing);
CREATE INDEX idx_crashpedftlcrsh ON crashes_ped (fatalcrash);
CREATE INDEX idx_crashpedinjry ON crashes_ped (injurycrash);
CREATE INDEX idx_crashvehint ON crashes_veh (int_id);
CREATE INDEX idx_crashvehcrlss ON crashes_veh (careless);
CREATE INDEX idx_crashvehrcklss ON crashes_veh (reckless);
CREATE INDEX idx_crashvehflstpyld ON crashes_veh (failstopsignal);
CREATE INDEX idx_crashvehflyldrow ON crashes_veh (failyieldrow);
CREATE INDEX idx_crashvehnoinjftl ON crashes_veh (noinjuryfatality);
CREATE INDEX idx_crashvehsingveh ON crashes_veh (singveh);
CREATE INDEX idx_crashvehvhs ON crashes_veh (veryhighspeed);
CREATE INDEX idx_crashvehdui ON crashes_veh (influence);
CREATE INDEX idx_crashvehftl ON crashes_veh (fatalcrash);
CREATE INDEX idx_crashvehinjry ON crashes_veh (injurycrash);
CREATE INDEX idx_crashvehmultveh ON crashes_veh (multveh);
CREATE INDEX idx_crashvehrearend ON crashes_veh (rearend);
CREATE INDEX idx_crashvehrtang ON crashes_veh (rightangle);
CREATE INDEX idx_crashvehhedon ON crashes_veh (headon);
CREATE INDEX idx_crashbike1int ON crashes_bike1 (int_id);
CREATE INDEX idx_crashbike2int ON crashes_bike2 (int_id);
CREATE INDEX idx_crashbike2drvflt ON crashes_bike2 (aggressive_driverfault);
CREATE INDEX idx_crashbike2flylddrv ON crashes_bike2 (failyield_driverfault);
CREATE INDEX idx_crashbike2dsrgdsgndrv ON crashes_bike2 (disregardsignal_driverfault);
CREATE INDEX idx_crashbike2hispd ON crashes_bike2 (highspeed);
CREATE INDEX idx_crashbike2aggbkflt ON crashes_bike2 (aggressive_bikerfault);
CREATE INDEX idx_crashbike2flyldbik ON crashes_bike2 (failyield_bikerfault);
CREATE INDEX idx_crashbike2dsrgsgnbk ON crashes_bike2 (disregardsignal_bikerfault);
CREATE INDEX idx_crashbike2dui ON crashes_bike2 (influence);
CREATE INDEX idx_crashbike2dstdrv ON crashes_bike2 (distracted_driverfault);
CREATE INDEX idx_crashbike2carreckdrv ON crashes_bike2 (carereckless_driverfault);
CREATE INDEX idx_crashbike1bsvssp ON crashes_bike1 (bike_s_veh_s_st_p);
CREATE INDEX idx_crashbike2bsvssp ON crashes_bike2 (bike_s_veh_s_st_p);
CREATE INDEX idx_crashbike1bsvlso ON crashes_bike1 (bike_s_veh_lt_st_od);
CREATE INDEX idx_crashbike2bsvlso ON crashes_bike2 (bike_s_veh_lt_st_od);
CREATE INDEX idx_crashbike1bsvsstsd ON crashes_bike1 (bike_s_veh_s_st_sd);
CREATE INDEX idx_crashbike2bsvsstsd ON crashes_bike2 (bike_s_veh_s_st_sd);
CREATE INDEX idx_crashbike1bsvrssd ON crashes_bike1 (bike_s_veh_rt_st_sd);
CREATE INDEX idx_crashbike2bsvhrtstsd ON crashes_bike2 (bike_s_veh_rt_st_sd);
CREATE INDEX idx_crashbike1bsvrsp ON crashes_bike1 (bike_s_veh_rt_st_p);
CREATE INDEX idx_crashbike2bsvrsp ON crashes_bike2 (bike_s_veh_rt_st_p);
CREATE INDEX idx_crashbike1bsvrswp ON crashes_bike1 (bike_s_veh_rt_sw_ww_p);
CREATE INDEX idx_crashbike2bsvrswp ON crashes_bike2 (bike_s_veh_rt_sw_ww_p);
CREATE INDEX idx_crashbike1bsvsswwwp ON crashes_bike1 (bike_s_veh_s_sw_ww_p);
CREATE INDEX idx_crashbike2bsvsswwwp ON crashes_bike2 (bike_s_veh_s_sw_ww_p);
CREATE INDEX idx_crashbike2ftl ON crashes_bike2 (fatalcrash);
CREATE INDEX idx_crashbike1inj ON crashes_bike1 (injurycrash);
CREATE INDEX idx_crashbike2inj ON crashes_bike2 (injurycrash);
ANALYZE crashes_ped;
ANALYZE crashes_veh;
ANALYZE crashes_bike1;
ANALYZE crashes_bike2;


----------------------------
-- jefferson county crashes
----------------------------
-- geom_exact
UPDATE  crashes_jeffco
SET     geom_exact = ST_LineInterpolatePoint(
            ch.geom,
            (crashes_jeffco.mp - ch.refpt) / (ch.endrefpt - ch.refpt)
        )
FROM    cdot_highways ch
WHERE   ch.route = '095A'
AND     crashes_jeffco.mp >= ch.refpt
AND     crashes_jeffco.mp < ch.endrefpt;

CREATE INDEX sidx_crashes_jeffco_geomexact ON crashes_jeffco USING GIST (geom_exact);
ANALYZE crashes_jeffco (geom_exact);

-- remove crashes from outside denver limits
DELETE FROM crashes_jeffco
WHERE   NOT EXISTS (
            SELECT  1
            FROM    denver_streets ds
            WHERE   ST_DWithin(crashes_jeffco.geom_exact,ds.geom,1000)
        );

-- snap to denver streets
UPDATE  crashes_jeffco
SET     geom_exact = ST_ClosestPoint(ds.geom,crashes_jeffco.geom_exact),
        road_id1 = ds.road_id
FROM    denver_streets ds
WHERE   ds.road_id = (
            SELECT      ds2.road_id
            FROM        denver_streets ds2
            ORDER BY    crashes_jeffco.geom_exact <-> ds2.geom ASC
            LIMIT       1
        );

-- int_id
UPDATE  crashes_jeffco
SET     int_id = (
            SELECT      int_id
            FROM        denver_streets_intersections dsi
            WHERE       legs > 2
            ORDER BY    crashes_jeffco.geom_exact <-> dsi.geom ASC
            LIMIT       1
        )
WHERE   trim(lower(road_desc)) IN ('at intersection','intersection related');

-- indexes
CREATE INDEX idx_crashes_jeffco_severity ON crashes_jeffco (severity);
ANALYZE crashes_jeffco (severity);
