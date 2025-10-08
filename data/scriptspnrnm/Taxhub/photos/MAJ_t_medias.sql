-- vérifier bien le bon nombre et que cd_nom = cd_ref
select count(*)
from taxonomie.ajoutphotoinpn2021 a 
left join taxonomie.taxref t on t.cd_ref = a.cd_nom_ajout 
where t.cd_nom is not null and t.cd_nom = t.cd_ref 
;

-- taxon saisi, pas dans bib nom, est-il dans l'atlas ?
-- --> oui. exemple http://149.202.129.108/atlas/espece/86827
-- -- par contre, pas les mêmes n obs
select s.cd_nom,count(*)
from gn_synthese.synthese s
left join taxonomie.bib_noms bn on bn.cd_nom = s.cd_nom 
where bn.cd_nom is null
group by s.cd_nom;

-- vérifier que les cd_nom sont bien dans le taxhub (taxon ajouté)
-- --> il faut ajouter des taxons dans bib nom pour pouvoir ajouter média
select count(*)
from taxonomie.ajoutphotoinpn2021 a 
left join taxonomie.bib_noms bn on bn.cd_nom = a.cd_nom_ajout 
where bn.cd_nom is null
;

--- !!!
--- REQUETE DE MAJ bib noms
INSERT INTO taxonomie.bib_noms (
        cd_nom, 
        cd_ref, 
        nom_francais 
    )
select distinct 
		a."CD_NOM",
		a."CD_NOM",
		t.nom_vern 
from 
	taxonomie.ajoutphotoinpn2021 a
left join taxonomie.taxref t on t.cd_nom = a."CD_NOM"
left join taxonomie.bib_noms bn on bn.cd_nom = a."CD_NOM"
where bn.cd_nom is null
;

--select distinct 
--		a.cd_nom_ajout ,
--		t.nom_vern 
--from 
--	taxonomie.ajoutphotoinpn2021 a
--left join taxonomie.taxref t on t.cd_nom = a.cd_nom_ajout 
--left join taxonomie.bib_noms bn on bn.cd_nom = a.cd_nom_ajout 
--where bn.cd_nom is null 
--;

-- verifier bien pas déjà dans t_media & photo principale
select *
from taxonomie.ajoutphotoinpn2021 a, taxonomie.t_medias tm 
where a.cd_nom_ajout = tm.cd_ref and a.typephoto = 1
;
-- -- correction
update taxonomie.ajoutphotoinpn2021
set typephoto = 2
where cd_nom_ajout = 4770;

-- verifier pas plus d'un photo principale
select a.cd_nom_ajout, a.typephoto , count(*)
from taxonomie.ajoutphotoinpn2021 a 
where a.typephoto = 1
group by a.cd_nom_ajout, a.typephoto 
;

-- photo par type
select a.typephoto , count(*)
from taxonomie.ajoutphotoinpn2021 a 
group by a.typephoto 
;

-- verif table ajoutphotoinpn2021 : pas de doublon d'url
select a.url_ajout , count(*)
from taxonomie.ajoutphotoinpn2021 a 
group by a.url_ajout 
;

-- modifier titre pour ajouter nom vernaculaire + nom latin ()
--select a.cd_nom_ajout, t.nom_vern, t.nom_complet, a.titre,concat(split_part(t.nom_vern,',',1),' (',a.titre,')') as description_ajout
--from taxonomie.ajoutphotoinpn2021 a 
--left join taxonomie.taxref t on t.cd_ref = a.cd_nom_ajout 
--where t.cd_ref = t.cd_nom and t.nom_vern is not null
--;

update taxonomie.ajoutphotoinpn2021 
set titre2 = concat(split_part(t.nom_vern,',',1),' (',ajoutphotoinpn2021.titre,')')
from taxonomie.taxref t 
where t.cd_ref = t.cd_nom and t.nom_vern is not null and t.cd_ref = ajoutphotoinpn2021.cd_nom_ajout 
;

-- modifier Description pour que none = null
update taxonomie.ajoutphotoinpn2021 
set description = NULL
where description = 'None'
;

--- !!!
--- REQUETE insert nouvelles photos
INSERT INTO taxonomie.t_medias(
        cd_ref, 
        titre, 
        url, 
        auteur,
        desc_media, 
        date_media, 
        id_type
    )
select 
		a.cd_nom_ajout ,
		a.titre2,
		a.url_ajout,
		a.auteur,
		a.description,
		now(),
		a.typephoto 	
from 
	taxonomie.ajoutphotoinpn2021 a
;

-- vérifier pas ajout de photo principal pour sous espèces
SELECT t.id_rang, tm.cd_ref,tm.id_type,count(*)
from taxonomie.t_medias tm 
left join taxonomie.taxref t on t.cd_nom = tm.cd_ref 
where t.id_rang = 'SSES' and tm.id_type = 1
group by t.id_rang, tm.cd_ref, tm.id_type 
;

