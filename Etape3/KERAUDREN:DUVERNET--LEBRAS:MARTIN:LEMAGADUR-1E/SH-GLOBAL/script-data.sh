#!/bin/bash
for nomFichier in *.data
do
    let "nbSection = $(egrep -c "SECTION" < "$nomFichier")"
    nbFichier=1 # on initialise le compteur de fichier
    while [ $i -le $nbSection ]; do
        touch "Section_$nomFichier"_$nbFichier".txt"
        let "nbLigne= 3" # Le nombre de ligne que prend SECTION
        head -n $((($i * $nbLigne)-1)) < "$nomFichier" | tail -1 | colrm 1 6 > "Section_$nomFichier"_$nbFichier".txt"
        head -n $((($i * $nbLigne))) < "$nomFichier" | tail -1 | colrm 1 12 >> "Section_$nomFichier"_$nbFichier".txt"
        let $[ nbFichier+=1 ] # incrementation du nbFichier de 1 pour chaque boucle
    done
done