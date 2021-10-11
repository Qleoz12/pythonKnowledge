from datetime import datetime as dt

import dao
import pyodbc
import configparser

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

def insertFakedata(data, tableName, job_run_id):
    rows_processed = 0
    cols_processed = 0
    start_date_Time = dt.now()
    cnxn = dao.getTargetConnection()
    cursor = cnxn.cursor()
    success = True

    for index, row in enumerate(data):

        # print(type(row["8"]), row["8"])
        rows_processed += 1
        values=""
        cols_processed = 0
        for attr, value in row.__dict__.items():
            cols_processed+=1
            if(cols_processed<len(row.__dict__.items())):
                values += "'"+str(value)+"'" + ","
            else:
                values += "'"+str(value)+"'"

        #print(attr, value)
        #print(index,rows_processed)

        try:
            query="INSERT INTO resourcesDW.dbo.cliente(id, nombre, direccion, provincia, ciudad, pais, codigo_postal, telefono) VALUES("+values+");";
            cursor.execute(query)
        except Exception as e:
            print(type(str(e)))
            print(str(e))
            success = False

    cnxn.commit()
    cursor.close()
    cnxn.close()