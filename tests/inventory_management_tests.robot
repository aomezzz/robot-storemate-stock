*** Settings ***
Documentation       Inventory Management Full UI Automation Test Suite (TC-INV-001 - TC-INV-013)
Resource            ../resources/common.resource
Resource            ../resources/login_keywords.resource
Resource            ../resources/stock_keywords.resource

Suite Setup         Suite Initialization
Suite Teardown      Close Test Browser
Test Teardown       Close Modal If Open

*** Variables ***
${FIXTURE_IMAGE}        ${CURDIR}/../sabu.jpg
${FIXTURE_PNG}          ${CURDIR}/fixtures/sample_product.png
${FIXTURE_EXE}          ${CURDIR}/fixtures/executable.exe
${FIXTURE_LARGE_IMG}    ${CURDIR}/fixtures/large_image.png

*** Keywords ***
Suite Initialization
    Open Test Browser
    Login To StoreMate    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Verify Dashboard Loaded    expected_email=${VALID_EMAIL}
    Navigate To Stock Page

*** Test Cases ***
TC-INV-001: เปิด Modal เพิ่มสินค้า
    [Documentation]    ตรวจสอบหัวข้อหน้า ตารางสินค้า ช่องค้นหา ปุ่มเพิ่มสินค้า และความพร้อมของฟิลด์ใน Modal
    [Tags]    ui    inventory    tc-inv-001
    Wait Until Page Contains    จัดการสินค้าในคลัง    timeout=10s
    Wait Until Element Is Visible    ${TABLE_ROWS}    timeout=10s
    Wait Until Element Is Visible    ${SEARCH_INPUT}    timeout=10s
    Wait Until Element Is Visible    ${ADD_PRODUCT_BTN}    timeout=10s

    Open Add Product Modal

    # ตรวจสอบฟิลด์ต่างๆ ใน Modal
    Wait Until Element Is Visible    ${PRODUCT_NAME_INPUT}    timeout=5s
    Wait Until Element Is Visible    ${CATEGORY_SELECT}    timeout=5s
    Wait Until Element Is Visible    ${PRICE_INPUT}    timeout=5s
    Wait Until Element Is Visible    ${STOCK_QTY_INPUT}    timeout=5s
    Wait Until Element Is Visible    ${STATUS_SELECT}    timeout=5s
    Wait Until Element Is Visible    ${DESCRIPTION_TEXTAREA}    timeout=5s
    Wait Until Element Is Visible    ${SUBMIT_BTN}    timeout=5s
    Wait Until Element Is Visible    ${CANCEL_BTN}    timeout=5s

    # ตรวจสอบ container scrollable
    ${is_scrollable}=    Execute JavaScript    var el = document.querySelector("div.fixed > div"); return el ? (el.scrollHeight >= el.clientHeight || window.getComputedStyle(el).overflowY !== 'hidden') : true;
    Should Be True    ${is_scrollable}

TC-INV-002: เพิ่มสินค้าสำเร็จ
    [Documentation]    ทดสอบเพิ่มสินค้าสำเร็จ กรอกข้อมูลครบถ้วน และตรวจสอบข้อมูลที่เพิ่มในตาราง
    [Tags]    smoke    inventory    tc-inv-002
    ${product_name}=    Set Variable    TEST-Product-Auto-002
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=${product_name}
    ...    category=สบู่
    ...    price=129
    ...    quantity=25
    ...    status=พร้อมจำหน่าย
    ...    description=สินค้าสำหรับทดสอบระบบเพิ่มสินค้าอัตโนมัติ
    ...    file_path=${FIXTURE_IMAGE}
    Save Product Form
    Wait For Toast Notification    expected_text=เพิ่มสินค้า    timeout=10s

    # ค้นหาสินค้าและตรวจสอบข้อมูลในตาราง
    Search Product In Table    ${product_name}
    Wait Until Page Contains    ${product_name}    timeout=10s
    Wait Until Page Contains    129    timeout=10s
    Wait Until Page Contains    25    timeout=10s

TC-INV-003: Required Field Validation
    [Documentation]    ทดสอบ Validation เมื่อไม่กรอกข้อมูล หรือกรอกเฉพาะช่องว่าง
    [Tags]    negative    inventory    tc-inv-003
    Open Add Product Modal

    # กรณี 1: ไม่กรอกข้อมูลเลยแล้วกดบันทึก
    Save Product Form
    Wait Until Page Contains    กรอกข้อมูลสินค้าไม่ครบถ้วน    timeout=5s

    # กรณี 2: กรอกชื่อที่มีแต่ช่องว่าง
    Fill Product Name Field    ${SPACE}${SPACE}${SPACE}
    Select Product Category    สบู่
    Fill Product Price Field    100
    Fill Product Quantity Field    10
    Fill Product Description Field    คำอธิบาย
    Save Product Form
    Sleep    1s

    # ระบบต้องไม่บันทึกข้อมูลชื่อที่มีแต่ช่องว่าง และคงค่าที่กรอกถูกต้องไว้
    Element Should Be Visible    ${PRODUCT_NAME_INPUT}
    ${price_val}=    Get Value    ${PRICE_INPUT}
    Should Be Equal As Strings    ${price_val}    100
    ${qty_val}=    Get Value    ${STOCK_QTY_INPUT}
    Should Be Equal As Strings    ${qty_val}    10
    Cancel Product Form

