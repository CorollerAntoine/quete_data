DROP TABLE IF EXISTS commandes;
DROP TABLE IF EXISTS clients;

CREATE TABLE public.clients (
	id SERIAL NOT NULL,
	nom varchar(100) NOT NULL,
	email varchar(150) NULL,
	ville varchar(100) NULL,
	inscrit_le date DEFAULT CURRENT_DATE NULL,
	CONSTRAINT clients_email_key UNIQUE (email),
	CONSTRAINT clients_pkey PRIMARY KEY (id)
);



CREATE TABLE public.commandes (
	id SERIAL NOT NULL,
	client_id INTEGER NOT NULL,
	produit varchar(100) NOT NULL,
	montant numeric(10, 2) NOT NULL,
	commande_le date DEFAULT CURRENT_DATE NULL,
	CONSTRAINT commandes_pkey PRIMARY KEY (id),
	CONSTRAINT commandes_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

INSERT INTO public.clients (nom,email,ville) VALUES
	 ('Antoine Coroller','antoine@exemple.com','Rennes'),
	 ('Marie Dupont','marie@exemple.com','Rennes'),
	 ('Karim Benali','karim@exemple.com','Lausanne'),
	 ('Sophie Martin','sophie@exemple.com','Monaco'),
	 ('Lucas Petit','lucas@exemple.com','Lausanne');


INSERT INTO public.commandes (client_id,produit,montant) VALUES
	 (1,'Clavier',49.90),
	 (1,'Écran 27"',279.00),
	 (2,'Souris',25.50),
	 (3,'Ordinateur',1199.00),
	 (3,'Casque',89.90),
	 (4,'Webcam',59.00,'2026-09-23');



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

-- Requête 4 : le montant moyen d'une commande (AVG, et ROUND(AVG(montant), 2) pour arrondir)
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
