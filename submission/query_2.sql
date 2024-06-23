INSERT INTO malmarzooq80856.actors 
WITH 
previous_year AS (
    SELECT * 
    FROM malmarzooq80856.actors 
    WHERE current_year = 2001 --filter last year data
),
current_year AS (
    SELECT 
        actor, 
        actor_id,
      ARRAY_AGG(
        DISTINCT ROW(
          film,
          votes,
          rating,
          film_id
        )
      ) AS films,
    AVG(rating) AS rating_avg --calculating avg rating per actor/film
    FROM malmarzooq80856.actors 
    WHERE current_year = 2002 --filter current year data
    GROUP BY actor, actor_id
)
SELECT 
    COALESCE(py.actor, cy.actor) AS actor,
    COALESCE(py.actor_id, cy.actor_id) AS actor_id,
  CASE 
    WHEN cy.films IS NULL
      THEN py.films
    WHEN cy.films IS NOT NULL
      AND py.films IS NULL 
      THEN cy.films
    WHEN cy.films IS NOT NULL
      AND py.films IS NOT NULL
      THEN array_distinct(py.films || cy.films)
  END AS films,
    CASE
        WHEN py.rating_avg > 8 THEN 'star'
        WHEN py.rating_avg > 7 AND py.rating_avg <= 8 THEN 'good'
        WHEN py.rating_avg > 6 AND py.rating_avg <= 7 THEN 'average'
        WHEN py.rating_avg <= 6 THEN 'bad'
    END AS quality_class, --assign qa class based on rating avarge
    py.year IS NOT NULL AS is_active,
    COALESCE(cy.year, py.year + 1) AS current_year
FROM current_year cy
FULL OUTER JOIN previous_year py ON cy.actor_id = py.actor_id
