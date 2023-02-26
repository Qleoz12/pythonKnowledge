import random
import string
import unittest

"""
    Construir un programa que permita generar palabras que tengan por lo menos dos a.
"""

def generate_word():
    """
    programa que permita generar palabras que tengan por lo menos dos a.
    :return:
    """
    alphabet = string.ascii_lowercase
    word_length = 5
    count = 0
    while count < 2:
        word = ''.join(random.choice(alphabet) for _ in range(word_length))
        count = word.count('a')
    return word

class TestTwoAWordGenerator(unittest.TestCase):
    def test_generate_word(self):
        for _ in range(10):
            word = generate_word()
            print(word)
            self.assertEqual(len(word), 5)
            self.assertGreaterEqual(word.count('a'), 2)