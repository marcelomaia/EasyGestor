-- Table: nfe_sale_history

-- DROP TABLE nfe_sale_history;

CREATE TABLE nfe_sale_history
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  number text,
  series text,
  key text,
  auth text,
  sale_id bigint,
  cnpj_emit text,

  CONSTRAINT nfe_sale_history_pkey PRIMARY KEY (id),

  CONSTRAINT nfe_sale_history_sale_id_fkey FOREIGN KEY (sale_id)
      REFERENCES sale (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT nfe_sale_history_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_sale_history_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_sale_history_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT nfe_sale_history_te_modified_id_key UNIQUE (te_modified_id)
  );