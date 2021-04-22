SELECT pg_reload_conf();
DO
$body$
BEGIN
   IF NOT EXISTS (
      SELECT *
      FROM   pg_catalog.pg_user
      WHERE  usename = 'dev') THEN

      CREATE ROLE dev LOGIN PASSWORD 'dev_password';
   END IF;
   ALTER USER dev CREATEDB;

   IF NOT EXISTS (
      SELECT *
      FROM   pg_catalog.pg_user
      WHERE  usename = 'test') THEN

      CREATE ROLE test LOGIN PASSWORD 'test';
   END IF;
   ALTER USER test CREATEDB;
END
$body$