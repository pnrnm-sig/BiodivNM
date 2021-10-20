# -*- coding: utf-8 -*-

# test l'image si corrompue ou pas

from os import listdir
from PIL import Image, ImageDraw
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

xxx

filename = 'test.jpg'
output = open('./ImagesCorrompues.txt','w', encoding="utf-8")
output.write("URL\n")

for url in URLs:
    r = requests.get(url, allow_redirects=True)
    open(filename , 'wb').write(r.content)
    try:
        img = Image.open('./'+filename) # open the image file
        img.verify() # verify that it is, in fact an image
        img.show
    except (IOError, SyntaxError) as e:
        print('Bad file:', url) # print out the names of corrupt files
        output.write(url+"\n")
output.close()
