"""
Problem
A large shipment of doodads has just arrived, and each doodad has a suggested retail price of b cents. You’ve noticed
that consumers are much more likely to purchase goods when most of the trailing digits are the same. For example,
items are more likely to be priced at 99 cents rather than 57 cents. So to make your goods more appealing,
you’ve decided to sell your goods in bundles. To make a bundle, you choose a positive integer k, and sell k doodads
for k × b cents. With an appropriate choice of k you can have a more pleasing price. For example, selling 57-cent
doodads in bundles of size 7 means that each bundle sells for 399 cents, which has two trailing 9s, rather than
no trailing 9s of 57. This idea of trailing 9s can be generalized to any other trailing digit: bundles of 692 57-cent
doodads sell for 39 444 cents (three trailing 4s) and bundles of one million doodads sell for 57 000 000 cents (six trailing 0s).

After a little thought, you realize that you do not want to make your bundles too large—not only can the price
be excessive, but who really needs several million doodads? For any type of doodad, your marketing department has a
 maximum bundle price of a.

Given the price of a doodad, the desired trailing digit, and the maximum price of a bundle, write a program that
 optimizes the trailing digits.

input
Input consists of a single line containing three integers b, d, and a, where b (1 ≤ b < 106) is the price of
a doodad in cents, d (0 ≤ d ≤ 9) is the desired trailing digit, and a (b ≤ a < 1010 000) is the maximum price of a bundle.

output
Output the maximum number of consecutive occurrences of d that can appear at the end of a bundle price,
given that the price of the bundle cannot exceed a.

"""
"""
#include <iostream>

constexpr int moduloInverse(int a, int m) {
    int m0 = m;
    int x0 = 0;
    int x1 = 1;

    if (m == 1) {
        return 0;
    }

    while (a > 1) {
        const int q = a / m;
        int t = m;

        m = a % m;
        a = t;
        t = x0;

        x0 = x1 - q * x0;
        x1 = t;
    }

    while (x1 < 0) {
        x1 += m0;
    }
    return x1;
}

constexpr std::size_t log10_up(int n) {
    std::size_t res = 0;
    while (n > 0) {
        ++res;
        n /= 10;
    }
    return res;
}

constexpr std::size_t pow10(int n) {
    std::size_t res = 1;
    while (n > 0) {
        res *= 10;
        --n;
    }
    return res;
}

constexpr std::size_t n_digit(int count, int digit)
{
    std::size_t res = 0;

    for (int i = 0; i != count; ++i) {
        res *= 10;
        res += digit;
    }
    return res;
}

int solution(int a, int digit, std::size_t max_number)
{
    std::cout << a << " " << digit << " " << max_number << ":\n";
    if (digit == 0) {return 0; } // TODO
    const auto max_res = log10_up(max_number);

    for (int res = max_res; res != 0; --res) {
        const int modulo = pow10(res);
        const auto inverse = moduloInverse(a, modulo);
        if (inverse == 0) { continue; } // Error? `a` and `modulo` are not co-prime
        const auto sum = a * (n_digit(res, digit) * inverse % modulo);

        std::cout << a << " * ((" << n_digit(res, digit) << " * " << inverse << ") % " << modulo << ") == " << sum << std::endl;
        if (sum < max_number) {
            std::cout << "res = " << res << std::endl;
            return res;
        }
    }
    std::cout << "No" << std::endl;
    return 0;
}

int main() {
    solution(57, 9, 1000);
    solution(57, 4, 39000);
    solution(57, 4, 40000);
    return 0;
}
"""

# b = int(input("\nEnter price of one doodad between range 1 to 100000: "))

# b, d, a = map(int, input().split())
# if 1 <= b < 100000:
#     #print("\nPrice of one doodad is:", b)
#     pass
# else:
#     pass
#
# # d = int(input("\nEnter which digit you want to trail: "))
#
# if 0 <= d <= 9:
#     #print("\nTrailing digit you wish to trail is:", d)
#     pass
# else:
#     pass
#
# # a = int(input("\nEnter the maximum price of bundle more than the price you gave for a single doodad and less than 10000000: "))
#
# if b <= a < 10000000:
#      #print("\nMaximum price of bundle is:", a)
#     pass
# else:
#     pass
#
# x = b
# n = 1
#
# while x < a:
#     x = b * n
#     n += 1
#     # print("x:", x)
#
# y = x % (a // 10)
# c = 0
# temp = y
#
# while temp != 0:
#     temp = temp // 10
#     c += 1
#
# print(c)


