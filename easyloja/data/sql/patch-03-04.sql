-- Table sellablenfe:

-- DROP TABLE sellablenfe;

CREATE TABLE sellable_nfe
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  sellablenfe_id bigint,
  sellable_id integer,
  code text,
  salesperson_doc text,

  CONSTRAINT sellablenfe_id_pkey PRIMARY KEY (id ),
  CONSTRAINT sellable_id_fkey FOREIGN KEY (sellable_id)
      REFERENCES sellable (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sellablenfe_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sellablenfe_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sellablenfe_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT sellable_nfe_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);
