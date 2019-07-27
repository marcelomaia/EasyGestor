-- Table: sale_item_schedule

-- DROP TABLE sale_item_schedule;

CREATE TABLE sale_item_schedule(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  sale_item_id bigint,
  shipping_date timestamp without time zone,
  is_sent boolean,
  CONSTRAINT sale_item_schedule_pkey PRIMARY KEY (id ),
  CONSTRAINT sale_item_fkey FOREIGN KEY (sale_item_id)
      REFERENCES sale_item (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)

WITH (
  OIDS=FALSE
);