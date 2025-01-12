
csv_file="resultat.csv"

#écriture du fichier html
 echo "
 <!DOCTYPE html>
 <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">

<head>
  <meta charset='utf-8' />
  <title>Résultat JO2024</title>
  <meta name='auhor' content='Keraudren Johan' />
  <meta name='description' content='' />
  <meta name='keywords' content='' />
  <style>
      body {
          font-family: Arial, sans-serif;
          margin: 10px;
      }
      header {
          text-align: center;
          margin-bottom: 4px;
      }
      table {
          width: 60%;
          border-collapse: collapse;
          margin: 0;
          
      }
      th, td {
          border: 1px solid #000;
          padding: 1px;
          text-align: center;
          font-size : 5px;
      }
      th {
          background-color: #f5f5f5;
      }
      img {
          width: 9px;
          height: 6px;
      }
    
  </style>

</head>
<body>
    <table>
        <thead>
            <tr>
                <th> Drapeau </th>
                <th> Classement </th>
                <th> Pays </th>
                <th> OR </th>
                <th> ARGENT </th>
                <th> BRONZE </th>
            <tr>
        <thead>
        <tbody>
" >> Tableau2html.html;

# faire un egrep pour avoir le classement pays, medailles
while IFS=',' read -r classement pays or argent bronze
do
    echo "
        <tr>
            <td><img src='flags/${pays}.png' alt='${pays}'>  </td>
            <td>$classement</td>
            <td>$pays</td>
            <td>$or</td>
            <td>$argent</td>
            <td>$bronze</td>
        </tr>" >> Tableau2html.html
done < "fichier_$csv_file"
echo "</tbody>
    </table>
</body>
</html>
" >> Tableau2html.html