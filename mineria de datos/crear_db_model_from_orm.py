from dataclasses import dataclass, field
from typing import List

from sqlalchemy import MetaData,Table,Column,Integer,ForeignKey,String

from DBmanager import getConnection
from sqlalchemy.orm import registry

mapper_registry = registry()

@dataclass
class Profesor:
    id: int = field(init=False)
    name: str = None
    fullname: str = None
    nickname: str = None









def crearMoldeloRelacional():
    metadata_obj = MetaData()
    profesores = Table('profesores', metadata_obj,
                       Column('id', Integer, primary_key=True),
                       Column('name', String(50), nullable=False),
                       Column('nickname', String(50), nullable=True)
                       )
    mapper_registry.map_imperatively(Profesor, profesores, properties={})
    engine = getConnection()
    metadata_obj.create_all(engine)
