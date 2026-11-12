# Projet CEBD 2026-27 : élections européennes du 9 juin 2024

Code fourni pour le projet. Le sujet complet est sur Caséine.

## Prérequis

- Python 3 : aucune librairie à installer, les modules `csv` et `sqlite3` sont fournis avec Python.
- VS Code (avec l'extension Python) pour le code, ou l'éditeur de votre choix
- DB Browser for SQLite (<https://sqlitebrowser.org>) pour ouvrir `data/elections.db` et tester
  les requêtes, vues et triggers.

## Données

- `data/echantillon-bureaux-de-vote.csv` (fourni) : un échantillon de 8 836 bureaux de vote. Pour
  chaque département, la plus grande commune et 4 communes tirées au hasard, avec tous leurs bureaux.
  Il a exactement le format du fichier complet. Utilisez-le pour développer et tester.
- Le fichier complet (70 104 bureaux, environ 250 Mo) est à télécharger sur data.gouv.fr :
  <https://www.data.gouv.fr/datasets/resultats-des-elections-europeennes-du-9-juin-2024>,
  ressource **`resultats-definitifs-par-bureau-de-vote.csv`**.
  Lien direct :
  <https://static.data.gouv.fr/resources/resultats-des-elections-europeennes-du-9-juin-2024/20240613-154804/resultats-definitifs-par-bureau-de-vote.csv>.
  Enregistrez-le sous `data/resultats-definitifs-par-bureau-de-vote.csv` (il est ignoré par Git,
  ne le committez pas).

## Lancement

Depuis la racine du projet (les chemins `data/...` sont relatifs à celle-ci) :

```
python3 main.py
```

## Organisation

- `main.py` : menu principal.
- `actions/database_functions.py` : création, remplissage et suppression de la base.
- `actions/database_queries.py` : exemples de requêtes paramétrées.
- `utils/csv_extractor.py` : lecture du fichier CSV et insertion dans la base.
- `utils/db.py` : exécution d'un fichier de requêtes SQL.
- `data/v0_createDB.sql` : la table V0 fournie.
- `data/createDB.sql`, `data/deleteDB.sql` : à compléter (tables, vues, triggers, index).
# base_donnees
