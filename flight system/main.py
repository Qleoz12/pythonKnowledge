import dash
import dash_core_components as dcc
from dash import html
import dash_bootstrap_components as dbc
from dash.dependencies import Input, Output, State

from HomePage import Homepage
from callbacks import Homepage_callbacks

app = dash.Dash(
        __name__,
        external_stylesheets=[dbc.themes.UNITED],
        meta_tags=[
            {"name": "viewport", "content": "width=device-width, initial-scale=1"}
            ]
        )

server = app.server
app.title = "COVIDAnalytics"
app.config.suppress_callback_exceptions = True
external_stylesheets=[dbc.themes.BOOTSTRAP]

app.layout = html.Div([
    dcc.Location(id = 'url', refresh = False),
    html.Div(id = 'page-content')
])
# app.scripts.append_script({'external_url':'https://covidanalytics.io/assets/gtag.js'})
Homepage_callbacks.register_callbacks(app)

# redirects to different pages
@app.callback(Output('page-content', 'children'),[Input('url', 'pathname')])
def display_page(pathname):
    if pathname == '/vuelos':
        print("not implemented")
    else:
        return Homepage()

#Callbacks for navbar
@app.callback(
    Output("navbar-collapse", "is_open"),
    [Input("navbar-toggler", "n_clicks")],
    [State("navbar-collapse", "is_open")],
)
def toggle_navbar_collapse(n, is_open):
    if n:
        return not is_open
    return is_open

if __name__ == '__main__':
    app.run_server(debug=True,dev_tools_hot_reload=False)