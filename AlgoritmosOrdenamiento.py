import random
import time

def BubbleSort(lista, tam):
    for i in range(1, tam):
        for j in range(0, tam - i):
            if (lista[j] > lista[j + 1]):
                k = lista[j + 1]
                lista[j + 1] = lista[j]
                lista[j] = k;


def quicksort(lista, izq, der):
    i = izq
    j = der
    x = lista[(izq + der) // 2]

    while (i <= j):
        while lista[i] < x and j <= der:
            i = i + 1
        while x < lista[j] and j > izq:
            j = j - 1
        if i <= j:
            aux = lista[i];
            lista[i] = lista[j];
            lista[j] = aux;
            i = i + 1;
            j = j - 1;

        if izq < j:
            quicksort(lista, izq, j);
    if i < der:
        quicksort(lista, i, der);

def insertionSort(lista):
    n = len(lista)
    global comparaciones
    comparaciones=0
    for i in list(range(1, n)):
        val = lista[i]
        j = i

        while j > 0 and lista[j-1] > val:
            lista[j] = lista[j-1]
            j -= 1
            comparaciones += 1

        lista[j] = val

def imprimeLista(lista, tam):
    for i in range(0, tam):
        print(lista[i])


def leeLista():
    lista = random.sample(range(0, 101), 100)
    return lista


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    start_time = time.time()
    A=leeLista()
    print(A)
    BubbleSort(A, len(A))
    #imprimeLista(A, len(A))
    print("BubbleSort")
    print("--- %s seconds ---" % (time.time() - start_time))

    start_time = time.time()
    A = leeLista()
    print(A)
    quicksort(A, 0,len(A)-1)
    print("quicksort")
    print("--- %s seconds ---" % (time.time() - start_time))

    start_time = time.time()
    A = leeLista()
    print(A)
    insertionSort(A)
    print("insertionSort")
    print("--- %s seconds ---" % (time.time() - start_time))