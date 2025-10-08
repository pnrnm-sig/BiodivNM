library(data.table)
library(dplyr)

############################
# téléchargement des données par régions
############################
# https://openobs.mnhn.fr/archives

###########################
# sélection géographique
###########################

pdl <- read.csv("./extractINPN_paysDeLaLoire_04112024/extractINPN_paysDeLaLoire_04112024.csv", sep= ",", 
                header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(pdl$cdRef)
gc()
pdl <- read.csv("./extractINPN_paysDeLaLoire_04112024/extractINPN_paysDeLaLoire_04112024_part2.csv", sep= ",", 
                header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,pdl$cdRef))
gc()
pdl <- read.csv("./extractINPN_paysDeLaLoire_04112024/extractINPN_paysDeLaLoire_04112024_part3.csv", sep= ",", 
                header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,pdl$cdRef))
gc()
pdl <- read.csv("./extractINPN_paysDeLaLoire_04112024/extractINPN_paysDeLaLoire_04112024_part4.csv", sep= ",", 
                header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,pdl$cdRef))
gc()
pdl <- read.csv("./extractINPN_paysDeLaLoire_04112024/extractINPN_paysDeLaLoire_04112024_part5.csv", sep= ",", 
                header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,pdl$cdRef))
gc()

nmdie <- read.csv("./extractINPN_normandie_04112024/extractINPN_normandie_04112024.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,nmdie$cdRef))
gc()
nmdie <- read.csv("./extractINPN_normandie_04112024/extractINPN_normandie_04112024_part2.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,nmdie$cdRef))
gc()
nmdie <- read.csv("./extractINPN_normandie_04112024/extractINPN_normandie_04112024_part3.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,nmdie$cdRef))
gc()
nmdie <- read.csv("./extractINPN_normandie_04112024/extractINPN_normandie_04112024_part4.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,nmdie$cdRef))
gc()

cvl <- read.csv("./extractINPN_centreValDeLoire_04112024/extractINPN_centreValDeLoire_04112024.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,cvl$cdRef))
gc()
cvl <- read.csv("./extractINPN_centreValDeLoire_04112024/extractINPN_centreValDeLoire_04112024_part2.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,cvl$cdRef))
gc()
cvl <- read.csv("./extractINPN_centreValDeLoire_04112024/extractINPN_centreValDeLoire_04112024_part3.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,cvl$cdRef))
gc()
cvl <- read.csv("./extractINPN_centreValDeLoire_04112024/extractINPN_centreValDeLoire_04112024_part4.csv", sep= ",", header= TRUE,fileEncoding = 'UTF-8',encoding = 'UTF-8')
cd_ref <- unique(c(cd_ref,cvl$cdRef))
gc()

rm(cvl,nmdie,pdl)
gc()

cd_ref <- data.frame(cd_ref)
write.csv(cd_ref,'./cdref_openobs04112024.csv',row.names = FALSE)
