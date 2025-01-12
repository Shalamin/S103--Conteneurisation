docker run -d --name html2pdf-container sae103-html2pdf tail -f /dev/null
docker cp ./Tableau2html.html html2pdf-container:/data
docker cp flags html2pdf-container:/data
docker exec html2pdf-container weasyprint /data/"Tableau2html.html" /data/Tableau_JO2024.pdf
docker cp html2pdf-container:/data/Tableau_JO2024.pdf Tableau_JO2024.pdf
rm Tableau2html.html

docker rm -f html2pdf-container