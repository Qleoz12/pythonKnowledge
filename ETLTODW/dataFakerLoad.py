import _random
import random
import uuid
from datetime import datetime as dt

from mimesis import Person, Address, Datetime, Business
from mimesis.random import random as _randomMimesis
from sqlalchemy.orm import Session
from fastapi import Depends

import dao
from ETLTODW.databaseResouce import SessionLocalResource
from ETLTODW.models.OLTP.Models import clientesDB, ventasDB
from ETLTODW.models.OLTP.clientes import clientes

from ETLTODW.models.OLTP.ventas import ventas

person = Person('ES')
addess = Address()
datetimemimesis = Datetime()
_business=Business()
listaCities=['27C89018-0534-480C-B719-5498EEE22D77','4C2DFCB8-A052-4035-A2FE-E75C637BC64B','5526D776-861B-4085-9B5F-91D58221D161']
listaClientes=[]
listavehiculos=['12asd1fdf-as1df-42BA-BF07-4DA11asdfa11','1FA8683B-797A-46E0-8E8A-3A7729D75B66','3C0CCF30-8C41-45B6-912D-B7B50E114863','6E8B826A-141D-4CC3-90AB-C3734D22E17F']

def fakeDataClientes(num=1,city=None,country=None):
    output = []
    for x in range(num):
        instancedata=clientes(uuid.uuid4().__str__(),
                                person.name(),
                                person.last_name(),
                                datetimemimesis.date().isoformat(),
                                _randomMimesis.custom_code(mask="##########"),
                                city or random.choice(listaCities),
                                addess.postal_code(),
                                person.telephone(mask="3##########"))
        listaClientes.append(instancedata.id)
        output.append(instancedata)
    return output

def fakeDataVentas(num=1,_clienteID=None,_vehiculoID=None,fecha=None,referencia=None,descuentos=None,cantidad=None):
    output = [ventas(uuid.uuid4().__str__(),
                     _business.company(),
                     _clienteID or random.choice(listaClientes),
                     _vehiculoID or random.choice(listavehiculos),
                     None,
                     fecha or datetimemimesis.datetime().isoformat(),
                     None,
                     cantidad or _randomMimesis.randints(1,0,100)[0],
                     referencia,
                     descuentos,
                     _randomMimesis.custom_code(mask="##########"))

              for x in range(num)]
    return output



def insertFakedata(data, db,tableName, job_run_id):
    rows_processed = 0
    cols_processed = 0
    start_date_Time = dt.now()
    cnxn = dao.getTargetConnection()
    cursor = cnxn.cursor()
    success = True

    listadecampos=dao.getdatatable(db,tableName)
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
            query=f"INSERT INTO DW.dbo.{tableName}({','.join(listadecampos)}) VALUES("+values+");"
            cursor.execute(query)
        except Exception as e:
            print(type(str(e)))
            print(str(e))
            success = False

    cnxn.commit()
    cursor.close()
    cnxn.close()


def get_db():
    db = SessionLocalResource()
    try:
        yield db
    finally:
        db.close()

def insertFakedataResources(data: clientes,db: Session):
        print(data[0].__class__.__name__)
        if(data[0].__class__.__name__==clientes.__name__):

            for entity in data:
                db_entity = clientesDB(id=entity.id,
                                              nombres=entity.nombres,
                                              apellidos=entity.apellidos,
                                              nacimiento=entity.nacimiento,
                                              documento=entity.documento,
                                              lugarNacimiento=entity.lugarNacimiento,
                                              codigoPostal=entity.codigoPostal,
                                              telefono=entity.telefono)
                db.add(db_entity)
                db.commit()
                db.refresh(db_entity)

        if (data[0].__class__.__name__ == ventas.__name__):
            for entity in data:
                db_entity = ventasDB(id=entity.id,
                                     descripcion=entity.descripcion,
                                     clienteID = entity.clienteID,
                                     vehiculoID = entity.vehiculoID,
                                     EmpleadoID = entity.EmpleadoID,
                                     fecha = entity.fecha,
                                     sucursalID = entity.sucursalID,
                                     cantidad = entity.cantidad,
                                     referencia = entity.referencia,
                                     descuentos = entity.descuentos,
                                     totalFactura = entity.totalFactura)
                db.add(db_entity)
                db.commit()
                db.refresh(db_entity)






def loaddatafake():

    data=fakeDataClientes(200)
    insertFakedataResources(data=data,db=next(get_db()))

    data = fakeDataVentas(300)
    insertFakedataResources(data=data, db=next(get_db()))

    data = fakeDataVentas(100,_vehiculoID='3C0CCF30-8C41-45B6-912D-B7B50E114863',fecha='2021-01-01')
    insertFakedataResources(data=data, db=next(get_db()))

    data = fakeDataVentas(100, _vehiculoID='3C0CCF30-8C41-45B6-912D-B7B50E114863', fecha='2021-01-01')
    insertFakedataResources(data=data, db=next(get_db()))

def removedatafake():
    next(get_db()).execute('''TRUNCATE TABLE ventas''')
    next(get_db()).commit()
    next(get_db()).close()
    next(get_db()).execute('''delete from clientes''')
    next(get_db()).commit()
    next(get_db()).close()





