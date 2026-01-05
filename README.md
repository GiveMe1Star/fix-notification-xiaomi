# 🔔 Xiaomi Notification Fix Tool (v6.3.0)

Công cụ sửa lỗi thông báo (notification) trên điện thoại Xiaomi bằng cách thêm ứng dụng vào whitelist, giúp các app nhận thông báo đúng cách.

> **Tác giả:** LE MINH CUONG

---

## ⚠️ Cảnh báo & Miễn trừ trách nhiệm

> [!CAUTION]
> **VUI LÒNG ĐỌC KỸ TRƯỚC KHI SỬ DỤNG**

Việc sử dụng công cụ này có thể gây ra các vấn đề sau:

| Rủi ro | Mô tả |
|--------|-------|
| 🔋 **Tốn pin** | Whitelist ứng dụng có thể khiến chúng chạy nền nhiều hơn, tiêu tốn pin |
| ⚡ **Xung đột** | Có thể xung đột với các cài đặt hệ thống hoặc ROM tùy chỉnh |
| 💀 **Brick** | Trong trường hợp hiếm, có thể gây lỗi hệ thống (soft-brick) |

> [!WARNING]
> **TÁC GIẢ KHÔNG CHỊU TRÁCH NHIỆM** cho bất kỳ thiệt hại nào xảy ra với thiết bị của bạn khi sử dụng công cụ này. Bạn tự chịu rủi ro khi sử dụng.

---

## ✨ Tính năng

- ✅ Hỗ trợ **61+ ứng dụng** phổ biến (ngân hàng, mạng xã hội, OTT...)
- ✅ Tự động nhận diện **ROM Trung Quốc** và áp dụng cài đặt đặc biệt
- ✅ Whitelist đầy đủ: package, process, service
- ✅ Tối ưu GMS Check-in timeout
- ✅ Giao diện menu đơn giản, dễ sử dụng

---

## 📋 Danh sách ứng dụng hỗ trợ

| Loại | Ứng dụng |
|------|----------|
| **Google** | GMS, GSF, Gmail, YouTube, Chrome, Android Auto |
| **Ngân hàng VN** | Agribank, BIDV, MB Bank, Vietcombank, VietinBank, Techcombank, TPBank, VPBank, VIB, SHB |
| **Ví điện tử** | MoMo, VNPay, ViettelPay |
| **Chat/OTT** | Zalo, Messenger, Telegram, WhatsApp, Viber, Discord, Line, Skype, WeChat |
| **Mạng xã hội** | Facebook, Instagram, Twitter/X, LinkedIn, TikTok |
| **Khác** | Grab, Shopee, Lazada, FPT Play, VTV Go, Outlook, Teams |

---

## 🛠️ Yêu cầu

1. **Điện thoại Xiaomi** (MIUI/HyperOS)
2. **Bật USB Debugging** trên điện thoại:
   - Vào **Cài đặt → Giới thiệu điện thoại → Nhấn 7 lần vào "Phiên bản MIUI"**
   - Vào **Cài đặt → Cài đặt bổ sung → Tùy chọn nhà phát triển**
   - Bật **USB Debugging** (và **USB Debugging (Security settings)** nếu có)
3. **Kết nối USB** điện thoại với máy tính
4. **Windows** (đã bao gồm sẵn ADB trong thư mục)

---

## 🚀 Hướng dẫn sử dụng

### Bước 1: Kết nối điện thoại
- Cắm cáp USB giữa điện thoại và máy tính
- Mở khóa màn hình điện thoại
- Nếu xuất hiện popup "Cho phép USB Debugging", chọn **OK**

### Bước 2: Chạy công cụ
- Nhấn đúp vào file adb\adb.exe
- Nhấn đúp vào file `FIX_NOTIFICATION_XIAOMI.bat`

### Bước 3: Chọn ứng dụng
```
Ví dụ nhập:
  0           → Whitelist TẤT CẢ 61 ứng dụng
  1 2 3       → Google Services + Framework + Account
  8 22 24     → Agribank + MB Bank + MoMo
  55 36 13    → Zalo + Telegram + Discord
  X           → Thoát
```

### Bước 4: Cài đặt GMS Check-in (khuyến nghị)
- Chọn **3** (3 phút) để tối ưu nhận thông báo
- Hoặc **0** để bỏ qua

### Bước 5: Khởi động lại
- Nhấn **Y** để khởi động lại điện thoại và áp dụng thay đổi

---

## ⚠️ Lưu ý cho ROM Trung Quốc

Nếu sử dụng ROM Trung Quốc, sau khi chạy tool cần kiểm tra thêm:

1. Vào **Cài đặt → Ứng dụng → Chọn app đã whitelist**
2. Chọn **"Battery saver" → "No restrictions"**
3. Bật **"Auto-start"** trong App settings
4. Kiểm tra thông báo có hoạt động không

---

## 📁 Cấu trúc thư mục

```
fix noti/
├── FIX_NOTIFICATION_XIAOMI.bat  # Script chính
├── LICENSE                      # MIT License
├── NOTICE.txt                   # Thông tin bản quyền
├── README.md                    # File này
└── adb/                         # Thư mục ADB tools
    ├── adb.exe                  # Android Debug Bridge (nhấn đúp để chạy)
    ├── AdbWinApi.dll            # ADB Windows API
    ├── AdbWinUsbApi.dll         # ADB USB API
    ├── fastboot.exe             # Fastboot tool
    └── LICENSE                  # Apache 2.0 License
```

---

## ❓ Xử lý lỗi thường gặp

| Lỗi | Giải pháp |
|-----|-----------|
| **Không tìm thấy thiết bị** | Kiểm tra cáp USB, bật USB Debugging, mở khóa màn hình |
| **Thiết bị unauthorized** | Chấp nhận popup "Cho phép USB Debugging" trên điện thoại |
| **Thông báo vẫn không nhận** | Chạy lại tool, chọn đúng app, restart điện thoại |
| **ROM Trung Quốc vẫn lỗi** | Làm theo hướng dẫn thủ công ở phần "Lưu ý cho ROM Trung Quốc" |

---

## 📜 License

Dự án này sử dụng **2 license**:

| Thành phần | License | File |
|------------|---------|------|
| Script & Công cụ | MIT License | [LICENSE](./LICENSE) |
| ADB Tools (Google) | Apache License 2.0 | [adb/LICENSE](./adb/LICENSE) |

© 2025 **LE MINH CUONG** - Script chính

© 2023 **The Android Open Source Project** - ADB Tools
