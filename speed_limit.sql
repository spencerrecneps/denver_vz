--------------------------------------------------------------
-- speed limit
--------------------------------------------------------------
-- denver_street_centerline
UPDATE  generated.denver_streets
SET     speed_limit = dsc.speedlimit,
        speed_limit_source = 'denver_street_centerline'
FROM    denver_street_centerline dsc
WHERE   denver_streets.tdgid_denver_street_centerline = dsc.tdg_id;
