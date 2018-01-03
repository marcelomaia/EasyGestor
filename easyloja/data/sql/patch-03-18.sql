-- Table: recurrency

-- DROP TABLE recurrency;

CREATE TABLE recurrency
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  period integer,
  type_period character varying,
  subject text,
  message text,
  sellable_id bigint,
  CONSTRAINT recurrency_pkey PRIMARY KEY (id ),
  CONSTRAINT sellable_id_fkey FOREIGN KEY (sellable_id)
      REFERENCES sellable (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);