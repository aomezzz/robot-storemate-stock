*** Settings ***
Documentation       Page Object Keywords and locators for Stock & Inventory Management
Resource            common.resource

*** Variables ***
${STOCK_PATH}                   /stock
${SIDEBAR_STOCK_BTN}            xpath://button[contains(., 'จัดการสินค้าในคลัง')] | //a[contains(., 'จัดการสินค้าในคลัง')]
${ADD_PRODUCT_BTN}              xpath://button[contains(., 'เพิ่มสินค้า')]
${SEARCH_INPUT}                 css:input[placeholder*='ค้นหาโดยชื่อสินค้า']
${MODAL_CONTAINER}              xpath://div[contains(@class, 'fixed') and (contains(@class, 'backdrop') or .//input[@name='productName'])]
${PRODUCT_NAME_INPUT}           css:input[name='productName']
${CATEGORY_SELECT}              css:select[name='categoryName']
${PRICE_INPUT}                  css:input[name='price']
${STOCK_QTY_INPUT}              css:input[name='stockQuantity']
${STATUS_SELECT}                css:select[name='status']
${DESCRIPTION_TEXTAREA}         css:textarea[name='description']
${FILE_INPUT}                   css:input[type='file']
${SUBMIT_BTN}                   xpath://button[contains(., 'บันทึก') or starts-with(@data-test, 'submit-product')]
${CANCEL_BTN}                   xpath://button[contains(., 'ยกเลิก') or @data-test='cancel-edit-product']
${CONFIRM_BTN}                  xpath://button[contains(., 'ยืนยัน')]
${DELETE_BTN}                   xpath://button[contains(., 'ลบสินค้า') or starts-with(@data-test, 'delete-product')]
${FIRST_MANAGE_BTN}             xpath:(//table//tbody//tr//button[contains(., 'จัดการ') or starts-with(@data-test, 'menagemate-product')])[1]
${FIRST_TABLE_ROW}              xpath://table//tbody//tr[1]
${TABLE_ROWS}                   css:table tbody tr
${EMPTY_SEARCH_STATE}           xpath://table//tbody//td[contains(., 'ไม่พบรายการสินค้าที่ค้นหา')]
${TOAST_LOCATOR}                css:[role='status'], .go4109123758, [role='alert']

*** Keywords ***
Click Interactive Element
    [Documentation]    Dispatches native click to ensure React component event handlers trigger.
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${el}=    Get WebElement    ${locator}
    Execute JavaScript    arguments[0].scrollIntoView({block: 'center'}); arguments[0].click();    ARGUMENTS    ${el}
    Sleep    0.3s

Set React Input Value
    [Documentation]    Sets input value via native prototype setter and dispatches input/change events for React state updates.
    [Arguments]    ${locator}    ${value}
    Wait Until Element Is Visible    ${locator}    timeout=10s
    ${el}=    Get WebElement    ${locator}
    Execute JavaScript
    ...    var el = arguments[0];
    ...    var proto = el.tagName === 'TEXTAREA' ? window.HTMLTextAreaElement.prototype : window.HTMLInputElement.prototype;
    ...    var setter = Object.getOwnPropertyDescriptor(proto, 'value').set;
    ...    setter.call(el, arguments[1]);
    ...    el.dispatchEvent(new Event('input', { bubbles: true }));
    ...    el.dispatchEvent(new Event('change', { bubbles: true }));
    ...    ARGUMENTS    ${el}    ${value}

Navigate To Stock Page
    [Documentation]    Navigates to the Stock Management page and verifies table is rendered.
    Go To    ${BASE_URL}${STOCK_PATH}
    Wait Until Location Contains    /stock    timeout=15s
    Wait Until Page Contains    จัดการสินค้าในคลัง    timeout=15s
    Wait Until Element Is Visible    ${ADD_PRODUCT_BTN}    timeout=15s
    Sleep    1s

Open Add Product Modal
    [Documentation]    Opens the Add Product modal and waits for form elements to become interactable.
    Close Modal If Open
    Click Interactive Element    ${ADD_PRODUCT_BTN}
    Wait Until Element Is Visible    ${PRODUCT_NAME_INPUT}    timeout=10s

Close Modal If Open
    [Documentation]    Checks if product modal is open and closes it cleanly.
    ${is_open}=    Run Keyword And Return Status    Element Should Be Visible    ${PRODUCT_NAME_INPUT}
    IF    ${is_open}
        Cancel Product Form
    END
    Sleep    0.3s

Cancel Product Form
    [Documentation]    Clicks cancel button and handles discard confirmation if present.
    ${has_cancel}=    Run Keyword And Return Status    Element Should Be Visible    ${CANCEL_BTN}
    IF    ${has_cancel}
        Click Interactive Element    ${CANCEL_BTN}
        Sleep    0.5s
        ${has_confirm}=    Run Keyword And Return Status    Element Should Be Visible    ${CONFIRM_BTN}
        IF    ${has_confirm}
            Click Interactive Element    ${CONFIRM_BTN}
            Sleep    0.5s
        END
    END
    ${is_still_open}=    Run Keyword And Return Status    Element Should Be Visible    ${PRODUCT_NAME_INPUT}
    IF    ${is_still_open}
        Press Keys    None    \\27
        Sleep    0.5s
    END

Fill Product Name Field
    [Documentation]    Fills product name input.
    [Arguments]    ${name}
    Set React Input Value    ${PRODUCT_NAME_INPUT}    ${name}

Select Product Category
    [Documentation]    Selects product category by label.
    [Arguments]    ${category_label}
    Wait Until Element Is Visible    ${CATEGORY_SELECT}    timeout=5s
    Select From List By Label    ${CATEGORY_SELECT}    ${category_label}

Fill Product Price Field
    [Documentation]    Fills price input.
    [Arguments]    ${price}
    Set React Input Value    ${PRICE_INPUT}    ${price}

Fill Product Quantity Field
    [Documentation]    Fills stock quantity input.
    [Arguments]    ${quantity}
    Set React Input Value    ${STOCK_QTY_INPUT}    ${quantity}

Select Product Status Option
    [Documentation]    Selects product status by label.
    [Arguments]    ${status_label}
    ${has_status}=    Run Keyword And Return Status    Element Should Be Visible    ${STATUS_SELECT}
    IF    ${has_status}
        Select From List By Label    ${STATUS_SELECT}    ${status_label}
    END

Fill Product Description Field
    [Documentation]    Fills product description textarea.
    [Arguments]    ${description}
    Set React Input Value    ${DESCRIPTION_TEXTAREA}    ${description}

Upload Product File
    [Documentation]    Makes file input interactable and uploads the given file path.
    [Arguments]    ${file_path}
    ${abs_path}=    Normalize Path    ${file_path}
    Execute JavaScript    var el = document.querySelector("input[type='file']"); if (el) { el.style.opacity = '1'; el.style.display = 'block'; el.style.visibility = 'visible'; el.style.width = '100px'; el.style.height = '30px'; }
    Choose File    ${FILE_INPUT}    ${abs_path}
    Sleep    0.5s

Save Product Form
    [Documentation]    Clicks the save/submit button on the product form.
    Wait Until Element Is Visible    ${SUBMIT_BTN}    timeout=5s
    Execute JavaScript
    ...    const form = document.querySelector('form');
    ...    if (form) form.noValidate = true;
    ...    const btn = document.querySelector("button[data-test^='submit-product']") || document.querySelector("form button[type='submit']");
    ...    if (btn) { btn.scrollIntoView({block: 'center'}); btn.click(); }
    Sleep    0.5s

Fill Product Form Complete
    [Documentation]    Fills all or specified fields in the product form.
    [Arguments]    ${name}=${EMPTY}    ${category}=${EMPTY}    ${price}=${EMPTY}    ${quantity}=${EMPTY}    ${status}=พร้อมจำหน่าย    ${description}=${EMPTY}    ${file_path}=${EMPTY}
    IF    '${name}' != '${EMPTY}'
        Fill Product Name Field    ${name}
    END
    IF    '${category}' != '${EMPTY}'
        Select Product Category    ${category}
    END
    IF    '${price}' != '${EMPTY}'
        Fill Product Price Field    ${price}
    END
    IF    '${quantity}' != '${EMPTY}'
        Fill Product Quantity Field    ${quantity}
    END
    IF    '${status}' != '${EMPTY}'
        Select Product Status Option    ${status}
    END
    IF    '${description}' != '${EMPTY}'
        Fill Product Description Field    ${description}
    END
    IF    '${file_path}' != '${EMPTY}'
        Upload Product File    ${file_path}
    END

Search Product In Table
    [Documentation]    Searches for a keyword in the product table.
    [Arguments]    ${keyword}
    Wait Until Element Is Visible    ${SEARCH_INPUT}    timeout=10s
    ${el}=    Get WebElement    ${SEARCH_INPUT}
    Execute JavaScript
    ...    var el = arguments[0];
    ...    var val = arguments[1];
    ...    var setter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
    ...    setter.call(el, val);
    ...    el.dispatchEvent(new Event('input', { bubbles: true }));
    ...    el.dispatchEvent(new Event('change', { bubbles: true }));
    ...    el.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true }));
    ...    el.dispatchEvent(new KeyboardEvent('keyup', { key: 'Enter', code: 'Enter', keyCode: 13, which: 13, bubbles: true }));
    ...    ARGUMENTS    ${el}    ${keyword}
    Sleep    1.5s

Open First Product Management Modal
    [Documentation]    Clicks manage button on the first product row.
    Close Modal If Open
    Click Interactive Element    ${FIRST_MANAGE_BTN}
    Wait Until Element Is Visible    ${PRODUCT_NAME_INPUT}    timeout=10s

Click Delete Product And Confirm
    [Documentation]    Clicks delete button and confirms deletion dialog.
    Click Interactive Element    ${DELETE_BTN}
    Wait Until Element Is Visible    ${CONFIRM_BTN}    timeout=5s
    Click Interactive Element    ${CONFIRM_BTN}
    Sleep    1s

Wait For Toast Notification
    [Documentation]    Waits for toast notification and optionally asserts expected text.
    [Arguments]    ${expected_text}=${EMPTY}    ${timeout}=10s
    Wait Until Element Is Visible    ${TOAST_LOCATOR}    timeout=${timeout}
    IF    '${expected_text}' != '${EMPTY}'
        Element Should Contain    ${TOAST_LOCATOR}    ${expected_text}
    END
