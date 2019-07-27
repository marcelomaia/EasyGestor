-- Table: stock_increase_item

-- DROP TABLE stock_increase_item;

CREATE TABLE stock_increase_item
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  quantity numeric(20,3),
  stock_increase_id bigint,
  sellable_id bigint,
  CONSTRAINT stock_increase_item_pkey PRIMARY KEY (id ),
  CONSTRAINT stock_increase_item_sellable_id_fkey FOREIGN KEY (sellable_id)
      REFERENCES sellable (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_item_stock_increase_id_fkey FOREIGN KEY (stock_increase_id)
      REFERENCES stock_increase (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_item_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_item_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT stock_increase_item_te_created_id_key UNIQUE (te_created_id ),
  CONSTRAINT stock_increase_item_te_modified_id_key UNIQUE (te_modified_id )
)
WITH (
  OIDS=FALSE
);