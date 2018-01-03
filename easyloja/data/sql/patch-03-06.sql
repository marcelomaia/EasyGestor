-- Table group_attribute:

-- DROP TABLE group_attribute;

CREATE TABLE group_attribute
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  description varchar,
  type int,
  notes text,

  CONSTRAINT group_attribute_id_pkey PRIMARY KEY (id ),

  CONSTRAINT group_attribute_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT group_attribute_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT group_attribute_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT group_attribute_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);