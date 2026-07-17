# Golden Owl DevOps Internship - Technical Test Solution

 Dự án thực hiện các bước gồm: đóng gói container (Containerization), kiểm thử tự động (Automated Testing), tích hợp liên tục (CI) và triển khai liên tục (CD) bảo mật dạng serverless trên nền tảng 
 **Google Cloud Platform (GCP)**.

 **Live URL:** [https://goldenowl-app-2exnywcshq-as.a.run.app](https://goldenowl-app-2exnywcshq-as.a.run.app)

---

##  Tổng quan về Kiến trúc (Architecture Overview)

Kiến trúc hệ thống tận dụng một luồng pipeline bảo mật, hiện đại và có khả năng mở rộng cao được xây dựng hoàn toàn dựa trên **GitHub Actions** và **Google Cloud Platform (GCP)**.

![Sơ đồ kiến trúc](./architecture-diagram.png) 

### Trình tự vận hành của luồng (Workflow Sequence):
1. **Developer Push:** Lập trình viên đẩy mã nguồn mới lên kho lưu trữ GitHub.
2. **CI Stage (Test):** GitHub Actions kích hoạt một workflow runner để cài đặt các package phụ thuộc và thực hiện kiểm thử tự động (`npm test`).
3. **Containerization (Build):** Sau khi các bài test vượt qua thành công trên nhánh `main`, một Docker image tối ưu cho môi trường production sẽ được build bằng **Multi-stage Dockerfile**.
4. **Secure Push:** GitHub Actions xác thực với GCP thông qua cơ chế **Workload Identity Federation (WIF)** và push Docker image lên **Google Artifact Registry (GAR)**.
5. **CD Stage (Deployment):** GitHub Actions gọi API triển khai của **Google Cloud Run**, ra lệnh cho dịch vụ này kéo image mới nhất từ GAR về và khởi chạy container.
6. **Live Traffic:** Người dùng cuối truy cập ứng dụng Node.js một cách an toàn qua giao thức HTTPS thông qua bộ cân bằng tải (Load Balancer) toàn cầu được tích hợp sẵn của Cloud Run.

---

##  Các cấu phần đã triển khai 

### 1. Đóng gói Container với Multi-Stage Dockerfile
* **Nội dung thực hiện:** Xây dựng một `Dockerfile` gồm 2 giai đoạn (Giai đoạn 1: Build & Test sử dụng `node:18-alpine`; Giai đoạn 2: Runner tối giản cho Production).
* **Lý do lựa chọn:** 
  * **Bảo mật & Dung lượng tối ưu:** Bằng cách tách biệt các công cụ build và môi trường chạy test khỏi layer thực thi cuối cùng, kích thước image được giảm thiểu tối đa (sử dụng Alpine Linux) và thu hẹp các lỗ hổng bảo mật bề mặt.
  * **Nguyên lý Fail-Fast:** Các bài test tự động được chạy *ngay trong* quá trình build Docker ở Giai đoạn 1, ngăn chặn hoàn toàn việc mã nguồn lỗi bị đóng gói thành image.

### 2. Xác thực qua Workload Identity Federation (WIF)
* **Nội dung thực hiện:** Cấu hình GCP Workload Identity Federation kết hợp với một Service Account được chỉ định nhằm thiết lập mối quan hệ tin cậy giữa GitHub Actions và GCP thông qua OpenID Connect (OIDC), loại bỏ hoàn toàn việc sử dụng file Key JSON tĩnh.
* **Lý do lựa chọn:** 
  * **Tiêu chuẩn bảo mật hiện đại:** Các file Key JSON tĩnh của Service Account tiềm ẩn rủi ro bảo mật rất lớn nếu vô tình bị rò rỉ. WIF giúp loại bỏ hoàn toàn các thông tin xác thực dài hạn này.
  * **Nguyên tắc đặc quyền tối thiểu (Least Privilege):** Các token bảo mật ngắn hạn được sinh ra động cho mỗi lần pipeline chạy, kèm theo ràng buộc nghiêm ngặt `--attribute-condition` để đảm bảo duy nhất repository này mới có quyền mượn danh tài khoản.

### 3. Triển khai liên tục dạng Serverless qua Google Cloud Run
* **Lý do lựa chọn:** 
  * **Tự động Co giãn (Auto Scaling tích hợp):** Cloud Run đáp ứng trọn vẹn yêu cầu cốt lõi của bài test. Nó có khả năng tự động co giãn theo chiều ngang từ **0 đến N instances** dựa trên lượng request đồng thời, và tự động giảm về 0 khi không có traffic để tối ưu chi phí hạ tầng.
  * **Cân bằng tải toàn cầu & HTTPS tích hợp:** Cloud Run tự động xử lý chứng chỉ TLS/SSL và cung cấp sẵn một bộ HTTPS Load Balancer hoàn chỉnh. Điều này đảm bảo tính sẵn sàng cao mà không cần tốn công cấu hình thủ công các máy chủ ảo Compute Engine hay quản lý các reverse-proxy phức tạp như Nginx.

