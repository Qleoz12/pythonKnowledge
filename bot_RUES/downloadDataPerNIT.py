# librerias e importes
import sys

from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import time
import locale
import os
import pandas as pd
from bot_BBDDM.py.Utils import monthToNum

locale.setlocale(locale.LC_ALL, ("es_ES", "UTF-8"))
directory = "D:\\ETL\\"
# time.sleep(10)

# Opciones de navegación
options = webdriver.ChromeOptions()
prefs = {
    'download.default_directory': directory,
    'profile.default_content_setting_values.automatic_downloads': 1
}

options.add_experimental_option('prefs', prefs)
options.add_argument("--start-maximized")
options.add_argument("--disable-blink-features")
options.add_argument("--disable-blink-features=AutomationControlled")
options.add_argument('ignore-certificate-errors')
options.add_experimental_option("prefs", prefs)

# Dirección de driver selenium


try:
    os.makedirs(directory, mode=0o666, exist_ok=True)
except OSError as e:
    sys.exit("Can't create {dir}: {err}".format(dir=directory, err=e))

driver_path = '.\\driver_selenium\\105_chromedriver.exe'

driver = webdriver.Chrome()

# Esconder ventana del navegador
# driver.set_window_position(-10000,0)

# Iniciar en pantalla
driver.maximize_window
time.sleep(1)

# URL destino
driver.get('https://www.rues.org.co/')
time.sleep(4)


def getDownLoadedFileName(waitTime):
    driver.execute_script("window.open()")
    # switch to new tab
    driver.switch_to.window(driver.window_handles[-1])
    # navigate to chrome downloads
    driver.get('chrome://downloads')
    # define the endTime
    endTime = time.time() + waitTime
    while True:
        try:
            # get downloaded percentage
            downloadPercentage = driver.execute_script(
                "return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('#progress').value")
            # check if downloadPercentage is 100 (otherwise the script will keep waiting)
            if downloadPercentage == 100:
                # return the file name once the download is completed
                return driver.execute_script(
                    "return document.querySelector('downloads-manager').shadowRoot.querySelector('#downloadsList downloads-item').shadowRoot.querySelector('div#content  #file-link').text")
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
    time.sleep(2)
    try:

        df = pd.read_csv('NIT.csv', encoding="cp1252", engine='python')
        counter = 0
        # Initialize an empty DataFrame
        df2 = pd.DataFrame(columns=['Column1', 'Column2'])
        for index, value in df.iloc[:, 0].items():
            # print(value)
            input=WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//input[@id='txtNIT']")))
            input.clear()
            WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//input[@id='txtNIT']"))).send_keys(str(value).strip().split("-")[0])
            WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.XPATH, "//button[@id='btnConsultaNIT']"))).click()
            time.sleep(4)
            data=WebDriverWait(driver, 10).until(
                EC.presence_of_all_elements_located((By.XPATH, "//table[@id='rmTable2']/tbody/tr/td[6]")))
            statusvalues=[v.text for v in data]
            counter += 1
            # print(statusvalues)
            df2 = df2._append({'Column1': value, 'Column2': statusvalues.__str__()}, ignore_index=True)

        df2.to_csv("recopiled.csv")
        # Cerrar navegador
    except Exception as  e:
        print(e)

    driver.close()
    # Finalizar proceso Selenium
    driver.quit()
    sys.exit()
