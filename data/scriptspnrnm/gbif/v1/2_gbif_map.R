library(htmlwidgets)
library(leaflet)

ajout_gbif <- read.csv2("./ajout_gbif.csv", encoding="UTF-8",sep=';')
key_gbif <- read.csv2("./sortie_gbif_key.csv", encoding="UTF-8",sep=';')

for (row in 1:nrow(key_gbif)) {
  cd_ref <- key_gbif[row, "cd_ref"]
  gbif_id  <- key_gbif[row,"gbif_key"]
  
  # create style raster layer 
  projection = '3857' # projection code
  style = 'style=osm-bright' # map style
  tileRaster = paste0('https://tile.gbif.org/',projection,'/omt/{z}/{x}/{y}@1x.png?',style)
  # create our polygons layer 
  prefix = 'https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?'
  polygons = 'style=classic.poly&bin=hex&hexPerTile=70' # ploygon styles 
  taxonKey = paste('taxonKey=',gbif_id,sep='') # taxonKey
  tilePolygons = paste0(prefix,polygons,'&',taxonKey)
  # attibution
  attrib = paste('© <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a>, <a href="https://www.gbif.org/fr/terms" target="_blank">GBIF</a>',
                 ' - ','<a href="https://www.gbif.org/fr/species/',gbif_id,'" target="_blank">',
                 ajout_gbif[ajout_gbif$cd_ref==cd_ref,'nom_valide'],'</a>',
                 sep='')
  # plot the styled map
  m = leaflet() %>%
    setView(lng = 20, lat = 20, zoom = 01) %>%
    addTiles(attribution = attrib)  %>%
    addTiles(urlTemplate=tileRaster) %>%
    addTiles(urlTemplate=tilePolygons)
  
  saveWidget(m, file=paste("./GBIF/",cd_ref,".html",sep=''))
}




