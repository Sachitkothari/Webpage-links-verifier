*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    LinkChecker.py

*** Test Cases ***
Get All Links From Webpage
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --disable-gpu
    Open Browser    file:///C:/Users/sachi/OneDrive/Documents/Projects/Web Link Checker/test.html   Chrome    options=${options}
    #Open Browser    file:///C:/Users/sachi/OneDrive/Documents/Projects/Web Link Checker/test.html    Chrome
    ${elements}=    Get WebElements    xpath=//a[@href]
    ${links}=    Create List
    FOR    ${element}    IN    @{elements}
        ${href}=    Get Element Attribute    ${element}    href
        IF    '${href}'.startswith('http')
            Append To List    ${links}    ${href}
        END
    END

    ${links}=    Remove Duplicates    ${links}
    ${broken_links}=    Create List
    ${seleniumlib}=    Get Library Instance    SeleniumLibrary
    ${driver}=    Set Variable    ${seleniumlib.driver}
    FOR    ${link}    IN    @{links}
        ${is_broken}=    Is Broken Link    ${link}    ${driver}
        IF    ${is_broken}
            Append To List    ${broken_links}    ${link}
        END
    END
    Close Browser

    Log    Total links checked: ${links.__len__()}
    Log    Broken links: ${broken_links}
    Log    Total broken links: ${broken_links.__len__()}