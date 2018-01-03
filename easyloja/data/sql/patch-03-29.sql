ALTER TABLE delivery_item ADD COLUMN sale_id INTEGER;

alter table delivery_item add 

CONSTRAINT sale_fkey FOREIGN KEY (sale_id)
    REFERENCES sale (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;