-- vérifier une seule photo principale par espèce
SELECT t.id_rang, tm.cd_ref,tm.id_type,count(*)
from taxonomie.t_medias tm 
left join taxonomie.taxref t on t.cd_nom = tm.cd_ref 
where t.id_rang = 'ES' and tm.id_type = 1
group by t.id_rang, tm.cd_ref, tm.id_type 
;

-- vérifier une seule photo principale en général
SELECT tm.cd_ref,tm.id_type,count(*)
from taxonomie.t_medias tm 
where tm.id_type = 1
group by tm.cd_ref, tm.id_type 
;

-- vérifier que pas modifier les infos d'avant
select  act.id_type_copie,tm.id_type , count(*)
from taxonomie.t_medias tm
left join taxonomie.ajout_copie_tmedia act on act.id_media = tm.id_media
where act.id_media is not null
group by act.id_type_copie,tm.id_type;

-- -- si modif : update (ne fonctionne pas pour 4 medias...)
--UPDATE 
--    taxonomie.t_medias tm
--SET 
--    id_type = 1
--FROM 
--    taxonomie.ajout_copie_tmedia act
--WHERE 
--    act.id_media = tm.id_media and act.id_type_copie=1
--;
-- edit à la main pour les 4 medias où ça ne fonctionne pas : pour bien avoir un media
-- avec 1 Principal
select * 
FROM 
	taxonomie.t_medias tm
left join taxonomie.ajout_copie_tmedia act on act.id_media = tm.id_media 
WHERE 
    act.id_type_copie<>tm.id_type ;
   
--------------------------------------------
--------------------------------------------
-- vérifier que l'édition des nouveaux médias est ok
select  a.typephoto,tm.id_type , count(*)
from taxonomie.t_medias tm
left join taxonomie.ajoutphotoinpn2021 a on a.cd_nom_ajout = tm.cd_ref 
where a.url_ajout = tm.url  and tm.chemin is null
group by a.typephoto ,tm.id_type; 

----- supprime les url avec images corrompues
delete 
FROM 
	taxonomie.t_medias tm
WHERE tm.url in (
'https://taxref.mnhn.fr/api/media/download/inpn/162671',
'https://taxref.mnhn.fr/api/media/download/inpn/238752',
'https://taxref.mnhn.fr/api/media/download/inpn/239310',
'https://taxref.mnhn.fr/api/media/download/inpn/239311',
'https://taxref.mnhn.fr/api/media/download/inpn/239313',
'https://taxref.mnhn.fr/api/media/download/inpn/239319',
'https://taxref.mnhn.fr/api/media/download/inpn/239320',
'https://taxref.mnhn.fr/api/media/download/inpn/239322',
'https://taxref.mnhn.fr/api/media/download/inpn/239323',
'https://taxref.mnhn.fr/api/media/download/inpn/239325',
'https://taxref.mnhn.fr/api/media/download/inpn/239326',
'https://taxref.mnhn.fr/api/media/download/inpn/239329',
'https://taxref.mnhn.fr/api/media/download/inpn/239332',
'https://taxref.mnhn.fr/api/media/download/inpn/239334',
'https://taxref.mnhn.fr/api/media/download/inpn/241197',
'https://taxref.mnhn.fr/api/media/download/inpn/241610',
'https://taxref.mnhn.fr/api/media/download/inpn/241612',
'https://taxref.mnhn.fr/api/media/download/inpn/241625',
'https://taxref.mnhn.fr/api/media/download/inpn/241626',
'https://taxref.mnhn.fr/api/media/download/inpn/242157',
'https://taxref.mnhn.fr/api/media/download/inpn/242158',
'https://taxref.mnhn.fr/api/media/download/inpn/242165',
'https://taxref.mnhn.fr/api/media/download/inpn/242166',
'https://taxref.mnhn.fr/api/media/download/inpn/242370',
'https://taxref.mnhn.fr/api/media/download/inpn/242372',
'https://taxref.mnhn.fr/api/media/download/inpn/242470',
'https://taxref.mnhn.fr/api/media/download/inpn/242472',
'https://taxref.mnhn.fr/api/media/download/inpn/242849',
'https://taxref.mnhn.fr/api/media/download/inpn/242869',
'https://taxref.mnhn.fr/api/media/download/inpn/243471',
'https://taxref.mnhn.fr/api/media/download/inpn/293814',
'https://taxref.mnhn.fr/api/media/download/inpn/382187',
'https://taxref.mnhn.fr/api/media/download/inpn/382222',
'https://taxref.mnhn.fr/api/media/download/inpn/382277'
)
;

-------------------
-- maj de t_medias
select concat(replace(t_medias.url,'https://taxref.mnhn.fr/api/media/download/inpn/','https://geonature.parc-naturel-normandie-maine.fr/taxhub/static/medias/inpn/'),'.jpg')
from taxonomie.t_medias
where t_medias."source" = 'INPN';

update taxonomie.t_medias
set url = concat(replace(t_medias.url,'https://taxref.mnhn.fr/api/media/download/inpn/','https://geonature.parc-naturel-normandie-maine.fr/taxhub/static/medias/inpn/'),'.jpg')
where "source" = 'INPN' and (id_type = 1 or id_type = 2);