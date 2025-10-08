# -*- coding: utf-8 -*-

# recherche du code GBIF associé à un taxon, en utilisant l'API du GBIF et le nom, puis
# la famille, l'ordre, la classe, le phylum ou le regne du taxon

import requests

fichier = open('./errors.csv','r',encoding='utf-8')
fichier = fichier.read()

liste = fichier.split('\n')
liste.pop(0)
liste.pop(len(liste)-1)

fichier = open('./ajout_openobs2.csv',"w",encoding='utf-8')
fichier.write('cd_ref;gbif_key;match_type\n')

j = len(liste)
for ligne in liste:
    try:
        url = "https://api.gbif.org/v1/species/match?verbose=false"
        
        val = ligne.split(";")
        cd_ref = val[0]
        nom = val[1]
        url = url+"&name="+nom
        x = requests.get(url)
        key = x.json()['usageKey']
        match = x.json()['matchType']
        
        fichier.write(cd_ref+";")
        fichier.write(str(key)+";")
        fichier.write(match)
        fichier.write('\n')
    except:
        pass
fichier.close()
    
