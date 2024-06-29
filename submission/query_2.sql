INSERT INTO malmarzooq80856.actors 
WITH 
previous_year AS (
    SELECT
        actor,
        actor_id,
        films,
        quality_class,
        is_active,
        current_year 
    FROM malmarzooq80856.actors 
    WHERE current_year = 2001 --filter last year data
),
current_year AS (
    SELECT 
        actor,
        actor_id,
        ARRAY_AGG(
            ROW(film, votes, rating, film_id, year)
        ) AS films,
        year as current_year,
        AVG(rating) AS rating_avg --calculating avg rating per actor/film
    FROM bootcamp.actor_films
    WHERE year = 2002 --filter current year data
    GROUP BY actor, actor_id, year
)
SELECT 
    COALESCE(py.actor, cy.actor) AS actor,
    COALESCE(py.actor_id, cy.actor_id) AS actor_id,
    CASE 
        WHEN cy.films IS NULL THEN py.films
        WHEN py.films IS NULL THEN cy.films
        ELSE array_distinct(py.films || cy.films)
    END AS films,
    CASE
        WHEN cy.rating_avg > 8 THEN 'star'
        WHEN cy.rating_avg  > 7 THEN 'good'
        WHEN cy.rating_avg  > 6 THEN 'average'
        ELSE 'bad'
    END AS quality_class, --assign quality class based on rating average
    (py.current_year IS NOT NULL) AS is_active,
    COALESCE(cy.current_year, py.current_year + 1) AS current_year
FROM current_year cy
FULL OUTER JOIN previous_year py ON cy.actor_id = py.actor_id
