#!/bin/bash

docker run -d --name wget-container bigpapoo/sae103-wget -c "sleep 1000000"
docker cp ./drapeau.csv wget-container:/data/
while IFS=',' read -r pays iso; 
do
    iso_code=$(grep -i "^$pays," "drapeau.csv" | cut -d',' -f2)
    docker exec wget-container wget -O "${pays}.png" "https://flagcdn.com/16x12/${iso_code}.png" 
    echo "Drapeau $iso_code traitée avec succès."
done < "drapeau.csv"
docker cp wget-container:/data/ ./flags/
docker rm -f wget-container
