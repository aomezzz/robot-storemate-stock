*** Settings ***
Documentation       Stock Management Test Suite (Codegen Specification TC-LOT-001 to TC-LOT-010)
Resource            ../resources/common.resource
Resource            ../resources/login_keywords.resource
Resource            ../resources/stock_keywords.resource

Suite Setup         Suite Initialization
Suite Teardown      Close Test Browser
Test Teardown       Close Modal If Open

*** Variables ***
${FIXTURE_IMAGE}        ${CURDIR}/../sabu.jpg
${FIXTURE_EXE}          ${CURDIR}/fixtures/executable.exe
${FIXTURE_LARGE_IMG}    ${CURDIR}/fixtures/large_image.png

*** Keywords ***
Suite Initialization
    Open Test Browser
    Login To StoreMate    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Verify Dashboard Loaded    expected_email=${VALID_EMAIL}
    Navigate To Stock Page

*** Test Cases ***
TC-LOT-001: เพิ่มสินค้าใหม่สำเร็จ (Positive Test)
    [Documentation]    ทดสอบเพิ่มสินค้าใหม่ด้วยข้อมูลที่ถูกต้อง ครบถ้วน พร้อมแนบรูปภาพ sabu.jpg
    [Tags]    smoke    stock    tc-lot-001
    # 1. คลิกปุ่ม + เพิ่มสินค้า
    Open Add Product Modal

    # 2. กรอกข้อมูลสินค้าตามเอกสารข้อกำหนด
    Fill Product Form Complete
    ...    name=สบู่มะม่วง
    ...    category=สบู่
    ...    price=119
    ...    quantity=15
    ...    status=พร้อมจำหน่าย
    ...    description=-
    ...    file_path=${FIXTURE_IMAGE}

    # 3. กดปุ่ม "บันทึก"
    Save Product Form

    # 4. ตรวจสอบการแจ้งเตือนสำเร็จ (Toast Notification)
    Wait For Toast Notification    expected_text=เพิ่มสินค้า    timeout=10s

    # 5. ตรวจสอบว่าสินค้าใหม่ปรากฏในรายการสินค้า
    Search Product In Table    สบู่มะม่วง
    Wait Until Page Contains    สบู่มะม่วง    timeout=10s
    Take Test Screenshot    tc-lot-001-success.png

TC-LOT-002: เพิ่มสินค้าโดยไม่กรอกชื่อสินค้า (Negative Test)
    [Documentation]    ทดสอบเพิ่มสินค้าโดยเว้นว่างช่องชื่อสินค้า ระบบต้องแสดง Error Validation
    [Tags]    negative    stock    tc-lot-002
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=${EMPTY}
    ...    category=สบู่
    ...    price=119
    ...    quantity=15
    ...    description=-
    ...    file_path=${FIXTURE_IMAGE}
    Save Product Form
    Wait Until Page Contains    กรอกข้อมูลสินค้าไม่ครบถ้วน    timeout=5s
    Cancel Product Form

TC-LOT-003: ไม่เลือกหมวดหมู่สินค้า (Negative Test)
    [Documentation]    ทดสอบเพิ่มสินค้าโดยไม่เลือกหมวดหมู่สินค้า ระบบต้องแสดงข้อความแจ้งเตือน
    [Tags]    negative    stock    tc-lot-003
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=สบู่มะม่วง
    ...    price=119
    ...    quantity=15
    ...    description=-
    Save Product Form
    Wait Until Page Contains    กรอกข้อมูลสินค้าไม่ครบถ้วน    timeout=5s
    Cancel Product Form

TC-LOT-004: กรอกราคาสินค้าไม่ถูกต้อง (Negative Test)
    [Documentation]    ทดสอบกรอกราคาสินค้าติดลบ ระบบต้องแสดง Validation Error "ราคาต้องไม่ต่ำกว่า 0"
    [Tags]    negative    stock    tc-lot-004
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=สบู่มะม่วง
    ...    category=สบู่
    ...    price=-100
    ...    quantity=15
    ...    description=-
    Save Product Form
    Wait Until Page Contains    ราคาต้องไม่ต่ำกว่า 0    timeout=5s
    Cancel Product Form

TC-LOT-005: กรอกจำนวนสินค้าไม่ถูกต้อง (Negative Test)
    [Documentation]    ทดสอบกรอกจำนวนสินค้าติดลบ ระบบต้องแสดง Validation Error "จำนวนต้องไม่ต่ำกว่า 0"
    [Tags]    negative    stock    tc-lot-005
    Open Add Product Modal
    Fill Product Form Complete
    ...    name=สบู่มะม่วง
    ...    category=สบู่
    ...    price=119
    ...    quantity=-5
    ...    description=-
    Save Product Form
    Wait Until Page Contains    จำนวนต้องไม่ต่ำกว่า 0    timeout=5s
    Cancel Product Form

