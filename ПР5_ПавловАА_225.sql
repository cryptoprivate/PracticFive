-- DROP SEQUENCE film_id_seq;

CREATE SEQUENCE film_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE film_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE film_id_seq TO postgres;

-- DROP SEQUENCE hall_id_seq;

CREATE SEQUENCE hall_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE hall_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE hall_id_seq TO postgres;

-- DROP SEQUENCE screening_id_seq;

CREATE SEQUENCE screening_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 2147483647
	START 1
	CACHE 1
	NO CYCLE;

-- Permissions

ALTER SEQUENCE screening_id_seq OWNER TO postgres;
GRANT ALL ON SEQUENCE screening_id_seq TO postgres;
-- public.film определение

-- Drop table

-- DROP TABLE film;

CREATE TABLE film (
	id serial4 NOT NULL,
	"name" varchar(255) NULL,
	description text NULL,
	CONSTRAINT film_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE film OWNER TO postgres;
GRANT ALL ON TABLE film TO postgres;


-- public.hall определение

-- Drop table

-- DROP TABLE hall;

CREATE TABLE hall (
	id serial4 NOT NULL,
	"name" varchar(100) NULL,
	CONSTRAINT hall_pkey PRIMARY KEY (id)
);

-- Permissions

ALTER TABLE hall OWNER TO postgres;
GRANT ALL ON TABLE hall TO postgres;


-- public.hall_row определение

-- Drop table

-- DROP TABLE hall_row;

CREATE TABLE hall_row (
	hall_id int4 NULL,
	"number" int4 NULL,
	capacity int4 NULL,
	CONSTRAINT hall_row_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE hall_row OWNER TO postgres;
GRANT ALL ON TABLE hall_row TO postgres;


-- public.screening определение

-- Drop table

-- DROP TABLE screening;

CREATE TABLE screening (
	id serial4 NOT NULL,
	hall_id int4 NULL,
	film_id int4 NULL,
	"time" timestamp NULL,
	CONSTRAINT screening_pkey PRIMARY KEY (id),
	CONSTRAINT screening_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(id),
	CONSTRAINT screening_hall_id_fkey FOREIGN KEY (hall_id) REFERENCES hall(id)
);

-- Permissions

ALTER TABLE screening OWNER TO postgres;
GRANT ALL ON TABLE screening TO postgres;


-- public.tickets определение

-- Drop table

-- DROP TABLE tickets;

CREATE TABLE tickets (
	id_screening int4 NOT NULL,
	"row" int4 NOT NULL,
	seat int4 NOT NULL,
	"cost" int4 NULL,
	CONSTRAINT tickets_pkey PRIMARY KEY (id_screening, "row", seat),
	CONSTRAINT tickets_id_screening_fkey FOREIGN KEY (id_screening) REFERENCES screening(id)
);

-- Permissions

ALTER TABLE tickets OWNER TO postgres;
GRANT ALL ON TABLE tickets TO postgres;


-- public.films_after_time исходный текст

CREATE MATERIALIZED VIEW films_after_time
TABLESPACE pg_default
AS SELECT film.name AS "Название фильма",
    screening."time" AS "Дата показа"
   FROM screening
     JOIN film ON film.id = screening.film_id
  WHERE screening."time" > '2024-01-01 11:00:00'::timestamp without time zone
WITH DATA;

-- Permissions

ALTER TABLE films_after_time OWNER TO postgres;
GRANT ALL ON TABLE films_after_time TO postgres;


-- public.prokate_for_film исходный текст

CREATE MATERIALIZED VIEW prokate_for_film
TABLESPACE pg_default
AS SELECT hall.name AS "Зал",
    film.name AS "Название фильма",
    screening."time" AS "Дата показа"
   FROM screening
     JOIN hall ON hall.id = screening.hall_id
     JOIN film ON film.id = screening.film_id
  WHERE film.name::text = 'Ужасающий 3'::text
WITH DATA;

-- Permissions

ALTER TABLE prokate_for_film OWNER TO postgres;
GRANT ALL ON TABLE prokate_for_film TO postgres;


-- public.prokate_for_hall_five исходный текст

CREATE MATERIALIZED VIEW prokate_for_hall_five
TABLESPACE pg_default
AS SELECT hall.name AS "Зал",
    film.name AS "Название фильма",
    screening."time" AS "Дата показа"
   FROM screening
     JOIN film ON film.id = screening.film_id
     JOIN hall ON hall.id = screening.hall_id
  WHERE hall.name::text = 'Зал 5'::text
WITH DATA;

-- Permissions

ALTER TABLE prokate_for_hall_five OWNER TO postgres;
GRANT ALL ON TABLE prokate_for_hall_five TO postgres;




-- Permissions

GRANT ALL ON SCHEMA public TO pg_database_owner;
GRANT USAGE ON SCHEMA public TO public;


INSERT INTO public.film (id,"name",description) VALUES
	 (1,'Форсаж 1','Боевик'),
	 (2,'Веном 3','Боевик, ужасы'),
	 (3,'Ужасающий 3','Ужасы'),
	 (4,'Переводчик','Триллер'),
	 (5,'Драйв','Драма'),
	 (6,'Форсаж 6','Боевик'),
	 (7,'Аватар','Научная фантастика'),
	 (8,'Гадкий я 4','Мультфильм');
INSERT INTO public.hall (id,"name") VALUES
	 (1,'Зал 1'),
	 (2,'Зал 2'),
	 (3,'Зал 3'),
	 (4,'Зал 4'),
	 (5,'Зал 5'),
	 (6,'Зал 6'),
	 (7,'Зал 7'),
	 (8,'Зал 8');
INSERT INTO public.hall_row (hall_id,"number",capacity) VALUES
	 (1,1,6),
	 (2,6,12),
	 (3,2,8),
	 (4,3,7),
	 (5,5,8),
	 (6,1,20),
	 (7,1,14),
	 (8,1,3);
INSERT INTO public.screening (id,hall_id,film_id,"time") VALUES
	 (1,1,1,'2024-02-01 11:40:00'),
	 (2,2,1,'2024-02-09 20:40:00'),
	 (3,3,3,'2024-02-01 11:40:00'),
	 (4,5,5,'2024-02-06 10:30:00'),
	 (5,4,4,'2024-02-07 11:40:00'),
	 (6,6,6,'2024-01-01 10:30:00'),
	 (7,7,7,'2024-02-17 21:00:00'),
	 (8,5,3,'2024-02-10 21:00:00');
INSERT INTO public.tickets (id_screening,"row",seat,"cost") VALUES
	 (1,5,12,450),
	 (3,4,9,350),
	 (2,6,8,400),
	 (5,8,4,300),
	 (4,2,10,500),
	 (2,3,10,680),
	 (1,6,7,520),
	 (5,3,8,520);


