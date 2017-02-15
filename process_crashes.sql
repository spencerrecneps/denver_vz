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
UPDATE  received.crashes_veh
SET     circumstance = CASE WHEN circumstance IS NULL THEN FALSE ELSE circumstance END,
        multveh = CASE WHEN multveh IS NULL THEN FALSE ELSE multveh END,
        singveh = CASE WHEN singveh IS NULL THEN FALSE ELSE singveh END,
        unrestrained = CASE WHEN unrestrained IS NULL THEN FALSE ELSE unrestrained END,
        careless = CASE WHEN careless IS NULL THEN FALSE ELSE careless END,
        reckless = CASE WHEN reckless IS NULL THEN FALSE ELSE reckless END,
        failstopsignal = CASE WHEN failstopsignal IS NULL THEN FALSE ELSE failstopsignal END,
        failyieldROW = CASE WHEN failyieldROW IS NULL THEN FALSE ELSE failyieldROW END,
        highspeed = CASE WHEN highspeed IS NULL THEN FALSE ELSE highspeed END,
        veryhighspeed = CASE WHEN veryhighspeed IS NULL THEN FALSE ELSE veryhighspeed END,
        fatalcrash = CASE WHEN fatalcrash IS NULL THEN FALSE ELSE fatalcrash END,
        injurycrash = CASE WHEN injurycrash IS NULL THEN FALSE ELSE injurycrash END,
        noinjuryfatality = CASE WHEN noinjuryfatality IS NULL THEN FALSE ELSE noinjuryfatality END,
        rearend = CASE WHEN rearend IS NULL THEN FALSE ELSE rearend END,
        rightangle = CASE WHEN rightangle IS NULL THEN FALSE ELSE rightangle END,
        parkedcar = CASE WHEN parkedcar IS NULL THEN FALSE ELSE parkedcar END,
        headon = CASE WHEN headon IS NULL THEN FALSE ELSE headon END,
        sideswipe_samedirec = CASE WHEN sideswipe_samedirec IS NULL THEN FALSE ELSE sideswipe_samedirec END,
        sideswipe_oppdirec = CASE WHEN sideswipe_oppdirec IS NULL THEN FALSE ELSE sideswipe_oppdirec END,
        influence = CASE WHEN influence IS NULL THEN FALSE ELSE influence END;
UPDATE  received.crashes_ped
SET     backing = CASE WHEN backing IS NULL THEN FALSE ELSE backing END,
        darklit_fatal = CASE WHEN darklit_fatal IS NULL THEN FALSE ELSE darklit_fatal END,
        intersection = CASE WHEN intersection IS NULL THEN FALSE ELSE intersection END,
        nonintrsct_fatal = CASE WHEN nonintrsct_fatal IS NULL THEN FALSE ELSE nonintrsct_fatal END,
        ped_cw = CASE WHEN ped_cw IS NULL THEN FALSE ELSE ped_cw END,
        pedinstreet = CASE WHEN pedinstreet IS NULL THEN FALSE ELSE pedinstreet END,
        midblockcrossing = CASE WHEN midblockcrossing IS NULL THEN FALSE ELSE midblockcrossing END,
        crossagainstsignal = CASE WHEN crossagainstsignal IS NULL THEN FALSE ELSE crossagainstsignal END,
        walkinroad = CASE WHEN walkinroad IS NULL THEN FALSE ELSE walkinroad END,
        intersectioncrossing = CASE WHEN intersectioncrossing IS NULL THEN FALSE ELSE intersectioncrossing END,
        influence_driver = CASE WHEN influence_driver IS NULL THEN FALSE ELSE influence_driver END,
        carelessreckless = CASE WHEN carelessreckless IS NULL THEN FALSE ELSE carelessreckless END,
        failyieldrow = CASE WHEN failyieldrow IS NULL THEN FALSE ELSE failyieldrow END,
        disregardsigns = CASE WHEN disregardsigns IS NULL THEN FALSE ELSE disregardsigns END,
        ped_cw_motoristlt = CASE WHEN ped_cw_motoristlt IS NULL THEN FALSE ELSE ped_cw_motoristlt END,
        ped_midblock = CASE WHEN ped_midblock IS NULL THEN FALSE ELSE ped_midblock END,
        ped_cw_motoriststraight = CASE WHEN ped_cw_motoriststraight IS NULL THEN FALSE ELSE ped_cw_motoriststraight END,
        ped_nocw_motoriststraight = CASE WHEN ped_nocw_motoriststraight IS NULL THEN FALSE ELSE ped_nocw_motoriststraight END,
        ped_motoristRT = CASE WHEN ped_motoristRT IS NULL THEN FALSE ELSE ped_motoristRT END,
        ped_nocw_motoristLT = CASE WHEN ped_nocw_motoristLT IS NULL THEN FALSE ELSE ped_nocw_motoristLT END,
        midblock_injuryfatal = CASE WHEN midblock_injuryfatal IS NULL THEN FALSE ELSE midblock_injuryfatal END,
        distracted_driverfault = CASE WHEN distracted_driverfault IS NULL THEN FALSE ELSE distracted_driverfault END,
        distracted_pedfault = CASE WHEN distracted_pedfault IS NULL THEN FALSE ELSE distracted_pedfault END,
        straightgrade = CASE WHEN straightgrade IS NULL THEN FALSE ELSE straightgrade END,
        highspeed = CASE WHEN highspeed IS NULL THEN FALSE ELSE highspeed END,
        fatalcrash = CASE WHEN fatalcrash IS NULL THEN FALSE ELSE fatalcrash END,
        injurycrash = CASE WHEN injurycrash IS NULL THEN FALSE ELSE injurycrash END,
        noinjuryfatality = CASE WHEN noinjuryfatality IS NULL THEN FALSE ELSE noinjuryfatality END;
