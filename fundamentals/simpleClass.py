class Person:

    def __init__(self,name,age):
        self.name= name
        self.age = age




if __name__ == '__main__':

    Lorenzo = Person("lorenzo",15)


    print(Lorenzo.name)
    print(Lorenzo.age)

    print(Lorenzo.__str__())