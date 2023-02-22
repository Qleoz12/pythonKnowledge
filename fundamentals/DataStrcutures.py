
thisset = {"apple", "banana", "cherry"}
print(thisset)

thisset.add("apple")
print(thisset)

mydict=dict()

mydict["key"]=thisset
mydict["key2"]=[1,2,3,4,5,6,7,8,9]


mydict.get("key2").append(10)

for k,v in mydict.items():
    print(k,v)


z = complex(2, -3)
print(z)

z = complex(1)
print(z)

z = complex()
print(z)

z = complex('5-9j')
print(z)