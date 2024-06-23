CREATE TABLE malmarzooq80856.actors (
  -- Actor name
  actor VARCHAR,
  -- Actor's ID
  actor_id VARCHAR,
  films ARRAY (ROW(
    -- The name of the film
    film VARCHAR,
    -- The number of votes the film received
    votes INTEGER,
    -- The rating of the film
    rating DOUBLE,
    -- A unique identifier for each film
    film_id VARCHAR
  )),
  -- Average rating of the movies for this actor in their most recent year
  quality_class VARCHAR,
  -- Indicates whether an actor is currently active in the film industry
  is_active BOOLEAN,
  -- The year this row represents for the actor
  current_year INTEGER
)
WITH (
  FORMAT = 'PARQUET',
  partitioning = ARRAY['current_year']
)
