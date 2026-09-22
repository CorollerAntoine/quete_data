prenom = input("Quel est ton prénom ? ")
while True:
    try:
        heures_semaine = int(input("Combien d'heures par semaine comptes-tu coder ? "))
        if heures_semaine < 0:
            print("Le nombre d'heures ne peut pas être négatif.")
            continue
        break
    except ValueError:
        print("Oups, il faut écrire un nombre en chiffres !")
heures_an = heures_semaine*52
phrase = f"Bienvenue {prenom} ! A ce rythme, tu coderas {heures_an} heures d'ici un an."
print(phrase)