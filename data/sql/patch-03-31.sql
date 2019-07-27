-- Table: nfce_branch_series

-- DROP TABLE nfce_branch_series;

CREATE TABLE nfce_branch_series
(
  id bigserial NOT NULL,
  te_created_id bigint,
  te_modified_id bigint,
  series text,
  station_id bigint,

  CONSTRAINT nfce_branch_series_pkey PRIMARY KEY (id),
  CONSTRAINT till_station_id_fkey FOREIGN KEY (station_id)
      REFERENCES branch_station (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfce_branch_series_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfce_branch_series_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT nfce_branch_series_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT nfce_branch_series_te_modified_id_key UNIQUE (te_modified_id)
  );