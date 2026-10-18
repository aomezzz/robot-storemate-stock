*** Settings ***
Documentation       Common keywords and configuration for StoreMate Robot Framework test suite.
Library             SeleniumLibrary
Library             OperatingSystem
Library             String

*** Variables ***
${BASE_URL}             https://storemate-final.vercel.app
${VALID_EMAIL}          aomezzz.aomsin@gmail.com
${VALID_PASSWORD}       Aomezzz_007
${BROWSER}              chrome
${HEADLESS}             ${FALSE}
${DEFAULT_TIMEOUT}      15s

*** Keywords ***
Open Test Browser
    [Documentation]    Opens browser configured with standard viewport and options.
    [Arguments]    ${url}=${BASE_URL}    ${headless_mode}=${HEADLESS}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    --disable-gpu
    Call Method    ${options}    add_argument    --window-size\=1920,1080
    IF    ${headless_mode}
        Call Method    ${options}    add_argument    --headless\=new
    END
    Open Browser    ${url}    ${BROWSER}    options=${options}
    Set Selenium Timeout    ${DEFAULT_TIMEOUT}
    Set Window Size    1920    1080

Close Test Browser
    [Documentation]    Closes the currently active browser session.
    Close All Browsers

Take Test Screenshot
    [Documentation]    Captures a screenshot to the screenshots folder.
    [Arguments]    ${filename}
    Capture Page Screenshot    ${EXECDIR}/results/screenshots/${filename}
