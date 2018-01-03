ALTER TABLE impnf add column station_id int;
ALTER TABLE impnf ADD CONSTRAINT station_id_fk FOREIGN KEY (station_id) REFERENCES branch_station (id);