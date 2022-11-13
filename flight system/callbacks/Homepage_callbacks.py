from dash import Input, Output, html

from flight_system import calcularVuelo


def register_callbacks(app):


    # @app.callback(
    #     Output("example-output", "children"),
    #     [Input('example-button', 'n_clicks')]
    # )
    # def calcular(n):
    #     if n is not None:
    #         viaje= calcularVuelo("bogota","paris",2000000,12,10,100)
    #         return viaje.__str__()

    @app.callback(
        [Output('table-container', 'data'),
        Output('example-img', 'src')],
        [Input('example-button', 'n_clicks')]
    )
    def calcular(n):
        if n is not None:
            viaje,fig,name = calcularVuelo("bogota", "paris", 2000000, 12, 10, 100)
            return viaje,name#,fig



