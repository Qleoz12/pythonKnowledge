from dash import Input, Output, html, State, dash

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
        [Input('example-button', 'n_clicks'),],
        [State('origen', 'value'),
         State('destino', 'value'),
         State('pasajeros', 'value'),
         State('escaladas', 'value'),
         State('viaje_valor', 'value'),]
    )
    def calcular(n,origen,destino,pasajeros,escaladas,viaje_valor):
        if n is not None:
            viaje,fig,name = calcularVuelo(origen, destino, viaje_valor, 12, escaladas, pasajeros)
            return viaje,name#,fig

    return dash.no_update


