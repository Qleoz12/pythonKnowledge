def is_prime(num):
    if num < 2:
        return False
    for i in range(2, int(num**0.5) + 1):
        if num % i == 0:
            return False
    return True

def find_primes(start, end):
    primes = [num for num in range(start, end + 1) if is_prime(num)]
    return primes

def save_to_file(primes, filename='results.txt'):
    with open(filename, 'w') as file:
        for prime in primes:
            file.write(str(prime) + '\n')

if __name__ == "__main__":
    start_limit = int(input("Enter the starting limit: "))
    end_limit = int(input("Enter the ending limit: "))

    primes = find_primes(start_limit, end_limit)

    save_to_file(primes,"nuevonombre.txt")

    print(f"Prime numbers between {start_limit} and {end_limit} are saved in results.txt.")
