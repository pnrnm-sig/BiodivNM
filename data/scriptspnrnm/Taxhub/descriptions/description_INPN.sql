-- pas de description => liste pour recherche API taxref
select distinct bn.cd_ref
from taxonomie.bib_noms bn
where bn.cd_ref not in
	(select distinct bn.cd_ref
	from taxonomie.bib_noms bn
	left join taxonomie.cor_taxon_attribut cta on cta.cd_ref = bn.cd_ref 
	where cta.id_attribut = 100)
order by bn.cd_ref asc
;

-- une fois le résultat de l'API chargée dans la base de données (ajoutdescriptioninpn2021.inpn_portrait)
-- ajout dans la table des nouvelles descriptions
-- ! attention, vérifier la longueur des descriptions avant et le formatage
INSERT INTO taxonomie.cor_taxon_attribut (id_attribut, valeur_attribut , cd_ref)
select 
	100, 
	ajoutdescriptioninpn2021.inpn_portrait,
	ajoutdescriptioninpn2021.cd_nom_desc
from taxonomie.ajoutdescriptioninpn2021
;