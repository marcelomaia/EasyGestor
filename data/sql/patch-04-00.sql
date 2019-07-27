CREATE TABLE payment_cost_center (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    name text UNIQUE,
    color text
);


ALTER TABLE payment add column cost_center_id int;
ALTER TABLE payment ADD CONSTRAINT cost_center_id_fk FOREIGN KEY (cost_center_id) REFERENCES payment_cost_center (id);