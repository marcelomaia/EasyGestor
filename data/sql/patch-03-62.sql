CREATE TABLE impnf
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  
  name text,
  brand text,
  printer_model text,
  dll text,
  port text,
  is_default boolean,

  CONSTRAINT impnf_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT impnf_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
