*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    LinkChecker.py

*** Variables ***
${URL}    ${EMPTY}

*** Test Cases ***
Get All Links From Webpage
    Check Links On Page    ${URL}

*** Keywords ***
Check Links On Page
    [Arguments]    ${url}
    ${is_valid}=    Evaluate    isinstance($url, str) and $url.startswith('http')
    IF    not ${is_valid}
        Log    "${url}" is not a valid URL. Please provide a URL starting with http:// or https://    console=True
        RETURN
    END

    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    #Call Method    ${options}    add_argument    --headless
    #Call Method    ${options}    add_argument    --disable-gpu
    Open Browser    ${url}    Chrome    options=${options}
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

    Log    Total links checked: ${links.__len__()}    console=True
    Log    Broken links: ${broken_links}    console=True
    Log    Total broken links: ${broken_links.__len__()}    console=True