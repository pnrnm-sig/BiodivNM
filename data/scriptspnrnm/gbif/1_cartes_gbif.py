# -*- coding: utf-8 -*-

# recherche du code GBIF associé à un taxon, en utilisant l'API du GBIF et le nom, puis
# la famille, l'ordre, la classe, le phylum ou le regne du taxon

import requests
import random
import time

fichier = open('./ajout_gbif.csv','r',encoding='utf-8')
fichier = fichier.read()

liste = fichier.split('\n')
liste.pop(0)
liste.pop(len(liste)-1)

fichier = open('./sortie_gbif_key.csv',"w",encoding='utf-8')
fichier.write('cd_ref;gbif_key;match_type\n')

i = 0
j = len(liste)
print(str(i)+'/'+str(j))
for ligne in liste:
    try:
        url = "https://api.gbif.org/v1/species/match?verbose=false"
        
        val = ligne.split(";")
        cd_ref = val[0]
        nom = val[1]
        famille = val[2]
        ordre = val[3]
        classe = val[4]
        phylum = val[5]
        regne = val[6]
        if famille!="":
            url=url+"&family="+famille
        elif ordre!="":
            url=url+"&order="+ordre
        elif classe!="":
            url=url+"&class="+classe
        elif phylum!="":
            url=url+"&phylum="+phylum
        elif regne!="":
            url=url+"&kingdom="+regne
        url = url+"&name="+nom
    
        x = requests.get(url)
        key = x.json()['usageKey']
        match = x.json()['matchType']
        
        fichier.write(cd_ref+";")
        fichier.write(str(key)+";")
        fichier.write(match)
        fichier.write('\n')
        time.sleep(random.random()/25)
    except:
        pass
    i += 1
    if i%100==0:
        print(str(i)+'/'+str(j))

fichier.close()
    
