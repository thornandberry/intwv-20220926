DROP TABLE IF EXISTS "dimDate";

CREATE TABLE IF NOT EXISTS "dimDate" 
(
  	"date_key" INTEGER NOT NULL PRIMARY KEY,
  	"date" date NOT NULL,
  	"month" smallint NOT NULL,
  	"quarter" smallint NOT NULL,
  	"year" smallint NOT NULL,
	"week" smallint NOT NULL,
  	"is_weekend" boolean
);

INSERT INTO "dimDate"
SELECT
	DISTINCT(TO_CHAR("InvoiceDate" :: DATE, 'yyyMMDD')::integer) as date_key,
	date("InvoiceDate") as date,
	EXTRACT(MONTH from "InvoiceDate") as month,
	EXTRACT(QUARTER from "InvoiceDate") as quarter,
	EXTRACT(YEAR from "InvoiceDate") as year,
	EXTRACT(WEEK from "InvoiceDate") as week,
	CASE
		WHEN EXTRACT(ISODOW from "InvoiceDate") IN (6,7) THEN true ELSE false
	END as is_weekend
FROM public."Invoice";

DROP TABLE IF EXISTS "dimAlbum";

CREATE TABLE IF NOT EXISTS public."dimAlbum"
(
	"AlbumId_key" SERIAL PRIMARY KEY,
    "AlbumId" integer NOT NULL,
    "Title" character varying(160) COLLATE pg_catalog."default" NOT NULL,
    "ArtistId" integer NOT NULL
);

INSERT INTO "dimAlbum"
SELECT
	a."AlbumId" as albumid_key,
	*
FROM public."Album" as a;