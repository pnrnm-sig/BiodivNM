
--METADONNEES
--################################
--  Import FDW
--################################

CREATE SCHEMA IF NOT EXISTS gn_meta;

IMPORT FOREIGN SCHEMA gn_meta
LIMIT TO (gn_meta.cor_dataset_actor)
FROM SERVER geonaturedbserver INTO gn_meta;

ALTER TABLE gn_meta.cor_dataset_actor OWNER TO myuser;
GRANT ALL ON TABLE gn_meta.cor_dataset_actor TO myuser;