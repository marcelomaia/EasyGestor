CREATE TABLE payment_iugu_bill
(
  id bigserial NOT NULL,
  payment_id bigint,
  te_created_id bigint,
  te_modified_id bigint,

  iugu_id varchar,
  status int,
  secure_id varchar,
  secure_url varchar,
  doc_pdf varchar,
  due_date date,
  paid_at date,


-- PK
  CONSTRAINT payment_iugu_bill_id_pkey PRIMARY KEY (id ),

-- FOREIGN KEYS
  CONSTRAINT payment_iugu_bill_payment_id_fkey FOREIGN KEY (payment_id)
      REFERENCES payment (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
--
  CONSTRAINT payment_iugu_bill_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT payment_iugu_bill_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,

  CONSTRAINT payment_iugu_bill_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT payment_iugu_bill_te_modified_id_key UNIQUE (te_modified_id)
);
