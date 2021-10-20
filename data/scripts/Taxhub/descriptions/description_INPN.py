# -*- coding: utf-8 -*-

# récupération des descriptions de l'INPN, avec l'API taxref, à partir d'une liste de taxons en .csv
# attention, elles sont nombreuses à dépasser la limites de 2500 caractères. 
# Par ailleurs, il faut les retravailler pour harmoniser les styles entre les différentes fiches

import requests
import random
import time

fichier = open('./liste_descriptions_ajout.csv','r',encoding='utf-8')
fichier = fichier.read()

cd_liste = fichier.split('\n')
cd_liste.pop(0)
cd_liste.pop(len(cd_liste)-1)

fichier = open('./sortie_fiche.csv',"w",encoding='utf-8')
fichier.write('cd_nom£inpn_portrait£nbcar\n')

i = 0
j = len(cd_liste)
print(str(i)+'/'+str(j))
for cd_nom in cd_liste:
    if cd_nom=='53908':
        pass
    else:
        try:
            source = '<i>Source : <a href="https://inpn.mnhn.fr/espece/cd_nom/'+cd_nom
            source = source+'/tab/fiche" target="_blank"> fiche descriptive, INPN</a></i>'
            x = requests.get('https://taxref.mnhn.fr/api/taxa/'+cd_nom+'/factsheet')
            text = x.json()['text']

            # MODIF
            text = text.replace('\n','')
            text = text.replace('\r','')
            text = text.replace('\r','')
            text = text.replace('&nbsp;',' ')
            a = len(text)+1
            b = len(text)
            while a>b:
                a = len(text)
                text = text.replace('  ',' ')
                b = len(text)
            text = text.replace('</span>','')
            text = text.replace('</font>','')
            text = text.replace('<font face="Arial, Verdana">','')
            text = text.replace('<font face="Arial, sans-serif">','')
            text = text.replace('<font face="Arial, Verdana" style="">','')
            text = text.replace('<font color="#000000">','')
            text = text.replace('<span style="font-size: 13.3333px;">','')
            text = text.replace('<span style="font-size: 13.3333px; font-family: Arial, Verdana;">','')
            text = text.replace('<span style="font-style: normal;">','')
            text = text.replace('<div align="justify">','')
            text = text.replace('</div>','')
            text = text.replace('<p style="">','<p>')
            text = text.replace('<p style="font-style: normal; font-weight: normal; font-family: Arial, Verdana; font-size: 10pt; font-variant-ligatures: normal; font-variant-caps: normal;">','<p>')
            text = text.replace('<p style="font-weight: normal; font-family: Arial, Verdana; font-size: 10pt; font-variant-ligatures: normal; font-variant-caps: normal;"><span style="font-style: normal;">','<p>')
            text = text.replace('<p style="font-weight: normal; font-family: Arial, Verdana; font-size: 10pt;">','<p>')
            text = text.replace('<i style="font-style: normal;">','<i>')
            text = text.replace('<p style="font-style: normal; font-family: Arial, Verdana; font-size: 10pt; font-variant-ligatures: normal; font-variant-caps: normal;">','<p>')
            text = text.replace('<p style="font-style: normal;">','<p>')
            text = text.replace('<p align="justify">','<p>')
            text = text.replace('<b style="font-style: normal;">','<b>')
            text = text.replace('<strong style="font-size: 10pt;">','<strong>')
            # FIN modif
            
            fichier.write(cd_nom+"£")
            fichier.write(text)
            fichier.write(source)
            fichier.write("£"+str(len(text)))
            fichier.write('\n')
            time.sleep(random.random()/20)
        except:
            pass
    i += 1
    if i%1000==0:
        print(str(i)+'/'+str(j))

fichier.close()
    
