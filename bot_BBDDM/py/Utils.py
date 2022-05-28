def monthToNum(shortMonth :str):
    shortMonth=shortMonth.lower()
    print(shortMonth)
    dict={
        'ene': 1,
        'feb': 2,
        'mar': 3,
        'abr': 4,
        'may': 5,
        'jun': 6,
        'jul': 7,
        'ago': 8,
        'sep': 9,
        'oct': 10,
        'ocu': 10, # this fix month page error
        'nov': 11,
        'dic': 12
    }

    if shortMonth in dict:
        return dict[shortMonth]
    else:
        print(shortMonth)
        return "NONE"
    return



