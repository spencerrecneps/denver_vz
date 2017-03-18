SELECT  int_id,
        corridor_name,
        distance,
        all_base_weight,
        all_window_weight,
        all_vicinity_weight,
        all_avg_weight,
        all_median_weight,
        all_hilo_window_weight,
        all_hilo_avg_weight,
        all_weight_per_mile,
        all_hilo_weight_per_mile,
        all_ints_w_fatals,
        all_ints_gt_zero,
        all_ints_gt_one,
        all_ints_gt_two,
        all_ints_gt_three,
        ped_base_weight,
        ped_window_weight,
        ped_vicinity_weight,
        ped_avg_weight,
        ped_median_weight,
        ped_hilo_window_weight,
        ped_hilo_avg_weight,
        ped_weight_per_mile,
        ped_hilo_weight_per_mile,
        ped_ints_w_fatals,
        ped_ints_gt_zero,
        ped_ints_gt_one,
        ped_ints_gt_two,
        ped_ints_gt_three,
        CASE    WHEN ped_hilo_weight_per_mile >= 4 AND ped_ints_gt_one > 2 THEN 1
                WHEN ped_ints_gt_zero > 3
                    AND ped_window_weight::FLOAT / ped_vicinity_weight > 0.8
                    THEN 1
                ELSE 0
                END AS ped_automated_hin,
        COALESCE((
            SELECT  1
            FROM    hin,
                    denver_streets_intersections i
            WHERE   i.int_id = hin_corridor_windows.int_id
            AND     hin.mode = 'pedestrian'
            AND     ST_Intersects(i.geom,hin.tmp_geom_buffer)
            LIMIT   1
        ),0) AS ped_final_hin,
        bike_base_weight,
        bike_window_weight,
        bike_vicinity_weight,
        bike_avg_weight,
        bike_median_weight,
        bike_hilo_window_weight,
        bike_hilo_avg_weight,
        bike_weight_per_mile,
        bike_hilo_weight_per_mile,
        bike_ints_w_fatals,
        bike_ints_gt_zero,
        bike_ints_gt_one,
        bike_ints_gt_two,
        bike_ints_gt_three,
        CASE    WHEN bike_hilo_weight_per_mile >= 4 AND bike_ints_gt_zero > 3 THEN 1
                WHEN bike_ints_gt_zero > 3
                    AND bike_window_weight::FLOAT / bike_vicinity_weight > 0.8
                    THEN 1
                ELSE 0
                END AS bike_automated_hin,
        COALESCE((
            SELECT  1
            FROM    hin,
                    denver_streets_intersections i
            WHERE   i.int_id = hin_corridor_windows.int_id
            AND     hin.mode = 'bike'
            AND     ST_Intersects(i.geom,hin.tmp_geom_buffer)
            LIMIT   1
        ),0) AS bike_final_hin,
        veh_base_weight,
        veh_window_weight,
        veh_vicinity_weight,
        veh_avg_weight,
        veh_median_weight,
        veh_hilo_window_weight,
        veh_hilo_avg_weight,
        veh_weight_per_mile,
        veh_hilo_weight_per_mile,
        veh_ints_w_fatals,
        veh_ints_gt_zero,
        veh_ints_gt_one,
        veh_ints_gt_two,
        veh_ints_gt_three,
        veh_ints_gt_five,
        veh_ints_gt_ten,
        CASE    WHEN veh_hilo_weight_per_mile >= 14 AND veh_ints_gt_two > 2 THEN 1
                ELSE 0
                END AS veh_automated_hin,
        COALESCE((
            SELECT  1
            FROM    hin,
                    denver_streets_intersections i
            WHERE   i.int_id = hin_corridor_windows.int_id
            AND     hin.mode = 'vehicle'
            AND     ST_Intersects(i.geom,hin.tmp_geom_buffer)
            LIMIT   1
        ),0) AS veh_final_hin
FROM    generated.hin_corridor_windows;
