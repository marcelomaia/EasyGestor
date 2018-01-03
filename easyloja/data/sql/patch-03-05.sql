-- Table: remote_printer

--DROP TABLE remote_printer;

CREATE TABLE remote_printer
(
  id bigserial NOT NULL,
  is_default boolean,
  driver character varying,
  path character varying,
  full_name character varying,
  te_created_id character varying,
  te_modified_id character varying,
  CONSTRAINT remote_printer_pkey PRIMARY KEY (id )
)
WITH (
  OIDS=FALSE
);
