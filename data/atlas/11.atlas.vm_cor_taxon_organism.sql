 -- Vue Nombre d'oservation par taxons et par organisme
 -- uniquement producteurs et fournisseurs

CREATE MATERIALIZED VIEW atlas.vm_cor_taxon_organism AS
SELECT obs_by_dataset_and_orga.nb_obs AS nb_observations,
    obs_by_dataset_and_orga.cd_ref,
    bo.id_organisme AS id_organism,
    bo.nom_organisme AS nom_organism,
    bo.adresse_organisme AS adresse_organism,
    bo.cp_organisme AS cp_organism,
    bo.ville_organisme AS ville_organism,
    bo.tel_organisme AS tel_organism,
    bo.email_organisme AS email_organism,
    bo.url_organisme AS url_organism,
    bo.url_logo
   FROM (

with cor_obs_sel as (
SELECT distinct
	obs.id_observation,
	obs.cd_ref,
	case 
		when rcda.id_organism is not null then rcda.id_organism
		when tr.id_organisme is not null then tr.id_organisme
		else null
	end as id_organism
FROM atlas.vm_observations obs
	JOIN gn_meta.cor_dataset_actor rcda ON obs.id_dataset = rcda.id_dataset
	left join utilisateurs.t_roles tr on tr.id_role = rcda.id_role
	where rcda.id_nomenclature_actor_role = ANY (ARRAY[370, 369])
)
SELECT count(DISTINCT cos.id_observation) AS nb_obs,
            cos.cd_ref,
            cos.id_organism
from cor_obs_sel cos
GROUP BY cos.cd_ref, cos.id_organism

          ) obs_by_dataset_and_orga
     JOIN utilisateurs.bib_organismes bo ON bo.id_organisme = obs_by_dataset_and_orga.id_organism;

CREATE UNIQUE INDEX vm_cor_taxon_organism_cd_ref_id_organism_idx
    ON atlas.vm_cor_taxon_organism USING btree (cd_ref, id_organism);

CREATE INDEX vm_cor_taxon_organism_id_organism_idx
    ON atlas.vm_cor_taxon_organism USING btree (id_organism);