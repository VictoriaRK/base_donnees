import os
import sys
from utils import db
from utils import csv_extractor

# Fonction permettant de créer la base de données
def database_create(data):
    print("\nCréation de la base de données")
    try:
        # On exécute les requêtes du fichier de création de la V0, puis celles de la nouvelle base
        db.updateDBfile(data, "data/v0_createDB.sql")
        db.updateDBfile(data, "data/createDB.sql")
    except Exception as e:
        # En cas d'erreur, on affiche un message
        print("L'erreur suivante s'est produite lors de la création de la base : " + repr(e) + ".")
    else:
        # Si tout s'est bien passé, on affiche le message de succès et on commit
        print("La base de données a été créée avec succès.")
        data.commit()

# Fonction permettant d'insérer les données d'un fichier CSV dans la base
def database_insert(data, file):
    print("\nInsertion des données du fichier " + file + " dans la base.")
    if not os.path.exists(file):
        print("Le fichier " + file + " n'existe pas. Voir README.md pour le télécharger.")
        return
    try:
        # On lit les données dans le fichier CSV, pour la V0 puis pour la nouvelle base
        csv_extractor.read_csv_file_V0(data, file)
        csv_extractor.read_csv_file(data, file)
    except Exception as e:
        # En cas d'erreur, on annule toutes les insertions faites depuis le dernier commit et on affiche un message
        data.rollback()
        print("L'erreur suivante s'est produite lors de l'insertion des données : " + repr(e) + ".", file=sys.stderr)
    else:
        # Si tout s'est bien passé, on affiche le message de succès et on commit
        print("Les données ont été insérées dans la base avec succès.")
        data.commit()

# Fonction permettant de supprimer la base de données
def database_delete(data):
    print("\nSuppression de la base de données.")
    try:
        # On exécute les requêtes du fichier de suppression
        db.updateDBfile(data, "data/deleteDB.sql")
    except Exception as e:
        # En cas d'erreur, on affiche un message
        print("Erreur lors de la suppression de la base de données : " + repr(e) + ".")
    else:
        # Si tout s'est bien passé, on affiche le message de succès et on commit
        print("La base de données a été supprimée avec succès.")
        data.commit()
