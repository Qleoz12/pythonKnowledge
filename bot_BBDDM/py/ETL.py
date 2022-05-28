import uuid

import pandas as pd
import openpyxl as xl
import csv

from bot_BBDDM.py.Models import dim_persona, dim_localidad, dim_red, dim_incidente, fact_llamadas
from bot_BBDDM.py.database import getConnection, SessionLocal
from sqlalchemy.orm import Session

from bot_BBDDM.py.utils_xls_csv import get_db


class ETL():

    def load(self):
        sesion = next(get_db())
        with open('D:\ETL\llamadas-123-mes-de-mayo-2020.csv', 'r') as file:
            reader = csv.DictReader(file, delimiter=',')
            for row in reader:
                dim_persona_e = dim_persona(
                    id=uuid.uuid4(),
                    genero=row['GENERO'],
                    edad=row['EDAD']
                )
                sesion.add(dim_persona_e)
                sesion.commit()

                dim_localidad_e = dim_localidad(
                    id=uuid.uuid4(),
                    codigo=row['CODIGO DE LOCALIDAD'],
                    localidad=row['LOCALIDAD']
                )

                exists = sesion.query(dim_localidad).filter_by(codigo=dim_localidad_e.codigo,
                                                               localidad=dim_localidad_e.localidad).first() is not None
                if not exists:
                    sesion.add(dim_localidad_e)
                    sesion.commit()

                dim_red_e = dim_red(
                    id=uuid.uuid4(),
                    red=row['RED']
                )

                exists = sesion.query(dim_red).filter_by(red=dim_red_e.red).first() is not None
                if not exists:
                    sesion.add(dim_red_e)
                    sesion.commit()

                dim_incidente_e = dim_incidente(
                    id=uuid.uuid4(),
                    incidente=row['TIPO_INCIDENTE'],
                    prioridad=row['PRIORIDAD']
                )

                exists = sesion.query(dim_incidente).filter_by(incidente=dim_incidente_e.incidente,
                                                               prioridad=dim_incidente_e.prioridad).first() is not None
                if not exists:
                    sesion.add(dim_incidente_e)
                    sesion.commit()

                dim_incidente_c_id = sesion.query(dim_incidente.id).filter(
                    dim_incidente.incidente == row['TIPO_INCIDENTE']).first()
                dim_red_c_id = sesion.query(dim_red.id).filter(dim_red.red == row['RED']).first()
                dim_localidad_c_id = sesion.query(dim_localidad.id).filter_by(codigo=dim_localidad_e.codigo,
                                                                              localidad=dim_localidad_e.localidad).first()

                fact_llamadas_e = fact_llamadas(
                    id=uuid.uuid4(),
                    codigo=row['NUMERO_INCIDENTE'],
                    desplazamiento=row['FECHA_INICIO_DESPLAZAMIENTO-MOVIL'],
                    localidad_id=dim_localidad_c_id.id,
                    incidente_id=dim_incidente_c_id.id,
                    persona_id=dim_persona_e.id,
                    red_id=dim_red_c_id.id
                )

                sesion.add(fact_llamadas_e)
                sesion.commit()

