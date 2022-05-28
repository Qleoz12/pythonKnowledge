# librerias e importes

import glob

import pyautogui as pyautogui
from selenium import webdriver
import sys

from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time
import pandas as pd
from datetime import date
from datetime import datetime
from datetime import timedelta
import locale
import os

from bot_BBDDM.py.Utils import monthToNum

locale.setlocale(locale.LC_ALL, ("es_ES", "UTF-8"))


directory="D:\\ETL\\"

# time.sleep(10)

# Opciones de navegación

options = webdriver.ChromeOptions()
prefs = {
    'download.default_directory' : directory,
    'profile.default_content_setting_values.automatic_downloads': 1
}

options.add_experimental_option('prefs', prefs)
options.add_argument("--start-maximized")
options.add_argument("--disable-blink-features")
options.add_argument("--disable-blink-features=AutomationControlled")
options.add_argument('ignore-certificate-errors')
options.add_experimental_option("prefs", prefs)

#Dirección de driver selenium


try:
    os.makedirs(directory, mode=0o666, exist_ok=True)
except OSError as e:
    sys.exit("Can't create {dir}: {err}".format(dir=directory, err=e))


driver_path = '..\\driver_selenium\\chromedriver.exe'

driver = webdriver.Chrome(driver_path, chrome_options=options)

#Esconder ventana del navegador
# driver.set_window_position(-10000,0)

#Iniciar en pantalla

driver.maximize_window
time.sleep(1)

#URL destino

driver.get('https://datosabiertos.bogota.gov.co/dataset/llamadas-de-urgencias-y-emergencias-que-ingresan-a-traves-de-la-linea-123')
time.sleep(4)



def getDownLoadedFileName(waitTime):
    driver.execute_script("window.open()")
    # switch to new tab
    driver.switch_to.window(driver.window_handles[-1])
    # navigate to chrome downloads
    driver.get('chrome://downloads')
    # define the endTime
    endTime = time.time()+waitTime
    while True:
        try:
            # get downloaded percentage
            downloadPercentage = driver.execute_script(
                "return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('#progress').value")
            # check if downloadPercentage is 100 (otherwise the script will keep waiting)
            if downloadPercentage == 100:
                # return the file name once the download is completed
                return driver.execute_script("return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('div#content  #file-link').text")
        except:
            pass
        time.sleep(1)
        if time.time() > endTime:
            break

def check_exists_by_xpath(element, xpath):
    try:
        element.find_element_by_xpath(xpath)
    except NoSuchElementException:
        return False
    return True

if __name__ == '__main__':
    # Funciones BOT

    # driver.find_element_by_id("email").send_keys("laika.reporting@cos.com.co")
    # time.sleep(2)
    # driver.find_element_by_id("submitBtn").click()
    # time.sleep(2)
    try:
        path = "*//div[@class='container']/div[@class='row dataset-item-file']"
        pathButton = ".//div/div/a[@class='btn btn-default background-blue block-right-width resource-url-analytics']"
        users = []
        mapa = []
        users = driver.find_elements_by_xpath(path)
        print(len(users))  # check it must be 12
        # find_elements_by_xpath("//p/span[@class='gray text-a4']").
        counter = 1
        for user in users:
            # texto=user.text
            # print(user.get_attribute('innerHTML'))
            print(counter)
            counter += 1


            if check_exists_by_xpath(user,".//span[@class='gray text-a4']"):
                span = user.find_element_by_xpath(".//span[@class='gray text-a4']")
                texto = user.find_element_by_xpath(".//span[@class='gray text-a4']").text
                mascada=texto.split()
                mes=mascada[len(mascada)-2]
                mes=monthToNum(mes[:3])
                ano = mascada[len(mascada)-1]
                print(ano+"-"+str(mes))
                mapa.append(ano+"-"+str(mes))
            if mes!='NONE':
                button = user.find_element_by_xpath(pathButton)
                button.click()
            # driver.execute_script("arguments[0].click()", user)

            time.sleep(4)


        # TODO determinar save para clasificar archivos
        # disañar modelo relacional
        # pruebas

        print(mapa)

        # Cerrar navegador
    except Exception as  e:
       print(e)

    driver.close()
    # Finalizar proceso Selenium
    driver.quit()
    sys.exit()

    #load
    ETL().load()