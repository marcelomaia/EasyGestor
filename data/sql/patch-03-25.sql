-- Table: person_category_payment_info

-- DROP TABLE person_category_payment_info;

CREATE TABLE person_category_payment_info
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  person_id bigint NOT NULL,
  payment_category_id bigint NOT NULL,
  is_default boolean,
  CONSTRAINT person_category_payment_info_pkey PRIMARY KEY (id),
  CONSTRAINT person_category_payment_info_payment_category_id_fkey FOREIGN KEY (payment_category_id)
      REFERENCES payment_category (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT person_category_payment_info_person_id_fkey FOREIGN KEY (person_id)
      REFERENCES person (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT person_category_payment_info_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT person_category_payment_info_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT person_category_payment_info_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT person_category_payment_info_te_modified_id_key UNIQUE (te_modified_id)
);