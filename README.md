### Phần mềm xem công thức nấu ăn
----------------------------------------------------------------------------------------------------

Ứng dụng "Phần mềm xem công thức nấu ăn" là một ứng dụng di động được viết bằng Flutter. Đây là hướng dẫn về cách đóng gói và mở ứng dụng trên các thiết bị Android.

### Đóng gói ứng dụng

Để đóng gói ứng dụng "Phần mềm xem công thức nấu ăn" trên thiết bị Android, bạn có thể thực hiện các bước sau:

*   Mở Terminal và di chuyển đến thư mục gốc của dự án bằng lệnh `cd <đường_dẫn_đến_thư_mục_gốc_của_dự_án>`.
    
*   Chạy lệnh `flutter build apk` để tạo file APK của ứng dụng.
    
*   Sau khi thực hiện lệnh trên, Flutter sẽ tạo ra một file APK trong thư mục `build/app/outputs/apk` của dự án.
    
*   Để kiểm tra xem file APK đã được tạo thành công, bạn có thể di chuyển đến thư mục `build/app/outputs/apk` và kiểm tra xem file APK có tồn tại hay không.
    

### Mở ứng dụng

Sau khi đã đóng gói ứng dụng thành công, bạn có thể cài đặt và mở ứng dụng trên thiết bị Android bằng các bước sau:

*   Kết nối thiết bị Android của bạn với máy tính.
    
*   Sao chép file APK được tạo ra trong thư mục `build/app/outputs/apk` vào thiết bị Android của bạn.
    
*   Trên thiết bị Android, mở ứng dụng "Files" hoặc "Trình quản lý tệp tin" và tìm file APK đã sao chép.
    
*   Nhấp vào file APK để bắt đầu cài đặt ứng dụng.
    
*   Nếu yêu cầu, cho phép cài đặt ứng dụng từ nguồn không rõ bằng cách bật tùy chọn "Unknown sources" trong cài đặt thiết bị.
    
*   Sau khi hoàn tất quá trình cài đặt, bạn có thể mở ứng dụng bằng cách tìm kiếm ứng dụng "Phần mềm xem công thức nấu ăn" trong danh sách các ứng dụng trên thiết bị Android của bạn.
    

**Chú ý:** Để có thể đóng gói và mở ứng dụng thành công, bạn cần phải cài đặt Flutter và Android Studio. Bạn cũng cần phải cấu hình một số thiết lập cho dự án của mình, như cấu hình SDK và thiết bị đích để đảm bảo rằng ứng dụng của bạn được đóng gói và mở thành công trên các thiết bị di động Android.