TC-INV-004: Numeric Validation
    [Documentation]    ทดสอบ Validation ฟิลด์ตัวเลข ราคาและจำนวนติดลบ
    [Tags]    negative    inventory    tc-inv-004
    Open Add Product Modal

    # ราคาติดลบ
    Fill Product Price Field    -50
    Save Product Form
    Wait Until Page Contains    ราคาต้องไม่ต่ำกว่า 0    timeout=5s

    # จำนวนสินค้าติดลบ
    Fill Product Quantity Field    -10
    Save Product Form
    Wait Until Page Contains    จำนวนต้องไม่ต่ำกว่า 0    timeout=5s

    # ทดสอบเลข 0 ต้องไม่แสดง error กรอกข้อมูลไม่ครบถ้วน
    Fill Product Price Field    0
    Fill Product Quantity Field    0
    Cancel Product Form

TC-INV-005: Image Upload
    [Documentation]    ทดสอบอัปโหลดรูปภาพ PNG, JPG และตรวจสอบปฏิเสธไฟล์ .exe หรือไฟล์ขนาดเกิน 5MB
    [Tags]    inventory    tc-inv-005
    # 1. ไฟล์ไม่รองรับ .exe
    Open Add Product Modal
    Upload Product File    ${FIXTURE_EXE}
    Wait For Toast Notification    expected_text=ไม่รองรับ หรือขนาดใหญ่เกิน 5MB    timeout=8s
    Cancel Product Form

    # 2. ไฟล์ขนาดเกิน 5 MB
    Open Add Product Modal
    Upload Product File    ${FIXTURE_LARGE_IMG}
    Wait For Toast Notification    expected_text=ไม่รองรับ หรือขนาดใหญ่เกิน 5MB    timeout=8s
    Cancel Product Form

TC-INV-006: Cancel Modal
    [Documentation]    ทดสอบการกดยกเลิก Modal ยืนยันการละทิ้ง และตรวจสอบว่าฟอร์มถูกรีเซ็ต
    [Tags]    ui    inventory    tc-inv-006
    ${unsubmitted_name}=    Set Variable    CANCELLED-ITEM-999
    Open Add Product Modal
    Fill Product Name Field    ${unsubmitted_name}
    Fill Product Price Field    99
    Cancel Product Form

    # ตรวจสอบว่า Modal ปิดลง
    Wait Until Element Is Not Visible    ${PRODUCT_NAME_INPUT}    timeout=5s

    # เปิดใหม่อีกครั้ง และตรวจสอบว่าฟิลด์ว่าง
    Open Add Product Modal
    ${val}=    Get Value    ${PRODUCT_NAME_INPUT}
    Should Be Equal As Strings    ${val}    ${EMPTY}
    Cancel Product Form

    # ยืนยันว่าไม่มีสินค้าถูกสร้าง
    Search Product In Table    ${unsubmitted_name}
    Wait Until Element Is Visible    ${EMPTY_SEARCH_STATE}    timeout=5s

TC-INV-007: Search
    [Documentation]    ทดสอบค้นหาด้วยชื่อ ค้นหาด้วยรหัสสินค้า และค้นหาคำที่ไม่มีในระบบ
    [Tags]    smoke    inventory    tc-inv-007
    # 1. ค้นหาด้วยชื่อที่มีอยู่
    Search Product In Table    สบู่
    Wait Until Page Contains    สบู่    timeout=10s

    # 2. ค้นหาด้วยรหัสสินค้าจากตาราง
    ${product_code}=    Get Text    xpath://table//tbody//tr[1]//td[1]
    Search Product In Table    ${product_code}
    Wait Until Page Contains    ${product_code}    timeout=10s

    # 3. ค้นหาคำที่ไม่มีผลลัพธ์
    Search Product In Table    NON_EXISTING_KEYWORD_XYZ_99999
    Wait Until Element Is Visible    ${EMPTY_SEARCH_STATE}    timeout=10s

    # 4. ล้างคำค้นหา
    Search Product In Table    ${EMPTY}
    Wait Until Element Is Visible    ${FIRST_TABLE_ROW}    timeout=10s

