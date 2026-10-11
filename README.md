# StoreMate Robot Framework Test Suite

โปรเจกต์ทดสอบอัตโนมัติของระบบ **StoreMate** (https://storemate-final.vercel.app/) ด้วย **Robot Framework**

---

## ข้อมูลบัญชีและสภาพแวดล้อมที่ใช้ทดสอบ (Test Environment & Account)

- **URL เว็บไซต์**: https://storemate-final.vercel.app/
- **บัญชีทดสอบ**:
  - **Email**: `aomezzz.aomsin@gmail.com`
  - **Password**: `Aomezzz_007`
- **ระบบปฏิบัติการ / เครื่องมือ**: Windows, Python 3.13, Robot Framework 7.5, SeleniumLibrary 6.9

---

## โครงสร้างโปรเจกต์ (Project Structure)

```
1-robot-storemate/
├── venv/                              # Python Virtual Environment
├── tests/                             # Test Suites (.robot)
│   ├── test-stocks.robot              # ชุดทดสอบระบบจัดการสินค้าในคลัง (10 Test Cases ตาม Spec)
│   ├── test_login.robot               # ชุดทดสอบระบบเข้าสู่ระบบ (Login)
│   ├── test_sample.robot              # ชุดทดสอบพื้นฐานเริ่มต้น
│   └── fixtures/                      # ไฟล์ข้อมูลทดสอบ (Test Fixtures)
│       ├── product_spec.xlsx          # ไฟล์ xlsx สำหรับทดสอบแนบไฟล์
│       ├── large_file.xlsx            # ไฟล์จำลองขนาดเกิน 5 MB
│       └── executable.exe             # ไฟล์จำลองนามสกุลไม่รองรับ
├── resources/                         # Reusable Keywords & Locators
│   ├── storemate_keywords.robot       # คีย์เวิร์ดและ Selector สำหรับ StoreMate
│   └── keywords.robot                 # คีย์เวิร์ดส่วนกลาง
├── results/                           # รายงานผลการรันทดสอบ
│   ├── report.html                    # รายงานผลสรุป (เปิดดูใน Browser)
│   ├── log.html                       # บันทึกรายละเอียดการรันทุก Step
│   ├── login-success.png              # ภาพแคปหน้าจอเมื่อล็อกอินสำเร็จ
│   └── stock-tc001-added.png          # ภาพแคปหน้าจอการจัดการสินค้า
├── requirements.txt                   # รายการ dependencies
└── .gitignore                         # กำหนดไฟล์ที่ไม่ต้องขึ้น Git
```

---

## ชุดทดสอบที่มี (Test Cases)

### 1. [tests/test-stocks.robot](tests/test-stocks.robot) (โมดูล จัดการสินค้าในคลัง)
ครอบคลุมครบทั้ง 10 กรณีทดสอบตามเอกสาร **Test Case Specification (SPRS - Storemate Ecommerce)**:
- **TC-LOT-001**: เพิ่มสินค้าในคลังใหม่สำเร็จผ่าน Modal Popup (Positive Test)
  - ข้อมูลทดสอบ: ชื่อ `สบู่สมุนไพรไหมทอง`, หมวดหมู่ `สบู่`, ราคา `85`, จำนวน `100`, สถานะ `พร้อมจำหน่าย`, แนบไฟล์ `product_spec.xlsx`
- **TC-LOT-002**: เพิ่มสินค้าโดยไม่กรอกชื่อสินค้า (Negative Test)
- **TC-LOT-003**: ไม่เลือกหมวดหมู่สินค้า (Negative Test)
- **TC-LOT-004**: ราคาสินค้าไม่ถูกต้อง เช่น กรอกค่าติดลบ `-50` (Negative Test)
- **TC-LOT-005**: จำนวนสินค้าไม่ถูกต้อง เช่น กรอกค่าติดลบ `-10` (Negative Test)
- **TC-LOT-006**: อัปโหลดรูปภาพหรือไฟล์ไม่ถูกต้อง เช่น ไฟล์ขนาดเกิน 5 MB หรือนามสกุล `.exe` (Negative Test)
- **TC-LOT-007**: แก้ไขข้อมูลสินค้าสำเร็จ ปรับจำนวนเป็น `50` และสถานะเป็น `ไม่พร้อมจำหน่าย` (Positive Test)
- **TC-LOT-008**: ลบสินค้าที่ไม่มีประวัติใช้งาน (Positive Test)
- **TC-LOT-009**: ลบสินค้าที่มีประวัติใช้งาน (Negative / Business Rule Test)
- **TC-LOT-010**: ค้นหาสินค้าด้วยชื่อ คำค้นหา `สบู่` (พบข้อมูล) และ `ไม่มีสินค้านี้ในระบบ` (ไม่พบข้อมูล) (Positive & Negative Test)

### 2. [tests/test_login.robot](tests/test_login.robot) (โมดูล เข้าสู่ระบบ)
- **TC01 - Login With Valid Credentials Should Succeed**: เข้าสู่ระบบสำเร็จและ redirect ไปยังหน้า Dashboard
- **TC02 - Login With Invalid Password Should Fail**: กรอกรหัสผ่านผิดและไม่สามารถเข้าสู่ระบบได้
- **TC03 - Login With Empty Password Should Show Validation**: เว้นว่างรหัสผ่าน

---

## รวมคำสั่งในการรันเทส (Test Execution Commands)

รันคำสั่งเหล่านี้ผ่าน **PowerShell** หรือ Terminal ในโฟลเดอร์โปรเจกต์:

### 1. รันชุดทดสอบจัดการสินค้า (Stock Management)
```powershell
# รันแบบ Headless (ไม่เปิดหน้าต่างเบราว์เซอร์ - ค่าเริ่มต้น)
.\venv\Scripts\robot.exe -d results tests/test-stocks.robot

# รันแบบเปิดหน้าต่าง Chrome ดูขั้นตอนการทำงานจริง (Headed Mode)
.\venv\Scripts\robot.exe -d results -v HEADLESS:false tests/test-stocks.robot
```

### 2. รันชุดทดสอบเข้าสู่ระบบ (Login)
```powershell
# รันแบบ Headless
.\venv\Scripts\robot.exe -d results tests/test_login.robot

# รันแบบเปิดหน้าต่าง Chrome (Headed Mode)
.\venv\Scripts\robot.exe -d results -v HEADLESS:false tests/test_login.robot
```

### 3. รันเทสทั้งหมดในโปรเจกต์พร้อมกัน
```powershell
# รันทุกไฟล์เทสในโฟลเดอร์ tests/
.\venv\Scripts\robot.exe -d results tests/
```

### 4. รันเจาะจงเฉพาะ Test Case หรือ Tag ที่ต้องการ
```powershell
# รันเฉพาะ Test Case ที่ต้องการ (เช่น TC-LOT-001)
.\venv\Scripts\robot.exe -d results -t "TC-LOT-001*" tests/test-stocks.robot

# รันเฉพาะกลุ่ม Positive Tests
.\venv\Scripts\robot.exe -d results -i positive tests/test-stocks.robot

# รันเฉพาะกลุ่ม Negative Tests
.\venv\Scripts\robot.exe -d results -i negative tests/test-stocks.robot

# รันเฉพาะกลุ่ม Smoke Tests
.\venv\Scripts\robot.exe -d results -i smoke tests/
```

---

## การดูรายงานผลการทดสอบ (Reports & Evidence)

หลังจากรันเสร็จแล้ว สามารถเปิดไฟล์ดูผ่านเว็บเบราว์เซอร์ได้ทันที:
- **Report สรุปผลภาพรวม (สวยงาม):** [results/report.html](results/report.html)
- **Log รายละเอียดการทำงานทุกขั้นตอน:** [results/log.html](results/log.html)
- **หลักฐานรูปภาพหน้าจอ:**
  - เข้าสู่ระบบสำเร็จ: [results/login-success.png](results/login-success.png)
  - เพิ่มสินค้าสำเร็จ: [results/stock-tc001-added.png](results/stock-tc001-added.png)
