-- Table: supplier_category

-- DROP TABLE supplier_category;

CREATE TABLE supplier_category
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  name text,
  CONSTRAINT supplier_category_pkey PRIMARY KEY (id),
  CONSTRAINT supplier_category_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT supplier_category_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT supplier_category_name_key UNIQUE (name),
  CONSTRAINT supplier_category_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT supplier_category_te_modified_id_key UNIQUE (te_modified_id)
);

