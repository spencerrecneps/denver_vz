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
