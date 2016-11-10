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
