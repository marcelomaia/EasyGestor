CREATE TABLE product_initial_stock (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    initial_quantity numeric(20, 3) CONSTRAINT positive_quantity
        CHECK (initial_quantity >= 0),
    initial_date date,
    storable_id bigint REFERENCES product_adapt_to_storable(id),
    branch_id bigint REFERENCES person_adapt_to_branch(id)
);