#!/bin/bash

if [[ ! -x "./script-image.sh" || ! -x "./script-wget.sh" 
    || ! -x "./script-excel2csv.sh" || ! -x "./script-html.sh" || ! -x "./script-html2pdf.sh" ]]; then
    echo "Rendre les scripts exécutables avec 'chmod +x script-image.sh script-wget.sh script-excel2csv.sh script-html.sh script-html2pdf.sh'"
    exit 1
fi

echo "######################################
#   traitement des données images    #
######################################"

./script-image.sh

echo "#######################################
#   Lancement tu téléchargement       #
#       des images via wget           #
#######################################"

./script-wget.sh


echo "#######################################
#   traitement des données csv        #
#######################################"

./script-excel2csv.sh

echo "#######################################
#   Création du fichier html          #
#######################################"

./script-html.sh

echo "#######################################
#   Conversion html vers pdf          #
#######################################"

./script-html2pdf.sh