import dash_core_components as dcc
import dash_html_components as html
import pandas as pd
import pathlib
import plotly.graph_objs as go
# Colours
color_1 = "#003399"
color_2 = "#00ffff"
color_3 = "#002277"
color_b = "#F8F8FF"



# Path
BASE_PATH = pathlib.Path(__file__).parent.resolve()
DATA_PATH = BASE_PATH.joinpath("Data").resolve()

supplyDemand = pd.read_csv(DATA_PATH.joinpath("supplyDemand.csv"))
# create an encapsulated layout component
chart_panel = html.Div(
    [
        dcc.Graph(
            figure={
                "data": [
                    go.Scatter(
                        x=supplyDemand[
                            "Período"
                        ],
                        y=supplyDemand[
                            "Inflacion al consumidor (IPC)"
                        ],
                        # hoverinfo="Inflación al consumidor (IPC)",
                        line={
                            "color": color_1,
                            "width": 1.5,
                        },
                        name="IPC",
                    ),
                    go.Scatter(
                        x=supplyDemand[
                            "Período"
                        ],
                        y=supplyDemand[
                            "Devaluación nominal 5/"
                        ],
                        # hoverinfo="TRM 5/",
                        line={
                            "color": color_2,
                            "width": 1.5,
                        },
                        name="Devaluación nominal",
                    ),
                ],
                "layout": go.Layout(
                    height=250,
                 xaxis={"tickangle": -90,
                        "showgrid": False,
                        "tickcolor": "#b0b1b2",
                        "tickmode": "linear",
                        },
                #     xaxis={
                #         "range": [
                #            1-1-2022,
                #             1-1-2023,
                #         ],
                #         "showgrid": False,
                #         "showticklabels": True,
                #         "tickangle": -90,
                #         "tickcolor": "#b0b1b2",
                #         "tickfont": {
                #             "family": "Arial",
                #             "size": 9,
                #         },
                #         "tickmode": "linear",
                #         "tickprefix": "1Q",
                #         "ticks": "",
                #         "type": "linear",
                #         "zeroline": True,
                #         "zerolinecolor": "#FFFFFF",
                #     },
                    yaxis={
                #         "autorange": False,
                #         "linecolor": "#b0b1b2",
                #         # "nticks": 1,
                        "range": [
                            -10,
                            40,
                        ],
                #         "showgrid": False,
                #         "showline": True,
                #         "tickcolor": "#b0b1b2",
                #         "tickfont": {
                #             "family": "Arial",
                #             "size": 9,
                        },
                #         "ticks": "outside",
                # #         "ticksuffix": " ",
                #         "type": "linear",
                #         "zerolinecolor": "#b0b1b2",
                #     },
                    # margin={
                    #     "r": 10,
                    #     "t": 5,
                    #     "b": 0,
                    #     "l": 40,
                    #     "pad": 2,
                    # },
                #     hovermode="closest",
                #     legend={
                #         "x": 0.5,
                #         "y": -0.4,
                #         "font": {
                #             "size": 9
                #         },
                #         "orientation": "h",
                #         "xanchor": "center",
                #         "yanchor": "bottom",
                #     },
                ),
            }
        )
    ],
    className="page-3m",
)
