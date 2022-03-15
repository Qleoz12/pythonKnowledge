import uuid

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ETLTODW.dataFakerLoad import insertFakedata
from ETLTODW.models.OLAP.cliente import cliente

from ETLTODW.models.OLAP.tiempo import tiempo
from ETLTODW.models.OLTP import Models
from ETLTODW.models.OLTP.Models import ciudadesDB, provinciasDB, paisesDB



class ETL:

    def __init__(self, db: Session,dbconn=None,dbSource=None,dbTarget=None):
        self.dbconn=dbconn
        self.db=db
        self.dbSource = dbSource
        self.dbTarget = dbTarget

    def extraccion(self,db: Session):
        tiempo=db.query(Models.ventasDB).all()
        print (db.query(Models.ventasDB).count())
        clientes = db.query(Models.clientesDB).all()
        print(db.query(Models.clientesDB).count())
        clientes = db.query(Models.clientesDB).join(ciudadesDB).join(provinciasDB).join(paisesDB).all()
        print(db.query(Models.clientesDB).count())
        return {'ventas' :tiempo,'clientes':clientes}




    def transform(self,dataTotransform):
        '''
        :desc: la transformación se hace del lenguaje de origen a normalización requerida
        :return:
        '''
        clientesdata =dataTotransform['clientes']
        ventasdata   =dataTotransform['ventas']
        '''
            dimensiones
        '''
        tiemposDim=[]
        clientesDim = []

        for ventadata in ventasdata:
            current=tiempo(uuid.uuid4(),
               ventadata.fecha.day,
               ventadata.fecha.month,
               ventadata.fecha.year,
               ventadata.fecha.weekday(),
               ventadata.fecha.strftime('%j'),
               False,
               ventadata.fecha.weekday() in [5, 6],
               ventadata.fecha.isocalendar().week)
            tiemposDim.append(current)

        # se limpian tiempos repetidos
        tiemposDim = list(set(tiemposDim))

        for _clientedata in clientesdata:
            current=cliente(_clientedata.id,
                          _clientedata.nombres,
                          None,
                          _clientedata.ciudadesDB.nombre,
                          _clientedata.ciudadesDB.provinciasDB.nombre,
                          _clientedata.ciudadesDB.provinciasDB.paisesDB.nombre,
                          _clientedata.codigoPostal,
                          _clientedata.telefono)
            clientesDim.append(current)


        return {'tiempo' :tiemposDim,'clientes':clientesDim}





    def load(self,dataToLoad):

        print(dataToLoad['tiempo'][0].__class__.__name__)
        print(dataToLoad['clientes'][0].__class__.__name__)
        insertFakedata(dataToLoad['tiempo'], "DW", "tiempo", "job_run_id")
        insertFakedata(dataToLoad['clientes'], "DW", "clientes", "job_run_id")


    def processDBsResource(self):
        print('realizando extracción')
        return self.extraccion(self.db)