from dash import Dash, html, Input, Output, State, ctx, dcc, dash
from datetime import datetime

"""
📘 Tic Tac Toe - Dash App
==========================

A simple interactive Tic Tac Toe game built with Python and Dash.

🔧 Requirements
---------------
1. Python 3.7 or higher
2. Install required libraries:

    pip install dash

📦 Libraries Used
------------------
- dash
- datetime (built-in)

▶️ How to Run in PyCharm
--------------------------
1. Open this file in a PyCharm project.
2. Create a Run Configuration:
   - Script: this `.py` file
   - Interpreter: select the one where `dash` is installed
3. Click the green Run button or use shortcut: Ctrl + Shift + F10
4. Open your browser and go to: http://127.0.0.1:8050

📌 Notes
---------
- Tailwind CSS is included via CDN for styling.
- Music starts playing on the first move.
- Cell colors change depending on the player:
    - X = red
    - O = blue
- You can change `number_cells` to experiment with larger board sizes (e.g. 16 for 4x4).

Author: qleoz12 - https://www.linkedin.com/in/leonardo-sanchez-89590b127/ 
"""

# --- App Init ---
app = Dash(__name__)
app.title = "Tic Tac Toe using dash to master it"
cell_colors = {
    "": "bg-gray-100",
    "X": "bg-red-500 text-white",
    "O": "bg-blue-500 text-white"
}



base_cell_class = "w-20 h-20 text-2xl font-bold m-1 border border-gray-300 rounded-md hover:bg-gray-200 transition duration-150"
game_music= "https://cdn.pixabay.com/audio/2025/06/07/audio_f81e4afb31.mp3"
# ----magic numbers ----------------------------------------------------------------------------------------------------
number_cells=9 #experiment with game bigger
class_names = [f"{base_cell_class} {cell_colors['']}" for _ in range(number_cells)]
# --- Data Models ------------------------------------------------------------------------------------------------------
# --- Player Classes ---
class HistoryPlayer:
    def __init__(self, name, symbol):
        self.name = name
        self.symbol = symbol
        self.win_time = datetime.now()

    def __str__(self):
        return f"{self.name} ({self.symbol}) won at {self.win_time.strftime('%Y-%m-%d %H:%M:%S')}"

class Player:
    def __init__(self, name, symbol):
        self.name = name
        self.symbol = symbol
        self.wins = []

    def add_win(self):
        self.wins.append(HistoryPlayer(self.name, self.symbol))

# --- UI Components ------------------------------------------------------------------------------------------------------
def player_name_inputs(id_prefix=""):
    return html.Div([
        dcc.Input(id=f'{id_prefix}name-x', type='text', placeholder='Name for Player X', debounce=True,
                  className="border border-gray-300 p-2 rounded-md w-full mb-3"),
        dcc.Input(id=f'{id_prefix}name-o', type='text', placeholder='Name for Player O', debounce=True,
                  className="border border-gray-300 p-2 rounded-md w-full mb-3"),
        html.Button("Start Game", id=f'{id_prefix}start', n_clicks=0,
                    className="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-4 py-2 rounded-md transition"),
        html.Div(id=f'{id_prefix}name-status', className="mt-2 text-blue-600 font-medium")
    ], className="mb-6")

def players_history():
    return html.Div([
        html.H3("Player History", className="text-xl font-bold mb-3"),
        html.Div(id="player-history", className="whitespace-pre-line text-sm text-gray-700")
    ], className="p-4")

def game_board():
    return html.Div(id='board', children=[
        html.Div([
            html.Button("", id=f"cell-{i}", n_clicks=0,
                        className=base_cell_class)
            for i in range(number_cells)
        ], className="grid grid-cols-3 justify-center gap-1")
    ], className="bg-white p-6 rounded-xl shadow-md")

