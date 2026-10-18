# StoreMate Robot Framework Test Suite (SeleniumLibrary)

โปรเจกต์ทดสอบอัตโนมัติแบบ End-to-End (E2E) สำหรับระบบ **StoreMate** (https://storemate-final.vercel.app/) พัฒนาด้วย **Robot Framework** และ **SeleniumLibrary** โดยออกแบบสถาปัตยกรรมตามรูปแบบ **Page Object / Resource Pattern (Keyword-Driven Framework)** รองรับการทดสอบทั้งแบบ Headless Mode และ Headed Mode พร้อมระบบรายงานผลแบบ Interactive HTML Report (`report.html` และ `log.html`)

---

## ⚡ Quick Start (เริ่มต้นใช้งานใน 3 ขั้นตอน)

หากติดตั้ง Python 3.10+ และ Google Chrome เรียบร้อยแล้ว สามารถเริ่มรันได้ทันที:

```powershell
# 1. ติดตั้ง Dependencies
pip install -r requirements.txt

# 2. คัดลอก Environment Variables
copy .env.example .env

# 3. สั่งรันการทดสอบทั้งหมด (Headless Mode)
robot -d results --variable HEADLESS:True tests/login_tests.robot tests/stock_tests.robot tests/inventory_management_tests.robot
```

---

## 1. ข้อมูลระบบและบัญชีทดสอบ (Test Environment & Credentials)

- **URL เว็บไซต์**: `https://storemate-final.vercel.app/`
- **บัญชีทดสอบ (Admin / Moderator)**:
  - **Email**: `aomezzz.aomsin@gmail.com`
  - **Password**: `Aomezzz_007`
- **ความต้องการของระบบ (Prerequisites)**:
  - Python 3.10 ขึ้นไป (ทดสอบแล้วบน Python 3.13)
  - Google Chrome หรือ Microsoft Edge Browser ติดตั้งในเครื่อง
  - ติดตั้งแพ็กเกจ Python ตามไฟล์ `requirements.txt`

---

## 2. ขั้นตอนการติดตั้งอย่างละเอียด (Detailed Installation)

### ขั้นตอนที่ 1: ตรวจสอบเวอร์ชัน Python
เปิด Terminal หรือ Command Prompt แล้วตรวจสอบเวอร์ชัน Python:
```bash
python --version
# หรือ
py --version
```
*(ต้องเป็น Python 3.10 ขึ้นไป)*

---

### ขั้นตอนที่ 2: (แนะนำ) สร้างและเปิดใช้งาน Virtual Environment (venv)
เพื่อป้องกันไม่ให้แพ็กเกจชนกับระบบอื่นในเครื่อง แนะนำให้สร้างสภาพแวดล้อมเสมือนก่อน:

#### บน Windows (PowerShell):
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```
> *หมายเหตุ: หากพบปัญหา Execution Policy บน PowerShell ให้รัน: `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` แล้วเปิดใช้งานใหม่อีกครั้ง*

#### บน Windows (Command Prompt):
```cmd
python -m venv venv
.\venv\Scripts\activate.bat
```

#### บน macOS / Linux:
```bash
python3 -m venv venv
source venv/bin/activate
```

---

### ขั้นตอนที่ 3: ติดตั้ง Dependencies ทั้งหมด
รันคำสั่งติดตั้งผ่านไฟล์ `requirements.txt`:
```bash
pip install -r requirements.txt
```

หรือหากต้องการติดตั้งด้วยตนเองทีละแพ็กเกจ:
```bash
pip install robotframework==7.2.2
pip install robotframework-seleniumlibrary==6.7.1
pip install selenium==4.30.0
pip install webdriver-manager==4.0.2
pip install python-dotenv==1.0.1
```

---

### ขั้นตอนที่ 4: ตั้งค่า Environment Variables
คัดลอกไฟล์ `.env.example` ไปเป็น `.env`:

#### บน Windows (PowerShell):
```powershell
Copy-Item .env.example .env
```

#### บน Windows (Command Prompt):
```cmd
copy .env.example .env
```

#### บน macOS / Linux:
```bash
cp .env.example .env
```

เนื้อหาภายในไฟล์ `.env`:
```env
BASE_URL=https://storemate-final.vercel.app
VALID_EMAIL=aomezzz.aomsin@gmail.com
VALID_PASSWORD=Aomezzz_007
```

---

## 3. คำสั่งสำหรับการรันการทดสอบ (Test Execution Commands)

เลือกวิธีรันได้ 3 รูปแบบตามความสะดวก:

### วิธีที่ 1: รันผ่าน Interactive Runner Menu (`run_tests.bat`) (ง่ายที่สุดบน Windows)
ดับเบิลคลิกไฟล์ `run_tests.bat` หรือเปิดผ่าน Command Prompt:
```cmd
.\run_tests.bat
```
จะมีเมนูให้เลือกหมายเลข:
- `[1]` รันชุดทดสอบทั้งหมด (All Tests - Headless Mode)
- `[2]` รันชุดทดสอบทั้งหมดแบบเปิดเบราว์เซอร์จริง (All Tests - Headed Mode)
- `[3]` รันเฉพาะ Login Tests (TC01 - TC03)
- `[4]` รันชุด Stock Management (TC-LOT-001 - TC-LOT-010)
- `[5]` รันชุด Inventory Management UI Suite (TC-INV-001 - TC-INV-013)
- `[6]` เปิดดูรายงานผล HTML ล่าสุดทันที

---

### วิธีที่ 2: รันผ่าน Robot Framework CLI (Command Line)

#### 2.1 รันการทดสอบทั้งหมด (All 26 Test Cases)
```bash
# รันแบบ Headless Mode (เบื้องหลัง ไม่แสดงหน้าต่างเบราว์เซอร์ - รวดเร็ว เหมาะกับ CI/CD)
robot -d results --variable HEADLESS:True tests/login_tests.robot tests/stock_tests.robot tests/inventory_management_tests.robot

# รันแบบ Headed Mode (เปิดหน้าต่างเบราว์เซอร์จริงขึ้นมาให้เห็นการทำงาน)
robot -d results --variable HEADLESS:False tests/login_tests.robot tests/stock_tests.robot tests/inventory_management_tests.robot
```

#### 2.2 รันแยกตาม Test Suite (ไฟล์ทดสอบ)
```bash
# รันเฉพาะชุด Login (3 Test Cases)
robot -d results --variable HEADLESS:True tests/login_tests.robot

# รันเฉพาะชุด Stock Management (10 Test Cases: TC-LOT-001 ถึง TC-LOT-010)
robot -d results --variable HEADLESS:True tests/stock_tests.robot

# รันเฉพาะชุด Inventory Management UI Suite (13 Test Cases: TC-INV-001 ถึง TC-INV-013)
robot -d results --variable HEADLESS:True tests/inventory_management_tests.robot
```

#### 2.3 รันเฉพาะ Test Case ที่ระบุ (Filtering by Test Name)
```bash
# รันเฉพาะเคส TC-LOT-001 (เพิ่มสินค้าใหม่สำเร็จ)
robot -d results --variable HEADLESS:False -t "TC-LOT-001: เพิ่มสินค้าใหม่สำเร็จ" tests/stock_tests.robot

# รันแบบใช้ Wildcard (เช่น รันทุกเคสที่ขึ้นต้นด้วย TC-INV-001)
robot -d results --variable HEADLESS:True -t "TC-INV-001*" tests/inventory_management_tests.robot
```

#### 2.4 รันตาม Tags (Filtering by Tags)
```bash
# รันเฉพาะเคสที่มีแท็ก Smoke
robot -d results -i Smoke tests/login_tests.robot tests/stock_tests.robot

# รันเฉพาะเคสที่มีแท็ก Regression
robot -d results -i Regression tests/login_tests.robot tests/stock_tests.robot

# รันเฉพาะเคส Negative Tests
robot -d results -i Negative tests/login_tests.robot tests/stock_tests.robot
```

#### 2.5 ปรับแต่งตัวแปรผ่าน CLI (Variable Overrides)
```bash
# สลับเบราว์เซอร์เป็น Microsoft Edge (ค่าเริ่มต้นคือ chrome)
robot -d results --variable BROWSER:edge tests/login_tests.robot

# เปลี่ยน Timeout จากเดิม 15s เป็น 30s
robot -d results --variable TIMEOUT:30s tests/login_tests.robot

# เปลี่ยน URL เป้าหมายในการทดสอบ
robot -d results --variable BASE_URL:https://storemate-final.vercel.app tests/login_tests.robot
```

---

### วิธีที่ 3: รันผ่าน `npm` Scripts (สำหรับผู้ที่คุ้นเคยกับคำสั่งเดิม)
หากมี Node.js ติดตั้งไว้ สามารถใช้ npm scripts ได้ทันที:

```bash
# รันการทดสอบทั้งหมด (Headless)
npm test

# รันเฉพาะแต่ละชุด
npm run test:login    # ชุด Login
npm run test:stock    # ชุด Stock Management
npm run test:inv      # ชุด Inventory Management

# รันแบบเปิดหน้าต่างเบราว์เซอร์ (Headed)
npm run test:headed

# เปิดดูรายงานผลการทดสอบล่าสุด
npm run test:report
```

---

## 4. โครงสร้างโปรเจกต์ (Project Structure)

```
1-robot-storemate/
├── resources/                             # Resource Files (Keywords & Page Objects)
│   ├── common.resource                    # จัดการเปิด-ปิดเบราว์เซอร์, Chrome Options, ถ่ายภาพ Screenshot
│   ├── login_keywords.resource            # Keywords & Locators สำหรับระบบ Login และ Dashboard
│   └── stock_keywords.resource            # Keywords สำหรับจัดการสินค้า, Form inputs, Search และ React dispatchers
├── tests/                                 # ชุดการทดสอบอัตโนมัติ (.robot)
│   ├── login_tests.robot                  # ชุดทดสอบระบบเข้าสู่ระบบ (TC01 - TC03)
│   ├── stock_tests.robot                  # ชุดทดสอบจัดการสต็อกตามข้อกำหนด (TC-LOT-001 ถึง TC-LOT-010)
│   ├── inventory_management_tests.robot   # ชุดทดสอบระบบจัดการสินค้าครบวงจร (TC-INV-001 ถึง TC-INV-013)
│   └── fixtures/                          # ไฟล์ทดสอบ (Mock files)
│       ├── sample_product.png             # ไฟล์รูปภาพ PNG ตัวอย่าง
│       ├── large_image.png                # ไฟล์จำลองขนาดเกิน 5 MB
│       └── executable.exe                 # ไฟล์จำลองนามสกุลไม่รองรับ (.exe)
├── sabu.jpg                               # ไฟล์รูปภาพสินค้าทดสอบ "สบู่มะม่วง"
├── results/                               # ผลลัพธ์และรายงานผลการทดสอบ
│   ├── report.html                        # สรุปผลการทดสอบระดับภาพรวม (Summary Report)
│   ├── log.html                           # รายละเอียด Log ทุกขั้นตอนของ Keyword พร้อมแทรกภาพ
│   ├── output.xml                         # ข้อมูลดิบสำหรับประมวลผลต่อบน CI/CD
│   └── screenshots/                       # ภาพบันทึกหน้าจอขณะรันเคสทดสอบ
├── requirements.txt                       # รายการ Python dependencies สำหรับติดตั้ง
├── run_tests.bat                          # Batch script เมนูลัดสำหรับรันบน Windows
├── package.json                           # Runner scripts ผ่าน npm
├── .env.example                           # ตัวอย่างการตั้งค่า Environment Variables
└── .env                                   # ไฟล์คอนฟิก Environment Variables จริง
```

---

## 5. รายการชุดการทดสอบทั้งหมด (Test Suite Coverage - 26 Cases)

### 5.1 Login Suite (`tests/login_tests.robot` - 3 Test Cases)
| รหัสเคส | ชื่อเคสการทดสอบ | ประเภท | แท็ก (Tags) |
|---|---|---|---|
| **TC01** | Login With Valid Credentials Should Succeed | Positive | `Smoke`, `Regression`, `Login` |
| **TC02** | Login With Invalid Password Should Fail | Negative | `Negative`, `Login` |
| **TC03** | Login With Empty Password Should Show Validation | Negative | `Negative`, `Login` |

### 5.2 Stock Management Suite (`tests/stock_tests.robot` - 10 Test Cases)
| รหัสเคส | ชื่อเคสการทดสอบ | ประเภท | แท็ก (Tags) |
|---|---|---|---|
| **TC-LOT-001** | เพิ่มสินค้าใหม่สำเร็จ | Positive | `Stock`, `Positive`, `Smoke` |
| **TC-LOT-002** | เพิ่มสินค้าโดยไม่กรอกชื่อสินค้า | Negative | `Stock`, `Negative`, `Validation` |
| **TC-LOT-003** | ไม่เลือกหมวดหมู่สินค้า | Negative | `Stock`, `Negative`, `Validation` |
| **TC-LOT-004** | กรอกราคาสินค้าไม่ถูกต้อง | Negative | `Stock`, `Negative`, `Validation` |
| **TC-LOT-005** | กรอกจำนวนสินค้าไม่ถูกต้อง | Negative | `Stock`, `Negative`, `Validation` |
| **TC-LOT-006** | อัปโหลดรูปภาพไม่ถูกต้อง (.exe และ > 5MB) | Negative | `Stock`, `Negative`, `Upload` |
| **TC-LOT-007** | แก้ไขข้อมูลสินค้าสำเร็จ | Positive | `Stock`, `Positive`, `Regression` |
| **TC-LOT-008** | ลบสินค้าที่ไม่มีประวัติใช้งาน | Positive | `Stock`, `Positive`, `Delete` |
| **TC-LOT-009** | ลบสินค้าที่มีประวัติใช้งาน (ป้องกันการลบตามกฎธุรกิจ) | Negative | `Stock`, `Negative`, `BusinessRule` |
| **TC-LOT-010** | ค้นหาสินค้าด้วยชื่อ (พบสินค้า และกรณีไม่พบสินค้า) | Positive | `Stock`, `Positive`, `Search` |

### 5.3 Inventory Management UI Suite (`tests/inventory_management_tests.robot` - 13 Test Cases)
| รหัสเคส | ชื่อเคสการทดสอบ | ประเภท |
|---|---|---|
| **TC-INV-001** | เปิด Modal เพิ่มสินค้า และตรวจสอบ Field ต่างๆ | UI / Sanity |
| **TC-INV-002** | เพิ่มสินค้าสำเร็จ และตรวจสอบข้อมูลในตาราง | End-to-End |
| **TC-INV-003** | Required Field Validation (เว้นว่างทั้งหมด หรือกรอกเฉพาะช่องว่าง) | Validation |
| **TC-INV-004** | Numeric Validation (ราคาติดลบ, จำนวนติดลบ, ค่า 0) | Validation |
| **TC-INV-005** | Image Upload Validation (PNG, JPG, .exe, ขนาดเกิน 5MB) | File Upload |
| **TC-INV-006** | Cancel Modal และตรวจสอบการ Reset ข้อมูล | UI Behavior |
| **TC-INV-007** | Search Functionality (ค้นหาด้วยชื่อ, รหัสสินค้า, และ Empty State) | Search |
| **TC-INV-008** | Duplicate Submission Prevention (ป้องกันการกดซ้ำ) | Boundary / UI |
| **TC-INV-009** | Data Integrity (ตรวจสอบข้อมูลคงอยู่หลัง Reload หน้าเว็บ) | Data Integrity |
| **TC-INV-010** | Incomplete Form Validation Message Position & Disappearance | Toast / UI |
| **TC-INV-011** | Successful Product Creation Notification | Notification |
| **TC-INV-012** | Error Notification Checks (Inline & Toast) | Notification |
| **TC-INV-013** | Notification Locator, CSS Class และ Auto-dismiss Assertions | UI Timing |

---

## 6. การเปิดดูรายงานผลการทดสอบ (Interactive HTML Reports)

หลังจากรันการทดสอบเสร็จสิ้น Robot Framework จะสร้างรายงานในโฟลเดอร์ `results/`:
- **`results/report.html`**: รายงานสรุปภาพรวม สถิติ Pass/Fail กราฟ และเวลารวม
- **`results/log.html`**: รายงานระดับเจาะลึก แสดงทุก Keyword ค่า Arguments และภาพจับหน้าจอ (Screenshot)
- **`results/screenshots/`**: ไฟล์ภาพหน้าจอจุดทดสอบสำคัญและเมื่อเกิดข้อผิดพลาด

### คำสั่งเปิดดูผลลัพธ์ผ่าน Terminal:

#### บน Windows (PowerShell):
```powershell
Start-Process results/report.html
Start-Process results/log.html
```

#### บน Windows (Command Prompt):
```cmd
start results/report.html
start results/log.html
```

#### บน macOS:
```bash
open results/report.html
open results/log.html
```

#### บน Linux:
```bash
xdg-open results/report.html
xdg-open results/log.html
```
