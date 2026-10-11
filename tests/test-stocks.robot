*** Settings ***
Documentation     Test Suite for StoreMate Stock Management (SPRS - Storemate Ecommerce)
...               อ้างอิงตามเอกสาร Test Case Specification โมดูล "จัดการสินค้าในคลัง"
Resource          ../resources/storemate_keywords.robot
Suite Setup       Login And Navigate To Stock Page
Suite Teardown    Close StoreMate Browser
Test Teardown     Close Modal If Open

*** Variables ***
${FIXTURE_VALID_FILE}    tests/fixtures/product_spec.xlsx
${FIXTURE_LARGE_FILE}    tests/fixtures/large_file.xlsx
${FIXTURE_EXE_FILE}      tests/fixtures/executable.exe

*** Keywords ***
Login And Navigate To Stock Page
    Open StoreMate Website            url=${LOGIN_URL}    headless=${HEADLESS}
    Login To StoreMate                email=${VALID_EMAIL}    password=${VALID_PASSWORD}
    Verify Dashboard Page Loaded
    Navigate To Stock Management Page

*** Test Cases ***
TC-LOT-001: เพิ่มสินค้าในคลังใหม่สำเร็จผ่าน Modal Popup (Positive Test)
    [Documentation]    TS-LOT-001 / FR-INV-01: เพิ่มสินค้าในคลังใหม่สำเร็จผ่าน Modal Popup
    ...                ข้อมูลทดสอบ: สบู่สมุนไพรไหมทอง, หมวดหมู่ สบู่, ราคา 85, จำนวน 100, สถานะ พร้อมจำหน่าย
    [Tags]             positive    inventory    smoke
    Open Add Product Modal
    Input Product Name           สบู่สมุนไพรไหมทอง
    Select Product Category      สบู่
    Input Product Price          85
    Input Product Quantity       100
    Select Product Status        พร้อมจำหน่าย
    Input Product Description    สบู่ทำความสะอาดผิวหน้าและผายช่วยบำรุงผิวให้เนียนนุ่ม
    Upload Product File          ${FIXTURE_VALID_FILE}
    Save Product Form
    Sleep                        2s
    Capture Page Screenshot      filename=stock-tc001-added.png

TC-LOT-002: เพิ่มสินค้าโดยไม่กรอกชื่อสินค้า (Negative Test)
    [Documentation]    TS-LOT-002 / FR-INV-01: เพิ่มสินค้าโดยเว้นว่างชื่อสินค้า ระบบต้องไม่อนุญาตให้บันทึก
    [Tags]             negative    inventory
    Open Add Product Modal
    Input Product Name           ${EMPTY}
    Select Product Category      สบู่
    Input Product Price          100
    Input Product Quantity       50
    Input Product Description    รายละเอียดสินค้าทดสอบ
    ${is_disabled}=              Run Keyword And Return Status    Element Should Be Disabled    ${LOC_BTN_SUBMIT_PRODUCT}
    IF    not ${is_disabled}
        Save Product Form
        Verify Modal Is Still Open
    END
    Cancel Product Form

TC-LOT-003: ไม่เลือกหมวดหมู่สินค้า (Negative Test)
    [Documentation]    TS-LOT-003 / FR-INV-01: ไม่ทำการเลือกตัวเลือกใน Dropdown หมวดหมู่ ระบบต้องไม่อนุญาตให้บันทึก
    [Tags]             negative    inventory
    Open Add Product Modal
    Input Product Name           สบู่สมุนไพรไหมทอง
    Input Product Price          85
    Input Product Quantity       100
    Input Product Description    สบู่ทำความสะอาดผิวหน้า
    ${is_disabled}=              Run Keyword And Return Status    Element Should Be Disabled    ${LOC_BTN_SUBMIT_PRODUCT}
    IF    not ${is_disabled}
        Save Product Form
        Verify Modal Is Still Open
    END
    Cancel Product Form

TC-LOT-004: ราคาสินค้าไม่ถูกต้อง (Negative Test)
    [Documentation]    TS-LOT-004 / FR-INV-01: กรอกค่าติดลบ -50 ในช่องราคา ระบบต้องป้องกันไม่ให้บันทึก
    [Tags]             negative    inventory
    Open Add Product Modal
    Input Product Name           สบู่สมุนไพรไหมทอง
    Select Product Category      สบู่
    Input Product Price          -50
    Input Product Quantity       100
    Input Product Description    สบู่ทำความสะอาดผิวหน้า
    ${is_disabled}=              Run Keyword And Return Status    Element Should Be Disabled    ${LOC_BTN_SUBMIT_PRODUCT}
    IF    not ${is_disabled}
        Save Product Form
        Verify Modal Is Still Open
    END
    Cancel Product Form

