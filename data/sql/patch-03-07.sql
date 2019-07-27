-- Table group_attribute:

-- DROP TABLE attribute;
-- Not finished yet
CREATE TABLE attribute
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,

  description varchar,
  value varchar,
  notes text,
  group_attribute_id bigint ,


-- PK
  CONSTRAINT attribute_id_pkey PRIMARY KEY (id ),

-- FOREIGN KEYS
  CONSTRAINT attribute_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT attribute_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT groupattribute_id_fkey FOREIGN KEY (group_attribute_id)
      REFERENCES group_attribute (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT attribute_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT attribute_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);