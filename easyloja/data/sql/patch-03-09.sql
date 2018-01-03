-- Table: stock_increase

-- DROP TABLE stock_increase;

CREATE TABLE stock_increase
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  confirm_date timestamp without time zone,
  status integer,
  reason text,
  notes text,
  responsible_id bigint,
  added_by_id bigint,
  branch_id bigint,
  cfop_id bigint,
  CONSTRAINT stock_increase_pkey PRIMARY KEY (id ),
  CONSTRAINT stock_increase_branch_id_fkey FOREIGN KEY (branch_id)
      REFERENCES person_adapt_to_branch (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_cfop_id_fkey FOREIGN KEY (cfop_id)
      REFERENCES cfop_data (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_added_by_id_fkey FOREIGN KEY (added_by_id)
      REFERENCES person_adapt_to_employee (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_responsible_id_fkey FOREIGN KEY (responsible_id)
      REFERENCES person_adapt_to_user (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT stock_increase_te_modified_id_key UNIQUE (te_modified_id ),
  CONSTRAINT valid_status CHECK (status >= 0 AND status < 8)
)
WITH (
  OIDS=FALSE
);