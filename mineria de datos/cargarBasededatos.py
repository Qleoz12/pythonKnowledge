import pandas as pd
import openpyxl as xl

from sqlalchemy import MetaData,Table,Column,Integer,ForeignKey,String
from sqlalchemy.orm import Session

from DBmanager import getConnection
from crear_db_model_from_orm import crearMoldeloRelacional, Profesor


def cargarInfo(file_name,sheet):


    df = pd.read_excel(io=file_name, sheet_name=sheet)
    # print(df)
    nombreprofesor=df.columns[0]
    nombreprofesor=nombreprofesor.replace("Instructor", "")
    nombreprofesor = nombreprofesor.replace("General", "")
    nombreprofesor=nombreprofesor.strip()
    # nombreprofesor=nombreprofesor.replace(" ", "")
    print(nombreprofesor)
    # print(len(nombreprofesor))
    # for col in df.columns:
    #     print(col)
    return nombreprofesor

def infoExcel(file_name):
    wb = xl.load_workbook(file_name, read_only=True)
    res = len(wb.sheetnames)
    print(res)
    return res

if __name__ == '__main__':

    crearMoldeloRelacional()
    engine = getConnection()
    session = Session(engine, future=True)

    counsheets=infoExcel("PROMEDIOprofesor.xlsx")
    profesores = set()
    for x in range(counsheets):
        profesor=cargarInfo("PROMEDIOprofesor.xlsx", "Table {}".format(x+1))
        profesores.add(profesor)
        profesorEntity = Profesor(name=profesor)
        session.add(profesorEntity)
        session.commit()



    print(len(profesores))






