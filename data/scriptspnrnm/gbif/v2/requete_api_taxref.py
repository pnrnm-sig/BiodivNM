import requests

# recherche avec l'api du mnhn
cdref = open('./cdref_openobs04112024_ajouselec.csv','r',encoding='utf-8')
cdref = cdref.read()

cdref = cdref.split('\n')
cdref.pop(0)
cdref.pop(len(cdref)-1)

resultat = open('./ajout_openobs.csv','w')
resultat.write('cd_ref;gbif_id\n')

for x in cdref:
    x = x.split(";")
    x = x[0]
    url = "https://taxref.mnhn.fr/api/taxa/"+x+"/externalIds"

    rq = requests.get(url)

    try:
        embedded = rq.json()['_embedded']['externalDb']
        for i in range(len(embedded)):
            if embedded[i]['externalDbName']=='GBIF':
                resultat.write(x+';'+embedded[i]['externalId']+'\n')
            else:
                pass
    except:
        resultat.write(x+';'+'ERROR\n')
        
resultat.close()

