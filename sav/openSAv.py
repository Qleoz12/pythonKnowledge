import pyreadstat
import multiprocessing as mp
import multiprocessing as mp
from time import time

import pandas as pd
import pyreadstat




if __name__ == '__main__':
    zxzxstr="D:/SisbenDiciembre2020.sav"
    reader = pyreadstat.read_file_in_chunks(pyreadstat.read_sav, zxzxstr, chunksize=10000)
    counter=1
    for df, meta in reader:
        print(df)  # df will contain 10K rows
        # do some cool calculations here for the chunk
        df.to_csv("SisbenDiciembre2020"+str(counter)+".csv",index=False)
        if(counter>10): break;
        counter+=1