# def is_divisible_by_57(number):
#     return number % 57 == 0
#
# def validate_trailing_number(number):
#     return number <= 39000
#
# def check_divisibility_and_limit():
#     for i in range(4):
#         number1 = int(f"{i}4444")
#         if is_divisible_by_57(number1) and validate_trailing_number(number1):
#             print(f"{number1} is divisible by 57 and within the limit.")
#
#         for x in range(10):
#             number2 = int(f"{i}{x}444")
#             if is_divisible_by_57(number2) and validate_trailing_number(number2):
#                 print(f"{number2} is divisible by 57 and within the limit.")
#
#             for y in range(10):
#                 number3 = int(f"{i}{x}{y}44")
#                 if is_divisible_by_57(number3) and validate_trailing_number(number3):
#                     print(f"{number3} is divisible by 57 and within the limit.")
#
# if __name__ == "__main__":
#     check_divisibility_and_limit()
# def main(B,d,a):
#     #B=57
#     #d=4
#     #a=39000
#
#     count=0
#     max=0
#     price=0
#     i=1
#     while price<a:
#         price=B*i
#         #print(price)
#         #print(str(price))
#         count=0
#
#
#         for x in range(len(str(price))):
#
#             if(str(price)[len(str(price))-1-x]==str(d) ):
#                 print("price",str(price))
#                 count+=1
#                 #print(count)
#             else:
#                 break
#
#         if(max<count):
#             #print("max",count)
#             max=count
#         i+=1
#
#     print(max)
#
# if __name__ == '__main__':
#     main(57,9,1000)
#     main(57,4,40000)
#     main(57,4,39000 )

# 57,9,1000
# 4,40000
# initial = 4
# current = initial
# limit = 40000
# cifra = 10
# i = 1
# digits= len(limit.__str__())-1
# while current<limit:
#     cifracurrent = cifra * i
#     current = cifracurrent + initial
#     print(i,current)
#     if (current % 57) == 0:
#         print("yey", current)
#     # print("i",i)
#     i += 1
#
# print(i)

# initial = 4
# current = initial
# limit = 40000
# cifra = 10
# i = len(str(limit)) - 2  # Start with the maximum value for reverse iteration
# digits = len(str(limit)) - 1
#
# while i > 0:
#     cifracurrent = cifra * i
#     current = cifracurrent + initial
#     print(i, current)
#     if (current % 57) == 0:
#         print("yey", current)
#     # print("i",i)
#     i -= 1
#
# print(i)


#
# def pad_right_with_number(number, width, padding_char):
#     str_number = str(number)
#     padding = max(0, width - len(str_number))
#     padded_number = str_number + padding_char * padding
#     return padded_number
#
#
#
# for number in range(10):
#     padded_number = pad_right_with_number(number, 5, '4')  # Adjust the width (5 in this case) as needed
#     print(padded_number)

# reverse_iteration(40000, 56, 4)


# def is_prime(num):
#     if num < 2:
#         return False
#     for i in range(2, int(num**0.5) + 1):
#         if num % i == 0:
#             return False
#     return True
#
# def find_prime_with_trailing_pattern(pattern, num_trails):
#     candidate = 1
#     while True:
#         candidate_str = str(candidate)
#         if candidate_str[-num_trails:] == pattern * num_trails and is_prime(candidate):
#             return candidate
#         candidate += 1
#
# # Example usage
# pattern = "9"
# num_trails = 4
# result = find_prime_with_trailing_pattern(pattern, num_trails)
# print(f"The prime number with {num_trails} trailing {pattern}'s is: {result}")

