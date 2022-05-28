import sys, os
sys.path.append(os.path.abspath('.'))

from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

def getConnection():

    server = "127.0.0.1"
    database = "mineria"
    port = "3306"
    user = "root"
    password = "root"

    e = create_engine("mysql+pymysql://root:root@localhost/masivas")
    return e



SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=getConnection())

Base = declarative_base()