##The code chooses a mysterious number and asks the user to guess it.
##At the end, the program reveals the number of tries it took the user to guess the number.
##seven tries maximum

import random

mysterious_number = random.randint(1, 100)
tries = 0 

while tries < 7 : 
    try:
        guess = int(input("Take a guess from 1 to 100 : "))
        if guess < 1 or guess > 100:
            print("The number must be between 1 and 100. ")
            continue
    except ValueError:
        print("Oops, you must enter a number in digits!")
        continue

    tries+=1

    if guess == mysterious_number:
        print(f"Congratulations! You guessed the mysterious number in {tries} tries.")
        break
    elif guess < mysterious_number:
        print("Too low!")
    elif guess > mysterious_number:
        print("Too high!")
    if tries == 7:
        print(f"Sorry, you've used all 7 tries. The mysterious number was {mysterious_number}.")
        break

