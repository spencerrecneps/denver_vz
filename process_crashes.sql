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


----------------------------
-- falsify nulls
----------------------------
UPDATE received.crashes_veh SET circumstance = 'f' WHERE circumstance IS NULL;
UPDATE received.crashes_veh SET multveh = 'f' WHERE multveh IS NULL;
UPDATE received.crashes_veh SET singveh = 'f' WHERE singveh IS NULL;
UPDATE received.crashes_veh SET unrestrained = 'f' WHERE unrestrained IS NULL;
UPDATE received.crashes_veh SET careless = 'f' WHERE careless IS NULL;
UPDATE received.crashes_veh SET reckless = 'f' WHERE reckless IS NULL;
UPDATE received.crashes_veh SET failstopsignal = 'f' WHERE failstopsignal IS NULL;
UPDATE received.crashes_veh SET failyieldROW = 'f' WHERE failyieldROW IS NULL;
UPDATE received.crashes_veh SET highspeed = 'f' WHERE highspeed IS NULL;
UPDATE received.crashes_veh SET veryhighspeed = 'f' WHERE veryhighspeed IS NULL;
UPDATE received.crashes_veh SET fatalcrash = 'f' WHERE fatalcrash IS NULL;
UPDATE received.crashes_veh SET injurycrash = 'f' WHERE injurycrash IS NULL;
UPDATE received.crashes_veh SET noinjuryfatality = 'f' WHERE noinjuryfatality IS NULL;
UPDATE received.crashes_veh SET rearend = 'f' WHERE rearend IS NULL;
UPDATE received.crashes_veh SET rightangle = 'f' WHERE rightangle IS NULL;
UPDATE received.crashes_veh SET parkedcar = 'f' WHERE parkedcar IS NULL;
UPDATE received.crashes_veh SET headon = 'f' WHERE headon IS NULL;
UPDATE received.crashes_veh SET sideswipe_samedirec = 'f' WHERE sideswipe_samedirec IS NULL;
UPDATE received.crashes_veh SET sideswipe_oppdirec = 'f' WHERE sideswipe_oppdirec IS NULL;
UPDATE received.crashes_veh SET influence = 'f' WHERE influence IS NULL;


