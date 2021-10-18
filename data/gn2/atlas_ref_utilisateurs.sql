
--UTILISATEURS
--################################
--  Import FDW
--################################

CREATE SCHEMA IF NOT EXISTS utilisateurs;

IMPORT FOREIGN SCHEMA utilisateurs
LIMIT TO (utilisateurs.bib_organismes,utilisateurs.t_roles)
FROM SERVER geonaturedbserver INTO utilisateurs;

ALTER TABLE utilisateurs.bib_organismes OWNER TO myuser;
GRANT ALL ON TABLE utilisateurs.bib_organismes TO myuser;

ALTER TABLE utilisateurs.t_roles OWNER TO myuser;
GRANT ALL ON TABLE utilisateurs.t_roles TO myuser;