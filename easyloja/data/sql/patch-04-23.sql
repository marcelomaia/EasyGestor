ALTER TABLE product drop column if exists scale;
ALTER TABLE product ADD COLUMN scale bool;
update product set scale = TRUE;