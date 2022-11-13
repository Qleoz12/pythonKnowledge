import dash_bootstrap_components as dbc
from dash import html


def Navbar():

    links = dbc.Row(
        [

            dbc.Button(
                "In the Press",
                className="nav-links-dd",
                color="link", href="/press",
            ),
        ],
        id="navbar-links",
        style={"position": "static"},
        # no_gutters=True,
        className="ml-auto",
    )
    navbar = dbc.Navbar(
        [
            html.A(
                dbc.Row(
                    [
                        dbc.Col(html.Img(src="assets/images/logo.jpg", height="100px")),
                    ],
                    align="center",
                ),
                href="/home",
            ),
            dbc.NavbarToggler(id="navbar-toggler"),
            dbc.Collapse(links, id="navbar-collapse", navbar=True),
        ],
        id="navbar",
        color="#0D4C92",
        dark=True,
    )

    return navbar