UPDATE  received.crashes_bike2
SET     injurycrash = CASE WHEN injurycrash IS NULL THEN FALSE ELSE injurycrash END,
        fatalcrash = CASE WHEN fatalcrash IS NULL THEN FALSE ELSE fatalcrash END,
        noinjuryfatality = CASE WHEN noinjuryfatality IS NULL THEN FALSE ELSE noinjuryfatality END,
        unit1_veh = CASE WHEN unit1_veh IS NULL THEN FALSE ELSE unit1_veh END,
        unit2_veh = CASE WHEN unit2_veh IS NULL THEN FALSE ELSE unit2_veh END,
        unit1_bike = CASE WHEN unit1_bike IS NULL THEN FALSE ELSE unit1_bike END,
        unit2_bike = CASE WHEN unit2_bike IS NULL THEN FALSE ELSE unit2_bike END,
        bicyclist = CASE WHEN bicyclist IS NULL THEN FALSE ELSE bicyclist END,
        complex = CASE WHEN complex IS NULL THEN FALSE ELSE complex END,
        nobike = CASE WHEN nobike IS NULL THEN FALSE ELSE nobike END,
        bike_fault = CASE WHEN bike_fault IS NULL THEN FALSE ELSE bike_fault END,
        ww = CASE WHEN ww IS NULL THEN FALSE ELSE ww END,
        xwalk = CASE WHEN xwalk IS NULL THEN FALSE ELSE xwalk END,
        sidewalk = CASE WHEN sidewalk IS NULL THEN FALSE ELSE sidewalk END,
        bike_s_veh_s_st_p = CASE WHEN bike_s_veh_s_st_p IS NULL THEN FALSE ELSE bike_s_veh_s_st_p END,
        bike_s_veh_lt_st_od = CASE WHEN bike_s_veh_lt_st_od IS NULL THEN FALSE ELSE bike_s_veh_lt_st_od END,
        bike_s_veh_rt_st_p = CASE WHEN bike_s_veh_rt_st_p IS NULL THEN FALSE ELSE bike_s_veh_rt_st_p END,
        bike_s_veh_rt_st_sd = CASE WHEN bike_s_veh_rt_st_sd IS NULL THEN FALSE ELSE bike_s_veh_rt_st_sd END,
        bike_s_veh_s_st_sd = CASE WHEN bike_s_veh_s_st_sd IS NULL THEN FALSE ELSE bike_s_veh_s_st_sd END,
        bike_s_veh_rt_st_ww_p = CASE WHEN bike_s_veh_rt_st_ww_p IS NULL THEN FALSE ELSE bike_s_veh_rt_st_ww_p END,
        highspeed = CASE WHEN highspeed IS NULL THEN FALSE ELSE highspeed END,
        influence = CASE WHEN influence IS NULL THEN FALSE ELSE influence END,
        distracted_driverfault = CASE WHEN distracted_driverfault IS NULL THEN FALSE ELSE distracted_driverfault END,
        aggressive_driverfault = CASE WHEN aggressive_driverfault IS NULL THEN FALSE ELSE aggressive_driverfault END,
        inexperience_bikerfault = CASE WHEN inexperience_bikerfault IS NULL THEN FALSE ELSE inexperience_bikerfault END,
        aggressive_bikerfault = CASE WHEN aggressive_bikerfault IS NULL THEN FALSE ELSE aggressive_bikerfault END,
        failyield_driverfault = CASE WHEN failyield_driverfault IS NULL THEN FALSE ELSE failyield_driverfault END,
        carereckless_driverfault = CASE WHEN carereckless_driverfault IS NULL THEN FALSE ELSE carereckless_driverfault END,
        disregardsignal_driverfault = CASE WHEN disregardsignal_driverfault IS NULL THEN FALSE ELSE disregardsignal_driverfault END,
        failyield_bikerfault = CASE WHEN failyield_bikerfault IS NULL THEN FALSE ELSE failyield_bikerfault END,
        disregardsignal_bikerfault = CASE WHEN disregardsignal_bikerfault IS NULL THEN FALSE ELSE disregardsignal_bikerfault END,
        allothercrashtype = CASE WHEN allothercrashtype IS NULL THEN FALSE ELSE allothercrashtype END,
        bike_s_veh_rt_sw_ww_p = CASE WHEN bike_s_veh_rt_sw_ww_p IS NULL THEN FALSE ELSE bike_s_veh_rt_sw_ww_p END,
        bike_s_veh_s_sw_ww_p = CASE WHEN bike_s_veh_s_sw_ww_p IS NULL THEN FALSE ELSE bike_s_veh_s_sw_ww_p END;
