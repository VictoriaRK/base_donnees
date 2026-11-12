import sqlite3
from actions import database_functions
from actions import database_queries

# Fichiers de données (voir README.md pour télécharger le fichier complet)
ECHANTILLON = "data/echantillon-bureaux-de-vote.csv"
COMPLET = "data/resultats-definitifs-par-bureau-de-vote.csv"

# Connexion à la base de données
data = sqlite3.connect("data/elections.db")
# SQLite ne vérifie les clés étrangères que si on le lui demande, à chaque connexion
data.execute("PRAGMA foreign_keys = ON")

# Fonction permettant de quitter le programme
def quitter():
    data.close()
    print("Au revoir !")
    exit(0)

# Fonction demandant le nom d'une commune puis affichant la participation dans ses bureaux de vote
def participation_commune():
    commune = input("Nom de la commune : ").strip()
    database_queries.participation_commune(data, commune)

# Association des actions aux fonctions
actions = {
    "1": lambda: database_functions.database_create(data),
    "2": lambda: database_functions.database_insert(data, ECHANTILLON),
    "3": lambda: database_functions.database_insert(data, COMPLET),
    "4": lambda: database_functions.database_delete(data),
    "5": participation_commune,
    "q": quitter
}

# Fonctions d'affichage du menu
def menu():
    print("\n=== Menu principal ===")
    print("1 - Créer la base de données")
    print("2 - Insérer les données de l'échantillon")
    print("3 - Insérer les données du fichier complet")
    print("4 - Supprimer la base de données")
    print("5 - Participation dans les bureaux de vote d'une commune")
    print("q - Quitter")

# Fonction principale
def main():
    # Appel du menu en boucle et gestion du choix
    while True:
        menu()
        choix = input("Votre choix : ").strip()
        action = actions.get(choix)
        if action:
            action()
        else:
            print("Choix invalide.")

# Appel de la fonction principale
main()
