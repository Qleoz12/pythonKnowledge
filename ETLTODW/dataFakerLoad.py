def loadFakeData():
    cur.execute("INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY) VALUES (%s, %s, %s, %s, %s)",
                (Id, name, age, adress, salary));
