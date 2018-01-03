DO $$
DECLARE retVal int;
BEGIN

SELECT INTO retVal COUNT(*) FROM pg_extension WHERE extname = 'unaccent';

IF (retVal = 0) THEN
   CREATE EXTENSION unaccent;
END IF;
END $$;
