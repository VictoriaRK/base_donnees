import csv, sqlite3

# Le fichier des résultats est un CSV encodé en UTF-8, dont les colonnes sont séparées par des points-virgules.
# On le lit avec le module csv de Python. csv.DictReader donne chaque ligne sous forme de dictionnaire
# indexé par le nom des colonnes de la première ligne du fichier.
# Toutes les valeurs lues sont des chaînes de caractères. À vous de choisir le bon type pour chaque colonne.

# Fonction permettant de lire le fichier CSV et d'insérer les bureaux de vote dans la table V0_Bureaux
def read_csv_file_V0(data: sqlite3.Connection, file):
    bureaux = []
    with open(file, 'r', encoding='utf-8', newline='') as f:
        for row in csv.DictReader(f, delimiter=';'):
            bureaux.append((row['Code département'], row['Libellé département'],
                            row['Code commune'], row['Libellé commune'], row['Code BV'],
                            int(row['Inscrits']), int(row['Votants']), row['% Votants'],
                            int(row['Abstentions']), int(row['Exprimés']),
                            int(row['Blancs']), int(row['Nuls'])))

    # Les ? sont remplacés par les valeurs de chaque tuple. Construire la requête en collant des chaînes
    # (avec format() ou +) échouerait dès la première apostrophe (L'Abergement-Clémenciat).
    # executemany exécute la requête pour chaque tuple de la liste, bien plus vite qu'une boucle de execute.
    cursor = data.cursor()
    cursor.executemany("INSERT INTO V0_Bureaux VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", bureaux)
    print(f"{len(bureaux)} bureaux de vote insérés dans V0_Bureaux.")

# Fonction permettant de lire le fichier CSV et d'insérer les données dans les tables de la nouvelle base
def read_csv_file(data: sqlite3.Connection, file):
    # TODO Etape 3 : lire le fichier et insérer les données dans les tables créées à l'étape 2
    Departement = {}
    Commune = {}
    BureauVote=[]
    Liste={}
    ListeBv=[]
    with open(file, 'r' , encoding='utf-8', newline='') as f:
        for row in csv.DictReader(f,delimiter=';'):
                dep,com,bv=row['Code département'],row['Code commune'],row['Code BV']
                Departement[dep]=row['Libellé département']
                Commune[com]=(row['Libellé commune'],dep)
                BureauVote.append((com,row['Code BV'],int(row['Inscrits']),int(row['Votants']),int(row['Blancs']),int(row['Nuls'])))
                for i in range(1,39):
                     panneau=int(row[f'Numéro de panneau {i}'])
                     Liste[panneau]=(row[f'Nuance liste {i}'],row[f'Libellé de liste {i}'],row[f'Libellé abrégé de liste {i}'],int(row[f'Sièges {i}']))
                     ListeBv.append((com,bv,panneau,int(row[f'Voix {i}'])))
    cursor = data.cursor()
    cursor.executemany("INSERT INTO Departement VALUES(?,?)",Departement.items())
    cursor.executemany("INSERT INTO Commune VALUES(?,?,?)" ,[(com, lib, dep) for com, (lib, dep) in Commune.items()])
    cursor.executemany("INSERT INTO Liste VALUES (?,?,?,?,?)",
                    [(panneau, nuance,libelle,libelle_ab, sieges) for panneau, (nuance, libelle,libelle_ab,sieges) in Liste.items()])
    cursor.executemany("INSERT INTO BureauVote VALUES (?, ?, ?, ?, ?, ?)", BureauVote)
    cursor.executemany("INSERT INTO ListeBv VALUES (?, ?, ?, ?)", ListeBv)
    
