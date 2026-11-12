import sqlite3

# Fonction permettant d'exécuter toutes les requêtes SQL d'un fichier
# executescript découpe lui-même le fichier en requêtes, y compris les triggers (BEGIN ... END;)
def updateDBfile(data: sqlite3.Connection, file):

    # Lecture du fichier
    with open(file, 'r', encoding='utf-8') as f:
        sql = f.read()

    # Exécution de toutes les requêtes du fichier
    data.executescript(sql)