# b, d, a = map(int, input().split())
# k = a // b  # Start with the maximum possible value of k
# # print(k)
#
# max_repetition = 0
# result_with_max_repetition = None
#
#
# while k > 0:
#     total_cost = k * b
#     bestresult = len(total_cost.__str__())
#
#     if total_cost <= a:
#         # print("k:", k, "Total Cost:", total_cost)
#         # repetition = total_cost % b
#
#         number_str = str(total_cost)
#         count = 0
#         last_digit = None
#
#         for digit in reversed(number_str):
#             if digit == str(d) and (digit == last_digit or last_digit is None):
#                 count += 1
#                 last_digit = digit
#             else:
#                 break
#
#             if count > max_repetition:
#                 max_repetition = count
#
#     if count == bestresult \
#          or (int(total_cost.__str__()[0])<d and max_repetition==bestresult-1):
#         k=-1
#         continue
#
#     k -= 1
#
# print(max_repetition)



# def reverse_iteration(a, b, d):
#     k = a // b  # Start with the maximum possible value of k
#     # print("max iterations",k)
#
#     max_repetition = 0
#     result_with_max_repetition = None
#     factors=[]
#     reducer = []
#     iterations=0
#     #determine relevan factors
#     for i in range(1, 11):  # Iterar sobre los números del 1 al 10
#         resultado = b * i
#         if resultado % 10 == d:  # Verificar si el último dígito es el buscado
#             factors.append(i)
#     print("factors",factors)
#     # print(k * b)
#     for i in factors:
#         if i != k % 10:
#             if k % 10 <i:
#                 reducer.append((k % 10) + 10 - i)
#             else:
#                 reducer.append((k % 10) - i)
#         else:
#             reducer.append(0)
#
#     #last conection
#     if reducer[0]==0 and len(reducer)>1:
#         reducer[0]=(factors[len(factors)-1] - factors[0])
#     #single reducer
#     if len(reducer)==1:
#         k=k-reducer[0]
#         reducer[0]=10
#
#     print("reducer",reducer)
#     iteratorReducer=0
#     while k > 0:
#         iterations+=1
#         # print(iterations)
#         total_cost = k * b
#         bestresult = len(total_cost.__str__())
#
#         if total_cost <= a:
#             print("k:", k, "Total Cost:", total_cost)
#             # repetition = total_cost % b
#
#             number_str = str(total_cost)
#             count = 0
#             last_digit = None
#
#             for digit in reversed(number_str):
#                 if digit == str(d) and (digit == last_digit or last_digit is None):
#                     count += 1
#                     last_digit = digit
#                 else:
#                     break
#             # print(count)
#             if count > max_repetition:
#                 max_repetition = count
#
#             if count == bestresult \
#                     or (int(total_cost.__str__()[0])<d and max_repetition==bestresult-1):
#                 k=-1
#                 continue
#
#         iteratorReducer += 1
#         currenreducer=0
#         if len(reducer)==1:
#             currenreducer=reducer[0]
#         else:
#             currenreducer=reducer[iteratorReducer % len(reducer)]
#
#         k = k -currenreducer
#
#     print("iterations",iterations)
#     print(max_repetition)


# # Example usage:
# reverse_iteration(100, 17, 7)

## tests
# reverse_iteration(1000, 57, 9)
# reverse_iteration(1000, 57, 5)
# reverse_iteration(40000, 56, 4)
# reverse_iteration(40000, 57, 4)
# reverse_iteration(39000, 57, 4)

b, d, a = input().strip().split()
m = 0; n = 1; p = 1; b = int(b); d = int(d); best = 0

def gcd(a, b):
    while b: a, b = b, a % b
    return a

for l in range(len(a)): # O(log10 a)
    # 10**l * x + d * (10**l-1)//9 = 0 (mod k) for all k that divides b
    # p*x + d*m = 0 (mod b) -> need to find this in O(log2 b)
    # p*x = -d*m (mod b) but gcd(p, b) might not be 1
    g = gcd(p, b) # O(log b)
    if -d*m%b%g == 0:
        x = -d*m//g*pow(p//g, -1, b//g)%(b//g)
        if x == 0: x += b//g # edge case: b//g is optimal rather than b
        t = 10**len(str(x))
        while x < t:
            r = f'{x}{str(d)*l}'; l2 = l; x2 = x
            while x2 % 10 == d: x2 //= 10; l2 += 1 # edge case if x also ends with some d's
            if len(r) < len(a) or (len(r) == len(a) and r <= a): best = max(best, l2)
            x += b//g
    m += p; p *= 10; p %= b; m %= b
print(best)