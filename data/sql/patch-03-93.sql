-- Resolucao do bug de ordem de compra...
ALTER TABLE receiving_order DROP CONSTRAINT valid_invoice_number;