----------------------------
-- indexes
----------------------------
CREATE INDEX idx_crashpedint ON crashes_ped (int_id);
CREATE INDEX idx_crashpedcareless ON crashes_ped (carelessreckless) WHERE carelessreckless IS TRUE;
CREATE INDEX idx_crashpedfailyield ON crashes_ped (failyieldrow) WHERE failyieldrow IS TRUE;
CREATE INDEX idx_crashpeddsrgdsgns ON crashes_ped (disregardsigns) WHERE disregardsigns IS TRUE;
CREATE INDEX idx_crashpedhispeed ON crashes_ped (highspeed) WHERE highspeed IS TRUE;
CREATE INDEX idx_crashpeddui ON crashes_ped (influence_driver) WHERE influence_driver IS TRUE;
CREATE INDEX idx_crashpeddstrctd ON crashes_ped (distracted_driverfault) WHERE distracted_driverfault IS TRUE;
CREATE INDEX idx_crashpedstrtgrd ON crashes_ped (straightgrade) WHERE straightgrade IS TRUE;
CREATE INDEX idx_crashpedlhxwk ON crashes_ped (ped_cw_motoristlt) WHERE ped_cw_motoristlt IS TRUE;
CREATE INDEX idx_crashpedlhnxwk ON crashes_ped (ped_nocw_motoristLT) WHERE ped_nocw_motoristLT IS TRUE;
CREATE INDEX idx_crashpedmdblk ON crashes_ped (ped_midblock) WHERE ped_midblock IS TRUE;
CREATE INDEX idx_crashpedcrsxwk ON crashes_ped (ped_cw_motoriststraight) WHERE ped_cw_motoriststraight IS TRUE;
CREATE INDEX idx_crashpedcrsnxwk ON crashes_ped (ped_nocw_motoriststraight) WHERE ped_nocw_motoriststraight IS TRUE;
CREATE INDEX idx_crashpedrh ON crashes_ped (ped_motoristRT) WHERE ped_motoristRT IS TRUE;
CREATE INDEX idx_crashpedentmdblk ON crashes_ped (midblockcrossing) WHERE midblockcrossing IS TRUE;
CREATE INDEX idx_crashpedagnstsgnl ON crashes_ped (crossagainstsignal) WHERE crossagainstsignal IS TRUE;
CREATE INDEX idx_crashpedwlkinrd ON crashes_ped (walkinroad) WHERE walkinroad IS TRUE;
CREATE INDEX idx_crashpedintxing ON crashes_ped (intersectioncrossing) WHERE intersectioncrossing IS TRUE;
CREATE INDEX idx_crashpedftlcrsh ON crashes_ped (fatalcrash) WHERE fatalcrash IS TRUE;
CREATE INDEX idx_crashpedinjry ON crashes_ped (injurycrash) WHERE injurycrash IS TRUE;
CREATE INDEX idx_crashvehint ON crashes_veh (int_id);
CREATE INDEX idx_crashvehcrlss ON crashes_veh (careless) WHERE careless IS TRUE;
CREATE INDEX idx_crashvehrcklss ON crashes_veh (reckless) WHERE reckless IS TRUE;
CREATE INDEX idx_crashvehflstpyld ON crashes_veh (failstopsignal) WHERE failstopsignal IS TRUE;
CREATE INDEX idx_crashvehflyldrow ON crashes_veh (failyieldrow) WHERE failyieldrow IS TRUE;
CREATE INDEX idx_crashvehnoinjftl ON crashes_veh (noinjuryfatality) WHERE noinjuryfatality IS TRUE;
CREATE INDEX idx_crashvehsingveh ON crashes_veh (singveh) WHERE singveh IS TRUE;
CREATE INDEX idx_crashvehvhs ON crashes_veh (veryhighspeed) WHERE veryhighspeed IS TRUE;
CREATE INDEX idx_crashvehdui ON crashes_veh (influence) WHERE influence IS TRUE;
CREATE INDEX idx_crashvehftl ON crashes_veh (fatalcrash) WHERE fatalcrash IS TRUE;
CREATE INDEX idx_crashvehinjry ON crashes_veh (injurycrash) WHERE injurycrash IS TRUE;
CREATE INDEX idx_crashvehmultveh ON crashes_veh (multveh) WHERE multveh IS TRUE;
CREATE INDEX idx_crashvehrearend ON crashes_veh (rearend) WHERE rearend IS TRUE;
CREATE INDEX idx_crashvehrtang ON crashes_veh (rightangle) WHERE rightangle IS TRUE;
CREATE INDEX idx_crashvehhedon ON crashes_veh (headon) WHERE headon IS TRUE;
CREATE INDEX idx_crashbike1int ON crashes_bike1 (int_id);
CREATE INDEX idx_crashbike2int ON crashes_bike2 (int_id);
CREATE INDEX idx_crashbike2drvflt ON crashes_bike2 (aggressive_driverfault) WHERE aggressive_driverfault IS TRUE;
CREATE INDEX idx_crashbike2flylddrv ON crashes_bike2 (failyield_driverfault) WHERE failyield_driverfault IS TRUE;
CREATE INDEX idx_crashbike2dsrgdsgndrv ON crashes_bike2 (disregardsignal_driverfault) WHERE disregardsignal_driverfault IS TRUE;
CREATE INDEX idx_crashbike2hispd ON crashes_bike2 (highspeed) WHERE highspeed IS TRUE;
CREATE INDEX idx_crashbike2aggbkflt ON crashes_bike2 (aggressive_bikerfault) WHERE aggressive_bikerfault IS TRUE;
CREATE INDEX idx_crashbike2flyldbik ON crashes_bike2 (failyield_bikerfault) WHERE failyield_bikerfault IS TRUE;
CREATE INDEX idx_crashbike2dsrgsgnbk ON crashes_bike2 (disregardsignal_bikerfault) WHERE disregardsignal_bikerfault IS TRUE;
CREATE INDEX idx_crashbike2dui ON crashes_bike2 (influence) WHERE influence IS TRUE;
CREATE INDEX idx_crashbike2dstdrv ON crashes_bike2 (distracted_driverfault) WHERE distracted_driverfault IS TRUE;
CREATE INDEX idx_crashbike2carreckdrv ON crashes_bike2 (carereckless_driverfault) WHERE carereckless_driverfault IS TRUE;
CREATE INDEX idx_crashbike1bsvssp ON crashes_bike1 (bike_s_veh_s_st_p) WHERE bike_s_veh_s_st_p IS TRUE;
CREATE INDEX idx_crashbike2bsvssp ON crashes_bike2 (bike_s_veh_s_st_p) WHERE bike_s_veh_s_st_p IS TRUE;
CREATE INDEX idx_crashbike1bsvlso ON crashes_bike1 (bike_s_veh_lt_st_od) WHERE bike_s_veh_lt_st_od IS TRUE;
CREATE INDEX idx_crashbike2bsvlso ON crashes_bike2 (bike_s_veh_lt_st_od) WHERE bike_s_veh_lt_st_od IS TRUE;
CREATE INDEX idx_crashbike1bsvsstsd ON crashes_bike1 (bike_s_veh_s_st_sd) WHERE bike_s_veh_s_st_sd IS TRUE;
CREATE INDEX idx_crashbike2bsvsstsd ON crashes_bike2 (bike_s_veh_s_st_sd) WHERE bike_s_veh_s_st_sd IS TRUE;
CREATE INDEX idx_crashbike1bsvrssd ON crashes_bike1 (bike_s_veh_rt_st_sd) WHERE bike_s_veh_rt_st_sd IS TRUE;
CREATE INDEX idx_crashbike2bsvhrtstsd ON crashes_bike2 (bike_s_veh_rt_st_sd) WHERE bike_s_veh_rt_st_sd IS TRUE;
CREATE INDEX idx_crashbike1bsvrsp ON crashes_bike1 (bike_s_veh_rt_st_p) WHERE bike_s_veh_rt_st_p IS TRUE;
CREATE INDEX idx_crashbike2bsvrsp ON crashes_bike2 (bike_s_veh_rt_st_p) WHERE bike_s_veh_rt_st_p IS TRUE;
CREATE INDEX idx_crashbike1bsvrswp ON crashes_bike1 (bike_s_veh_rt_sw_ww_p) WHERE bike_s_veh_rt_sw_ww_p IS TRUE;
CREATE INDEX idx_crashbike2bsvrswp ON crashes_bike2 (bike_s_veh_rt_sw_ww_p) WHERE bike_s_veh_rt_sw_ww_p IS TRUE;
CREATE INDEX idx_crashbike1bsvsswwwp ON crashes_bike1 (bike_s_veh_s_sw_ww_p) WHERE bike_s_veh_s_sw_ww_p IS TRUE;
CREATE INDEX idx_crashbike2bsvsswwwp ON crashes_bike2 (bike_s_veh_s_sw_ww_p) WHERE bike_s_veh_s_sw_ww_p IS TRUE;
CREATE INDEX idx_crashbike2ftl ON crashes_bike2 (fatalcrash) WHERE fatalcrash IS TRUE;
CREATE INDEX idx_crashbike1inj ON crashes_bike1 (injurycrash) WHERE injurycrash IS TRUE;
CREATE INDEX idx_crashbike2inj ON crashes_bike2 (injurycrash) WHERE injurycrash IS TRUE;
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

