CREATE TABLE company_cnae (
    id serial NOT NULL PRIMARY KEY,
    company_id bigint REFERENCES person_adapt_to_company(id),
    cnae_id bigint REFERENCES cnae(id)
);
