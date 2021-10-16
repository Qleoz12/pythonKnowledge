from datetime import datetime as dt

import dao
import pyodbc
import configparser

#target
# CREATE TABLE resourcesDW.dbo.cliente (
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


# CREATE TABLE resourcesDW.dbo.tiempo (
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


# CREATE TABLE resourcesDW.dbo.ventas (
# 	fechaID varchar(256) COLLATE Modern_Spanish_CI_AS NULL,
# 	clienteID varchar(256) COLLATE Modern_Spanish_CI_AS NULL,
# 	vehiculoID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	sucursalID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	empleadoID varchar(100) COLLATE Modern_Spanish_CI_AS NULL,
# 	precio varchar(100) COLLATE Modern_Spanish_CI_AS NULL
# );




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