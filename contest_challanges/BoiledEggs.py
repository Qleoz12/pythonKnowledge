"""

UVA - 11900
Three of the trouble-makers went to Malaysia this year. A rest house was booked for them. Unlike
other rest houses, this rest house was like a normal duplex house. So, it had a kitchen. And the
trouble-makers were given all the ingredients to cook, but they had to cook themselves.
None of them had any previous cooking experience, but
they became very excited and planned to cook so many delicious foods! Ideas were coming from their minds like rains
from clouds. So, they went to the super market and bought a
lot of extra ingredients for their great recipes. For example,
they bought 20 eggs. The excited trouble-makers returned to
the rest house and found that the gas stove was not connected
to the gas cylinder. So, they became very sad, because it was
not possible for them to connect such complex thing. And so
many foods were about to be rotten. But luckily, they found
the microwave oven working. So, they tried to boil all the
eggs using the microwave oven (may be, first time in history)!
And they succeeded to boil the eggs!
Now they have n eggs and a bowl. They put some eggs in the bowl with some water. And after
that they put the bowl into the oven to boil the eggs. It’s risky to put more than P eggs in the bowl
and the bowl can carry at most Q gm of eggs. It takes 12 minutes to boil a bowl of eggs. Now you are
given the weight of the eggs in gm, and the trouble-makers have exactly 12 minutes in their hand. You
have to find the maximum number of eggs they can boil without taking any risk.
Input
The first line of input will contain T (≤ 100) denoting the number of cases.
Each case starts with 3 integers n (1 ≤ n ≤ 30), P (1 ≤ P ≤ 30) and Q (1 ≤ Q ≤ 30). The next
line contains n positive integers (not greater than 10) in non-descending order. These integers denote
the weight of the eggs in gm.
Output

For each case, print the case number and the desired result.
Sample Input
 - n number of egs
 - P t’s risky to put more than P eggs in the bowl
 - Q the bowl can carry at most Q gm of eggs.
2
3 2 10
1 2 3
4 5 5
4 4 5 5
Sample Output
Case 1: 2
Case 2: 1
"""

def max_eggs_to_boil(n, P, Q, weights):
    total_weight = 0
    eggs_boiled = 0

    for i in range(n):
        if eggs_boiled + 1 <= P and total_weight + weights[i] <= Q:
            eggs_boiled += 1
            total_weight += weights[i]
        else:
            break

    return eggs_boiled

def main():
    T = int(input())
    for case in range(1, T + 1):
        n, P, Q = map(int, input().split())
        weights = list(map(int, input().split()))

        result = max_eggs_to_boil(n, P, Q, weights)

        print(f"Case {case}: {result}")

if __name__ == "__main__":
    main()