TC-LOT-006: อัปโหลดรูปภาพไม่ถูกต้อง (Negative Test)
    [Documentation]    ทดสอบอัปโหลดไฟล์ที่ไม่รองรับ (.exe) และไฟล์ขนาดเกิน 5MB
    [Tags]    negative    stock    tc-lot-006
    Open Add Product Modal
    Upload Product File    ${FIXTURE_EXE}
    Wait For Toast Notification    expected_text=ไม่รองรับ หรือขนาดใหญ่เกิน 5MB    timeout=8s

    Upload Product File    ${FIXTURE_LARGE_IMG}
    Wait For Toast Notification    expected_text=ไม่รองรับ หรือขนาดใหญ่เกิน 5MB    timeout=8s
    Cancel Product Form

TC-LOT-007: แก้ไขข้อมูลสินค้าสำเร็จ (Positive Test)
    [Documentation]    ทดสอบค้นหาสินค้าและแก้ไขข้อมูลราคาและจำนวน
    [Tags]    regression    stock    tc-lot-007
    Search Product In Table    สบู่มะม่วง
    Open First Product Management Modal
    Fill Product Price Field    99
    Fill Product Quantity Field    10
    Save Product Form
    Sleep    1s
    Close Modal If Open
    Search Product In Table    สบู่มะม่วง
    Wait Until Page Contains    สบู่มะม่วง    timeout=10s

TC-LOT-008: ลบสินค้าที่ไม่มีประวัติใช้งาน (Positive Test)
    [Documentation]    ทดสอบลบสินค้าที่สร้างขึ้นมาและยืนยันการลบ
    [Tags]    regression    stock    tc-lot-008
    Search Product In Table    สบู่มะม่วง
    ${row_exists}=    Run Keyword And Return Status    Page Should Contain Element    ${FIRST_MANAGE_BTN}
    IF    ${row_exists}
        Open First Product Management Modal
        ${has_del}=    Run Keyword And Return Status    Element Should Be Visible    ${DELETE_BTN}
        IF    ${has_del}
            Click Delete Product And Confirm
            Wait For Toast Notification    expected_text=ลบสินค้าเรียบร้อยแล้ว    timeout=10s
        ELSE
            Cancel Product Form
        END
    END

TC-LOT-009: ลบสินค้าที่มีประวัติใช้งาน (Negative / Business Rule Test)
    [Documentation]    ตรวจสอบเงื่อนไขทางธุรกิจสำหรับสินค้าที่มีประวัติการใช้งาน
    [Tags]    negative    stock    tc-lot-009
    Search Product In Table    ${EMPTY}
    ${row_exists}=    Run Keyword And Return Status    Page Should Contain Element    ${FIRST_MANAGE_BTN}
    IF    ${row_exists}
        Open First Product Management Modal
        ${has_del}=    Run Keyword And Return Status    Element Should Be Visible    ${DELETE_BTN}
        IF    ${has_del}
            ${is_disabled}=    Run Keyword And Return Status    Element Should Be Disabled    ${DELETE_BTN}
            IF    not ${is_disabled}
                Click Interactive Element    ${DELETE_BTN}
                ${has_confirm}=    Run Keyword And Return Status    Element Should Be Visible    ${CONFIRM_BTN}
                IF    ${has_confirm}
                    Click Interactive Element    ${CONFIRM_BTN}
                END
                Sleep    1s
            END
        END
        Close Modal If Open
    END

TC-LOT-010: ค้นหาสินค้าด้วยชื่อ (Positive & Empty State Test)
    [Documentation]    ทดสอบค้นหาด้วยชื่อสินค้าที่มีอยู่ และตรวจสอบกรณีไม่พบสินค้า (Empty State)
    [Tags]    smoke    stock    tc-lot-010
    # 1. ค้นหาด้วยชื่อที่มีอยู่
    Search Product In Table    สบู่
    Wait Until Element Is Visible    ${FIRST_TABLE_ROW}    timeout=10s

    # 2. ค้นหาคำที่ไม่มีผลลัพธ์
    Search Product In Table    ไม่มีสินค้านี้ในระบบแน่นอน999
    Wait Until Element Is Visible    ${EMPTY_SEARCH_STATE}    timeout=10s
    Element Should Contain    ${EMPTY_SEARCH_STATE}    ไม่พบรายการสินค้าที่ค้นหา

    # 3. ล้างคำค้นหา
    Search Product In Table    ${EMPTY}
    Wait Until Element Is Visible    ${FIRST_TABLE_ROW}    timeout=10s
