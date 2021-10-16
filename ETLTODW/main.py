import datetime
import uuid

import dao
from mimesis import Person, Datetime
from mimesis import Address

from ETLTODW.models.OLAP.cliente import cliente
from ETLTODW.models.OLAP.tiempo import tiempo

person = Person('ES')
addess = Address()
datetimemimesis = Datetime()
def create_rows_mimesis(num=1,province=None,city=None,country=None):
    output = [cliente(uuid.uuid4(), person.name(), addess.address(), province or addess.province(),city or addess.city(),country or addess.country(), addess.postal_code(), person.telephone()) for x in range(num)]
    return output

def create_rows_mimesis2(num=1,day=None,month=None,ano=None,weekday=None,diadelano=None,holyday=None,weekend=None,weekeYear=None):
    output = []

    for x in range(num):
        if ano and month and day:
            datetime_obj = datetime.datetime(year=ano, month=month, day=day)
        else:
            datetime_obj = datetimemimesis.datetime()
        pivot=tiempo(uuid.uuid4(),
                     day or datetime_obj.day,
                     month or datetime_obj.month,
                     ano or datetime_obj.year,
                     weekday or datetime_obj.weekday(),
                     diadelano or datetime_obj.strftime('%j'),
                     holyday or False,
                     weekend or datetime_obj.weekday() in [5,6] or False,
                     weekeYear or datetime_obj.isocalendar().week)
        output.append(pivot)
    return output

if __name__ == '__main__':
    DATA=create_rows_mimesis(10)
    DATA2 = create_rows_mimesis(20,"California","Los Ángeles","United States")
    DATA3 = create_rows_mimesis(50, "Nueva York", "Nueva York", "United States")
    DATA4 = create_rows_mimesis(10, "Chicago", "Illinois", "United States")

    DATA5 = create_rows_mimesis2(30)
    DATA6 = create_rows_mimesis2(10,1,1,2021)
    DATA7 = create_rows_mimesis2(20,1,6,2021,None,None,True)

    dao.insertFakedata(DATA,"resourcesDW","cliente", "job_run_id")
    dao.insertFakedata(DATA2,"resourcesDW", "cliente", "job_run_id")
    dao.insertFakedata(DATA3,"resourcesDW", "cliente", "job_run_id")
    dao.insertFakedata(DATA4,"resourcesDW", "cliente", "job_run_id")

    dao.insertFakedata(DATA5, "resourcesDW", "tiempo", "job_run_id")
    dao.insertFakedata(DATA6, "resourcesDW", "tiempo", "job_run_id")
    dao.insertFakedata(DATA7, "resourcesDW", "tiempo", "job_run_id")
