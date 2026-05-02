from selenium.common.exceptions import TimeoutException, WebDriverException

def is_broken_link(url, driver, timeout=10):
    """
    Check if a URL is a broken link by attempting to load it.
    
    Args:
        url: The URL to check
        driver: Selenium WebDriver instance
        timeout: Maximum time to wait for page load (seconds)
        
    Returns:
        bool: True if link is broken, False otherwise
    """
    original_window = driver.current_window_handle
    new_window = None
    
    try:
        # Open new tab
        driver.execute_script("window.open('');")
        new_window = driver.window_handles[-1]
        driver.switch_to.window(new_window)
        
        # Set page load timeout
        driver.set_page_load_timeout(timeout)
        driver.get(url)
        
        # Check for error indicators
        title = driver.title.lower()
        page_source = driver.page_source.lower()
        
        error_indicators = ['404', 'not found', 'error', 'page not found', 'forbidden']
        
        is_broken = (
            any(indicator in title for indicator in error_indicators) or
            any(indicator in page_source[:500] for indicator in error_indicators)  # Check first 500 chars
        )
        
        return is_broken
        
    except TimeoutException:
        # Timeout likely means broken/slow link
        return True
    except WebDriverException as e:
        # Log specific WebDriver issues instead of silently failing
        print(f"WebDriver error checking {url}: {e}")
        return True
    except Exception as e:
        # Unexpected errors should be visible
        print(f"Unexpected error checking {url}: {e}")
        return True
    finally:
        # Always cleanup, even if errors occur
        if new_window and new_window in driver.window_handles:
            driver.switch_to.window(new_window)
            driver.close()
        driver.switch_to.window(original_window)