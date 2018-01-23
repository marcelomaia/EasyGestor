ALTER TABLE sale ADD COLUMN year int;
update sale set year = 2018 where year is null;