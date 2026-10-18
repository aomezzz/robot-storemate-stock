*** Settings ***
Documentation       Authentication & Login Test Suite for StoreMate
Resource            ../resources/common.resource
Resource            ../resources/login_keywords.resource

Test Setup          Open Test Browser
Test Teardown       Close Test Browser

*** Test Cases ***
TC01 - Login With Valid Credentials Should Succeed
    [Documentation]    ทดสอบการเข้าสู่ระบบด้วยข้อมูลบัญชีที่ถูกต้อง ต้องเข้าสู่ Dashboard ได้สำเร็จ
    [Tags]    smoke    regression    login
    # 1. กรอกข้อมูล Email และ Password ที่ถูกต้อง
    Navigate To Login Page
    Input Email Address    ${VALID_EMAIL}
    Input Password Text    ${VALID_PASSWORD}

    # 2. กดปุ่มเข้าสู่ระบบ
    Click Login Button

    # 3. ตรวจสอบว่าระบบนำทางเข้าสู่หน้า Dashboard สำเร็จ
    Verify Dashboard Loaded    expected_email=${VALID_EMAIL}

    # 4. บันทึกภาพหน้าจอ
    Take Test Screenshot    login-success.png

TC02 - Login With Invalid Password Should Fail
    [Documentation]    ทดสอบการเข้าสู่ระบบด้วยรหัสผ่านที่ไม่ถูกต้อง ระบบต้องไม่อนุญาตให้เข้าสู่ Dashboard
    [Tags]    negative    login
    # 1. กรอก Email ถูกต้อง และกรอก Password ผิด
    Navigate To Login Page
    Input Email Address    ${VALID_EMAIL}
    Input Password Text    WrongPassword123!

    # 2. กดปุ่มเข้าสู่ระบบ
    Click Login Button

    # 3. ตรวจสอบว่าไม่สามารถเข้าหน้า Dashboard ได้
    Verify Login Failed

TC03 - Login With Empty Password Should Show Validation
    [Documentation]    ทดสอบการเข้าสู่ระบบโดยเว้นว่างรหัสผ่าน ระบบต้องไม่นำทางเข้าสู่ Dashboard
    [Tags]    negative    login
    # 1. กรอกเฉพาะ Email และเว้นว่าง Password
    Navigate To Login Page
    Input Email Address    ${VALID_EMAIL}

    # 2. กดปุ่มเข้าสู่ระบบ
    Click Login Button

    # 3. ตรวจสอบว่าระบบยังคงอยู่ที่หน้าเดิม ไม่เข้า Dashboard
    Verify Login Failed
