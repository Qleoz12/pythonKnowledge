# Script Author: Martin Beck
# Medium Article Follow-Along: https://medium.com/better-programming/how-to-scrape-tweets-with-snscrape-90124ed006af

# Pip install the command below if you don't have the development version of snscrape
# !pip install git+https://github.com/JustAnotherArchivist/snscrape.git

# Run the below command if you don't already have Pandas
# !pip install pandas

#pip install mysql-connector-python


#Schema
# CREATE TABLE `tweets` (
#   `id` varchar(64) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `fecha` datetime DEFAULT NULL,
#   `url` varchar(500) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `lenguaje` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `re-tweets` varchar(100) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `tweet ID` varchar(256) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `contenido` varchar(1024) COLLATE utf8_spanish_ci DEFAULT NULL,
#   `usuario` varchar(256) COLLATE utf8_spanish_ci DEFAULT NULL
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_spanish_ci

#ALTER TABLE testdb.tweets ADD usuario varchar(256) NULL;
# Imports
import csv
import datetime
import sys
import uuid

import MySQLdb
import iso8601 as iso8601
import numpy
import snscrape.modules.twitter as sntwitter
import pandas as pd


# Below are two ways of scraping using the Python Wrapper.
# Comment or uncomment as you need. If you currently run the script as is it will scrape both queries
# then output two different csv files.
import translators as ts
from tzlocal import get_localzone

from mysql import connector


def connection():

    config = {
        "user": "root",
        "password": "root",
        "host": "localhost",
        "port": 3306,
        "charset" : 'utf8',
        "use_unicode" : True
    }
    try:
        c = connector.connect(**config)
        return c
    except:
        print("connection error")
        exit(1)

def extraccion():
    # Query by text search
    # Setting variables to be used below
    maxTweets = 100
    # Creating list to append tweet data to
    tweets_list2 = []
    # Using TwitterSearchScraper to scrape data and append tweets to list
    for i,tweet in enumerate(sntwitter.TwitterSearchScraper('etl since:2020-08-01 until:2021-09-11').get_items()):
        if i>maxTweets:
            break
        tweets_list2.append([tweet.date,tweet.url,tweet.lang,tweet.retweetCount, tweet.id, tweet.content, tweet.user.username])

    # Creating a dataframe from the tweets list above
    tweets_df2 = pd.DataFrame(tweets_list2, columns=['Datetime', 'url of tweet','lenguaje','re-twittes','Tweet Id', 'Text', 'Username'])

    # Display first 5 entries from dataframe
    tweets_df2.head()

    # Export dataframe into a CSV
    tweets_df2.to_csv('text-query-tweets.csv', sep=',', index=False)


def transform():
    '''
    :desc: la transformación se hace del lenguaje de origen a normalización requerida
    :return:
    '''
    data=[]
    with open('text-query-tweets.csv',encoding="utf8") as csvfile:
        spamreader = csv.reader(csvfile, delimiter=',')

        for row in spamreader:
            if (spamreader.line_num > 1):
                row[0] = datetime.datetime.fromisoformat(row[0])
                row[5] = row[5].format("utf-8")
                if(row[2]!='es' ):
                    translation=ts.google(row[5],to_language="es")
                    row[5]=translation
                    row[5] = row[5].encode('ascii', errors='ignore')
                data.append(row)

    return data


def load(dataclean):
    cur = dbconn.cursor()
    arraySize = len(dataclean)
    for r in range(0, arraySize):
        try:
            # Merge the titles with a ,)
            print(get_localzone())
            print()
            uuidstr = uuid.uuid4()
            # Enforce UTF-8 for the connection.
            cur.execute('SET NAMES utf8mb4')
            cur.execute("SET CHARACTER SET utf8mb4")
            cur.execute("SET character_set_connection=utf8mb4")
            cur.execute(
                """INSERT INTO tweets(id,fecha,url, lenguaje,`re-tweets`, `tweet ID`, contenido, usuario) VALUES( %s,%s,%s,%s,%s,%s,%s,%s)""",
                (str(uuidstr), dataclean[r][0], dataclean[r][1], dataclean[r][2], dataclean[r][3], dataclean[r][4],
                 dataclean[r][5], dataclean[r][6]))
            dbconn.commit()
        except ValueError:
            print("Error")
            print(ValueError)
    pass

# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    print('realizando extracción')
    extraccion()

    print('realizando transformación')
    dataclean=transform()
    dataclean.pop(0)
    an_array = numpy.array(dataclean)
    print(an_array)

    '''
        mostrar base de datos existentes 
    '''
    show_db_query = "use testdb"
    dbconn=connection()
    cur = dbconn.cursor()
    cur.execute(show_db_query)
    for x in cur:
        print(x)

    print('realizando carga dedatos')
    load(dataclean)

