*** Settings ***
Documentation     Resource file containing reusable keywords and variables.
Library           SeleniumLibrary

*** Variables ***
${BROWSER}        chrome
${DELAY}          0.3s

*** Keywords ***
Open Application With Browser
    [Arguments]    ${url}    ${browser}=${BROWSER}
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}

Close Application
    Close Browser
