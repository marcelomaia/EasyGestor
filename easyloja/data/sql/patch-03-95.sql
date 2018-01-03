ALTER TABLE payment add column branch_id bigint;
ALTER TABLE payment ADD CONSTRAINT branch_id_fk FOREIGN KEY (branch_id) REFERENCES person_adapt_to_branch (id);