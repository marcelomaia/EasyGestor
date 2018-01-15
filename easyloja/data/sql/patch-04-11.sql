ALTER TABLE product ADD COLUMN weighable bool;
update product set weighable = TRUE;