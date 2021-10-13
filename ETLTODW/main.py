import uuid
import pandas as pd

import dao
from mimesis import Person, Datetime
from mimesis import Address
from mimesis.enums import Gender


from ETLTODW.models.cliente import cliente
from ETLTODW.models.tiempo import tiempo

person = Person('ES')
addess = Address()
datetime = Datetime()
def create_rows_mimesis(num=1,province=None,city=None,country=None):
    output = [cliente(uuid.uuid4(), person.name(), addess.address(), province or addess.province(),city or addess.city(),country or addess.country(), addess.postal_code(), person.telephone()) for x in range(num)]
    return output

def create_rows_mimesis2(num=1,day=None,month=None,ano=None):
    output = [tiempo(uuid.uuid4(),
                     day or datetime.datetime().day,
                     month or datetime.datetime().month,
                     ano or datetime.datetime().year,
                     city or datetime.datetime().weekday(),
                     country or datetime.datetime().isocalendar(),
                     or False,
                     or False,
                    datetime.datetime().)
            for x in range(num)]
    return output

if __name__ == '__main__':
    DATA=create_rows_mimesis(10)
    DATA2 = create_rows_mimesis(20,"California","Los Ángeles","United States")
    DATA3 = create_rows_mimesis(50, "Nueva York", "Nueva York", "United States")
    DATA4 = create_rows_mimesis(10, "Chicago", "Illinois", "United States")

    DATA5 = create_rows_mimesis(10, "Chicago", "Illinois", "United States")

    dao.insertFakedata(DATA,"resourcesDW","cliente", "job_run_id")
    dao.insertFakedata(DATA2,"resourcesDW", "cliente", "job_run_id")
    dao.insertFakedata(DATA3,"resourcesDW", "cliente", "job_run_id")
    dao.insertFakedata(DATA4,"resourcesDW", "cliente", "job_run_id")

    dao.insertFakedata(DATA5, "resourcesDW", "tiempo", "job_run_id")
