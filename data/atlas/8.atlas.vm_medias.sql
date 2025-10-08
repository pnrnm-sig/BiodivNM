-- Médias de chaque taxon

CREATE MATERIALIZED VIEW atlas.vm_medias AS
   SELECT t_medias.id_media,
      t_medias.cd_ref,
      t_medias.titre,
      t_medias.url,
      t_medias.chemin,
      t_medias.auteur,
      t_medias.desc_media,
      t_medias.date_media,
      t_medias.id_type,
      t_medias.licence,
      t_medias.source
   FROM taxonomie.t_medias
WHERE NOT t_medias.supprime = true and t_medias.is_public = true
WITH DATA;

CREATE INDEX vm_medias_cd_ref_idx ON atlas.vm_medias USING btree (cd_ref);
CREATE UNIQUE INDEX vm_medias_id_media_idx ON atlas.vm_medias USING btree (id_media);