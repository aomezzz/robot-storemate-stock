@echo off
chcp 65001 >nul
echo ========================================================
echo        StoreMate Robot Framework Test Runner
echo ========================================================
echo.
echo เลือกลำดับการทดสอบที่ต้องการรัน:
echo [1] รันชุดทดสอบทั้งหมด (All Tests - Headless Mode)
echo [2] รันชุดทดสอบทั้งหมดแบบเปิดเบราว์เซอร์ (All Tests - Headed Mode)
echo [3] รันเฉพาะ Login Tests (TC01 - TC03)
echo [4] รันชุด Stock Management Codegen (TC-LOT-001 - TC-LOT-010)
echo [5] รันชุด Inventory Management UI Suite (TC-INV-001 - TC-INV-013)
echo [6] เปิดดูรายงานผลการทดสอบล่าสุด (Open HTML Report)
echo.
set /p choice="กรุณาเลือกตัวเลือก (1-6): "

if "%choice%"=="1" (
    echo [RUNNING] All Tests in Headless Mode...
    robot -d results --variable HEADLESS:True tests/login_tests.robot tests/stock_tests.robot tests/inventory_management_tests.robot
    pause
    exit /b
)
if "%choice%"=="2" (
    echo [RUNNING] All Tests in Headed Mode...
    robot -d results --variable HEADLESS:False tests/login_tests.robot tests/stock_tests.robot tests/inventory_management_tests.robot
    pause
    exit /b
)
if "%choice%"=="3" (
    echo [RUNNING] Login Tests...
    robot -d results --variable HEADLESS:True tests/login_tests.robot
    pause
    exit /b
)
if "%choice%"=="4" (
    echo [RUNNING] Stock Tests (TC-LOT-001 - TC-LOT-010)...
    robot -d results --variable HEADLESS:True tests/stock_tests.robot
    pause
    exit /b
)
if "%choice%"=="5" (
    echo [RUNNING] Inventory Management Tests (TC-INV-001 - TC-INV-013)...
    robot -d results --variable HEADLESS:True tests/inventory_management_tests.robot
    pause
    exit /b
)
if "%choice%"=="6" (
    echo [OPENING] Opening results/report.html...
    start results/report.html
    exit /b
)

echo [ERROR] ตัวเลือกไม่ถูกต้อง
pause
