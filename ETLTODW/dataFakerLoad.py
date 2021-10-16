import uuid
from datetime import datetime as dt
from random import Random

from mimesis import Person, Address, Datetime, Business

import dao

from ETLTODW.models.OLAP.cliente import cliente
from ETLTODW.models.OLTP.ventas import ventas

person = Person('ES')
addess = Address()
datetimemimesis = Datetime()
_business=Business()
_Random=Random()
def fakeDataClientes(num=1,city=None,country=None):
    output = [cliente(uuid.uuid4(),
                      person.name(),
                      person.last_name(),
                      person.age(),
                      person.identifier(),
                      city or addess.city(),
                      addess.postal_code(),
                      person.telephone())
              for x in range(num)]
    return output

def fakeDataVentas(num=1,_clienteID=None,_vehiculoID=None,fecha=None,referencia=None,descuentos=None,cantidad=None):
    output = [ventas(uuid.uuid4(),
                     _business.company(),
                     _clienteID,
                     _vehiculoID,
                     None,
                     fecha or datetimemimesis.datetime(),
                     None,
                     cantidad or _Random.randints(1,0,100),
                     referencia,
                     descuentos,
                     _business.price())

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
            query=f"INSERT INTO resourcesDW.dbo.{tableName}({','.join(listadecampos)}) VALUES("+values+");"
            cursor.execute(query)
        except Exception as e:
            print(type(str(e)))
            print(str(e))
            success = False

    cnxn.commit()
    cursor.close()
    cnxn.close()

def insertFakedataResources():
