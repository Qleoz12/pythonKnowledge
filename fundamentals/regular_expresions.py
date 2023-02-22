


if __name__ == '__main__':
    import re

    text = "He was carefully disguised but captured quickly by police."
    results= re.findall(r"\w+ly\b", text)

    print(results)