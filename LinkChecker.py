from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

def is_broken_link(url, driver):
    try:
        original_window = driver.current_window_handle
        driver.execute_script("window.open('');")
        driver.switch_to.window(driver.window_handles[-1])
        driver.get(url)
        
        # 404/error pages don't have a standard signal, so check title
        title = driver.title.lower()
        is_broken = any(word in title for word in ['404', 'not found', 'error', 'page not found'])
        
        driver.close()
        driver.switch_to.window(original_window)
        return is_broken
    except Exception:
        return True