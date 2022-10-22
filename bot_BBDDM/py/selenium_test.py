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


driver_path = '..\\driver_selenium\\105_chromedriver.exe'

driver = webdriver.Chrome(driver_path, chrome_options=options)

#Esconder ventana del navegador
# driver.set_window_position(-10000,0)

#Iniciar en pantalla

driver.maximize_window
time.sleep(1)

#URL destino

driver.get('https://app.powerbi.com/view?r=eyJrIjoiOTk3NDZhYTMtZjg5NC00OWIxLWE3NmItOTIzYjdlZmFmNmJhIiwidCI6IjU2MmQ1YjJlLTBmMzEtNDdmOC1iZTk4LThmMjI4Nzc4MDBhOCJ9&pageName=ReportSection')
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


        # path = "//*[@id='formulaBarTextDivId_textElement']"
        # html_source = driver.page_source
        # print(html_source)
        # selector="#pvExplorationHost > div > div > exploration > div > explore-canvas > div > div.canvasFlexBox > div > div.displayArea.disableAnimations.actualSizeAlignCenter.actualSizeAlignMiddle.actualSizeCentered > div.visualContainerHost.visualContainerOutOfFocus > visual-container-repeat > visual-container:nth-child(7) > transform > div > div.visualContent > div > visual-modern > div > div > div.tableEx.showFocus > div.innerContainer > div.bodyCells > div > div:nth-child(1) > div:nth-child(1)\")"
        # something=driver.find_element(By.cssSelector(selector))
        users = driver.find_elements_by_xpath("//div[@class='innerContainer']/div[@class='bodyCells']/div/div")
        # print(len(users))  # check it must be 12
        # find_elements_by_xpath("//p/span[@class='gray text-a4']").
        counter = 1
        # users.click()


        # Cerrar navegador
    except Exception as  e:
       print(e)

    driver.close()
    # Finalizar proceso Selenium
    driver.quit()
    sys.exit()

