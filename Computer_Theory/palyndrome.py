import unittest

def is_palindrome(word):
    left_index = 0
    right_index = len(word) - 1

    while left_index < right_index:
        if word[left_index] != word[right_index]:
            return False
        left_index += 1
        right_index -= 1

    return True


class TestPalindrome(unittest.TestCase):
    def test_palindrome(self):
        self.assertTrue(is_palindrome("oro"))
        self.assertTrue(is_palindrome("oso"))
        self.assertTrue(is_palindrome("1111"))
        self.assertFalse(is_palindrome("palindromo"))
        self.assertFalse(is_palindrome("hola"))
        self.assertFalse(is_palindrome("12321"))


if __name__ == '__main__':
    unittest.main()