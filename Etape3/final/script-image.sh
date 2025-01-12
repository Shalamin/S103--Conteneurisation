#!/bin/bash

# Paramètres pour les images
MAX_DIM="960x600"
MAX_SIZE="153600"  # 150 Ko
largeurMax=960
hauteurMax=600
largeurMin=320
largeurMin=200
mkdir -p images_output

for fichier in image/*
do

    docker run -d --name imagick-container bigpapoo/sae103-imagick -c "sleep 999999"
    docker cp $fichier imagick-container:/data/
    BASENAME=$(basename "$fichier" | cut -d. -f1)
    IMAGE_SIZE=$(stat --format=%s "$fichier")
    dimensions=$(identify -format "%wx%h" "$fichier")
    largeur=$(echo "$dimensions" | cut -d'x' -f1)
    hauteur=$(echo "$dimensions" | cut -d'x' -f2)

    if [[ "$fichier" != *.webp ]]; then
        docker exec imagick-container convert /data/"$(basename "$fichier")" /data/"$BASENAME.webp"
    elif [ "$IMAGE_SIZE" -gt "$MAX_SIZE" ]; then
        docker exec imagick-container convert /data/"$(basename "$fichier")" -quality 75 /data/"$BASENAME.webp"
    elif [ "$largeur" -gt "$largeurMax" ] || [ "$hauteur" -gt "$hauteurMax" ]; then
        docker exec imagick-container convert /data/"$(basename "$fichier")" -resize "${largeurMax}x${hauteurMax}" /data/"$BASENAME.webp"
    elif [ "$largeur" -lt "$largeurMin" ] || [ "$hauteur" -lt "$hauteurMin" ]; then
        docker exec imagick-container convert /data/"$(basename "$fichier")" -resize "${largeurMin}x${hauteurMin}" /data/"$BASENAME.webp"
    fi

        docker cp imagick-container:/data/"$BASENAME.webp" images_output/"$BASENAME.webp"
        docker rm -f imagick-container

        echo "Image $IMAGE traitée avec succès."
        
done