-- flag_ped
UPDATE  crashes_jeffco SET flag_ped = 'f';
UPDATE  crashes_jeffco
SET     flag_ped = 't'
WHERE   trim(lower(acctype)) = 'pedestrian';

-- flag_bike
UPDATE  crashes_jeffco SET flag_bike = 'f';
UPDATE  crashes_jeffco
SET     flag_bike = 't'
WHERE   trim(lower(acctype)) = 'bicycle';

-- flag_veh
UPDATE  crashes_jeffco SET flag_veh = 'f';
UPDATE  crashes_jeffco
SET     flag_veh = 't'
WHERE   NOT (flag_ped OR flag_bike);

-- flag_injury
UPDATE  crashes_jeffco SET flag_injury = 'f';
UPDATE  crashes_jeffco
SET     flag_injury = 't'
WHERE   trim(lower(severity)) = 'inj';

-- flag_fatal
UPDATE  crashes_jeffco SET flag_fatal = 'f';
UPDATE  crashes_jeffco
SET     flag_fatal = 't'
WHERE   trim(lower(severity)) = 'fat';

-- indexes
CREATE INDEX idx_crshjffco_intid ON crashes_jeffco (int_id);
CREATE INDEX idx_crshjffco_flgped ON crashes_jeffco (flag_ped) WHERE flag_ped IS TRUE;
CREATE INDEX idx_crshjffco_flgbke ON crashes_jeffco (flag_bike) WHERE flag_bike IS TRUE;
CREATE INDEX idx_crshjffco_flgveh ON crashes_jeffco (flag_veh) WHERE flag_veh IS TRUE;
CREATE INDEX idx_crshjffco_flginj ON crashes_jeffco (flag_injury) WHERE flag_injury IS TRUE;
CREATE INDEX idx_crshjffco_flgfat ON crashes_jeffco (flag_fatal) WHERE flag_fatal IS TRUE;
ANALYZE crashes_jeffco;
