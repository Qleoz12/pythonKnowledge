import datetime
import uuid
from datetime import datetime as dt

from mimesis import Person, Address, Datetime

import dao
import pyodbc
import configparser

#target
# CREATE TABLE DW.dbo.clientes(
# 	id varchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	nombre nchar(128) COLLATE Modern_Spanish_CI_AS NULL,
# 	direccion nchar(128) COLLATE Modern_Spanish_CI_AS NULL,
# 	provincia nchar(32) COLLATE Modern_Spanish_CI_AS NULL,
# 	ciudad nchar(32) COLLATE Modern_Spanish_CI_AS NULL,
# 	pais nchar(64) COLLATE Modern_Spanish_CI_AS NULL,
# 	codigo_postal nchar(16) COLLATE Modern_Spanish_CI_AS NULL,
# 	telefono nchar(32) COLLATE Modern_Spanish_CI_AS NULL,
# 	CONSTRAINT PK_cliente PRIMARY KEY (id)
# );


# CREATE TABLE DW.dbo.tiempo (
# 	id varchar(256) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	dia varchar(2) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	mes varchar(2) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	ano varchar(4) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	diasemana varchar(2) COLLATE Modern_Spanish_CI_AS NOT NULL,
# 	diaelaño SMALLINT NOT NULL,
# 	vacaciones bit NOT NULL,
# 	findesemana bit NOT NULL,
# 	semanaano TINYINT NOT NULL,
# 	CONSTRAINT PK_tiempo PRIMARY KEY (id)
# );


# CREATE TABLE DW.dbo.ventas (
# 	fechaID varchar(256) COLLATE Modern_Spanish_CI_AS NULL,
# 	clienteID varchar(256) COLLATE Modern_Spanish_CI_AS NULL,
# 	vehiculoID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	sucursalID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	empleadoID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	precio varchar(100) COLLATE Modern_Spanish_CI_AS NULL
# );
from ETLTODW.database import SessionLocal
from ETLTODW.databaseResouce import SessionLocalResource
from ETLTODW.models.OLAP.cliente import cliente
from ETLTODW.models.OLAP.tiempo import tiempo

person = Person('ES')
addess = Address()
datetimemimesis = Datetime()

def create_rows_mimesis(num=1,province=None,city=None,country=None):
    output = [cliente(uuid.uuid4(), person.name(), addess.address(), province or addess.province(),city or addess.city(),country or addess.country(), addess.postal_code(), person.telephone()) for x in range(num)]
    return output

def create_rows_mimesis2(num=1,day=None,month=None,ano=None,weekday=None,diadelano=None,holyday=None,weekend=None,weekeYear=None):
    output = []

    for x in range(num):
        if ano and month and day:
            datetime_obj = datetime.datetime(year=ano, month=month, day=day)
        else:
            datetime_obj = datetimemimesis.datetime()
        pivot=tiempo(uuid.uuid4(),
                     day or datetime_obj.day,
                     month or datetime_obj.month,
                     ano or datetime_obj.year,
                     weekday or datetime_obj.weekday(),
                     diadelano or datetime_obj.strftime('%j'),
                     holyday or False,
                     weekend or datetime_obj.weekday() in [5,6] or False,
                     weekeYear or datetime_obj.isocalendar().week)
        output.append(pivot)
    return output



def getdatatable(db,table):
    #query=f" SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{table}' and TABLE_CATALOG = N'{db}';"
    query=f" SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'{table}' ;"
    config = configparser.ConfigParser()
    config.readfp(open(r'config.ini'))

    DSN = config.get('DB_Target', 'DSN')
    DB = config.get('DB_Target', 'DB')
    UID = config.get('DB_Target', 'UID')
    PWD = config.get('DB_Target', 'PWD')

    cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                          f"Server={DSN};"
                          f"Database={db or DB};"
                          f"uid={UID};pwd={PWD};"
                          "Trusted_Connection=yes;",autocommit=True)
    # cnxn.autocommit(True)
    cursor = cnxn.cursor()
    success = True
    listadecampos=None
    all_databaselists = {}
    tableDesc=None
    try:
        print(query)
        tableDesc=cursor.execute(query).fetchall()
        cnxn.commit()
        cursor.close()
        cnxn.close()




    except Exception as e:
        print(type(str(e)))
        print(str(e))
        success = False

    col_names = []
    for desc in tableDesc:
        col_names.append(desc[0])

    print(col_names)
    return col_names



def getSourceConnection():
    config = configparser.ConfigParser()
    config.readfp(open(r'config.ini'))

    DSN = config.get('DB_Source', 'DSN')
    DB = config.get('DB_Source', 'DB')
    UID = config.get('DB_Source', 'UID')
    PWD = config.get('DB_Source', 'PWD')

    cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                            f"Server={DSN};"
                            f"Database={DB};"
                            f"uid={UID};pwd={PWD};"
                            "Trusted_Connection=yes;")

    return cnxn



def getTargetConnection():
    config = configparser.ConfigParser()
    config.readfp(open(r'config.ini'))

    DSN = config.get('DB_Target', 'DSN')
    DB = config.get('DB_Target', 'DB')
    UID = config.get('DB_Target', 'UID')
    PWD = config.get('DB_Target', 'PWD')

    cnxn = pyodbc.connect("Driver={SQL Server Native Client 11.0};"
                            f"Server={DSN};"
                            f"Database={DB};"
                            f"uid={UID};pwd={PWD};"
                            "Trusted_Connection=yes;")

    return cnxn

def get_db():
    db = SessionLocalResource()
    try:
        yield db
    finally:
        db.close()

def get_dbDW():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()