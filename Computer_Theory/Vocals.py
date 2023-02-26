import unittest

def count_vowels(string):
    """
    Cuenta el número de vocales en una cadena.

    :param string: La cadena a analizar.
    :type string: str
    :return: El número de vocales en la cadena.
    :rtype: int
    """
    vowels = "aeiouAEIOU"
    count = 0
    for char in string:
        if char in vowels:
            count += 1
    return count


class TestCountVowels(unittest.TestCase):

    def test_count_vowels_basic(self):
        self.assertEqual(count_vowels("hello world"), 3)

    def test_count_vowels_empty_string(self):
        self.assertEqual(count_vowels(""), 0)

    def test_count_vowels_all_vowels(self):
        self.assertEqual(count_vowels("aeiouAEIOU"), 10)

    def test_count_vowels_no_vowels(self):
        self.assertEqual(count_vowels("bcdfghjklmnpqrstvwxyz"), 0)


if __name__ == '__main__':
    unittest.main()