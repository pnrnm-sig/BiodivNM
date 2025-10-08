
--TAXONOMIE
--################################
--  Import FDW
--################################

CREATE SCHEMA IF NOT EXISTS taxonomie;

IMPORT FOREIGN SCHEMA taxonomie
LIMIT TO (taxonomie.taxref, taxonomie.cor_taxon_attribut, taxonomie.t_medias,taxonomie.bib_noms)
FROM SERVER geonaturedbserver INTO taxonomie ;

ALTER TABLE taxonomie.taxref OWNER TO myuser;
GRANT ALL ON TABLE taxonomie.taxref TO myuser;

ALTER TABLE taxonomie.cor_taxon_attribut OWNER TO myuser;
GRANT ALL ON TABLE taxonomie.cor_taxon_attribut TO myuser;

ALTER TABLE taxonomie.t_medias OWNER TO myuser;
GRANT ALL ON TABLE taxonomie.t_medias TO myuser;

ALTER TABLE taxonomie.taxonomie.bib_noms OWNER TO myuser;
GRANT ALL ON TABLE taxonomie.taxonomie.bib_noms TO myuser;
