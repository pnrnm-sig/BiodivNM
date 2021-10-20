# -*- coding: utf-8 -*-

# ouvre image d'une liste, lorsque pas d'auteur lorsque récup depuis l'API taxref

import os
from PIL import Image
import requests

fichier = open('./auteurNULL.csv','r', encoding="utf-8")
fichier = fichier.read()
liste = fichier.split('\n')

liste.pop(0)
liste.pop(len(liste)-1)

fichiers = []

for e in liste:
    fichier = e.split(';')[1]
    fichier = fichier.split('/')
    fichier = fichier[len(fichier)-1]
    fichiers.append(fichier)

auteur1 = ''

output0= open('./auteurNULL_modif.csv','r', encoding="utf-8")
output= open('./auteurNULL_modif.csv','a', encoding="utf-8")
ln = output0.read()
ln = len(ln.split("\n"))-1
i = 0
for fichier in fichiers:
    print(fichier)
    if ln>0 and i <= ln:
        i+=1
    else:
        filename = './/INPN//'+fichier+'.jpg'
        img = Image.open('./'+filename) # open the image file
        img.show()
        auteur0 = input('Auteur :')
        if auteur0=="STOP":
            os.system("TASKKILL /F /IM Microsoft.Photos.exe")
            break
        if auteur0=='':
            auteur0=auteur1
        else:
            auteur1=auteur0
        output.write(fichier+";"+auteur0+"\n")
        os.system("TASKKILL /F /IM Microsoft.Photos.exe")

output.close()
    
    
    
