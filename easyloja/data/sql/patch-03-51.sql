-- Table: public.product_pis_template

-- DROP TABLE public.product_pis_template;

CREATE TABLE public.product_pis_template
(
  id bigint NOT NULL DEFAULT nextval('product_pis_template_id_seq'::regclass),
  te_created_id bigint,
  te_modified_id bigint,
  product_tax_template_id bigint,

  v_pis numeric(20,2),
  v_bc numeric(20,4),
  q_bc_prod numeric(16,4),
  calculo integer,
  cst integer,
  p_pis numeric(10,2),

  CONSTRAINT product_pis_template_pkey PRIMARY KEY (id),
  CONSTRAINT product_pis_template_product_tax_template_id_fkey FOREIGN KEY (product_tax_template_id)
      REFERENCES public.product_tax_template (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT product_pis_template_te_created_id_fkey FOREIGN KEY (te_created_id)
      REFERENCES public.transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT product_pis_template_te_modified_id_fkey FOREIGN KEY (te_modified_id)
      REFERENCES public.transaction_entry (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT product_pis_template_product_tax_template_id_key UNIQUE (product_tax_template_id),
  CONSTRAINT product_pis_template_te_created_id_key UNIQUE (te_created_id),
  CONSTRAINT product_pis_template_te_modified_id_key UNIQUE (te_modified_id)
)
WITH (
  OIDS=FALSE
);