from sys import stdin
"""
UVA - 11111
B - Generalized Matrioshkas 

Vladimir worked for years making matrioshkas, those nesting dolls that certainly represent truly Russian
craft. A matrioshka is a doll that may be opened in two halves, so that one finds another doll inside.
Then this doll may be opened to find another one inside it. This can be repeated several times, till a
final doll -that cannot be opened- is reached.
Recently, Vladimir realized that the idea of nesting dolls might be generalized to nesting toys.
Indeed, he has designed toys that contain toys but in a more general sense. One of these toys may
be opened in two halves and it may have more than one toy inside it. That is the new feature that
Vladimir wants to introduce in his new line of toys.
Vladimir has developed a notation to describe how nesting toys should be constructed. A toy
is represented with a positive integer, according to its size. More precisely: if when opening the toy
represented by m we find the toys represented by n1, n2, . . ., nr, it must be true that n1+n2+. . .+nr <
m. And if this is the case, we say that toy m contains directly the toys n1, n2, . . ., nr. It should be
clear that toys that may be contained in any of the toys n1, n2, . . ., nr are not considered as directly
contained in the toy m.
A generalized matrioshka is denoted with a non-empty sequence of non zero integers of the form:
a1 a2 . . . aN
such that toy k is represented in the sequence with two integers −k and k, with the negative one
occurring in the sequence first that the positive one.
For example, the sequence
−9 − 7 − 2 2 − 3 − 2 − 1 1 2 3 7 9
represents a generalized matrioshka conformed by six toys, namely, 1, 2 (twice), 3, 7 and 9. Note that
toy 7 contains directly toys 2 and 3. Note that the first copy of toy 2 occurs left from the second one
and that the second copy contains directly a toy 1. It would be wrong to understand that the first −2
and the last 2 should be paired.
On the other hand, the following sequences do not describe generalized matrioshkas:
•
−9 − 7 − 2 2 − 3 − 1 − 2 2 1 3 7 9
because toy 2 is bigger than toy 1 and cannot be allocated inside it.
•
−9 − 7 − 2 2 − 3 − 2 − 1 1 2 3 7 − 2 2 9
because 7 and 2 may not be allocated together inside 9.
•
−9 − 7 − 2 2 − 3 − 1 − 2 3 2 1 7 9
because there is a nesting problem within toy 3.
Your problem is to write a program to help Vladimir telling good designs from bad ones.
Input
The input file contains several test cases, each one of them in a separate line. Each test case is a
sequence of non zero integers, each one with an absolute value less than 107
.
Output
Output texts for each input case are presented in the same order that input is read.
For each test case the answer must be a line of the form
:-) Matrioshka!
if the design describes a generalized matrioshka. In other case, the answer should be of the form
:-( Try again.
Sample Input
-9 -7 -2 2 -3 -2 -1 1 2 3 7 9
-9 -7 -2 2 -3 -1 -2 2 1 3 7 9
-9 -7 -2 2 -3 -1 -2 3 2 1 7 9
-100 -50 -6 6 50 100
-100 -50 -6 6 45 100
-10 -5 -2 2 5 -4 -3 3 4 10
-9 -5 -2 2 5 -4 -3 3 4 9
Sample Output
:-) Matrioshka!
:-( Try again.
:-( Try again.
:-) Matrioshka!
:-( Try again.
:-) Matrioshka!
:-( Try again

"""
# Sample Input
input_lines = [
    "-9 -7 -2 2 -3 -2 -1 1 2 3 7 9",
    "-9 -7 -2 2 -3 -1 -2 2 1 3 7 9",
    "-9 -7 -2 2 -3 -1 -2 3 2 1 7 9",
    "-100 -50 -6 6 50 100",
    "-100 -50 -6 6 45 100",
    "-10 -5 -2 2 5 -4 -3 3 4 10",
    "-9 -5 -2 2 5 -4 -3 3 4 9",
]

# Loop through each input line
for dato in input_lines:
    # Clean up and split the input line into a list of integers
    dato = dato.strip().split()
    stack1, stack2 = list(), list()
    i, j, band, s = 0, len(dato), True, None

    # Iterate through the list of integers
    while band and i < j:
        datos = int(dato[i])
        print(i,datos)
        # If the current number is negative, add its positive counterpart to stack2
        if datos < 0:
            stack1.append(datos)
            stack2.append(datos * (-1))
        else:
            # If the current number is positive, check if it can close a Matrioshka
            if len(stack1) == 0 or stack1[-1] + datos != 0:
                band = False
            else:
                # Pop the top elements from both stacks, and check if the Matrioshka is valid
                print("stacks", stack1, stack2)
                pop2=stack2.pop()
                pop1=stack1.pop()
                print("pops",pop1,pop2)
                # Update the sum of elements in stack2
                if len(stack1) > 0:
                    s = stack2.pop() - datos
                    print("s",s)
                    if s <= 0:
                        band = False
                    stack2.append(s)

        i += 1

    # Check if the loop completed successfully and if the stacks are empty
    band = band and len(stack1) == 0

    # Print the result based on the validity of the Matrioshka sequence
    if band:
        print(':-) Matrioshka!')
    else:
        print(':-( Try again.')
