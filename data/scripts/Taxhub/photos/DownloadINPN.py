# -*- coding: utf-8 -*-

# télécharge les images à partir des liens INPN

from os import listdir
from PIL import Image
import requests

fichier = open('./URL_t_medias_202109131010.csv','r', encoding="utf-8")
fichier = fichier.read()
URLs = fichier.split('\n')

URLs.pop(0)
URLs.pop(len(URLs)-1)

for url in URLs:
    r = requests.get(url, allow_redirects=True)
    filename = url.split('/')
    filename = './INPN/'+filename[len(filename)-1]+'.jpg'
    open(filename , 'wb').write(r.content)
    try:
        img = Image.open(filename) # open the image file
        img.verify() # verify that it is, in fact an image
    except (IOError, SyntaxError) as e:
        print('Bad file:', url) # print out the names of corrupt files
