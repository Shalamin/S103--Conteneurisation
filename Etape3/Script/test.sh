#!/bin/bash

# Check if input file is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 'Tableau des médailles v2'.xlsx"
    exit 1
fi

input_file=$1
csv_file="resultat.csv"


docker run -d --name excel2csv-container -v $(pwd)/data:/data sae103-excel2csv tail -f /dev/null
docker cp ./$(input_file) excel2csv-container:/data
docker exec excel2csv-container ssconvert /data/$(input_file) /data/resultat.csv
docker cp excel2csv-container:/data/resultat.csv ./resultat.csv

# Sort le fichier csv par :
# 1. Médails d'or 
# 2. Médails d'argent 
# 3. Médails de bronze
# 4. Nom du pays
# Après le tri, on ajoute le classement
awk -F',' 'NR>1 {print $0}' "$csv_file" | # Skip le header
    sort -t',' -k2,2nr -k3,3nr -k4,4nr -k1,1 | 
    # Sort par classement Or, Argent, Bronze, 
    #pays pour avoir dans le bon ordre .
    awk -F',' '{
        if (NR == 1) {
            print $0
            prev = $0
            rank = 1
        } else {
            split(prev, a, ",")
            split($0, b, ",")
            if (a[2] == b[2] && a[3] == b[3] && a[4] == b[4]) { 
                print "-" " - " $0
            } else {
                print rank " - " $0
            }
            rank++
            prev = $0
        }
    }' | #Si le classement est le même que le précédent, on met un tiret
    sort -t',' -k2,2nr -k3,3nr -k4,4nr -k1,1 | # Sort finale par classement Or, Argent, Bronze, pays

echo "Le fichier sortie_$csv_file à été créé avec succès."