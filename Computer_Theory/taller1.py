import unittest

"""
llamada de todos los testing
"""
def main():
    loader = unittest.TestLoader()
    suite = loader.discover(start_dir='./', pattern='*.py')
    runner = unittest.TextTestRunner()
    runner.run(suite)

if __name__ == '__main__':
    main()