UPDATE  received.crashes_bike1
SET     injury = CASE WHEN injury IS NULL THEN FALSE ELSE injury END,
        same_dir = CASE WHEN same_dir IS NULL THEN FALSE ELSE same_dir END,
        opp_dir = CASE WHEN opp_dir IS NULL THEN FALSE ELSE opp_dir END,
        perpen = CASE WHEN perpen IS NULL THEN FALSE ELSE perpen END,
        angle = CASE WHEN angle IS NULL THEN FALSE ELSE angle END,
        bike_s_veh_s_st_p = CASE WHEN bike_s_veh_s_st_p IS NULL THEN FALSE ELSE bike_s_veh_s_st_p END,
        bike_s_veh_lt_St_od = CASE WHEN bike_s_veh_lt_St_od IS NULL THEN FALSE ELSE bike_s_veh_lt_St_od END,
        bike_s_veh_rt_St_p = CASE WHEN bike_s_veh_rt_St_p IS NULL THEN FALSE ELSE bike_s_veh_rt_St_p END,
        bike_s_veh_rt_St_sd = CASE WHEN bike_s_veh_rt_St_sd IS NULL THEN FALSE ELSE bike_s_veh_rt_St_sd END,
        bike_s_veh_s_st_sd = CASE WHEN bike_s_veh_s_st_sd IS NULL THEN FALSE ELSE bike_s_veh_s_st_sd END,
        bike_s_veh_rt_St_WW_p = CASE WHEN bike_s_veh_rt_St_WW_p IS NULL THEN FALSE ELSE bike_s_veh_rt_St_WW_p END,
        bike_s_veh_s_sW_WW_p = CASE WHEN bike_s_veh_s_sW_WW_p IS NULL THEN FALSE ELSE bike_s_veh_s_sW_WW_p END,
        bike_s_veh_rt_SW_WW_p = CASE WHEN bike_s_veh_rt_SW_WW_p IS NULL THEN FALSE ELSE bike_s_veh_rt_SW_WW_p END,
        highspeed = CASE WHEN highspeed IS NULL THEN FALSE ELSE highspeed END,
        injurycrash = CASE WHEN injurycrash IS NULL THEN FALSE ELSE injurycrash END;
