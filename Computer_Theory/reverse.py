import unittest


def invertir_cadena(cadena):
    return cadena[::-1]


class TestInvertirCadena(unittest.TestCase):

    def test_invertir_cadena(self):
        self.assertEqual(invertir_cadena("Computador"), "rodatupmoC")
        self.assertEqual(invertir_cadena("Datos"), "sotaD")
        self.assertEqual(invertir_cadena(""), "")
        self.assertEqual(invertir_cadena("a"), "a")
        self.assertEqual(invertir_cadena("ab"), "ba")
        self.assertEqual(invertir_cadena("abc"), "cba")


if __name__ == '__main__':
    unittest.main()
