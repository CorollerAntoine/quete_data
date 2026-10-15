-- =====================================================
-- Modèle en étoile (OLAP) construit à partir du modèle normalisé de la boutique.
-- Objectif : optimiser les requêtes analytiques en réduisant le nombre de jointures.
-- =====================================================
DROP TABLE IF EXISTS fait_ventes;

DROP TABLE IF EXISTS dim_client;

DROP TABLE IF EXISTS dim_produit;

DROP TABLE IF EXISTS dim_date;


CREATE TABLE dim_client (
    client_key SERIAL PRIMARY KEY,
    client_id INTEGER,
    nom VARCHAR(100) NOT NULL,
    ville VARCHAR(100),
    pays VARCHAR(100)
);

CREATE TABLE dim_produit (
    produit_key SERIAL PRIMARY KEY,
    libelle VARCHAR(100) NOT NULL,
    categorie VARCHAR(50)
);

CREATE TABLE dim_date (
    date_key DATE PRIMARY KEY,
    annee INTEGER NOT NULL,
    mois INTEGER NOT NULL,
    nom_mois VARCHAR(20),
    trimestre INTEGER NOT NULL,
    jour_semaine VARCHAR(20)
);

CREATE TABLE fait_ventes (
    vente_key SERIAL PRIMARY KEY,
    client_key INTEGER NOT NULL REFERENCES dim_client(client_key),
    produit_key INTEGER NOT NULL REFERENCES dim_produit(produit_key),
    date_key DATE NOT NULL REFERENCES dim_date(date_key),
    quantite INTEGER NOT NULL DEFAULT 1,
    montant NUMERIC(10, 2) NOT NULL
);

INSERT INTO
    dim_date (date_key, annee, mois, nom_mois, trimestre, jour_semaine)
SELECT d,
    EXTRACT(YEAR FROM d),
    EXTRACT(MONTH FROM d),
    TO_CHAR(d, 'TMMonth'),
    EXTRACT(QUARTER FROM d),
    TO_CHAR(d, 'TMDay')
FROM generate_series('2026-09-01' :: DATE, '2026-10-31' :: DATE, '1 day') AS d;


INSERT INTO dim_client (client_id, nom, ville, pays)
SELECT id, nom, ville, 'France'
FROM clients;

UPDATE dim_client set pays = 'Suisse' where ville = 'Lausanne';
UPDATE dim_client set pays = 'Monaco' where ville = 'Monaco';

SELECT * FROM dim_client;

INSERT INTO
    dim_produit (produit_key, libelle, categorie)
VALUES
    (1, 'Clavier', 'Périphériques'),
    (2, 'Écran 27"', 'Périphériques'),
    (3, 'Souris', 'Périphériques'),
    (4, 'Ordinateur', 'Informatique'),
    (5, 'Casque', 'Informatique'),
    (6, 'Webcam', 'Périphériques');

--SELECT * FROM dim_produit;


INSERT INTO fait_ventes (client_key, produit_key, date_key, quantite, montant)
SELECT dc.client_key,
       dp.produit_key,
       cmd.commande_le,
       1,
       cmd.montant
FROM commandes cmd
JOIN dim_client  dc ON dc.client_id = cmd.client_id
JOIN dim_produit dp ON dp.libelle = cmd.produit;

--select * from commandes; 
--select * from fait_ventes;
--SELECT COUNT(*) FROM commandes;
--SELECT COUNT(*) FROM fait_ventes;

--Calcul du chiffre d'affaires global et du chiffre d'affaires par client
SELECT nom, montant,
       SUM(montant) OVER ()                       AS total_global,
       SUM(montant) OVER (PARTITION BY client_id) AS total_du_client
FROM commandes cmd
JOIN clients c ON c.id = cmd.client_id;


--Le classement des commandes par client selon le montant de la commande (du plus élevé au plus bas)
SELECT c.nom, cmd.produit, cmd.montant,
       ROW_NUMBER() OVER (PARTITION BY cmd.client_id ORDER BY cmd.montant DESC) AS rang
FROM commandes cmd
JOIN clients c ON c.id = cmd.client_id;


--Calcul du chiffre d'affaires par jour et du chiffre d'affaires de la veille
SELECT dd.date_key, SUM(f.montant) AS ca_jour,
       LAG(SUM(f.montant)) OVER (ORDER BY dd.date_key) AS ca_veille
FROM fait_ventes f
JOIN dim_date dd ON dd.date_key = f.date_key
GROUP BY dd.date_key
ORDER BY dd.date_key;

--Pour chaque ville, le produit le plus cher vendu — version fonction fenêtre.

--select * from commandes; 
--select * from clients;

with classement as (
    select c.ville, cmd.produit, cmd.montant,
        Row_Number() over (partition by c.ville order by cmd.montant desc) as rang
    from commandes cmd
    join clients c on c.id = cmd.client_id
)
select ville, produit, montant
from classement
where rang = 1;

--Pour chaque commande, son montant et le pourcentage qu’elle représente dans le total de son client.
select c.nom, cmd.montant, 
         round(cmd.montant / sum(cmd.montant) over (partition by cmd.client_id) * 100, 2) as pourcentage
from commandes cmd 
join clients c on c.id = cmd.client_id;

--Le cumul progressif du chiffre d’affaires, commande par commande, dans l’ordre chronologique.
select cmd.id, cmd.commande_le, cmd.montant,
        sum(cmd.montant) over (order by cmd.commande_le, cmd.id) as cumul
from commandes cmd;

select cmd.id, cmd.commande_le, cmd.montant,
        sum(cmd.montant) over (partition by cmd.commande_le, cmd.id) as cumul
from commandes cmd;