"""
1.	(20 marks) Suppose you were Julius Caesar. One day a solider gave you an encrypted letter from the general in another legion. The first line is as follows:
Lpshudwru, zh kdyh uhfhlyhg dq hqflskhuhg plvvlyh wkdw pdb krog pdwwhuv ri lpsruw iru rxu fdpsdljq.
The first words decrypted (using a Caesar cipher with key 3) are:
imperator, we have received an enciphered missive that may hold matters of import for our campaign.
"""

def caesar_cipher(message, cipherKey, alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
    """
    Encrypts or decrypts a message using a Caesar cipher with the given key.
    :param message: The message to encrypt or decrypt.
    :param cipherKey: The key for the Caesar cipher (an integer).
    :param alphabet: The alphabet to use for the cipher.
    :return: The encrypted or decrypted message.
    """
    result = []
    cipherKey = int(cipherKey)  # convert key to integer sample a into
    uppercaseMessage = message.upper()
    for currentCharacter in uppercaseMessage:
        if currentCharacter in alphabet:
            position = alphabet.find(currentCharacter)
            newPosition = (position + cipherKey) % len(alphabet)
            result.append(alphabet[newPosition])
        else:
            result.append(currentCharacter)
    return ''.join(result)


def caesar_cipher_decrypt(message, cipherKey, alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ"):
    return caesar_cipher(message, -int(cipherKey), alphabet)


## test
var_to_decrypt="Lpshudwru, zh kdyh uhfhlyhg dq hqflskhuhg plvvlyh wkdw pdb krog pdwwhuv ri lpsruw iru rxu fdpsdljq."
var_decrypted=caesar_cipher_decrypt(var_to_decrypt,3)
print(var_decrypted)

# --- Interactive Loop ---
def caesar_main():
    while True:
        choice = input("Do you want to Encrypt or Decrypt a message? (E/D)\n").strip().upper()
        if choice not in ['E', 'D']:
            print("Invalid choice. Please enter E or D.")
            continue

        key = input("What is our key for this campaign?\n").strip()
        try:
            key = int(key)
        except ValueError:
            print("Invalid key. Please enter a number.")
            continue

        while True:
            message = input("What is your encrypted message?\n")
            if choice == 'D':
                result = caesar_cipher_decrypt(message, key)
                print("Here is your decrypted message:")
            else:
                result = caesar_cipher(message, key)
                print("Here is your encrypted message:")
            print(result)

            again = input(f"Do you have more message to be {'decrypted' if choice == 'D' else 'encrypted'}? (Y/N)\n").strip().upper()
            if again != 'Y':
                break

        # Optionally, allow switching between E/D or quitting
        restart = input("Do you want to switch between Encrypt/Decrypt or quit? (E/D to switch, Q to quit)\n").strip().upper()
        if restart == 'Q':
            break

# Run the program
caesar_main()

# 2.	(6 marks) Find the output of the following:

L1 = [9,8,7,3,2,1,4,5,6]
START = 4
tempSUM = 0
for C in range(START,7):
    tempSUM = tempSUM*2 + L1[C]
    print(C-3, ":", tempSUM)
    tempSUM += tempSUM + L1[-1]*3
    print(tempSUM)

# 1: 2
# 22
# 2: 45
# 108
# 3: 220
# 458


# 3.	(7 marks) Write down the output of the following cases:
# Please use _ to denote an empty space.
# For random numbers, just write down one of the possible numbers.
# a.	Print("I am {}".format("hungry"))
print("I am {}".format("hungry")) #I am hungry

# b.	USD_to_CAD = 1.372201025
# USD = 49.99
# CAD_price = 49.99 * USD_to_CAD
# formatted_price = f"The price in CAD is ${CAD_price:.2f}"
# print(formatted_price)

USD_to_CAD = 1.372201025
USD = 49.99
CAD_price = 49.99 * USD_to_CAD
formatted_price = f"The price in CAD is ${CAD_price:.2f}"
print(formatted_price)
# The price in CAD is $68.60


# c.	print(f"{'Address:':10}100 W 49th Ave")
print(f"{'Address:':10}100 W 49th Ave")
# Address:  100 W 49th Ave


# d.	import random
# print(random.randint(0,10))
# print(random.uniform(90,100))
# print(random.random())


import random
print(random.randint(0,10))
print(random.uniform(90,100))
print(random.random())

# 8
# 98.57692337621062
# 0.9525209009482036

# e.	import numpy as np
# a=np.array([99,30,45,50,88])
# print(a[a>50])

import numpy as np
a=np.array([99,30,45,50,88])
print(a[a>50])

# [99 88]