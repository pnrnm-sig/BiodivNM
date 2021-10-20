# -*- coding: utf-8 -*-

# à partir d'une liste de taxons, récupère infos si espèce protégée ou patrimoniale

import requests

fichier = open('./bib_noms_202109091532.csv','r',encoding='utf-8')
fichier = fichier.read()

cd_liste = fichier.split('\n')
cd_liste.pop(0)
cd_liste.pop(len(cd_liste)-1)

fichier = open('./sortie_statuts.csv',"w",encoding='utf-8')
fichier.write('cd_ref;source\n')

i = 0
j = len(cd_liste)
print(str(i)+'/'+str(j))
for cd_ref in cd_liste:
    x = requests.get('https://taxref.mnhn.fr/api/taxa/'+cd_ref+'/status/columns')
    try:
        infos = x.json()['_embedded']['status'][0]

        # LR
        for liste in ['worldRedList','europeanRedList',"nationalRedList"]:
            try:
                listerouges = infos[liste].split(',')
            except:
                listerouges = ""
            listerouge=False
            if listerouges!="":
                for l in listerouges:
                    if l in ['CR','EN','VU']:
                        listerouge=True
                        fichier.write(cd_ref+";"+"Espèce menacée"+'\n')
                        break
            if listerouge:
                break
        # dt Znieff        
        if infos['determinanteZnieff'] != None:
            fichier.write(cd_ref+";"+"Espèce déterminante ZNIEFF"+'\n')

        # protection
        protections = ['nationalProtection','regionalProtection','departementalProtection']
        protection=False
        for p in protections:
            if infos[p] != None:
                protection=True
                fichier.write(cd_ref+";"+"Espèce protégée"+'\n')
                break
            if protection:
                break
    except:
        pass
    i += 1
    if i%50==0:
        print(str(i)+'/'+str(j))

fichier.close()
