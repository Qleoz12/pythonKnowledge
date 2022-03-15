import datetime
import uuid

from sqlalchemy import Column, String, Date, Integer, BigInteger, ForeignKey
from pydantic import BaseModel
from sqlalchemy.orm import relation

from ETLTODW.databaseResouce import BaseResource

class clientesBase(BaseModel):
    title: str
    text: str


class clientesCreate(clientesBase):
    pass

class clientes(clientesBase):
    id = str
    nombres = str
    apellidos = str
    nacimiento = datetime.date
    documento = str
    lugarNacimiento = str
    codigoPostal = str
    telefono = str

    class Config:
        orm_mode = True


class paisesDB(BaseResource):
    __tablename__ = "paises"
    id     = Column(String, primary_key=True, index=True,default=uuid.uuid4())
    nombre = Column(String, nullable=True)
    iso2   = Column(String, nullable=True)
    iso3   = Column(String, nullable=True)
    phoneCode= Column(String, nullable=True)

class provinciasDB(BaseResource):
    __tablename__ = "provincias"
    id = Column(String, primary_key=True, index=True,default=uuid.uuid4())
    nombre = Column(String, nullable=True)
    paisID = Column(String, ForeignKey("paises.id"))
    paisesDB = relation(paisesDB, backref='paises')

class ciudadesDB(BaseResource):
    __tablename__ = "ciudades"
    id = Column(String, primary_key=True, index=True,default=uuid.uuid4(),)
    nombre = Column(String, nullable=True)
    provinciaID = Column(String, ForeignKey("provincias.id"))
    provinciasDB = relation(provinciasDB, backref='provincias')
    codigoEstatal = Column(String, nullable=True)



class clientesDB(BaseResource):
    __tablename__ = "clientes"
    id = Column(String, primary_key=True, index=True,default=uuid.uuid4())
    nombres =Column(String, nullable=True, default="new")
    apellidos =Column(String, nullable=True, default="new")
    nacimiento =Column(Date, nullable=True, default="new")
    documento =Column(String, nullable=True, default="new")
    lugarNacimiento =Column(String, ForeignKey("ciudades.id"))
    ciudadesDB = relation(ciudadesDB, backref='ciudades')
    codigoPostal =Column(String, nullable=True, default="new")
    telefono =Column(String, nullable=True, default="new")

class ventasDB(BaseResource):
    __tablename__ = "ventas"
    id = Column(String, primary_key=True, index=True,default=uuid.uuid4())
    descripcion =Column(String, nullable=True, default="new")
    clienteID =Column(String, nullable=False)
    vehiculoID =Column(String, nullable=False)
    EmpleadoID =Column(String, nullable=True, default="new")
    fecha =Column(Date, nullable=True, default="new")
    sucursalID =Column(String, nullable=True, default="new")
    cantidad =Column(Integer, nullable=True, default="new")
    referencia = Column(String, nullable=True, default="new")
    descuentos = Column(String, nullable=True, default="new")
    totalFactura = Column(BigInteger, nullable=True, default="new")




