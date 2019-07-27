ALTER TABLE sale ADD COLUMN tab_id INTEGER;


alter table sale add CONSTRAINT sale_tab_fkey FOREIGN KEY (tab_id)
    REFERENCES sale_tab (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;