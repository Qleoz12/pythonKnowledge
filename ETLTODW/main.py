import uuid
import pandas as pd

import dao
from mimesis import Person, Datetime
from mimesis import Address
from mimesis.enums import Gender


from ETLTODW.models.cliente import cliente
person = Person('en')
addess = Address()
datetime = Datetime()
def create_rows_mimesis(num=1):
    output = [cliente(uuid.uuid4(), person.name(), addess.address(), addess.province(), addess.city(), addess.country(), addess.postal_code(), person.telephone()) for x in range(num)]
    return output

if __name__ == '__main__':
    DATA=create_rows_mimesis(10)

    dao.insertFakedata(DATA,"cliente", "job_run_id")
