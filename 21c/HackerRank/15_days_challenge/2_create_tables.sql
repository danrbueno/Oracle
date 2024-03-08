CREATE TABLE hackerrank.tb_hacker (
    id NUMERIC(10) NOT NULL,
    ds_name VARCHAR2(50) NOT NULL,
    CONSTRAINT hacker_pk PRIMARY KEY(id)
);

CREATE TABLE hackerrank.tb_submission (
    id NUMERIC(10) NOT NULL,
    dt_submission DATE NOT NULL,
    vl_score NUMERIC(10) NOT NULL,
    hacker_id NUMERIC(10) NOT NULL,
    CONSTRAINT hacker_fk FOREIGN KEY (hacker_id) REFERENCES tb_hacker(id)
);