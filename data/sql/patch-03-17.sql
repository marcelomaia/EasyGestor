CREATE TABLE sale_returned_item
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  quantity numeric(20,3),
  base_price numeric(20,2),
  price numeric(20,2),
  sale_id bigint,
  sale_item_id bigint,
  sellable_id bigint,
  CONSTRAINT sale_retured_item_pkey PRIMARY KEY (id ),
  CONSTRAINT sale_returned_item_sale_id_fkey FOREIGN KEY (sale_id)
      REFERENCES sale (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_returned_item_sellable_id_fkey FOREIGN KEY (sellable_id)
      REFERENCES sellable (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_returned_item_sale_item_id_fkey FOREIGN KEY (sale_item_id)
      REFERENCES sale_item (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_returned_item_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_returned_item_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT sale_returned_item_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT sale_returned_item_te_modified_id_key UNIQUE (te_modified_id ),
  CONSTRAINT positive_base_price CHECK (base_price >= 0::numeric),
  CONSTRAINT positive_price CHECK (price >= 0::numeric),
  CONSTRAINT positive_quantity CHECK (quantity >= 0::numeric)
)
WITH (
  OIDS=FALSE
);