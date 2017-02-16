-----------------------------------
-- Crashes by classification and mode
-----------------------------------
SELECT      (
                SELECT      ds.class_description
                FROM        denver_streets ds
                WHERE       ca.int_id IN (ds.intersection_from,ds.intersection_to)
                ORDER BY    ds.class_order ASC
                LIMIT       1
            ) AS "Highest Classification",
            SUM(veh_allinjury) AS "Vehicle - Injury",
            SUM(veh_allfatal) AS "Vehicle - Fatal",
            SUM(ped_allinjury) AS "Pedestrian - Injury",
            SUM(ped_allfatal) AS "Pedestrian - Fatal",
            SUM(bike_allinjury) AS "Bike - Injury",
            SUM(bike_allfatal) AS "Bike - Fatal"
FROM        generated.crash_aggregates ca
GROUP BY    (
                SELECT      ds.class_description
                FROM        denver_streets ds
                WHERE       ca.int_id IN (ds.intersection_from,ds.intersection_to)
                ORDER BY    ds.class_order ASC
                LIMIT       1
            );


-----------------------------------
-- Crashes by number of lanes and mode
-----------------------------------
SELECT      (
                SELECT      ds.travel_lanes
                FROM        denver_streets ds
                WHERE       ca.int_id IN (ds.intersection_from,ds.intersection_to)
                ORDER BY    ds.travel_lanes DESC
                LIMIT       1
            ) AS "Number of Lanes",
            SUM(veh_allinjury) AS "Vehicle - Injury",
            SUM(veh_allfatal) AS "Vehicle - Fatal",
            SUM(ped_allinjury) AS "Pedestrian - Injury",
            SUM(ped_allfatal) AS "Pedestrian - Fatal",
            SUM(bike_allinjury) AS "Bike - Injury",
            SUM(bike_allfatal) AS "Bike - Fatal"
FROM        generated.crash_aggregates ca
GROUP BY    (
                SELECT      ds.travel_lanes
                FROM        denver_streets ds
                WHERE       ca.int_id IN (ds.intersection_from,ds.intersection_to)
                ORDER BY    ds.travel_lanes DESC
                LIMIT       1
            )
ORDER BY    (
                SELECT      ds.travel_lanes
                FROM        denver_streets ds
                WHERE       ca.int_id IN (ds.intersection_from,ds.intersection_to)
                ORDER BY    ds.travel_lanes DESC
                LIMIT       1
            ) DESC;
