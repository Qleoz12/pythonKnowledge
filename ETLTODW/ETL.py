from sqlalchemy.orm import Session


class ETL:

    def __init__(self, dbconn,dbSource,dbTarget):
        self.dbconn=dbconn
        self.dbSource = dbSource
        self.dbTarget = dbTarget

    def extraccion(self,db: Session):

        db.add(db_note)
        db.commit()
        db.refresh(db_note)
        return db_note
        pass



    def transform(self):
        '''
        :desc: la transformación se hace del lenguaje de origen a normalización requerida
        :return:
        '''
        data=[]
        return data


    def load(self,dataclean):
        cur = dbconn.cursor()
        arraySize = len(dataclean)
        for r in range(0, arraySize):
            try:
                # Merge the titles with a ,)
                #print(get_localzone())
                #print()
                uuidstr = uuid.uuid4()
                # Enforce UTF-8 for the connection.
                cur.execute('SET NAMES utf8mb4')
                cur.execute("SET CHARACTER SET utf8mb4")
                cur.execute("SET character_set_connection=utf8mb4")
                cur.execute(
                    """INSERT INTO tweets(id,fecha,url, lenguaje,`re-tweets`, `tweet ID`, contenido, usuario) VALUES( %s,%s,%s,%s,%s,%s,%s,%s)""",
                    (str(uuidstr), dataclean[r][0], dataclean[r][1], dataclean[r][2], dataclean[r][3], dataclean[r][4],
                     dataclean[r][5], dataclean[r][6]))
                dbconn.commit()
            except ValueError:
                print("Error")
                print(ValueError)
        pass

    if __name__ == '__main__':

        print('realizando extracción')
        extraccion()

        print('realizando transformación')
        dataclean=transform()
        dataclean.pop(0)
        an_array = numpy.array(dataclean)
        print(an_array)

        '''
            mostrar base de datos existentes 
        '''
        show_db_query = "use testdb"
        dbconn=connection()
        cur = dbconn.cursor()
        cur.execute(show_db_query)
        for x in cur:
            print(x)

        print('realizando carga de datos')
        load(dataclean)