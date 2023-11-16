import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation


def update(frameNum, img, board, N):
    new_board = board.copy()
    for i in range(N):
        for j in range(N):
            # Contar vecinos vivos
            neighbors = (board[i, (j-1)%N] + board[i, (j+1)%N] +
                        board[(i-1)%N, j] + board[(i+1)%N, j] +
                        board[(i-1)%N, (j-1)%N] + board[(i-1)%N, (j+1)%N] +
                        board[(i+1)%N, (j-1)%N] + board[(i+1)%N, (j+1)%N])
            # Aplicar reglas del juego
            if board[i, j] == 1 and (neighbors < 2 or neighbors > 3):
                new_board[i, j] = 0
            elif board[i, j] == 0 and neighbors == 3:
                new_board[i, j] = 1
    # Actualizar el tablero y la imagen
    img.set_data(new_board)
    board[:] = new_board[:]
    return img,


if __name__ == '__main__':
    # Tamaño del tablero
    N = 1000
    # Inicializar tablero aleatorio
    board = np.random.choice([0, 1], size=(N, N), p=[0.8, 0.2])
    # Crear figura
    fig, ax = plt.subplots()
    img = ax.imshow(board, interpolation='nearest')

    # Crear animación
    ani = animation.FuncAnimation(fig, update, fargs=(img, board, N),
                                  frames=1000, interval=1, blit=True)
    # Mostrar animación
    plt.show()

