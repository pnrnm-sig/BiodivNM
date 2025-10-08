# -*- coding: utf-8 -*-

# met à plat 

# ouvrir le fichier issu de la requete dans la BD GeoNature et en faire des listes
fichier = open('./ajout_milieu.csv','r',encoding='utf-8')
fichier = fichier.read()

liste = fichier.split('\n')
liste.pop(0)
liste.pop(len(liste)-1)

cd_ref = []
listes_hab = []
listes_lib = []
listes_niv = []

for e in liste:
    e = e.split('µ')
    cdref = e[0]
    hab = e[1]
    lib = e[2]
    niv = e[3]
    if cdref not in cd_ref:
        cd_ref.append(cdref)
        listes_hab.append([hab])
        listes_lib.append([lib])
        listes_niv.append([niv])
    else:
        i = cd_ref.index(cdref)
        listes_hab[i].append(hab)
        listes_lib[i].append(lib)
        listes_niv[i].append(niv)

# parcourir les listes de cd_nom, d'habitat par cd_nom
## garde tous les habitats si :
## pas de niveau 2 : garde niveau 1 ou le 
list_resulthab = []
list_resultlib = []
i = 0
for cd in cd_ref:
    hab = listes_hab[i][:]
    resulthab = listes_hab[i][:]
    resultlib = listes_lib[i][:]
    niv = listes_niv[i][:]
    j = 0
	# pour chaque habitat associé
    for h in hab:
		# compare aux autres habitats de la liste :
		## garde le plus petit niveau, si celui-ci est niveau 2, enlève niveau 1 de la liste
        for h2 in hab[j:]:
            if h2[0:len(h)]==h and len(h)!=len(h2):
                try:
                    if int(niv[j+1])>2:
                        resultlib.pop(resulthab.index(h2))
                        resulthab.pop(resulthab.index(h2))

                    else:
                        resultlib.pop(resulthab.index(h))
                        resulthab.pop(resulthab.index(h))
                        break
                except:
				# si h a déjà été enlevé des résultats
                    pass
        j += 1
    list_resulthab.append(resulthab)
    list_resultlib.append(resultlib)
    i += 1

fichier = open('./sortie.csv',"w",encoding='utf-8')
fichier.write('"cd_ref_milieu";"code_eunis"\n')
i = 0
for cd in cd_ref:
    fichier.write(cd+';"')
    j = 0
    for hab in list_resulthab[i]:
        if len(list_resulthab[i])==j+1:
            fichier.write(hab+" : "+list_resultlib[i][j])
        else:
            fichier.write(hab+" : "+list_resultlib[i][j]+" | ")
        j += 1
    fichier.write('"\n')
    i += 1
fichier.close()
    
    
