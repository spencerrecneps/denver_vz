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
CREATE INDEX idx_crashvehint ON crashes_veh (int_id);
CREATE INDEX idx_crashbike1int ON crashes_bike1 (int_id);
CREATE INDEX idx_crashbike2int ON crashes_bike2 (int_id);
ANALYZE crashes_ped (int_id);
ANALYZE crashes_veh (int_id);
ANALYZE crashes_bike1 (int_id);
ANALYZE crashes_bike2 (int_id);


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
