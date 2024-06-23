INSERT INTO malmarzooq80856.actors_history_scd
WITH previous_years AS (
    -- Select actor details for previous years values using LAG
    SELECT
        actor,
        actor_id,
        quality_class,
        is_active,
        LAG(is_active, 1) OVER (
            PARTITION BY actor_id
            ORDER BY current_year
        ) AS previous_is_active,
        LAG(quality_class, 1) OVER (
            PARTITION BY actor_id
            ORDER BY current_year
        ) AS previous_quality_class,
        current_year
    FROM malmarzooq80856.actors
    WHERE current_year < 2000 -- Consider data before the year 2000 which is the case current year
),
check_changes AS (
    -- Determine changes in is_active or quality_class using SUM
    SELECT *,
        SUM( 
            CASE 
                WHEN is_active <> previous_is_active OR quality_class <> previous_quality_class
                    THEN 1
                ELSE 0
            END
        ) OVER (
            PARTITION BY actor_id
            ORDER BY current_year
        ) AS did_change
    FROM previous_years
)
SELECT 
    actor,
    actor_id,
    quality_class,
    MAX(is_active) AS is_active,
    MIN(current_year) AS start_date,
    MAX(current_year) AS end_date,
    2000 AS current_year -- Set the current year to 2000 
FROM check_changes
GROUP BY
    actor,
    actor_id,
    quality_class,
    did_change;
