import random
import string
import unittest

"""
Teniendo en cuenta el alfabeto latino conformado por las letras {A…Z} (mayúsculas), {a…z}
(minúsculas), los dígitos del {0…9}, construir de forma aleatoria una clave de un tamaño de 7 
caracteres conformada por:
a. El primer carácter en mayúscula. 
b. caracteres en minúscula.
c. 1 digito [0-9]
"""
def generate_random_key():
    uppercase_char = random.choice(string.ascii_uppercase)
    remaining_chars = random.choices(string.ascii_lowercase + string.digits, k=5)
    digit_char = random.choice(string.digits)
    key_list = remaining_chars + [digit_char]
    random.shuffle(key_list)
    return uppercase_char+''.join(key_list)


class TestGenerateRandomKey(unittest.TestCase):
    test_count=10
    def test_generate_random_key_length(self):
        for _ in range(self.test_count):
            key = generate_random_key()
            self.assertEqual(len(key), 7)

    def test_generate_random_key_first_char(self):
        for _ in range(self.test_count):
            key = generate_random_key()
            print(key)
            self.assertTrue(key[0].isupper())

    def test_generate_random_key_remaining_chars(self):
        for _ in range(self.test_count):
            key = generate_random_key()
            print(key)
            self.assertTrue(all(c.islower() or c.isdigit() for c in key[1:]))
            self.assertTrue(any(c.isdigit() for c in key[1:]))


if __name__ == '__main__':
    unittest.main()
