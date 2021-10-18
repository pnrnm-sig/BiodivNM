# GeoNature-atlas-BiodivNM
Biodiv' Normandie-Maine : https://biodiversite.parc-naturel-normandie-maine.fr/

Installation de GeoNature-atlas par le PNR Normandie-Maine.

Présentation de Biodiv' Normandie-Maine, voir [/docs/BiodivNM_Presentation_202111.pdf](/docs/BiodivNM_Presentation_202111.pdf)

Atlas ayant servi d'inspiration :
* https://biodiv-paysdelaloire.fr/
* https://biodiv.pnr-seine-normande.com/atlas
* https://clicnat.fr/

Voir [/README.rst](/README.rst) la présentation par le PN des Écrins

# Personnalisation du style
Modification de certains fichiers CSS et directement dans les modèles de pages html. 
Sinon, principalement surcharge des styles ou ajout de modèle personnalisé dans [/static/custom/custom.css](/static/custom/custom.css)

# Page accueil
## Rotation de la photo d'accueil
Tous les mois, en fonction de 12 photos dans [/static/custom/images/accueil-intro](/static/custom/images/accueil-intro)
```
sudo crontab -e

## change tous les mois
0 2 * 1 * cp /home/pnr/atlas/static/custom/images/accueil-intro/1_grandmurin.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 2 * cp /home/pnr/atlas/static/custom/images/accueil-intro/2_grenouillerousse.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 3 * cp /home/pnr/atlas/static/custom/images/accueil-intro/3_chouettecheveche.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 4 * cp /home/pnr/atlas/static/custom/images/accueil-intro/4_minotaure.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 5 * cp /home/pnr/atlas/static/custom/images/accueil-intro/5_mesangebleue.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 6 * cp /home/pnr/atlas/static/custom/images/accueil-intro/6_litorelle.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 7 * cp /home/pnr/atlas/static/custom/images/accueil-intro/7_damier.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 8 * cp /home/pnr/atlas/static/custom/images/accueil-intro/8_fluteau.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 9 * cp /home/pnr/atlas/static/custom/images/accueil-intro/9_mulette.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 10 * cp /home/pnr/atlas/static/custom/images/accueil-intro/10_hypholome.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 11 * cp /home/pnr/atlas/static/custom/images/accueil-intro/11_ cerfelaphe.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg
0 2 * 12 * cp /home/pnr/atlas/static/custom/images/accueil-intro/12_drosera.jpg /home/pnr/atlas/static/custom/images/accueil-intro.jpg

# redémarre pour appliquer les changements
10 2 * * * supervisorctl restart atlas
```

## Modification du fonctionnement "à voir en ce moment"

Sélection aléatoire de 12 taxons parmi les 36 les plus observés dans les 15 jours avant/après la date du jour, 
toutes années confondues. Sélection uniquement des taxons avec une photo.

Modification de la création de vm_taxons_plus_observes, voir [/static/custom/images/accueil-intro](/static/custom/images/accueil-intro)
```
CREATE MATERIALIZED VIEW atlas.vm_taxons_plus_observes AS
SELECT * 
	from (SELECT count(*) AS nb_obs,
          obs.cd_ref,
  	  tax.lb_nom,
  	  tax.group2_inpn,
  	  tax.nom_vern,
  	  m.id_media,
  	  m.url,
  	  m.chemin,
 	  m.id_type
 	  FROM atlas.vm_observations obs
 	    JOIN atlas.vm_taxons tax ON tax.cd_ref = obs.cd_ref
 	    LEFT JOIN atlas.vm_medias m ON m.cd_ref = obs.cd_ref AND m.id_type = 1
	 WHERE date_part('day'::text, obs.dateobs) >= date_part('day'::text, 'now'::text::date - 15) AND date_part('month'::text, obs.dateobs) = date_part('month'::text, 'now'::text::date - 15) OR date_part('day'::text, obs.dateobs) <= date_part('day'::text, 'now'::text::date + 15) AND date_part('month'::text, obs.dateobs) = date_part('day'::text, 'now'::text::date + 15)
 	 GROUP BY obs.cd_ref, tax.lb_nom, tax.nom_vern, m.url, m.chemin, tax.group2_inpn, m.id_type, m.id_media
 	 ORDER BY (count(*)) desc
 	LIMIT 36) as selection
 WHERE selection.id_media IS NOT NULL
 ORDER BY (random()) desc
 LIMIT 12;
 ```
 
Puis ajout d'une tâche planifiée pour raffraichir la vue toutes les 15 minutes.
```
sudo su postgres
crontab -e

*/15 * * * * psql -d geonatureatlas -c "REFRESH MATERIALIZED VIEW CONCURRENTLY atlas.vm_taxons_plus_observes;"
```

## Modification du fonctionnement limites pour les données et les cartes du territoire

Trois types de limites paramétrées dans la configuration de l'atlas : 
* les limites du PNR pour l'affichage sur les cartes
* la zone considérée pour récuperer les données de la base GeoNature
* les villes portes pour l'affichage sur les cartes

![limites_territoires](/docs/images/limites_territoire.png)

Voir modifications dans : [/data/ref](/data/ref) ; [/atlas/configuration/settings.ini](/atlas/configuration/settings.ini) ; [/install_db.sh](/install_db.sh)

# Ajout page "données" et page "partenaires"

Voir modèle de pages :
[/static/custom/templates/donnees.html](/static/custom/templates/donnees.html)
[/static/custom/templates/partenaires.html](/static/custom/templates/partenaires.html)

# Ajouts et/ou modification des pictos

[/static/images/](/static/images/)

# Modifications des photos 
## Ajouts INPN, Wikipedias etc.

Voir https://github.com/PnX-SI/TaxHub/tree/master/data/scripts
Scripts adaptés, cf. ...

## Ajout source et licence

## Ajout descriptions INPN

# Fiche espèce
## Ajout espèces protégées / espèces patrimoniales

## Ajout cartes INPN

## Ajout cartes GBIF

## Ajout des milieux

À partir des habitats associés aux taxons

