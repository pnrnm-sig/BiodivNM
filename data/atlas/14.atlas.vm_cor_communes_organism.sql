-- atlas.vm_cor_communes_organism
CREATE MATERIALIZED VIEW atlas.vm_cor_communes_organism
TABLESPACE pg_default
AS 

with obs_org as (
SELECT DISTINCT 
obs.id_observation,
CASE
	WHEN rcda.id_organism IS NOT NULL THEN rcda.id_organism
	WHEN tr.id_organisme IS NOT NULL THEN tr.id_organisme
	ELSE NULL::integer
END AS id_organism,
obs.insee
FROM atlas.vm_observations obs
JOIN gn_meta.cor_dataset_actor rcda ON obs.id_dataset = rcda.id_dataset
LEFT JOIN utilisateurs.t_roles tr ON tr.id_role = rcda.id_role
WHERE rcda.id_nomenclature_actor_role = ANY (ARRAY[370, 369])
)
select count(*) as nb_observations, vo.insee, oo.id_organism, bo.nom_organisme as nom_organism, bo.url_organisme as url_organism, bo.url_logo
from atlas.vm_observations vo
join obs_org oo on oo.id_observation = vo.id_observation
join utilisateurs.bib_organismes bo on bo.id_organisme = oo.id_organism 
group by oo.id_organism, bo.nom_organisme, bo.url_organisme, bo.url_logo, vo.insee
ORDER BY vo.insee,nb_observations desc

WITH DATA;

-- View indexes:
CREATE UNIQUE INDEX vm_cor_communes_organism_insee_id_organism_idx ON atlas.vm_cor_communes_organism USING btree (insee,id_organism);
CREATE INDEX vm_cor_communes_organism_id_organism_idx ON atlas.vm_cor_communes_organism USING btree (id_organism);