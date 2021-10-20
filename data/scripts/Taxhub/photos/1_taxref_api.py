# -*- coding: utf-8 -*-
import json
import requests
import time
import random

# requête API pour récupérer une photo par espèce
          
fichier = open('./espece-ssespece_1photo.csv','r', encoding="utf-8")
fichier = fichier.read()
liste = fichier.split('\n')

liste.pop(0)
liste.pop(len(liste)-1)

CD_NOM_LISTE = []
titres = []
auteurs = []
descriptions = []
URLs = []
typemedias = []
typephotos = []
erreurs = []

for e in liste:
    CD_NOM_LISTE.append(e.split(',')[0])

for CD_NOM in CD_NOM_LISTE:
    print(CD_NOM)
    url = 'https://taxref.mnhn.fr/api/taxa/'+CD_NOM+'/media'

    response = requests.get(url)
    try:
        data= response.json()
        time.sleep(random.random()/2)
                
        ## type de média :
        ## ## POUR ESPECES seulement : choper deux photos
        ## ## NB : vérifier pas de photo principale pour les sous-espèces (sinon bug à l'espèce)
        try:
            ## PHOTO 1
            # le nom du taxon => Titre
            titre = [str(data["_embedded"]["media"][0]['taxon']['scientificName'])]
            # INPN, + le droit d'auteur + licence => Auteur
            copyrght = str(data["_embedded"]["media"][0]['copyright'])
            if copyrght =="None":
                auteur ='INPN - '+str(data["_embedded"]["media"][0]['licence'])
            else:
                auteur ='INPN - '+ copyrght
                auteur = auteur+' - '+str(data["_embedded"]["media"][0]['licence'])
            auteur = [auteur]
            # titre => la description ?
            description = [str(data["_embedded"]["media"][0]['title'])]
            # le media => URL
            URL = [str(data["_embedded"]["media"][0]['_links']['file']['href'])]
            # le type de media
            typemedia = [str(data["_embedded"]["media"][0]['mimeType'])]
            # type photo
            typephoto = ['Photo']

            #try:
                ## PHOTO 2
                # le nom du taxon => Titre
                #titre.append(str(data["_embedded"]["media"][1]['taxon']['scientificName']))
                # INPN, + le droit d'auteur + licence => Auteur
                #copyrght = str(data["_embedded"]["media"][1]['copyright'])
                #if copyrght =="None":
                #    auteur2 ='INPN - '+str(data["_embedded"]["media"][1]['licence'])
                #else:
                #    auteur2 ='INPN - '+ copyrght
                #    auteur2 = auteur2+' - '+str(data["_embedded"]["media"][1]['licence'])
                #auteur.append(auteur2)
                # titre => la description ?
                #description.append(str(data["_embedded"]["media"][1]['title']))
                # le media => URL
                #URL.append(str(data["_embedded"]["media"][1]['_links']['file']['href']))
                # le type de media
                #typemedia.append(str(data["_embedded"]["media"][1]['mimeType']))
                # type photo
                #typephoto.append('Photo')
            #except:
            #    pass
            
            titres.append(titre)
            auteurs.append(auteur)
            descriptions.append(description)
            URLs.append(URL)
            typemedias.append(typemedia)
            typephotos.append(typephoto)
        except:
            erreurs.append(CD_NOM)
    except:
        erreurs.append(CD_NOM)

sortie = open('./INPN_espece-ssespece_1photo.txt','w', encoding="utf-8")
sortie.write('CD_NOM;titre;auteur;description;URL;typephoto;typemedia\n')
i = 0
for CD_NOM in CD_NOM_LISTE:
    if CD_NOM in erreurs:
        sortie.write(CD_NOM+";")
        sortie.write(";;;;;\n")
    else:
        titre = titres[i]
        auteur = auteurs[i]
        description = descriptions[i]
        URL = URLs[i]
        typephoto = typephotos[i]
        typemedia = typemedias[i]
        for e in range(len(titre)):
            sortie.write(CD_NOM+";")
            sortie.write(titre[e]+";")
            sortie.write(auteur[e]+";")
            sortie.write(description[e]+";")
            sortie.write(URL[e]+";")
            sortie.write(typephoto[e]+";")
            sortie.write(typemedia[e]+"\n")
        i+=1
sortie.close()
