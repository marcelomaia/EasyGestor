-- Table: sale_item_cofins

-- DROP TABLE sale_item_cofins;

CREATE TABLE sale_item_cofins
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  v_cofins numeric(20,2),
  v_bc numeric(20,4),
  q_bc_prod numeric(16,4),
  cst integer,
  calculo integer,
  p_cofins numeric(10,2),

  CONSTRAINT sale_item_cofins_pkey PRIMARY KEY (id),
  CONSTRAINT sale_item_cofins_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_item_cofins_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_item_cofins_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT sale_item_cofins_te_modified_id_key UNIQUE (te_modified_id)
)
WITH (
  OIDS=FALSE
);

