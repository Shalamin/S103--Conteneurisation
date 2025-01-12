#!/bin/bash
input_file=$1 # essaye non concluant pour le moment
csv_file="resultat.csv"


docker run -d --name excel2csv-container --platform linux/amd64 bigpapoo/sae103-excel2csv tail -f /dev/null
docker cp ./"Tableau des médailles v2.xlsx" excel2csv-container:/data
docker exec excel2csv-container ssconvert /data/"Tableau des médailles v2.xlsx" /data/resultat_brut.csv
docker cp excel2csv-container:/data/resultat_brut.csv resultat_brut.csv
##################################
#   traitement des données csv   #
##################################

#convertion des noms de pays "nom pays" || "nom. pays"
# Remplacement des noms de pays
tr "'" " " < "resultat_brut.csv" > "resultat_brut_temporaire.csv"
sed -E 's/"([^"]*)"/\1/g' "resultat_brut_temporaire.csv" > "$csv_file"
rm "resultat_brut_temporaire.csv"
#tri du fichier csv


#tri en médailles d'or
#tri en médailles d'argent
#tri en médailles de bronze
#SI les 3 d'avant sont égaux, tri par nom de pays

#affichage rank,pays,or,argent,bronze
awk -F',' 'NR>1 {print $0}' "$csv_file" |
   sort -t',' -k2,2nr -k3,3nr -k4,4nr -k1,1 | 
   #nr = numérique reverse partir du plus grand au plus petit
   awk -F',' '{
       if (NR == 1) {
           prev = $0
           rank = 1
           print rank "," $0
           rank++

       } else {
           split(prev, a, ",")
           split($0, b, ",")
           if (a[2] == b[2] && a[3] == b[3] && a[4] == b[4]) {
               print "-" "," $0
           } else {
               print rank "," $0
           }
           rank++
           prev = $0
       }
   }' |
   #enlever les 2 dernières lignes lignes du haut de tableau excel
   sed '$d' |
   sed '$d' > "fichier_$csv_file"

while IFS=',' read -r rank pays reste; do
    iso_code=$(grep -i "^$pays," "drapeau.csv" | cut -d',' -f2)
    echo "$rank,$pays,$iso_code,$reste"
done < "fichier_$csv_file" > "temp.csv"
mv "temp.csv" "fichier_$csv_file"

docker rm -f excel2csv-container