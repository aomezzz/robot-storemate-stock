*** Settings ***
Documentation     Keywords and variables for StoreMate application
Library           SeleniumLibrary

*** Variables ***
${BASE_URL}          https://storemate-final.vercel.app/
${LOGIN_URL}         https://storemate-final.vercel.app/login
${DASHBOARD_URL}     https://storemate-final.vercel.app/dashboard
${VALID_EMAIL}       aomezzz.aomsin@gmail.com
${VALID_PASSWORD}    Aomezzz_007
${BROWSER}           chrome
${HEADLESS}          ${True}
${DELAY}             0.2s

# Locators - Login & General
${LOC_EMAIL_INPUT}        id:email
${LOC_PASSWORD_INPUT}     id:password
${LOC_LOGIN_BUTTON}       xpath://form//button[@type='submit' or contains(., 'เข้าสู่ระบบ')]
${LOC_DASHBOARD_HEADING}  xpath://h1[contains(., 'แดชบอร์ด')] | //*[contains(text(), 'แดชบอร์ด')]
${LOC_NAV_LOGIN_BUTTON}   xpath://a[contains(., 'เข้าสู่ระบบ')] | //button[contains(., 'เข้าสู่ระบบ')]

# Locators - Stock Management
${STOCK_URL}                  https://storemate-final.vercel.app/stock
${LOC_STOCK_SIDEBAR_BTN}      xpath://button[@data-test='stock-button'] | //*[contains(text(), 'จัดการสินค้าในคลัง')]
${LOC_ADD_PRODUCT_BTN}        xpath://button[contains(., 'เพิ่มสินค้า')]
${LOC_SEARCH_INPUT}           xpath://input[@placeholder='ค้นหาโดยชื่อสินค้า หรือ รหัสสินค้า']
${LOC_MODAL_CONTAINER}        xpath://div[contains(@class, 'fixed') and contains(@class, 'backdrop-blur')]
${LOC_INPUT_PRODUCT_NAME}     xpath://input[@name='productName' or @placeholder='ชื่อสินค้า']
${LOC_SELECT_CATEGORY}        xpath://select[@name='categoryName']
${LOC_INPUT_PRICE}            xpath://input[@name='price' or @placeholder='ราคา']
${LOC_INPUT_STOCK_QTY}        xpath://input[@name='stockQuantity' or @placeholder='จำนวนสินค้า']
${LOC_SELECT_STATUS}          xpath://select[@name='status']
${LOC_TEXTAREA_DESC}          xpath://textarea[@name='description' or @placeholder='รายละเอียดสินค้า']
${LOC_INPUT_FILE}             xpath://div[contains(@class, 'fixed')]//input[@type='file']
${LOC_BTN_SUBMIT_PRODUCT}     xpath://button[@data-test='submit-product-add' or (contains(@class, 'bg-[#1e3a8a]') and contains(., 'บันทึก')) or (not(contains(@class, 'disabled')) and contains(., 'บันทึก'))]
${LOC_BTN_CANCEL_PRODUCT}     xpath://button[@data-test='cancel-edit-product' or contains(., 'ยกเลิก')]
${LOC_BTN_DELETE_PRODUCT}     xpath://button[contains(@data-test, 'delete-product') or contains(., 'ลบสินค้า')]

*** Keywords ***
Open StoreMate Website
    [Arguments]    ${url}=${BASE_URL}    ${browser}=${BROWSER}    ${headless}=${False}
    IF    ${headless}
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
        Evaluate    $options.add_argument('--headless=new')
        Evaluate    $options.add_argument('--no-sandbox')
        Evaluate    $options.add_argument('--disable-gpu')
        Evaluate    $options.add_argument('--window-size=1920,1080')
        Open Browser    ${url}    ${browser}    options=${options}
    ELSE
        Open Browser    ${url}    ${browser}
        Maximize Browser Window
    END
    Set Selenium Speed    ${DELAY}
    Set Selenium Timeout    15s

Go To Login Page
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    ${LOC_EMAIL_INPUT}    timeout=10s

Input Email
    [Arguments]    ${email}
    Wait Until Element Is Visible    ${LOC_EMAIL_INPUT}
    Input Text    ${LOC_EMAIL_INPUT}    ${email}

Input StoreMate Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOC_PASSWORD_INPUT}
    Input Text    ${LOC_PASSWORD_INPUT}    ${password}

Submit Login Form
    Wait Until Element Is Visible    ${LOC_LOGIN_BUTTON}
    Click Element    ${LOC_LOGIN_BUTTON}

Login To StoreMate
    [Arguments]    ${email}=${VALID_EMAIL}    ${password}=${VALID_PASSWORD}
    Go To Login Page
    Input Email    ${email}
    Input StoreMate Password    ${password}
    Submit Login Form

Verify Dashboard Page Loaded
    Wait Until Location Contains    /dashboard    timeout=10s
    Wait Until Page Contains    แดชบอร์ด    timeout=10s
    Page Should Contain    ${VALID_EMAIL}

Capture Dashboard Screenshot
    [Arguments]    ${filename}=login-success.png
    Capture Page Screenshot    filename=${filename}

# --- Stock Management Keywords ---

