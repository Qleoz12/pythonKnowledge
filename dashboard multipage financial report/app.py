# -*- coding: utf-8 -*-
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly.graph_objs as go
import dash_table
import pandas as pd
import lorem
import pathlib

# Path
from Utils import generate_table
from graph1 import chart_panel

BASE_PATH = pathlib.Path(__file__).parent.resolve()
DATA_PATH = BASE_PATH.joinpath("Data").resolve()

## Read in data
supplyDemand = pd.read_csv(DATA_PATH.joinpath("supplyDemand.csv"))
actualSeasonal = pd.read_csv(DATA_PATH.joinpath("actualSeasonal.csv"))
industrailProd = pd.read_csv(DATA_PATH.joinpath("industrailProd.csv"))
globalMarket = pd.read_csv(DATA_PATH.joinpath("globalMarket.csv"))
oecdCommersial = pd.read_csv(DATA_PATH.joinpath("oecdCommersial.csv"))
wtiPrices = pd.read_csv(DATA_PATH.joinpath("wtiPrices.csv"))
epxEquity = pd.read_csv(DATA_PATH.joinpath("epxEquity.csv"))
chinaSpr = pd.read_csv(DATA_PATH.joinpath("chinaSpr.csv"))
oecdIndustry = pd.read_csv(DATA_PATH.joinpath("oecdIndustry.csv"))
wtiOilprices = pd.read_csv(DATA_PATH.joinpath("wtiOilprices.csv"))
productionCost = pd.read_csv(DATA_PATH.joinpath("productionCost.csv"))
production2015 = pd.read_csv(DATA_PATH.joinpath("production2015.csv"))
energyShare = pd.read_csv(DATA_PATH.joinpath("energyShare.csv"))
adjustedSales = pd.read_csv(DATA_PATH.joinpath("adjustedSales.csv"))
growthGdp = pd.read_csv(DATA_PATH.joinpath("growthGdp.csv"))

# Colours
color_1 = "#003399"
color_2 = "#00ffff"
color_3 = "#002277"
color_b = "#F8F8FF"

app = dash.Dash(__name__)
app.title = "Multipage Report"

server = app.server

app.layout = html.Div(
    children=[
        html.Div(
            [
                html.Div(
                    [
                        html.Div(
                            [
                                html.Div(
                                    [
                                        html.Div(
                                            [
                                                html.Div(
                                                    html.Img(
                                                        src=app.get_asset_url(
                                                            "dash-logo-new.png"
                                                        ),
                                                        className="page-1a",
                                                    )
                                                ),
                                                html.Div(
                                                    [
                                                        html.H6("Comparativa de indicadores financieros"),
                                                        html.H5("Universidad Minuto de Dios"),
                                                        html.H6("Leonardo L Sanchez"),
                                                    ],
                                                    className="page-1b",
                                                ),
                                            ],
                                            className="page-1c",
                                        )
                                    ],
                                    className="page-1d",
                                ),
                                html.Div(
                                    [
                                        html.H1(
                                            [
                                                html.Span("03", className="page-1e"),
                                                html.Span("19"),
                                            ]
                                        ),
                                        html.H6("Suscipit nibh vita"),
                                    ],
                                    className="page-1f",
                                ),
                            ],
                            className="page-1g",
                        ),
                        html.Div(
                        children=[chart_panel,generate_table(supplyDemand,"Período")],
                        className="page-3m",
                        )
                    ],
                    className="subpage",
                ),
            ],
        className="page"),
    ],
)

if __name__ == "__main__":
    app.run_server(debug=True)
