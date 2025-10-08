--Copie du contenu de taxref (à partir du schéma taxonomie de TaxHub)

--DROP materialized view taxonomie.vm_taxref;
CREATE materialized view atlas.vm_taxref
AS 
WITH nomfrancais AS (
         SELECT bn.cd_nom,
            u.nom_francais,
            concat('0_', u.idx) AS idx
           FROM taxonomie.bib_noms bn
             CROSS JOIN LATERAL unnest(string_to_array(bn.nom_francais::text, ', '::text)) WITH ORDINALITY u(nom_francais, idx)
          ORDER BY bn.cd_nom
        ), nomvern AS (
         SELECT t.cd_nom,
            u.nom_vern,
            concat('1_', u.idx) AS idx
           FROM taxonomie.taxref t
             CROSS JOIN LATERAL unnest(string_to_array(t.nom_vern::text, ', '::text)) WITH ORDINALITY u(nom_vern, idx)
          ORDER BY t.cd_nom
        ), unionsel AS (
        select * from
         ((SELECT nf.cd_nom,
            nf.nom_francais AS nom_vern,
            nf.idx
           FROM nomfrancais nf)
        UNION
         (SELECT nv.cd_nom,
            nv.nom_vern,
            nv.idx
           FROM nomvern nv
             LEFT JOIN nomfrancais nf2 ON nf2.nom_francais = nv.nom_vern
          WHERE nf2.cd_nom IS null)) as unionsel
        order by idx
        ), new_nomvern AS (
         SELECT us.cd_nom,
            string_agg(us.nom_vern, ', '::text) AS nom_vern
           FROM unionsel us
          GROUP BY us.cd_nom
        )
 SELECT taxref.cd_nom,
    taxref.id_statut,
    taxref.id_habitat,
    taxref.id_rang,
    taxref.regne,
    taxref.phylum,
    taxref.classe,
    taxref.ordre,
    taxref.famille,
    taxref.cd_taxsup,
    taxref.cd_sup,
    taxref.cd_ref,
    taxref.lb_nom,
    taxref.lb_auteur,
    taxref.nom_complet,
    taxref.nom_complet_html,
    taxref.nom_valide,
    nnv.nom_vern,
    taxref.nom_vern_eng,
    taxref.group1_inpn,
    taxref.group2_inpn,
    taxref.sous_famille,
    taxref.tribu,
    taxref.url,
    taxref.group3_inpn
   FROM taxonomie.taxref
     LEFT JOIN new_nomvern nnv ON nnv.cd_nom = taxref.cd_nom
WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX vm_taxref_cd_nom_idx ON atlas.vm_taxref USING btree (cd_nom);
CREATE INDEX vm_taxref_cd_ref_idx ON atlas.vm_taxref USING btree (cd_ref);
CREATE INDEX vm_taxref_cd_taxsup_idx ON atlas.vm_taxref USING btree (cd_taxsup);
CREATE INDEX vm_taxref_lb_nom_idx ON atlas.vm_taxref USING btree (lb_nom);
CREATE INDEX vm_taxref_nom_complet_idx ON atlas.vm_taxref USING btree (nom_complet);
CREATE INDEX vm_taxref_nom_valide_idx ON atlas.vm_taxref USING btree (nom_valide);

-- Rangs de taxref ordonnés

CREATE TABLE atlas.bib_taxref_rangs (
    id_rang character(4) NOT NULL,
    nom_rang character varying(20) NOT NULL,
    tri_rang integer
);
INSERT INTO atlas.bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('Dumm', 'Domaine', 1);
INSERT INTO atlas.bib_taxref_rangs (id_rang, nom_rang, tri_rang) VALUES ('SPRG', 'Super-Règne', 2);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('KD  ', 'Règne', 3);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSRG', 'Sous-Règne', 4);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('IFRG', 'Infra-Règne', 5);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('PH  ', 'Embranchement', 6);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBPH', 'Sous-Phylum', 7);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('IFPH', 'Infra-Phylum', 8);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('DV  ', 'Division', 9);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBDV', 'Sous-division', 10);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SPCL', 'Super-Classe', 11);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('CLAD', 'Cladus', 12);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('CL  ', 'Classe', 13);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBCL', 'Sous-Classe', 14);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('IFCL', 'Infra-classe', 15);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('LEG ', 'Legio', 16);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SPOR', 'Super-Ordre', 17);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('COH ', 'Cohorte', 18);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('OR  ', 'Ordre', 19);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBOR', 'Sous-Ordre', 20);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('IFOR', 'Infra-Ordre', 21);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SPFM', 'Super-Famille', 22);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('FM  ', 'Famille', 23);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBFM', 'Sous-Famille', 24);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('TR  ', 'Tribu', 26);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSTR', 'Sous-Tribu', 27);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('GN  ', 'Genre', 28);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSGN', 'Sous-Genre', 29);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SC  ', 'Section', 30);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SBSC', 'Sous-Section', 31);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SER', 'Série', 32);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSER', 'Sous-Série', 33);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('AGES', 'Agrégat', 34);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('ES  ', 'Espèce', 35);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SMES', 'Semi-espèce', 36);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('MES ', 'Micro-Espèce',37);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSES', 'Sous-espèce', 38);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('NAT ', 'Natio', 39);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('VAR ', 'Variété', 40);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SVAR ', 'Sous-Variété', 41);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('FO  ', 'Forme', 42);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SSFO', 'Sous-Forme', 43);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('FOES', 'Forma species', 44);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('LIN ', 'Linea', 45);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('CLO ', 'Clône', 46);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('RACE', 'Race', 47);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('CAR ', 'Cultivar', 48);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('MO  ', 'Morpha', 49);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('AB  ', 'Abberatio',50);
--n'existe plus dans taxref V9
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang) VALUES ('CVAR', 'Convariété');
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang) VALUES ('HYB ', 'Hybride');
--non documenté dans la doc taxref
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang, tri_rang) VALUES ('SPTR', 'Supra-Tribu', 25);
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang) VALUES ('SCO ', '?');
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang) VALUES ('PVOR', '?');
INSERT INTO atlas.bib_taxref_rangs  (id_rang, nom_rang) VALUES ('SSCO', '?');
