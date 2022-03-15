from sqlalchemy import create_engine


def getConnection():

    server = "127.0.0.1"
    database = "mineria"
    port = "3306"
    user = "root"
    password = "root"

    e = create_engine("mysql+pymysql://root:root@localhost/mineria")
    return e