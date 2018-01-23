CREATE TABLE nfe_protocol (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    protocol text UNIQUE,
    download_path text,
    main_protocol bool,
    query_date date
);

