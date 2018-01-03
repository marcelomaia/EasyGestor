-- Table: product_serial_number

-- DROP TABLE product_serial_number;

CREATE TABLE product_serial_number
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  product_id bigint,
  sale_id bigint,
  branch_id bigint,
  status int,
  notes text,
  serial_number text,

  CONSTRAINT product_serial_number_pkey PRIMARY KEY (id ),

  CONSTRAINT product_serial_number_product FOREIGN KEY (product_id)
      REFERENCES product (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_serial_number_sale FOREIGN KEY (sale_id)
      REFERENCES sale (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_serial_branch FOREIGN KEY (branch_id)
      REFERENCES person_adapt_to_branch (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_serial_number_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT product_serial_number_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_serial_number_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT product_serial_number_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);