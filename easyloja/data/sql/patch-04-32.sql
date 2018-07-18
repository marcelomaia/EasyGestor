CREATE TABLE daily_flow (
    id serial NOT NULL PRIMARY KEY,
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),

    flow_date date UNIQUE,
    balance numeric(10,2)
);