Navigate To Stock Management Page
    Wait Until Location Contains     /dashboard                  timeout=10s
    ${status}=                       Run Keyword And Return Status    Wait Until Element Is Visible    ${LOC_STOCK_SIDEBAR_BTN}    timeout=5s
    IF    ${status}
        Click Element                ${LOC_STOCK_SIDEBAR_BTN}
    ELSE
        Go To                        ${STOCK_URL}
    END
    ${in_stock}=                     Run Keyword And Return Status    Wait Until Location Contains     /stock    timeout=5s
    IF    not ${in_stock}
        Go To                        ${STOCK_URL}
    END
    Wait Until Page Contains         จัดการสินค้าในคลัง          timeout=10s
    Wait Until Element Is Visible    ${LOC_ADD_PRODUCT_BTN}      timeout=10s

Open Add Product Modal
    Wait Until Element Is Visible    ${LOC_ADD_PRODUCT_BTN}       timeout=10s
    Execute Javascript               var b = document.evaluate("//button[contains(., 'เพิ่มสินค้า')]", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; if(b) b.click();
    Wait Until Element Is Visible    ${LOC_INPUT_PRODUCT_NAME}    timeout=10s

Input Product Name
    [Arguments]    ${product_name}
    Wait Until Element Is Visible    ${LOC_INPUT_PRODUCT_NAME}    timeout=10s
    Clear Element Text               ${LOC_INPUT_PRODUCT_NAME}
    IF    '${product_name}' != ''
        Input Text                   ${LOC_INPUT_PRODUCT_NAME}    ${product_name}
    END

Select Product Category
    [Arguments]    ${category}
    Wait Until Element Is Visible    ${LOC_SELECT_CATEGORY}    timeout=10s
    IF    '${category}' != ''
        Select From List By Label    ${LOC_SELECT_CATEGORY}    ${category}
    END

Input Product Price
    [Arguments]    ${price}
    Wait Until Element Is Visible    ${LOC_INPUT_PRICE}    timeout=10s
    Clear Element Text               ${LOC_INPUT_PRICE}
    IF    '${price}' != ''
        Input Text                   ${LOC_INPUT_PRICE}    ${price}
    END

Input Product Quantity
    [Arguments]    ${qty}
    Wait Until Element Is Visible    ${LOC_INPUT_STOCK_QTY}    timeout=10s
    Clear Element Text               ${LOC_INPUT_STOCK_QTY}
    IF    '${qty}' != ''
        Input Text                   ${LOC_INPUT_STOCK_QTY}    ${qty}
    END

Select Product Status
    [Arguments]    ${status}
    Wait Until Element Is Visible    ${LOC_SELECT_STATUS}    timeout=10s
    IF    '${status}' != ''
        Select From List By Label    ${LOC_SELECT_STATUS}    ${status}
    END

Input Product Description
    [Arguments]    ${description}
    Wait Until Element Is Visible    ${LOC_TEXTAREA_DESC}    timeout=10s
    Clear Element Text               ${LOC_TEXTAREA_DESC}
    IF    '${description}' != ''
        Input Text                   ${LOC_TEXTAREA_DESC}    ${description}
    END

Upload Product File
    [Arguments]    ${file_path}
    ${abs_path}=    Evaluate    os.path.abspath(r'''${file_path}''')    os
    Execute Javascript    var el = document.querySelector("input[type='file']"); if(el) { el.style.opacity='1'; el.style.display='block'; el.style.visibility='visible'; el.style.width='100px'; el.style.height='30px'; }
    Choose File     ${LOC_INPUT_FILE}    ${abs_path}

Save Product Form
    Wait Until Element Is Visible    ${LOC_BTN_SUBMIT_PRODUCT}    timeout=5s
    Click Button                     ${LOC_BTN_SUBMIT_PRODUCT}

Cancel Product Form
    ${cancel_present}=    Run Keyword And Return Status    Page Should Contain Element    ${LOC_BTN_CANCEL_PRODUCT}
    IF    ${cancel_present}
        Execute Javascript    var btn = document.querySelector("[data-test='cancel-edit-product']") || document.querySelector("button:contains('ยกเลิก')"); if(btn) btn.click();
        Sleep                 1s
    END

Close Modal If Open
    ${is_modal}=    Run Keyword And Return Status    Page Should Contain Element    ${LOC_MODAL_CONTAINER}
    IF    ${is_modal}
        Execute Javascript    var btn = document.querySelector("[data-test='cancel-edit-product']"); if(btn) btn.click();
        Sleep    1s
    END

Verify Modal Is Closed
    Wait Until Page Does Not Contain Element    ${LOC_INPUT_PRODUCT_NAME}    timeout=5s

Verify Modal Is Still Open
    Page Should Contain Element      ${LOC_MODAL_CONTAINER}

Search Product In Stock Table
    [Arguments]    ${search_term}
    Wait Until Element Is Visible    ${LOC_SEARCH_INPUT}    timeout=10s
    Clear Element Text               ${LOC_SEARCH_INPUT}
    IF    '${search_term}' != ''
        Input Text                   ${LOC_SEARCH_INPUT}    ${search_term}
    END
    Sleep                            1s

Open Manage Modal For Product
    [Arguments]    ${product_code}
    ${manage_locator}=    Set Variable    xpath://tbody//tr[contains(., '${product_code}')]//button[contains(., 'จัดการ')] | //table//tr[contains(., '${product_code}')]//button[contains(., 'จัดการ')]
    Wait Until Element Is Visible    ${manage_locator}    timeout=10s
    Click Button                     ${manage_locator}
    Wait Until Element Is Visible    ${LOC_MODAL_CONTAINER}    timeout=10s

Click Delete Product In Modal
    Execute Javascript               var b = document.querySelector("[data-test^='delete-product']"); if(b) b.click();
    Sleep                            1s

Close StoreMate Browser
    Close Browser
