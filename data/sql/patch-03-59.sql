  -- Update stock_transaction_history. Migrate TYPE_CONSIGNMENT_RETURNED and
  -- alter it's valid range to support it and TYPE_WORK_ORDER_USED.
  CREATE TABLE work_order_category (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint,
    te_modified_id bigint,
    name text UNIQUE NOT NULL,
    color text
  );
  CREATE TABLE work_order (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint,
    te_modified_id bigint,
    identifier serial NOT NULL,
    status integer CONSTRAINT valid_status
      CHECK (status >= 0 AND status <= 5),
    equipment text,
    estimated_hours numeric(10,2),
    estimated_cost numeric(20,2),
    estimated_start timestamp,
    estimated_finish timestamp,
    open_date timestamp,
    approve_date timestamp,
    finish_date timestamp,
    defect_reported text,
    defect_detected text,
    branch_id bigint REFERENCES person_adapt_to_branch(id) ON UPDATE CASCADE,
    quote_responsible_id bigint REFERENCES person_adapt_to_user(id) ON UPDATE CASCADE,
    execution_responsible_id bigint REFERENCES person_adapt_to_user(id) ON UPDATE CASCADE,
    category_id bigint REFERENCES work_order_category(id) ON UPDATE CASCADE,
    client_id bigint REFERENCES person_adapt_to_client(id) ON UPDATE CASCADE,
    sale_id bigint REFERENCES sale(id) ON UPDATE CASCADE,
    UNIQUE (identifier, branch_id)
  );
  CREATE TABLE work_order_item (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint,
    te_modified_id bigint,
    quantity numeric(20,3),
    price numeric(20,2),
    sellable_id bigint REFERENCES sellable(id) ON UPDATE CASCADE,
    order_id bigint REFERENCES work_order(id) ON UPDATE CASCADE
  );
