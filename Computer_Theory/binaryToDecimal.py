import random
import unittest

"""
Construir una palabra conformada por el alfabeto binario Σ= {0,1} de longitud aleatoria 
entre 1 y 5 dígitos y calcular su equivalencia en números decimales.
"""
def generate_binary_word():
    """
    genera una cadena binaria entre 1 - 5  caracteres
    :return:
    """
    word_length = random.randint(1, 5)
    return ''.join(random.choice(['0', '1']) for _ in range(word_length))

def binary_to_decimal(binary_word):
    """
    convierte una cadena binara en representacion decimal
    :return:
    """
    decimal = 0
    power = len(binary_word) - 1
    for digit in binary_word:
        if digit == '1':
            decimal += 2 ** power
        power -= 1
    return decimal


class TestBinaryToDecimalConversion(unittest.TestCase):
    def test_binary_to_decimal(self):
        test_cases = [
            ('1', 1),
            ('0', 0),
            ('10', 2),
            ('11', 3),
            ('101', 5),
            ('11111', 31)
        ]
        for binary_word, expected_decimal in test_cases:
            decimal_equivalent = binary_to_decimal(binary_word)
            self.assertEqual(decimal_equivalent, expected_decimal)

    def test_generate_binary_word_length(self):
        for _ in range(10):
            binary_word = generate_binary_word()
            print("termino binario "+ binary_word.__str__())
            print("termino decimal "+ binary_to_decimal(binary_word).__str__())
            self.assertGreater(len(binary_word), 0)
            self.assertLessEqual(len(binary_word), 5)

    def test_generate_binary_word_characters(self):
        for _ in range(10):
            binary_word = generate_binary_word()
            for character in binary_word:
                self.assertIn(character, ['0', '1'])