-- ped crashes
UPDATE  crashes_ped
SET     road_id1 = ds.road_id
FROM    denver_streets ds,
        denver_street_centerline dc
WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
AND     crashes_ped.street1 = dc.streetid;

UPDATE  crashes_ped
SET     road_id2 = ds.road_id
FROM    denver_streets ds,
        denver_street_centerline dc
WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
AND     crashes_ped.street2 = dc.streetid;

-- veh crashes
UPDATE  crashes_veh
SET     road_id1 = ds.road_id
FROM    denver_streets ds,
        denver_street_centerline dc
WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
AND     crashes_veh.street1 = dc.streetid;

UPDATE  crashes_veh
SET     road_id2 = ds.road_id
FROM    denver_streets ds,
        denver_street_centerline dc
WHERE   ds.tdgid_denver_street_centerline = dc.tdg_id
AND     crashes_veh.street2 = dc.streetid;
