ALTER TABLE  product ADD COLUMN pis_template_id bigint;
ALTER TABLE  product ADD COLUMN cofins_template_id bigint;
ALTER TABLE  sale_item ADD COLUMN pis_info_id bigint;
ALTER TABLE  sale_item ADD COLUMN cofins_info_id bigint;