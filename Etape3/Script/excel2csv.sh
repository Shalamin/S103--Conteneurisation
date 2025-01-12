#!/bin/bash

csv_file="resultat.csv"


docker run -d --name excel2csv-container bigpapoo/sae103-excel2csv
docker cp ./'Tableau des médailles v2'.xlsx excel2csv-container:/data
docker exec excel2csv-container ssconvert /data/'Tableau des médailles v2'.xlsx /data/resultat.csv
docker cp excel2csv-container:/data/resultat.csv ./resultat.csv