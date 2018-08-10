CREATE SEQUENCE nfe_carta_correcao_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 13
  CACHE 1;

CREATE TABLE nfe_carta_correcao
(
  id bigint NOT NULL PRIMARY KEY,
  te_created_id bigint,
  te_modified_id bigint,

  sequence int,
  nfe_key text,
  nfe_sale_history_id int,
  reason text,
  xml64 BYTEA,
  pdf64 BYTEA,

  CONSTRAINT nfe_carta_correcao_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_carta_correcao_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfe_sale_history_id_fkey FOREIGN KEY (nfe_sale_history_id)
      REFERENCES nfe_sale_history (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);