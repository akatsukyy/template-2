Trivy là một công cụ quét bảo mật đa năng, hỗ trợ phát hiện:
- Lỗ hổng 
- Cấu hình sai
- Lộ secrets
- Kiểm tra giấy phép phần mềm (Licenses) trên nhiều đối tượng khác nhau
---

## 1. Đối tượng quét (Scanning Targets)

Trivy cung cấp các lệnh CLI riêng biệt cho từng loại:

### a. Quét Container Image
Kiểm tra các lỗ hổng trong hệ điều hành (OS) và gói ngôn ngữ lập trình bên trong image.
*   **Câu lệnh:** `trivy image [IMAGE_NAME]`
*   **Ví dụ:** `trivy image python:3.9`
*   **Quét Image từ Registry riêng:**
    *   `trivy registry login [REGISTRY_URL]`
    *   Hỗ trợ: Docker Hub, AWS ECR, GCR, ACR, và Self-hosted registries

### b. Quét Hệ thống tệp (Filesystem) và Kho mã nguồn (Repository)
Dùng để kiểm tra mã nguồn cục bộ hoặc các project trên GitHub/GitLab.
*   **Quét thư mục cục bộ:** `trivy fs [PATH]` (Ví dụ: `trivy fs /path/to/project`)
*   **Quét kho mã nguồn:** `trivy repo [URL]` (Ví dụ: `trivy repo https://github.com/user/repo`)
### c. Quét Cấu hình sai (IaC & Config)
Phát hiện các lỗi thiết lập trong các tệp Infrastructure as Code (IaC).
*   **Câu lệnh:** `trivy config [PATH]`
*   **Định dạng hỗ trợ:** Terraform, CloudFormation, Ansible, Helm, Docker, và Kubernetes

### d. Quét Virtual Machine Image
Trivy có khả năng quét các vm image để tìm kiếm lỗ hổng và các cấu hình không an toàn
*   **Câu lệnh:** `trivy vm [IMAGE_NAME]`
*   **Mục đích:** Kiểm tra bảo mật cho các tệp tin hình ảnh máy ảo trước khi triển khai trong môi trường ảo hóa.

### e. Quét Cụm Kubernetes
Quét các tài nguyên đang chạy trong cụm để tìm rủi ro bảo mật.
*   **Câu lệnh:** `trivy k8s [CLUSTER_OR_RESOURCE]`
*   **Tích hợp:** Có thể quét toàn bộ Cluster hoặc một Resource cụ thể

### f. Quét Rootfs (Root File System)
Dùng để quét các hệ thống tệp tin gốc đã được giải nén, thường là từ các container runtime hoặc môi trường chroot.
*   **Câu lệnh:** `trivy rootfs [PATH]`
*   **Ví dụ:** `trivy rootfs /mnt/container-rootfs`
*   **Ứng dụng:** Kiểm tra bảo mật cho các "unpacked container image filesystem"

---

## 2. Cấu hình các bộ quét (Scanners Configuration)

Trivy cho phép bật/tắt hoặc tinh chỉnh các loại quét thông qua các cờ (flags) hoặc tệp cấu hình

*   **Vulnerability Scan:** Mặc định luôn bật để tìm lỗi CVE.
*   **Misconfiguration Scan:** Kiểm tra các chính sách (Policy) dựa trên các quy tắc có sẵn (Built-in) hoặc tùy chỉnh bằng ngôn ngữ **Rego**.
*   **Secret Scanning:** Tìm kiếm mật khẩu, API keys bị lộ trong mã nguồn.
*   **License Scanning:** Kiểm tra giấy phép của các thư viện phụ thuộc để đảm bảo tuân thủ.

---

## 3. Chế độ vận hành (Operational Modes)   

Bạn có thể chạy Trivy theo hai mô hình chính:

1.  **Standalone (Độc lập):** Máy quét tự tải cơ sở dữ liệu lỗ hổng và thực hiện quét trực tiếp.
2.  **Client/Server:**
    *   **Server:** Chạy một máy chủ tập trung để lưu trữ cơ sở dữ liệu: `trivy server`.
    *   **Client:** Máy khách gửi yêu cầu quét tới server: `trivy client --remote [SERVER_URL] image [IMAGE_NAME]`.

---

## 4. Quản lý Chuỗi cung ứng phần mềm (SBOM & VEX)

*   **Tạo SBOM:** Trivy hỗ trợ tạo danh mục thành phần phần mềm (SBOM) để quản lý phụ thuộc.
    *   Lệnh: `trivy sbom [PATH_TO_SBOM]`.
*   **VEX (Vulnerability Exploitability eXchange):** Sử dụng các tệp VEX để xác định xem một lỗ hổng có thực sự gây nguy hiểm trong ngữ cảnh sử dụng của bạn hay không.
    *   Hỗ trợ: Local VEX files, VEX Repository.

---

## 5. Tích hợp CI/CD và Báo cáo

*   **Hệ thống hỗ trợ:** GitHub Actions, GitLab CI, CircleCI, Travis CI, AWS CodePipeline, Azure, v.v.
*   **Định dạng báo cáo (Reporting):** Có thể cấu hình để xuất kết quả ra các định dạng khác nhau phục vụ báo cáo hoặc xử lý tự động.
*   **Lọc kết quả (Filtering):** Sử dụng tệp cấu hình để bỏ qua các lỗ hổng không mong muốn hoặc các tệp tin cụ thể.

---

## 6. Các lệnh CLI nâng cao thường dùng

*   `trivy clean`: Xóa bộ nhớ đệm (cache).
*   `trivy convert`: Chuyển đổi định dạng báo cáo.
*   `trivy plugin install [URL]`: Cài đặt thêm các tính năng mở rộng.
*   `trivy version`: Kiểm tra phiên bản hiện tại.

## 7. Test Result
### a. Trivy repo

![alt text](image-1.png)
![alt text](image-2.png)