DROP TABLE IF EXISTS "factInvoiceLine";

-- dimDate
DROP TABLE IF EXISTS dimDate;

CREATE TABLE IF NOT EXISTS dimDate 
(
  	"date_key" INTEGER NOT NULL PRIMARY KEY,
  	"date" date NOT NULL,
  	"month" smallint NOT NULL,
  	"quarter" smallint NOT NULL,
  	"year" smallint NOT NULL,
	"week" smallint NOT NULL,
  	"is_weekend" boolean
);

INSERT INTO dimDate
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

-- dimCustomer
DROP TABLE IF EXISTS dimCustomer;

CREATE TABLE IF NOT EXISTS dimCustomer
(
	"CustomerId_key" SERIAL PRIMARY KEY,
    "CustomerId" integer NOT NULL,
    "FirstName" character varying(40) COLLATE pg_catalog."default" NOT NULL,
    "LastName" character varying(20) COLLATE pg_catalog."default" NOT NULL,
    "Company" character varying(80) COLLATE pg_catalog."default",
    "Address" character varying(70) COLLATE pg_catalog."default",
    "City" character varying(40) COLLATE pg_catalog."default",
    "State" character varying(40) COLLATE pg_catalog."default",
    "Country" character varying(40) COLLATE pg_catalog."default",
    "PostalCode" character varying(10) COLLATE pg_catalog."default",
    "Phone" character varying(24) COLLATE pg_catalog."default",
    "Fax" character varying(24) COLLATE pg_catalog."default",
    "Email" character varying(60) COLLATE pg_catalog."default" NOT NULL,
    "SupportRepId" integer,
    "EmployeeLastName" character varying(20) COLLATE pg_catalog."default" NOT NULL,
    "EmployeeFirstName" character varying(20) COLLATE pg_catalog."default" NOT NULL,
    "EmployeeTitle" character varying(30) COLLATE pg_catalog."default",
    "ReportsTo" character varying(70) COLLATE pg_catalog."default",
    "EmployeeBirthDate" timestamp without time zone,
    "EmployeeHireDate" timestamp without time zone,
    "EmployeeAddress" character varying(70) COLLATE pg_catalog."default",
    "EmployeeCity" character varying(40) COLLATE pg_catalog."default",
    "EmployeeState" character varying(40) COLLATE pg_catalog."default",
    "EmployeeCountry" character varying(40) COLLATE pg_catalog."default",
    "EmployeePostalCode" character varying(10) COLLATE pg_catalog."default",
    "EmployeePhone" character varying(24) COLLATE pg_catalog."default",
    "EmployeeFax" character varying(24) COLLATE pg_catalog."default",
    "EmployeeEmail" character varying(60) COLLATE pg_catalog."default"
);

INSERT INTO dimCustomer
SELECT 
	c."CustomerId" as "CustomerId_key",
	c.*,
	e."LastName" as "EmployeeLastName",
	e."FirstName" as "EmployeeFirstName",
	e."Title" as "EmployeeTitle",
	CONCAT(e2."FirstName",' ',e2."LastName") as "ReportsTo",
	e."BirthDate" as "EmployeeBirthDate",
	e."HireDate" as "EmployeeHireDate",
	e."Address" as "EmployeeAddress",
	e."City" as "EmployeeCity",
	e."State" as "EmployeeState",
	e."Country" as "EmployeeCountry",
	e."PostalCode" as "EmployeePostalCode",
	e."Phone" as "EmployeePhone",
	e."Fax" as "EmployeeFax",
	e."Email" as "EmployeeEmail"
FROM PUBLIC."Customer" c
JOIN PUBLIC."Employee" e ON c."SupportRepId" = e."EmployeeId"
JOIN PUBLIC."Employee" e2 ON e2."EmployeeId" = e."ReportsTo";

-- dimTrack
DROP TABLE IF EXISTS dimTrack;

CREATE TABLE IF NOT EXISTS dimTrack
(
	"TrackId_key" SERIAL PRIMARY KEY,
    "TrackId" integer NOT NULL,
    "TrackName" character varying(200) COLLATE pg_catalog."default" NOT NULL,
    "Composer" character varying(220) COLLATE pg_catalog."default",
    "Milliseconds" integer NOT NULL,
    "Bytes" integer,
    "UnitPrice" numeric(10,2) NOT NULL,
    "AlbumTitle" character varying(160) COLLATE pg_catalog."default",
    "ArtistName" character varying(120) COLLATE pg_catalog."default",
    "GenreName" character varying(120) COLLATE pg_catalog."default",
    "MediaTypeName" character varying(120) COLLATE pg_catalog."default",
    "PlaylistName" character varying(120) COLLATE pg_catalog."default"
);

INSERT INTO dimTrack
SELECT 
	t."TrackId" as "TrackId_key",
	t."TrackId",
	t."Name" as "TrackName",
	t."Composer",
	t."Milliseconds",
	t."Bytes",
	t."UnitPrice",
	al."Title" as "AlbumTitle",
	ar."Name" as "ArtistName",
	g."Name" as "GenreName",
	m."Name" as "MediaTypeName"
FROM PUBLIC."Track" t
JOIN PUBLIC."Album" al ON al."AlbumId" = t."AlbumId"
JOIN public."Artist" ar ON ar."ArtistId" = al."ArtistId"
JOIN public."Genre" g ON g."GenreId" = t."GenreId"
JOIN public."MediaType" m ON m."MediaTypeId" = t."MediaTypeId";

-- dimInvoice

DROP TABLE IF EXISTS dimInvoice;

CREATE TABLE IF NOT EXISTS dimInvoice
(
    "InvoiceId_key" SERIAL PRIMARY KEY,
	"InvoiceId" integer NOT NULL,
    "CustomerId" integer NOT NULL,
    "InvoiceDate" timestamp without time zone NOT NULL,
    "BillingAddress" character varying(70) COLLATE pg_catalog."default",
    "BillingCity" character varying(40) COLLATE pg_catalog."default",
    "BillingState" character varying(40) COLLATE pg_catalog."default",
    "BillingCountry" character varying(40) COLLATE pg_catalog."default",
    "BillingPostalCode" character varying(10) COLLATE pg_catalog."default"
);

INSERT INTO dimInvoice
SELECT 
    i."InvoiceId" as "InvoiceId_key",
    i."InvoiceId",
    i."CustomerId",
    i."InvoiceDate",
    i."BillingAddress",
    i."BillingCity",
    i."BillingState",
    i."BillingCountry",
    i."BillingPostalCode"
FROM public."Invoice" i;