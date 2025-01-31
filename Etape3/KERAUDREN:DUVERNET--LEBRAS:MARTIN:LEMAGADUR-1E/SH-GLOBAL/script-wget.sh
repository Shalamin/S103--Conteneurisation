#!/bin/bash

docker run -d --name wget-container sae103-wget -c "sleep 1000000"
docker cp ./drapeau.csv wget-container:/data/
while IFS=',' read -r pays iso; 
do
    iso_code=$(grep -i "^$pays," "drapeau.csv" | cut -d',' -f2)
    docker exec wget-container wget -O "${iso_code}_w20.png" "https://flagcdn.com/w20/${iso_code}.png" 
    docker exec wget-container wget -O "${iso_code}_8x6.png" "https://flagcdn.com/80x60/${iso_code}.png" 
    echo "Drapeau $iso_code traitée avec succès."
done < "drapeau.csv"
docker exec wget-container wget -O "paris_2024.svg.png" "https://upload.wikimedia.org/wikipedia/fr/thumb/6/68/Logo_JO_d%27été_-_Paris_2024.svg/1200px-Logo_JO_d%27été_-_Paris_2024.svg.png"
docker cp wget-container:/data/ ./flags/
docker rm -f wget-container