def game_info_panel():
    return html.Div([
        html.H3("Current Turn:", className="text-gray-700 mb-1 font-medium"),
        html.Div(id='current-turn', className="text-lg mb-4"),
        html.H3("Move History:", className="text-gray-700 mb-1 font-medium"),
        html.Ul(id='move-history', children=[], className="text-base list-disc list-inside"),
        html.Br(),
        html.Button("Reset", id="reset", n_clicks=0,
                    className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"),
        html.Div(id='result', className="mt-4 text-green-600 text-lg"),
        html.Div(id='audio-trigger', style={"position": "absolute", "left": "-9999px"})
    ], className="ml-10 bg-white p-5 rounded-lg shadow w-72")

def get_default_return():
    children = [""] * number_cells
    result_text = ""
    turn_text = f"{players[current_player[0]].name} ({current_player[0]})"
    move_history_list = []
    win_history_text = get_all_win_history()
    music_src = ""

    return children + class_names + [result_text, turn_text, move_history_list, win_history_text, music_src]
# --- Winner Logic ---
def check_winner(b):
    wins = [(0,1,2),(3,4,5),(6,7,8),(0,3,6),(1,4,7),(2,5,8),(0,4,8),(2,4,6)]
    for i, j, k in wins:
        if b[i] and b[i] == b[j] == b[k]:
            return b[i]
    if "" not in b:
        return "Draw"
    return None

# --- Helper ---
def get_all_win_history():
    all_history = player_x.wins + player_o.wins
    return "\n".join(str(win) for win in all_history)
# --- Game State ------------------------------------------------------------------------------------------------------
@app.callback(
    [Output(f"cell-{i}", "children") for i in range(number_cells)] +
    [Output(f"cell-{i}", "className") for i in range(number_cells)] +  # <- Agrega esto
    [Output("result", "children"),
     Output("current-turn", "children"),
     Output("move-history", "children"),
     Output("player-history", "children"),
     Output("bg-music", "src")],
    [Input(f"cell-{i}", "n_clicks") for i in range(number_cells)] +
    [Input("reset", "n_clicks")]
)
def update_board(*args):
    global board, current_player, history, winner_declared, music_played
    triggered = ctx.triggered_id

    # Handle reset
    if triggered == "reset":
        board = [""] * number_cells
        current_player[0] = "X"
        history = []
        winner_declared[0] = False
        music_played[0] = False
        return get_default_return()

    if winner_declared[0]:
        return board + class_names + ["Game over. Click Reset to play again.", "", [html.Li(move) for move in history], get_all_win_history(), ""]

    for i in range(number_cells):
        if triggered == f"cell-{i}" and board[i] == "":
            symbol = current_player[0]
            board[i] = symbol
            history.append(f"{players[symbol].name} → Cell {i}")
            current_player[0] = "O" if symbol == "X" else "X"
            break

    winner = check_winner(board)
    result_text = ""

    if winner == "Draw":
        result_text = "Game ended in a draw!"
        winner_declared[0] = True
    elif winner:
        players[winner].add_win()
        result_text = f"{players[winner].name} wins!"
        winner_declared[0] = True

    # First move triggers music
    print(music_played)
    if not music_played[0]:
        music_played[0] = True
        src = game_music
    else:
        src = dash.no_update  # don't update src again

    print(src)
    # TODO improve this part
    cell_styles = [
        f"w-20 h-20 text-2xl font-bold m-1 border border-gray-300 rounded-md hover:bg-gray-200 transition duration-150 {cell_colors.get(board[i], '')}"
        for i in range(number_cells)
    ]
    return board + cell_styles +[
        result_text,
        f"{players[current_player[0]].name} ({current_player[0]})" if winner != "Draw" else "",
        [html.Li(move) for move in history],
        get_all_win_history(),
        src
    ]

# --- Name Setup Callback ---
@app.callback(
    Output("name-status", "children"),
    Input("start", "n_clicks"),
    State("name-x", "value"),
    State("name-o", "value")
)
def save_names(n, name_x, name_o):
    if n > 0:
        if not name_x or not name_o:
            return "Please enter both player names."
        player_x.name = name_x
        player_o.name = name_o
        names_locked[0] = True
        return f"Players set: {name_x} (X) vs {name_o} (O)"
    return ""



player_x = Player("Player X", "X")
player_o = Player("Player O", "O")
players = {"X": player_x, "O": player_o}
board = [""] * number_cells
current_player = ["X"]
history = []
names_locked = [False]
winner_declared = [False]
music_played = [False]



# --- Tailwind + Audio + JS ---
app.index_string = '''
<!DOCTYPE html>
<html>
    <head>
        {%metas%}
        <title>{%title%}</title>
        {%favicon%}
        {%css%}
        <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class="bg-gray-100">
        {%app_entry%}
        <footer>
            {%config%}
            {%scripts%}
            {%renderer%}
        </footer>
    </body>
</html>
'''



# --- App Layout ---
app.layout = html.Div([
    html.H1(app.title, className="text-center text-2xl font-bold text-gray-800 my-6"),
    html.Div([
        html.Div(player_name_inputs(), className="flex-1 bg-gray-50 p-5 rounded-lg shadow"),
        html.Div(players_history(), className="flex-1 bg-gray-50 p-5 rounded-lg shadow ml-5")
    ], className="flex justify-center gap-5 w-4/5 mx-auto mb-10"),
    html.Div([
        game_board(),
        game_info_panel()
    ], className="flex justify-center gap-10 mb-10"),
    html.Audio(id="bg-music", controls=False, autoPlay=True, loop=True, style={"display": "none"}),

])



# --- Game Update Callback ---
from dash import Output



# --- Run ---
if __name__ == "__main__":
    app.run(debug=True)
