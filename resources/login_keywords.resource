*** Settings ***
Documentation       Page Object Keywords and locators for Login Page and Authentication
Resource            common.resource

*** Variables ***
${LOGIN_PATH}               /login
${EMAIL_INPUT}              css:input[type='email'], #email, input[name='email']
${PASSWORD_INPUT}           css:input[type='password'], #password, input[name='password']
${LOGIN_BUTTON}             xpath://button[@data-test='btn-submit']
${DASHBOARD_HEADING}        xpath://h1[contains(., 'แดชบอร์ด')] | //*[contains(text(), 'แดชบอร์ด')]

*** Keywords ***
Navigate To Login Page
    [Documentation]    Navigates to the StoreMate login page.
    Go To    ${BASE_URL}${LOGIN_PATH}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    timeout=15s

Input Email Address
    [Documentation]    Inputs email into the email field.
    [Arguments]    ${email}
    Wait Until Element Is Visible    ${EMAIL_INPUT}    timeout=10s
    Clear Element Text    ${EMAIL_INPUT}
    Input Text    ${EMAIL_INPUT}    ${email}

Input Password Text
    [Documentation]    Inputs password into the password field.
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${PASSWORD_INPUT}    timeout=10s
    Clear Element Text    ${PASSWORD_INPUT}
    Input Password    ${PASSWORD_INPUT}    ${password}

Click Login Button
    [Documentation]    Clicks the submit button on the login form.
    Wait Until Element Is Visible    ${LOGIN_BUTTON}    timeout=10s
    Click Element    ${LOGIN_BUTTON}

Login To StoreMate
    [Documentation]    Performs complete login flow with given credentials.
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Navigate To Login Page
    Input Email Address    ${email}
    Input Password Text    ${password}
    Click Login Button

Verify Dashboard Loaded
    [Documentation]    Verifies that the user has navigated to Dashboard and dashboard elements are displayed.
    [Arguments]    ${expected_email}=${EMPTY}
    Wait Until Location Contains    /dashboard    timeout=20s
    Wait Until Element Is Visible    ${DASHBOARD_HEADING}    timeout=15s
    IF    '${expected_email}' != '${EMPTY}'
        Wait Until Page Contains    ${expected_email}    timeout=15s
    END

Verify Login Failed
    [Documentation]    Verifies that dashboard was not reached and user remains on login or error state.
    Sleep    1.5s
    ${current_url}=    Get Location
    Should Not Contain    ${current_url}    /dashboard
