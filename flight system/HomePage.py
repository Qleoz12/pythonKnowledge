### Data

### Graphing
import dash_bootstrap_components as dbc
import dash_core_components as dcc
import dash_html_components as html
import dash_table as dt

from data import Paises
from navbar import Navbar


def Homepage():
    nav = Navbar()

    def build_card(imgTop, titles, text, img, links):
        cardbody = []
        for i, t in enumerate(titles):
            cardbody.append(html.A(t, href=links[i], className="card-title"))
            cardbody.append(dcc.Markdown(text[i]))

        if imgTop:
            card_content = \
                [
                    dbc.CardImg(src=img, top=False),
                    dbc.CardBody(
                        cardbody,
                        className="home-card-body"
                    ),
                ]

        else:
            card_content = \
                [
                    dbc.CardBody(
                        cardbody,
                        className="home-card-body"
                    ),
                    dbc.CardImg(src=img, top=True),
                ]

        card = dbc.Card(
            card_content,
            className="home-card h-100"
        )

        return dbc.Col(
            [card],
            style={"margin": "0.5rem"},
        )

    data_text = '''
           130+ international Covid-19 clinical studies,
           aggregated into a single dataset.
           '''
    insights_text = '''
        Key characteristics of COVID-19 patients in an
        interactive summary. '''

    projections_text = '''
        Epidemiological predictions of COVID-19 \
        infections, hospital stays, and mortalities.
        '''

    policy_text = '''
        Predicting infections and deaths based on various policy \
        implementations'''

    ventilator_text = '''
           Leveraging delays between state peaks to \
           optimally re-use ventilators.
           '''

    mortality_calculator_text = '''
          Personalized calculator predicting mortality upon hospitalization.
          '''

    infection_calculator_text = '''
        Personalized calculator predicting results of COVID test.
        '''

    financial_text = '''
        Unemployment is rising. How analytics can help inform COVID-19 related financial decisions.
        '''

    cards = \
        [
            {
                "titles": ["Data", "Insights"],
                "text": [data_text, insights_text],
                "image": "assets/images/insights-4.png",
                "links": ["/dataset", "/interactive-graph"]
            },
            {
                "titles": ["Infection risk calculator", "Mortality risk calculator"],
                "text": [infection_calculator_text, mortality_calculator_text],
                "image": "assets/images/infection_logo.jpg",
                "links": ["/infection_calculator", "/mortality_calculator"]
            },
            {
                "titles": ["Case predictions", "Policy evaluations"],
                "text": [projections_text, policy_text],
                "image": "assets/images/forecast-1.png",
                "links": ["/projections", "/policies"]
            },
            {
                "titles": ["Ventilator allocation"],
                "text": [ventilator_text],
                "image": "assets/images/allocation.png",
                "links": ["/ventilator_allocation"]
            },
            {
                "titles": ["Financial relief planning"],
                "text": [financial_text],
                "image": "assets/images/financial_logo.jpeg",
                "links": ["/financial_relief", "/interactive-graph"]
            }

        ]

    body = dbc.Container(
        [
            dbc.Row(
                dbc.Col(
                    dcc.Markdown(
                        '''
                        El Sistema de Control de Partidas o DCS (sistema de facturación) es el sistema utilizado por las
                         aerolíneas y aeropuertos para facturar los pasajeros y su equipaje así como las mercancías. 
                         El sistema verifica si un supuesto pasajero tiene una reserva válida, asigna asiento y emite 
                         tarjeta de embarque. Además el sistema es responsable de la transmisión de datos de los 
                         pasajeros (Advanced Passenger Information o APIS) a las autoridades previo al vuelo. 
                         El DCS también incluye componentes que permiten calcular el emplazamiento óptimo de 
                         mercancías en el bodegón del avión en función de criterios de equilibrio, consumo de carburante,
                          carga y descarga de contenedores etc.
                         '''
                    ),
                ),
            ),
            dbc.Row([
                dbc.Col(
                    dbc.Select(
                        # label="Lugar de origen",
                        id="origen",
                        options=[
                            {"label": x, "value": x} for x in Paises
                        ],
                    )
                ),
                dbc.Col(
                    dbc.Select(
                        # label="Lugar de destino",
                        id="destino",
                        options=[
                            {"label": x, "value": x} for x in Paises
                        ],
                    )
                ),

            ]),

            dbc.Row([
                html.Div(
                    [
                        html.P("numero de pasajeros"),
                        dbc.Input(type="number", min=0, max=200, step=1, id="pasajeros"),
                    ], ),

                html.Div(
                    [
                        html.P("numero de escaladas"),
                        dbc.Input(type="number", min=1, max=10, step=1, id="escaladas"),
                    ], ),
                html.Span(style={"verticalAlign": "middle"}),
                dbc.Button(
                    "calcular Viaje",
                    id="example-button", href='/'
                ),
                html.Span(id="example-output", style={"verticalAlign": "middle"}),
                dt.DataTable(
                    id='table-container', )

            ]),
            dbc.Row([
                html.Img(id="example-img", height="1000px")
                # dcc.Graph(
                #     id='example-img',
                # )
            ]),
        ],
        className="page-body"
    )

    layout = html.Div([nav, body], className="site")
    return layout
