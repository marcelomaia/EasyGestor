-- Table product_attribute:

-- DROP TABLE product_attribute;

CREATE TABLE product_attribute
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  quantity bigint,
  price bigint,
  description varchar,

  product_id bigint,
  branch_id bigint ,


-- PK
  CONSTRAINT product_attribute_id_pkey PRIMARY KEY (id ),

-- FOREIGN KEYS
  CONSTRAINT attribute_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT attribute_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_atribute_product_id_fkey FOREIGN KEY (product_id)
      REFERENCES product (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT product_atribute_branch_id_fkey FOREIGN KEY (branch_id)
      REFERENCES person_adapt_to_branch (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,



  CONSTRAINT product_attribute_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT product_attribute_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);