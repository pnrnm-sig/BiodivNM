/* Carte répartition actuelle dans le monde (mapGBIF) */
const mapDiv = document.getElementById("map-gbif");
const mapgbif = L.map(mapDiv).setView([0, 0], 1);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                  attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(mapgbif)
L.tileLayer('https://api.gbif.org/v2/map/occurrence/density/{z}/{x}/{y}@1x.png?style=classic.poly&bin=hex&hexPerTile=70&taxonKey='+gbif_id, {
attribution: '<a href="https://www.gbif.org/fr/terms">GBIF</a>'
}).addTo(mapgbif);

const resizeObserver = new ResizeObserver(() => {
mapgbif.invalidateSize();
});
resizeObserver.observe(mapDiv);


/* Légende carte répartition actuelle dans le monde (mapGBIF) */
var legendGBIF = L.control({ position: "bottomleft" });

legendGBIF.onAdd = function(mapgbif) {
  var div = L.DomUtil.create("div", "legendGBIF");
  div.innerHTML += "<h4>Nombre  <br> d'observations</h4>";
  div.innerHTML += '<i style="background: #FFFF00"></i><span>1-10</span><br>';
  div.innerHTML += '<i style="background: #FFCC00"></i><span>11-100</span><br>';
  div.innerHTML += '<i style="background: #FF9900"></i><span>101-1000</span><br>';
  div.innerHTML += '<i style="background: #FF6600"></i><span>1001-10000</span><br>';
  div.innerHTML += '<i style="background: #D60A00"></i><span>100001+</span><br>';
 
  return div;
};

legendGBIF.addTo(mapgbif);
