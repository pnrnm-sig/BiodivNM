-- 1. sélection code et lib Eunis
select cd_ref, h.lb_code, h.lb_hab_fr, h.niveau
from taxonomie.bib_noms bn
left join ref_habitats.habref_corresp_taxon hct on hct.cd_nom = bn.cd_nom 
left join ref_habitats.habref h on h.cd_hab = hct.cd_hab_entre 
where h.cd_typo = 7
order by cd_ref,h.lb_code asc
;

-- 2. sélection que niveau 2 ou plus petit niveau restant si pas niveau 2
-- voir habitats.py

-- 3. maj de la table bib_attributs
-- ajout d'une nouvelle ligne
-- 104	atlas_milieu_habref	Milieu EUNIS	{}	false	Habitats associés aux taxons	text	textarea			2	104

-- maj de la table...
INSERT INTO taxonomie.cor_taxon_attribut (id_attribut, valeur_attribut , cd_ref)
select 
	104, 
	ajout_milieux_habref.code_eunis,
	ajout_milieux_habref.cd_ref_milieu
from taxonomie.ajout_milieux_habref
;

select *
from taxonomie.cor_taxon_attribut
where id_attribut= 104;

-- édition de la config de GeoNature-Atlas pour prise en compte
-- dans : /home/pnr/atlas/atlas/configuration/config.py
-- #### ID DES ATTRIBUTS DESCRIPTIFS DES TAXONS DE LA TABLE vm_cor_taxon_attribut
-- ATTR_MILIEU = 104

-- dans /home/pnr/atlas/models/repositories/vmCorTaxonAttribut.py
--        elif r.id_attribut == attrMilieu:
--            #descTaxon['milieu'] = r.valeur_attribut.replace("&" , " | ")
--            descTaxon['milieu'] = r.valeur_attribut

-- dans /home/pnr/atlas/templates/ficheEspce.html

-- dans / homme/pnr/atlas.sql
--     WHERE id_attribut IN (100, 101, 102, 103, 104);

