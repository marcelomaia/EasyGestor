-- Table: sale_tab

-- DROP TABLE sale_tab;

CREATE TABLE sale_tab
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  sale_id bigint,
  tab_num bigint,
  table_num bigint,
  color text,
  CONSTRAINT sale_tab_pkey PRIMARY KEY (id ),
  CONSTRAINT sale_tab_sale_id_fkey FOREIGN KEY (sale_id)
      REFERENCES sale (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_tab_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_tab_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_tab_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT sale_tab_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);
