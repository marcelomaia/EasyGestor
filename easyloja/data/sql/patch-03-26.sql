alter table calls add column price numeric(20,2);
alter table calls add column service_id bigint;
alter table calls add column link text;
alter table calls add column event text;
alter table calls add column status int;

alter table calls add CONSTRAINT service_id_fkey FOREIGN KEY (service_id)
    REFERENCES service (id) MATCH SIMPLE
    ON UPDATE NO ACTION ON DELETE NO ACTION;
