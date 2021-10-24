import uuid

from sqlalchemy import func, select
from sqlalchemy.orm import Session

from ETLTODW.dataFakerLoad import insertFakedata
from ETLTODW.models.OLAP.tiempo import tiempo
from ETLTODW.models.OLTP import Models
from ETLTODW.models.OLTP.ventas import ventas


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
        clientes = db.query(Models.clientesDB).all()
        print(db.query(Models.clientesDB).count())
        return {'ventas' :tiempo,'clientes':clientes}




    def transform(self,dataTotransform):
        '''
        :desc: la transformación se hace del lenguaje de origen a normalización requerida
        :return:
        '''
        clientes           =dataTotransform['clientes']
        ventasdata:ventas  =dataTotransform['ventas']
        tiempos=[]
        for  ventadata in ventasdata:
            current=tiempo(uuid.uuid4(),
               ventadata.fecha.day,
               ventadata.fecha.month,
               ventadata.fecha.year,
               ventadata.fecha.weekday(),
               ventadata.fecha.strftime('%j'),
               False,
               ventadata.fecha.weekday() in [5, 6],
               ventadata.fecha.isocalendar().week)
            tiempos.append(current)

        return {'tiempo' :tiempos,'clientes':clientes}





    def load(self,dataToLoad):

        print(dataToLoad['tiempo'][0].__class__.__name__)
        print(dataToLoad['clientes'][0].__class__.__name__)
        insertFakedata(dataToLoad['tiempo'], "DW", "tiempo", "job_run_id")
        insertFakedata(dataToLoad['clientes'], "DW", "clientes", "job_run_id")


    def processDBsResource(self):
        print('realizando extracción')
        return self.extraccion(self.db)

        # print('realizando transformación')
        # dataclean=transform()
        # dataclean.pop(0)
        # an_array = numpy.array(dataclean)
        # print(an_array)
        #
        # '''
        #     mostrar base de datos existentes
        # '''
        # show_db_query = "use testdb"
        # dbconn=connection()
        # cur = dbconn.cursor() 
        # cur.execute(show_db_query)
        # for x in cur:
        #     print(x)
        #
        # print('realizando carga de datos')
        # load(dataclean)