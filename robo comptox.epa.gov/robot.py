# librerias e importes

import glob

from selenium import webdriver
import sys

from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver import ActionChains, Keys
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


locale.setlocale(locale.LC_ALL, ("es_ES", "UTF-8"))
directory="D:\\ETL\\"

def check_exists_by_xpath(element, xpath):
    try:
        element.find_element_by_xpath(xpath)
    except NoSuchElementException:
        return False
    return True

def check_exist_css_selector(element, string):
    try:
        element.find_element(By.CSS_SELECTOR, string)
    except NoSuchElementException:
        return False
    return True

if __name__ == '__main__':
    # Funciones BOT

    # driver.find_element_by_id("email").send_keys("laika.reporting@cos.com.co")
    # time.sleep(2)
    # driver.find_element_by_id("submitBtn").click()
    # time.sleep(2)
    driver_path = '.\\driver_selenium\\chromedriver.exe'
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
    driver = webdriver.Chrome(driver_path, chrome_options=options)
    # driver.get('https://comptox.epa.gov/dashboard/assay-endpoints/BSK_BE3C_IP10_down')
    # time.sleep(4)


    path = "*//*[@id=\"resultsGrid\"]/div/div[2]/div[2]/div[3]/div[2]/div/div/div"
    pathButton = ".//div[@class='ag-cell-wrapper']/span/div/a"
    button2path="//div[@class='row content-chemical mr-0'][2]/div/main[@class='template-container mt-0 content-chemical container-fluid']/div/div/div/div/div/div[@class='scalable card'][4]/div[@class='card-header']/a[@class='fix collapsed']/h5[@class='mb-0 mt-1']/span"
    driver.get("https://comptox.epa.gov/dashboard/assay-endpoints/BSK_BE3C_IP10_down")
    users = []
    mapa = []
    users = driver.find_elements_by_xpath(path)
    print(len(users))  # check it must be 12
    # find_elements_by_xpath("//p/span[@class='gray text-a4']").
    counter = 1
    main_window = driver.current_window_handle
    for user in users:
        # texto=user.text
        # print(user.get_attribute('innerHTML'))

        print(counter)

        button = user.find_element_by_xpath(pathButton)
        print(button.text)

        driver.find_element(By.LINK_TEXT, button.text).send_keys(Keys.CONTROL + Keys.RETURN)
        time.sleep(6)
        driver.find_element_by_tag_name('body').send_keys(Keys.CONTROL + Keys.TAB)
        driver.switch_to.window(driver.window_handles[counter])
        driver.find_element(By.CSS_SELECTOR, ".scalable:nth-child(4) span").click()
        element = driver.find_element(By.CSS_SELECTOR, ".row:nth-child(2) > .pt-2")
        print(element.text)
        driver.switch_to.window(driver.window_handles[0])

        if check_exist_css_selector(driver,'.loading-page'):
            element = driver.find_element(By.CSS_SELECTOR, '.loading-page')
            driver.execute_script("""
            var element = arguments[0];
            element.parentNode.removeChild(element);
            """, element)
        # do whatever you have to do on this page, we will just got to sleep for now
        time.sleep(2)
        counter += 1








        # button.click()
        #
        # detail=driver.find_element_by_xpath(button2path)
        # if check_exists_by_xpath(user, ".//span[@class='gray text-a4']"):
        #     span = user.find_element_by_xpath(".//span[@class='gray text-a4']")
        #     texto = user.find_element_by_xpath(".//span[@class='gray text-a4']").text
        #     mascada = texto.split()
        #     mes = mascada[len(mascada) - 2]
        #     mes = monthToNum(mes[:3])
        #     ano = mascada[len(mascada) - 1]
        #     print(ano + "-" + str(mes))
        #     mapa.append(ano + "-" + str(mes))
        # # driver.execute_script("arguments[0].click()", user)
        #
        # time.sleep(4)




    driver.close()
    driver.quit()
    sys.exit()