# Quête Data

Montée en compétences en Python et SQL dans le cadre d'une reconversion
vers un poste Data.

## Contenu

| Fichier | Description |
|---|---|
| `bonjour.py` | Saisie utilisateur et validation d'entrées (try/except, boucles) |
| `nombre_mystere.py` | Jeu de devinette — recherche dichotomique, gestion d'erreurs |
| `sql/boutique.sql` | Modèle relationnel d'une boutique et requêtes d'analyse |

## Base de données `boutique`

Deux tables liées par une clé étrangère :

- `clients` (id, nom, email, ville, inscrit_le)
- `commandes` (id, client_id → clients.id, produit, montant, commande_le)

Contraintes d'intégrité : `NOT NULL`, `UNIQUE` sur l'email,
clé étrangère garantissant qu'aucune commande n'est orpheline.

Les requêtes couvrent les jointures, les agrégations (`GROUP BY`, `HAVING`)
et le calcul d'indicateurs (chiffre d'affaires par ville, panier moyen).

## Stack

Python 3, PostgreSQL 17, DBeaver, Git