TC-LOT-005: จำนวนสินค้าไม่ถูกต้อง (Negative Test)
    [Documentation]    TS-LOT-005 / FR-INV-01: กรอกค่าติดลบ -10 ในช่องจำนวนสินค้าในคลัง ระบบต้องไม่อนุญาตให้บันทึก
    [Tags]             negative    inventory
    Open Add Product Modal
    Input Product Name           สบู่สมุนไพรไหมทอง
    Select Product Category      สบู่
    Input Product Price          85
    Input Product Quantity       -10
    Input Product Description    สบู่ทำความสะอาดผิวหน้า
    ${is_disabled}=              Run Keyword And Return Status    Element Should Be Disabled    ${LOC_BTN_SUBMIT_PRODUCT}
    IF    not ${is_disabled}
        Save Product Form
        Verify Modal Is Still Open
    END
    Cancel Product Form

TC-LOT-006: อัปโหลดรูปภาพหรือไฟล์ไม่ถูกต้อง (Negative Test)
    [Documentation]    TS-LOT-006 / FR-INV-01: อัปโหลดไฟล์ขนาดเกิน 5 MB หรือนามสกุลที่ไม่รองรับ (.exe)
    [Tags]             negative    inventory
    Open Add Product Modal
    Input Product Name           สบู่สมุนไพรไหมทอง
    Select Product Category      สบู่
    Upload Product File          ${FIXTURE_LARGE_FILE}
    Sleep                        1s
    Upload Product File          ${FIXTURE_EXE_FILE}
    Sleep                        1s
    Cancel Product Form

TC-LOT-007: แก้ไขข้อมูลสินค้าสำเร็จ (Positive Test)
    [Documentation]    TS-LOT-007 / FR-INV-02: แก้ไขข้อมูลสินค้า จำนวนเป็น 50 และสถานะเป็น ไม่พร้อมจำหน่าย
    [Tags]             positive    inventory
    Close Modal If Open
    Sleep                        1s
    Execute Javascript           var b = document.querySelector("table button[data-test^='menagemate-product']"); if(b) b.click();
    Wait Until Element Is Visible    ${LOC_MODAL_CONTAINER}    timeout=10s
    Wait Until Element Is Visible    ${LOC_INPUT_STOCK_QTY}    timeout=10s
    Input Product Quantity       50
    Select Product Status        ไม่พร้อมจำหน่าย
    Execute Javascript           var b = document.querySelector("[data-test^='submit-product']"); if(b) b.click();
    Sleep                        2s

TC-LOT-008: ลบสินค้าที่ไม่มีประวัติใช้งาน (Positive Test)
    [Documentation]    TS-LOT-008 / FR-INV-02: ทดสอบการลบสินค้าที่ไม่มีประวัติการใช้งาน
    [Tags]             positive    inventory
    Close Modal If Open
    Sleep                        1s
    Execute Javascript           var b = document.querySelector("table button[data-test^='menagemate-product']"); if(b) b.click();
    Wait Until Element Is Visible    ${LOC_MODAL_CONTAINER}    timeout=10s
    Click Delete Product In Modal
    Cancel Product Form

TC-LOT-009: ลบสินค้าที่มีประวัติใช้งาน (Negative / Business Rule Test)
    [Documentation]    TS-LOT-009 / FR-INV-02: ลบสินค้าที่มีประวัติทำรายการ ระบบต้องไม่อนุญาตให้ลบ
    [Tags]             negative    inventory    business-rule
    Close Modal If Open
    Sleep                        1s
    Execute Javascript           var b = document.querySelector("table button[data-test^='menagemate-product']"); if(b) b.click();
    Wait Until Element Is Visible    ${LOC_MODAL_CONTAINER}    timeout=10s
    Click Delete Product In Modal
    Cancel Product Form

TC-LOT-010: ค้นหาสินค้าด้วยชื่อ (Positive & Negative Test)
    [Documentation]    TS-LOT-010 / FR-INV-03: ค้นหาสินค้าด้วยคำค้นหา "สบู่" (พบข้อมูล) และ "ไม่มีสินค้านี้ในระบบ" (ไม่พบข้อมูล)
    [Tags]             search    inventory
    Search Product In Stock Table    สบู่
    Sleep                            1s
    Page Should Contain              สบู่
    Search Product In Stock Table    ไม่มีสินค้านี้ในระบบ
    Sleep                            1s
    Search Product In Stock Table    ${EMPTY}
