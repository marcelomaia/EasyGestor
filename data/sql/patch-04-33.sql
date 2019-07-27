CREATE TABLE email_conf (
    id serial NOT NULL PRIMARY KEY,
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),

    smtp_server text,
    port int,
    email text,
    password text
);
