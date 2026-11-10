# Quête Data

Exercices d'apprentissage en Python et SQL, dans le cadre d'une montée
en compétences vers un poste de Data Engineer.

## Contenu

| Fichier | Description |
|---|---|
| `bonjour.py` | Saisie utilisateur et validation d'entrées (try/except, boucles) |
| `mysterious_number.py` | Jeu de devinette — recherche dichotomique, gestion d'erreurs |
| `sql/boutique.sql` | Modèle relationnel normalisé (OLTP) et requêtes d'analyse |
| `sql/boutique_etoile.sql` | Modèle en étoile (OLAP) construit à partir du modèle normalisé |

## Base `boutique` — modèle normalisé

Deux tables liées par une clé étrangère : `clients` et `commandes`.
Contraintes d'intégrité : `NOT NULL`, `UNIQUE` sur l'email, clé étrangère
garantissant qu'aucune commande n'est orpheline.

Requêtes couvrant les jointures, les agrégations (`GROUP BY`, `HAVING`),
les CTE et les fonctions fenêtre (`ROW_NUMBER`, `LAG`, cumuls).

## Base `boutique` — modèle en étoile

Transformation du modèle normalisé en schéma décisionnel :
une table de faits `fait_ventes` entourée de trois dimensions
(`dim_client`, `dim_produit`, `dim_date`).

Le chargement de la table de faits résout les clés de dimension à partir
des clés métier du système source — l'étape centrale d'un ETL.
Les scripts sont idempotents : ils peuvent être rejoués sans erreur.

## Stack

Python 3, PostgreSQL 17, DBeaver, Git