CREATE TABLE work_order_package (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint,
    te_modified_id bigint,


    identifier text NOT NULL,
    status integer NOT NULL CONSTRAINT valid_status
      CHECK (status >= 0 AND status <= 2),
    send_date timestamp,
    receive_date timestamp,
    send_responsible_id bigint REFERENCES person_adapt_to_user(id) ON UPDATE CASCADE,
    receive_responsible_id bigint REFERENCES person_adapt_to_user(id) ON UPDATE CASCADE,
    destination_branch_id bigint REFERENCES person_adapt_to_branch(id) ON UPDATE CASCADE,
    source_branch_id bigint NOT NULL REFERENCES person_adapt_to_branch(id) ON UPDATE CASCADE,
    CONSTRAINT different_branches CHECK (source_branch_id != destination_branch_id)
);

CREATE TABLE work_order_package_item (
    id serial NOT NULL PRIMARY KEY,
    te_created_id bigint,
    te_modified_id bigint,

    order_id bigint NOT NULL REFERENCES work_order(id) ON UPDATE CASCADE,
    package_id bigint NOT NULL REFERENCES work_order_package(id) ON UPDATE CASCADE,
    UNIQUE (order_id, package_id)
);