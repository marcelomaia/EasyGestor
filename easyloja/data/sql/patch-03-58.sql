
-- Table: nfe_volume

-- DROP TABLE nfe_volume;

CREATE TABLE nfe_volume
(
  id bigint NOT NULL DEFAULT nextval('nfe_volume_id_seq'::regclass),
  te_created_id bigint,
  te_modified_id bigint,
  quantity numeric(20,3),
  unit text,
  brand text,
  number text,
  net_weight numeric(10,2),
  gross_weight numeric(10,2),
  sale_id bigint,

  CONSTRAINT nfe_volume_pkey PRIMARY KEY (id),
  CONSTRAINT nfe_volume_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_volume_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_volume_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT nfe_volume_te_modified_id_key UNIQUE (te_modified_id),
  CONSTRAINT positive_quantity CHECK (quantity >= 0::numeric),
  CONSTRAINT positive_net_weight CHECK (net_weight >= 0::numeric),
  CONSTRAINT positive_gross_weight CHECK (gross_weight >= 0::numeric)
)
WITH (
  OIDS=FALSE
);
