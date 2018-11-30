CREATE TABLE company_cnae (
    id serial NOT NULL PRIMARY KEY,
    company_id bigint UNIQUE REFERENCES person_adapt_to_company(id),
    cnae_id bigint UNIQUE REFERENCES cnae(id)
);