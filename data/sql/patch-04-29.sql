ALTER TABLE payment add column affiliate_id int;
ALTER TABLE payment ADD CONSTRAINT affiliate_id_fk FOREIGN KEY (affiliate_id) REFERENCES person_adapt_to_affiliate (id);