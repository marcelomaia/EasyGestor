ALTER TABLE sale drop constraint valid_status;
ALTER TABLE sale add constraint valid_status CHECK (status >= 0 AND status <= 8);
