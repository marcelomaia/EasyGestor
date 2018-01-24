DROP TABLE IF EXISTS nfe_protocol;

CREATE TABLE nfe_protocol (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    protocol text UNIQUE,
    query_date timestamp without time zone,
    completed bool,
    last_protocol text
);
