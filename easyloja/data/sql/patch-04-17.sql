DROP TABLE IF EXISTS profile_action_settings;

CREATE SEQUENCE profile_action_settings_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 13
  CACHE 1;

CREATE TABLE profile_action_settings
(
  id bigint NOT NULL DEFAULT nextval('profile_action_settings_id_seq'::regclass),
  te_created_id bigint,
  te_modified_id bigint,
  action_name text,
  has_permission boolean,
  user_profile_id bigint,
  CONSTRAINT profile_actions_pkey PRIMARY KEY (id),
  CONSTRAINT profile_action_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES public.transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT profile_action_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES public.transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT profile_action_user_profile_id_fkey FOREIGN KEY (user_profile_id)
      REFERENCES public.user_profile (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT profile_action_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT profile_action_te_modified_id_key UNIQUE (te_modified_id)
)