-- MODIF PNRNM
-- ajout de champs : précision et validation
-- ajout champ info_geom_point en lien avec modif the_geom_point
-- modif de the_geom_point pour prendre en compte
-- modification de la sélection pour exclure données sensible sans diff (si mauvais lien avec champ diff)  => OR s.id_nomenclature_sensitivity = 71
-- ajouts des vues pour anonymiser ou pas les noms diffusés

--

-- Création de vue pour anonymiser ou pas les noms en fonction des producteurs / diffuseurs
-- et si l'info d'anonymisation est connue dans la table t_roles
-- VOIR diff_observers

-- Creation d'une vue permettant de reproduire le contenu de la table du même nom dans les versions précédentes
-- VOIR syntheseatlas

-- synthese.syntheseff source
CREATE MATERIALIZED VIEW synthese.syntheseff
TABLESPACE pg_default
AS SELECT d.id_synthese,
    d.id_dataset,
    d.cd_nom,
    d.dateobs,
    d.observateurs,
    d.altitude_retenue,
    d.the_geom_point,
    d.effectif_total,
    c.insee,
    d.diffusion_level,
    d."precision",
    d.validation,
    d.info_geom_point
   FROM synthese.syntheseatlas d
     JOIN atlas.l_communes c ON st_intersects(d.the_geom_point, c.the_geom)
WITH DATA;

 -- View indexes:
CREATE UNIQUE INDEX vm_syntheseff_id ON synthese.syntheseff USING btree (id_synthese);