UPDATE  received.crashes_bike_flags
SET     injury = CASE WHEN injury IS NULL THEN FALSE ELSE injury END,
        fatality = CASE WHEN fatality IS NULL THEN FALSE ELSE fatality END,
        flag_non = CASE WHEN flag_non IS NULL THEN FALSE ELSE flag_non END,
        bike_s_veh_s_st_p = CASE WHEN bike_s_veh_s_st_p IS NULL THEN FALSE ELSE bike_s_veh_s_st_p END,
        bike_s_veh_lt_St_od = CASE WHEN bike_s_veh_lt_St_od IS NULL THEN FALSE ELSE bike_s_veh_lt_St_od END,
        bike_s_veh_rt_St_p = CASE WHEN bike_s_veh_rt_St_p IS NULL THEN FALSE ELSE bike_s_veh_rt_St_p END,
        bike_s_veh_rt_St_sd = CASE WHEN bike_s_veh_rt_St_sd IS NULL THEN FALSE ELSE bike_s_veh_rt_St_sd END,
        bike_s_veh_s_st_sd = CASE WHEN bike_s_veh_s_st_sd IS NULL THEN FALSE ELSE bike_s_veh_s_st_sd END,
        bike_s_veh_rt_St_WW_p = CASE WHEN bike_s_veh_rt_St_WW_p IS NULL THEN FALSE ELSE bike_s_veh_rt_St_WW_p END,
        bike_s_veh_s_sW_WW_p = CASE WHEN bike_s_veh_s_sW_WW_p IS NULL THEN FALSE ELSE bike_s_veh_s_sW_WW_p END,
        bike_s_veh_rt_SW_WW_p = CASE WHEN bike_s_veh_rt_SW_WW_p IS NULL THEN FALSE ELSE bike_s_veh_rt_SW_WW_p END;


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


----------------------------
-- crashes_bike_flags
----------------------------
ALTER TABLE received.crashes_bike1 ADD COLUMN fatality BOOLEAN;
UPDATE  received.crashes_bike1
SET     fatality = flags.fatality,
        injury = flags.injury
FROM    received.crashes_bike_flags flags
WHERE   crashes_bike1.caseid = flags.caseid;


----------------------------
-- crashes_bike_supplement
----------------------------
ALTER TABLE received.crashes_bike1 ADD COLUMN driveract1 TEXT;
ALTER TABLE received.crashes_bike1 ADD COLUMN driveract2 TEXT;

UPDATE  received.crashes_bike1
SET     driveract1 = supplement.driveract1,
        driveract2 = supplement.driveract2
FROM    received.crashes_bike_supplement supplement
WHERE   crashes_bike1.caseid = supplement.caseid;


----------------------------
-- crashes_fatals
----------------------------
-- set columns
ALTER TABLE received.crashes_fatals DROP COLUMN IF EXISTS int_id;
ALTER TABLE received.crashes_fatals DROP COLUMN IF EXISTS flag_ped;
ALTER TABLE received.crashes_fatals DROP COLUMN IF EXISTS flag_bike;
ALTER TABLE received.crashes_fatals DROP COLUMN IF EXISTS flag_veh;
ALTER TABLE received.crashes_fatals ADD COLUMN int_id INTEGER;
ALTER TABLE received.crashes_fatals ADD COLUMN flag_ped BOOLEAN;
ALTER TABLE received.crashes_fatals ADD COLUMN flag_bike BOOLEAN;
ALTER TABLE received.crashes_fatals ADD COLUMN flag_veh BOOLEAN;

-- update new columns
UPDATE  received.crashes_fatals
SET     int_id = (
            SELECT      ints.int_id
            FROM        denver_streets_intersections ints
            ORDER BY    ST_Distance(ints.geom,crashes_fatals.geom) ASC
            LIMIT       1
        ),
        flag_ped =  CASE    WHEN 'Pedestrian' IN (first_traf, second_tra) THEN TRUE
                            ELSE FALSE
                            END,
        flag_bike = CASE    WHEN 'Bike' IN (first_traf, second_tra) THEN TRUE
                            ELSE FALSE
                            END;

UPDATE  received.crashes_fatals
SET     flag_veh =  CASE    WHEN flag_ped OR flag_bike THEN FALSE
                            ELSE TRUE
                            END;

-- indexes
CREATE INDEX idx_crshftl_ped ON received.crashes_fatals (flag_ped) WHERE flag_ped IS TRUE;
CREATE INDEX idx_crshftl_bike ON received.crashes_fatals (flag_bike) WHERE flag_bike IS TRUE;
CREATE INDEX idx_crshftl_veh ON received.crashes_fatals (flag_veh) WHERE flag_veh IS TRUE;
CREATE INDEX idx_crshftl_intid ON received.crashes_fatals (int_id);
ANALYZE received.crashes_fatals;
