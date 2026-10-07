CREATE TABLE commandes (
    id          SERIAL PRIMARY KEY,
    client_id   INTEGER NOT NULL REFERENCES clients(id),
    produit     VARCHAR(100) NOT NULL,
    montant     NUMERIC(10,2) NOT NULL,
    commande_le DATE DEFAULT CURRENT_DATE
);

INSERT INTO commandes (client_id, produit, montant) VALUES
    (1, 'Clavier',      49.90),
    (1, 'Écran 27"',   279.00),
    (2, 'Souris',       25.50),
    (3, 'Ordinateur', 1199.00),
    (3, 'Casque',       89.90),
    (4, 'Webcam',       59.00);

SELECT * FROM commandes; 

SELECT * FROM clients c ; 

SELECT c.nom, cmd.produit, cmd.montant
FROM clients c LEFT JOIN commandes cmd ON cmd.client_id = c.id;

SELECT c.nom,
       COUNT(cmd.id)  AS nb_commandes,
       SUM(cmd.montant) AS total_depense
FROM clients c
JOIN commandes cmd ON cmd.client_id = c.id
GROUP BY c.nom
ORDER BY total_depense DESC;

-- Tous les clients, même sans commande
FROM clients c LEFT JOIN commandes cmd ON cmd.client_id = c.id

-- Toutes les commandes, même sans client (ici : aucune, grâce à ta clé étrangère !)
SELECT c.nom, cmd.produit, cmd.montant
FROM commandes cmd LEFT JOIN clients c ON c.id = cmd.client_id;


-- Requête 1 : toutes les commandes avec le nom et la ville du client
SELECT cmd.id, cmd.produit, cmd.montant, cmd.commande_le, c.ville, c.nom FROM commandes cmd
JOIN clients c ON cmd.client_id = c.id
ORDER BY c.ville, c.nom; 

-- Requête 2 : les commandes des clients de Lausanne uniquement
SELECT cmd.id, cmd.produit, cmd.montant, cmd.commande_le, c.ville, c.nom FROM commandes cmd
JOIN clients c ON cmd.client_id = c.id
WHERE c.ville = 'Lausanne';

-- Requête 3 : le chiffre d'affaires total par ville, du plus élevé au plus faible
SELECT sum(cmd.montant) AS montant_total_ville, c.ville FROM clients c
JOIN commandes cmd ON cmd.client_id = c.id
GROUP BY c.ville 
ORDER BY montant_total_ville DESC;

-- Requête 4 : le montant moyen d'une commande (💡 AVG, et ROUND(AVG(montant), 2) pour arrondir)
SELECT
	ROUND(AVG(montant), 2) AS montant_moyen
FROM
	commandes;

-- Requête 5 : les clients ayant dépensé plus de 200 € au total
SELECT c.nom, c.email, sum(cmd.montant) AS somme_commandes FROM clients c 
JOIN commandes cmd ON c.id = cmd.client_id
GROUP BY c.nom, c.email 
HAVING  sum(cmd.montant) > 200
ORDER BY somme_commandes DESC;

-- Utilsation des CTE
-- Requête 6 : Les villes dont le chiffre d'affaires dépasse la moyenne des villes.
WITH ca_ville AS (
	SELECT sum(cmd.montant) AS somme_ville, c.ville 
	FROM commandes cmd
	JOIN clients c ON cmd.client_id = c.id
	GROUP BY c.ville
	),
	moyenne_ville AS (
	SELECT avg(somme_ville) AS moyenne_des_villes
	FROM ca_ville
	)

SELECT cav.ville, cav.somme_ville FROM ca_ville cav
CROSS JOIN moyenne_ville moy 
WHERE cav.somme_ville > moy.moyenne_des_villes
ORDER BY somme_ville DESC; 


-- Requête 7 :Pour chaque client : son nombre de commandes, son total et son panier moyen, y compris les clients sans commande 
SELECT * FROM clients c 
SELECT * FROM commandes cmd 

SELECT c.id, c.nom, NULLIF(count(cmd.client_id), 0) AS nombre_de_commandes_par_client, COALESCE(sum(cmd.montant),0) AS montant_total_par_clients, round(avg(cmd.montant), 2) AS moyenne_montant_par_clients FROM clients c
LEFT JOIN commandes cmd ON c.id = cmd.client_id
GROUP BY c.id;


-- Requête 8 : Le produit le plus cher acheté par chaque client.
WITH max_par_client AS (
	SELECT c.id, c.nom, max(cmd.montant) AS montant_max_par_client FROM clients c
	JOIN commandes cmd ON c.id = cmd.client_id
	GROUP BY c.id)
	
SELECT max_par_client.id, max_par_client.nom, max_par_client.montant_max_par_client, cmd.produit FROM max_par_client
JOIN commandes cmd ON max_par_client.id = cmd.client_id AND cmd.montant = max_par_client.montant_max_par_client
ORDER BY montant_max_par_client DESC; 

-- Requpete 9 - Une ligne par ville, avec la ville, le produit, le montant et le nom du client.
WITH max_par_ville AS (
	
	SELECT c.ville, max(cmd.montant) AS montant_max_par_ville FROM clients c
	JOIN commandes cmd ON c.id = cmd.client_id
	GROUP BY c.ville)
	
SELECT m.ville, c.nom, m.montant_max_par_ville, cmd.produit FROM max_par_ville m
JOIN clients c ON c.ville= m.ville
JOIN commandes cmd ON cmd.montant = m.montant_max_par_ville AND cmd.client_id = c.id
ORDER BY m.montant_max_par_ville DESC