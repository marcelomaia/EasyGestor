CREATE TABLE nfe_contract
(
  id bigserial NOT NULL PRIMARY KEY,
  te_created_id bigint,
  te_modified_id bigint,

  key text,
  contract integer,
  company_id bigint,
  start_date timestamp without time zone,
  end_date timestamp without time zone,

  CONSTRAINT impnf_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT impnf_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT company_id_fkey FOREIGN KEY (company_id)
      REFERENCES person_adapt_to_company (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
