CREATE TABLE factInvoiceLine
(
    "InvoiceLine_key" SERIAL PRIMARY KEY,
    "date_key" integer REFERENCES dimDate ("date_key"),
    "CustomerId_key" integer REFERENCES dimCustomer ("CustomerId_key"),
    "TrackId_key" integer REFERENCES dimTrack ("TrackId_key"),
    "InvoiceId_key" integer REFERENCES dimInvoice ("InvoiceId_key"),
    "UnitPrice" numeric(10,2) NOT NULL,
    "Quantity" integer NOT NULL
);

INSERT INTO factInvoiceLine ("date_key","CustomerId_key","TrackId_key","InvoiceId_key","UnitPrice","Quantity")
SELECT
	DISTINCT(TO_CHAR("InvoiceDate" :: DATE, 'yyyMMDD')::integer) AS date_key,
	c."CustomerId" as "CustomerId_key",
	t."TrackId" as "TrackId_key",
	i."InvoiceId" as "InvoiceId_key",
	il."UnitPrice",
	il."Quantity"
FROM public."InvoiceLine" il
JOIN public."Invoice" i ON i."InvoiceId" = il."InvoiceId"
JOIN public."Track" t ON t."TrackId" = il."TrackId"
JOIN public."Customer" c ON c."CustomerId" = i."CustomerId";