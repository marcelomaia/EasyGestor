CREATE TABLE person_adapt_to_affiliate (
    id serial NOT NULL PRIMARY KEY,
    te_modified_id bigint UNIQUE REFERENCES transaction_entry(id),
    te_created_id bigint UNIQUE REFERENCES transaction_entry(id),

    physical_products bool,
    business_type text,
    bank smallint,
    bank_ag text,
    bank_cc text,
    account_type smallint,
    commission_percent numeric(10,2) CONSTRAINT interest_percent_constraint
        CHECK (commission_percent >= 0 AND commission_percent <= 100),
    original_id bigint UNIQUE REFERENCES person(id)
);