-- nao conseguia validar o item por causa da constraint :D
ALTER TABLE payment_category DROP CONSTRAINT IF EXISTS payment_category_name_key;
ALTER TABLE payment_cost_center DROP CONSTRAINT IF EXISTS payment_cost_center_name_key;
