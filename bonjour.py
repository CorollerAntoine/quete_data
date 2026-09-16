prenom = input("Quel est ton nom ? ")
try:
    heures_semaine = int(input("Combien d'heures par semaine comptes-tu coder ? "))
except ValueError:
    print("Oups, il faut écrire un nombre en chiffres !")
heures_an = heures_semaine*52
phrase = f"Bienvenue {prenom} ! A ce rythme, tu coderas {heures_an} heures d'ici un an."
print(phrase)