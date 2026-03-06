*** Settings ***
Library    String
Library    SeleniumLibrary
Library    Collections

*** Test Cases ***
Get All Links From Webpage
    Open Browser  https://megamitensei.fandom.com/wiki/List_of_Persona_5_Royal_Personas  Chrome
    ${elements}=    Get WebElements    xpath=//a[@href]
    ${links}=    Create List
    FOR    ${element}    IN    @{elements}
        ${href}=    Get Element Attribute    ${element}    href
        Append To List    ${links}    ${href}
    END
    Log    ${links}
    Log    Total links: ${links.__len__()}
    Close Browser