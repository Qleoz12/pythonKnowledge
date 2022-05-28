import datetime
import uuid

from sqlalchemy import Column, String, Date, Integer, BigInteger, ForeignKey
from pydantic import BaseModel
from sqlalchemy.orm import relation

from database import Base

class dim_persona(Base):
    __tablename__ = "dim_persona"
    id      =Column(String, primary_key=True, index=True,default=uuid.uuid4())
    edad    =Column(String, nullable=True, default="new")
    genero  =Column(String, nullable=True, default="new")

class dim_localidad(Base):
    __tablename__ = "dim_localidad"
    id      =Column(String, primary_key=True, index=True,default=uuid.uuid4())
    codigo    =Column(Integer, nullable=True, default="new")
    localidad  =Column(String, nullable=True, default="new")

class dim_red(Base):
    __tablename__ = "dim_red"
    id      =Column(String, primary_key=True, index=True,default=uuid.uuid4())
    red    =Column(String, nullable=True, default="new")

class dim_incidente(Base):
    __tablename__ = "dim_incidente"
    id      =Column(String, primary_key=True, index=True,default=uuid.uuid4())
    incidente    =Column(String, nullable=True, default="new")
    prioridad    =Column(String, nullable=True, default="new")

class fact_llamadas(Base):
    __tablename__ = "fact_llamadas"
    id              =Column(String, primary_key=True, index=True,default=uuid.uuid4())
    codigo              = Column(String,  nullable=True, default="new")
    desplazamiento  =Column(String, nullable=True, default="new")
    recepcion       =Column(String, nullable=True, default="new")
    localidad_id    = Column(String, nullable=True, default="new")
    red_id          = Column(String, nullable=True, default="new")
    incidente_id    = Column(String, nullable=True, default="new")
    persona_id      = Column(String, nullable=True, default="new")










