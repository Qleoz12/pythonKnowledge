"""
UVA - 11115
Dear Uncle Jack is willing to give away some of his collectable CDs to his nephews. Among the titles
you can find very rare albums of Hard Rock, Classical Music, Reggae and much more; each title is
considered to be unique. Last week he was listening to one of his favorite songs, Nobody’s fool, and
realized that it would be prudent to be aware of the many ways he can give away the CDs among some
of his nephews.
So far he has not made up his mind about the total amount of CDs and the number of nephews.
Indeed, a given nephew may receive no CDs at all.
Please help dear Uncle Jack, given the total number of CDs and the number of nephews, to calculate
the number of different ways to distribute the CDs among the nephews.
Input
The input consists of several test cases. Each test case is given in a single line of the input by, space
separated, integers N (1 ≤ N ≤ 10) and D (0 ≤ D ≤ 25), corresponding to the number of nephews
and the number of CDs respectively. The end of the test cases is indicated with N = D = 0.
Output
The output consists of several lines, one per test case, following the order given by the input. Each line
has the number of all possible ways to distribute D CDs among N nephews.
Sample Input
1 20
3 10
0 0
Sample Output
1
59049
"""

while True:


    N, D = map(int, input().split())

    if(N==D and D==0):
        break

    print(N**D)