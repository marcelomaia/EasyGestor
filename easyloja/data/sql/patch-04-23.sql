ALTER TABLE product ADD COLUMN scale bool;
update product set scale = TRUE;