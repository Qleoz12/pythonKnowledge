import datetime
import uuid

import dao
from mimesis import Person, Datetime
from mimesis import Address

from ETLTODW import dataFakerLoad
from ETLTODW.ETL import ETL

from ETLTODW.models.OLAP.cliente import cliente
from ETLTODW.models.OLAP.tiempo import tiempo

person = Person('ES')
addess = Address()
datetimemimesis = Datetime()



if __name__ == '__main__':
    # DATA=create_rows_mimesis(10)
    # DATA2 = create_rows_mimesis(20,"California","Los Ángeles","United States")
    # DATA3 = create_rows_mimesis(50, "Nueva York", "Nueva York", "United States")
    # DATA4 = create_rows_mimesis(10, "Chicago", "Illinois", "United States")
    #
    # DATA5 = create_rows_mimesis2(30)
    # DATA6 = create_rows_mimesis2(10,1,1,2021)
    # DATA7 = create_rows_mimesis2(20,1,6,2021,None,None,True)
    #
    # dao.insertFakedata(DATA,"resourcesDW","cliente", "job_run_id")
    # dao.insertFakedata(DATA2,"resourcesDW", "cliente", "job_run_id")
    # dao.insertFakedata(DATA3,"resourcesDW", "cliente", "job_run_id")
    # dao.insertFakedata(DATA4,"resourcesDW", "cliente", "job_run_id")
    #
    # dao.insertFakedata(DATA5, "resourcesDW", "tiempo", "job_run_id")
    # dao.insertFakedata(DATA6, "resourcesDW", "tiempo", "job_run_id")
    # dao.insertFakedata(DATA7, "resourcesDW", "tiempo", "job_run_id")

    # dataFakerLoad.loaddatafake()
    myetl=ETL(db=next(dao.get_db()))
    datatotrasnform=myetl.processDBsResource()
    datatrasnformed=myetl.transform(datatotrasnform)

    myetl.load(datatrasnformed)
    # dataFakerLoad.removedatafake()