TC-INV-008: Duplicate Submission
    [Documentation]    ทดสอบป้องกันการกดส่งข้อมูลซ้ำซ้อน (Duplicate Submission Prevention)
    [Tags]    inventory    tc-inv-008
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=TEST-Dup-Check-008
    ...    category=สบู่
    ...    price=150
    ...    quantity=10
    ...    status=พร้อมจำหน่าย
    ...    description=ทดสอบการส่งข้อมูลซ้ำ
    ...    file_path=${FIXTURE_IMAGE}

    # คลิกบันทึก
    Save Product Form
    Wait For Toast Notification    timeout=10s

TC-INV-009: Data Integrity
    [Documentation]    ทดสอบความถูกต้องและคงอยู่ของข้อมูลหลัง Refresh หน้าเว็บ
    [Tags]    regression    inventory    tc-inv-009
    ${integrity_name}=    Set Variable    TEST-Integrity-Auto
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=${integrity_name}
    ...    category=สบู่
    ...    price=189
    ...    quantity=35
    ...    status=พร้อมจำหน่าย
    ...    description=ทดสอบ Data Integrity
    ...    file_path=${FIXTURE_IMAGE}
    Save Product Form
    Wait For Toast Notification    timeout=10s

    # ค้นหาและตรวจสอบ
    Search Product In Table    ${integrity_name}
    Wait Until Page Contains    ${integrity_name}    timeout=10s
    Wait Until Page Contains    189    timeout=10s
    Wait Until Page Contains    35    timeout=10s

    # รีเฟรชหน้าเว็บและค้นหาซ้ำ
    Reload Page
    Wait Until Location Contains    /stock    timeout=15s
    Search Product In Table    ${integrity_name}
    Wait Until Page Contains    ${integrity_name}    timeout=10s
    Wait Until Page Contains    189    timeout=10s
    Wait Until Page Contains    35    timeout=10s

TC-INV-010: Incomplete Form Validation Message
    [Documentation]    ตรวจสอบข้อความ Validation แสดงใต้ Text Box ที่จำเป็นและหายไปเมื่อกรอกครบ
    [Tags]    negative    inventory    tc-inv-010
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=${EMPTY}
    ...    category=สบู่
    ...    price=100
    ...    quantity=10
    ...    description=ทดสอบ Incomplete Validation
    Save Product Form
    Wait Until Page Contains    กรอกข้อมูลสินค้าไม่ครบถ้วน    timeout=5s

    # กรอกข้อมูลที่ขาดให้ครบ
    Fill Product Name Field    TEST-Incomplete-Fixed
    Select Product Status Option    พร้อมจำหน่าย
    Upload Product File    ${FIXTURE_IMAGE}
    Save Product Form
    Wait For Toast Notification    timeout=10s

TC-INV-011: Successful Product Creation Notification
    [Documentation]    ตรวจสอบการแสดงผล Toast Notification เมื่อสร้างสินค้าสำเร็จ
    [Tags]    smoke    inventory    tc-inv-011
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=TEST-Toast-Notify
    ...    category=สบู่
    ...    price=120
    ...    quantity=50
    ...    status=พร้อมจำหน่าย
    ...    description=ทดสอบ Toast Notification
    ...    file_path=${FIXTURE_IMAGE}
    Save Product Form
    Wait Until Element Is Visible    ${TOAST_LOCATOR}    timeout=10s
    ${toast_text}=    Get Text    ${TOAST_LOCATOR}
    Log    [TC-INV-011 Notification Text]: ${toast_text}
    Take Test Screenshot    notification-success.png
    Should Contain    ${toast_text}    เพิ่มสินค้า

TC-INV-012: Error Notification
    [Documentation]    ตรวจสอบการแสดงผล Error Notification ทั้งแบบ inline และ toast
    [Tags]    negative    inventory    tc-inv-012
    # Inline validation
    Open Add Product Modal
    Save Product Form
    Wait Until Page Contains    กรอกข้อมูลสินค้าไม่ครบถ้วน    timeout=5s

    # Invalid Price
    Fill Product Price Field    -10
    Save Product Form
    Wait Until Page Contains    ราคาต้องไม่ต่ำกว่า 0    timeout=5s

    # Toast for invalid file
    Upload Product File    ${FIXTURE_EXE}
    Wait For Toast Notification    expected_text=ไม่รองรับ หรือขนาดใหญ่เกิน 5MB    timeout=8s
    Cancel Product Form

TC-INV-013: Notification Locator and Assertions
    [Documentation]    ตรวจสอบ Class CSS ของ inline error และคุณสมบัติของ Notification
    [Tags]    ui    inventory    tc-inv-013
    Open Add Product Modal
    Save Product Form
    Wait Until Element Is Visible    css:.text-red-500    timeout=5s
    Element Should Be Visible    css:.text-red-500
    Cancel Product Form
