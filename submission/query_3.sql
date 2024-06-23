CREATE TABLE malmarzooq80856.actors_history_scd (
  -- Actor name
  actor VARCHAR,
  -- Actor's ID
  actor_id VARCHAR,
  -- Average rating of the movies for this actor in their most recent year
  quality_class VARCHAR,
  -- Indicates whether an actor is currently active in the film industry
  is_active BOOLEAN,
  -- The start date this row represents for the actor
  start_date INTEGER,
  -- The end date this row represents for the actor
  end_date INTEGER,
 -- The surrent year
  current_year INTEGER

)
WITH (
  FORMAT = 'PARQUET',
  partitioning = ARRAY['current_year']
)
