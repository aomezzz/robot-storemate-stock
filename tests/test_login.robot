*** Settings ***
Documentation     Test Suite for StoreMate Authentication
Resource          ../resources/storemate_keywords.robot
Test Setup        Open StoreMate Website    url=${LOGIN_URL}    headless=${HEADLESS}
Test Teardown     Close StoreMate Browser

*** Test Cases ***
TC01 - Login With Valid Credentials Should Succeed
    [Documentation]    ทดสอบเข้าสู่ระบบด้วย Email และ Password ที่ถูกต้อง แล้วตรวจสอบว่าเข้าสู่หน้า Dashboard ได้สำเร็จ
    [Tags]             smoke    regression    login
    Input Email                  ${VALID_EMAIL}
    Input StoreMate Password     ${VALID_PASSWORD}
    Submit Login Form
    Verify Dashboard Page Loaded
    Capture Dashboard Screenshot

TC02 - Login With Invalid Password Should Fail
    [Documentation]    ทดสอบเข้าสู่ระบบด้วยรหัสผ่านที่ไม่ถูกต้อง แล้วตรวจสอบว่าไม่สามารถเข้าหน้า Dashboard ได้
    [Tags]             negative    login
    Input Email                  ${VALID_EMAIL}
    Input StoreMate Password     WrongPassword123!
    Submit Login Form
    Sleep                        1s
    ${current_url}=              Get Location
    Should Not Contain           ${current_url}    /dashboard

TC03 - Login With Empty Password Should Show Validation
    [Documentation]    ทดสอบไม่กรอก Password
    [Tags]             negative    login
    Input Email                  ${VALID_EMAIL}
    Submit Login Form
    ${current_url}=              Get Location
    Should Not Contain           ${current_url}    /dashboard
