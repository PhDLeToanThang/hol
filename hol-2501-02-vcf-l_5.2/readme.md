# HOL-2501-02-VCF-L_5.2: VMware Cloud Foundation Operations - Getting More Out of It!

## Lab Overview

- **Mã học phần:** HOL-2501-02-VCF-L_5.2
- **Tên mô-đun thực hành:** VCF Operations - Getting More Out of It!
- **Phiên bản:** VMware Aria Operations 8.18 / VCF 5.2
- **Năm:** 2024
- **Tổng số trang:** 827
- **Thời gian ước tính:** 8+ giờ (tổng hợp 18 modules)

## Mục tiêu

Khám phá các tính năng nâng cao của VMware Aria Operations trong môi trường VMware Cloud Foundation (VCF), bao gồm:

- Mở rộng giám sát với Management Packs
- Giám sát và xử lý sự cố Kubernetes
- Quản lý dung lượng nâng cao (Capacity Management)
- Tích hợp và xử lý sự cố với Logs
- Cấu hình chi phí phù hợp với nhu cầu doanh nghiệp
- Tùy chỉnh cảnh báo và thông báo
- Tạo View để trực quan hóa dữ liệu
- Sử dụng Metrics và biểu đồ để xử lý sự cố
- Kỹ thuật xử lý sự cố nâng cao với Workbench
- Tự động hóa khắc phục sự cố
- Tối ưu hiệu suất với Rightsizing
- Kích hoạt Chargeback cho doanh nghiệp
- Lập kế hoạch dung lượng tương lai
- Giám sát ứng dụng
- Sử dụng VCF Diagnostics
- Quản lý License và Certificate
- Tổng quan Management Pack Builder
- Quản lý vCenter Configuration Drift

## Mục đích

Trang bị cho học viên kiến thức và kỹ năng thực hành chuyên sâu về VMware Aria Operations trong nền tảng VCF, giúp:

- Hiểu rõ cách vận hàng trung tâm dữ liệu tự động (Self-Driving Datacenter)
- Nắm vững các công cụ phân tích dự đoán và lập kế hoạch dung lượng
- Thành thạo kỹ thuật giám sát đa tầng từ infrastructure đến application
- Có khả năng tùy chỉnh và mở rộng nền tảng giám sát theo nhu cầu doanh nghiệp

## Lợi ích áp dụng vào thực tiễn

1. **Tiết kiệm chi phí vận hành:** Tối ưu tài nguyên thông qua Rightsizing và Capacity Management, giảm lãng phí tài nguyên
2. **Tăng tính sẵn sàng:** Phát hiện sớm và tự động hóa khắc phục sự cố, giảm MTTR (Mean Time to Resolution)
3. **Quản lý đa đám mây:** Giám sát tập trung trên nhiều nền tảng (vSphere, Kubernetes, Public Cloud)
4. **Ra quyết định dựa trên dữ liệu:** Cost visibility, Showback/Chargeback giúp các phòng ban hiểu rõ chi phí IT
5. **Tự động hóa vận hành:** Policy-driven automation giúp giảm can thiệp thủ công, tăng hiệu quả
6. **Lập kế hoạch dung lượng chính xác:** What-If scenarios và predictive analytics giúp dự báo nhu cầu tương lai

---

## Chi tiết các bước thực hành

### Module 1 - Extending your Solution with Management Packs (30 phút, Cơ bản)

**Giới thiệu:**
Aria Operations cung cấp khả năng giám sát vSphere ở cấu hình chuẩn. Management Packs (Integrations) cho phép mở rộng khả năng giám sát để phân tích dữ liệu từ nhiều tầng infrastructure như compute, storage, network và ứng dụng.

**Mục tiêu:**
- Xem xét các Management Packs đã cài đặt
- Cài đặt thêm Management Packs

**Các bước thực hành:**
1. **Đăng nhập Aria Operations** qua Firefox Browser → VCF Cloud Management bookmark → Aria Operations
2. **Xác thực Workspace ONE Access**: Chọn Workspace ONE Access → Redirect → Đăng nhập với `holadmin` / `VMware123!`
3. **Xem Repository tích hợp sẵn**: Administration → Integrations → Repository
4. **Cài đặt Management Pack mới**: Click ADD → BROWSE → Chọn file `.pak` từ `C:\labfiles\HOL-2501-02\Module 1\` → UPLOAD
5. **Chấp nhận EULA** → NEXT → FINISH
6. **Xem nội dung Management Pack**: Click vào Management Pack for Storage Devices → Content tab
7. **Thêm Account**: ADD ACCOUNT → Physical Storage Devices Adapter
   - Name: `HOL vCenter`
   - vCenter Server: `vcenter-mgmt.vcf.sddc.lab`
   - Credential: administrator@vsphere.local / VMware123!
8. **Kiểm tra Alert Definitions** từ Management Pack: Operations → Alert Definitions → Filter by Adapter Type = "Physical"
9. **Đăng xuất**: Preferences → Log Out

**Kết luận:** Management Packs cung cấp khả năng mở rộng đáng kể cho Aria Operations, cho phép quản lý chủ động multi-cloud enterprise.

---

### Module 2 - Monitoring and Troubleshooting Kubernetes (30 phút, Cơ bản)

**Giới thiệu:**
Đi sâu vào VMware Aria Operations Management Pack for Kubernetes, hỗ trợ nhiều distribution: TKG, TKGi, Red Hat OpenShift, Amazon EKS.

**Mục tiêu:**
- Cài đặt prerequisites (cAdvisor)
- Triển khai và cấu hình Management Pack for Kubernetes
- Xem xét các dashboard và alert mới

**Các bước thực hành:**
1. **Triển khai cAdvisor**: File Explorer → `C:\labfiles\HOL-2501-02\Module 2\deploy_cadvisor.ps1` → Open with Code → Run
2. **Đăng nhập Aria Operations** (như Module 1)
3. **Cài Management Pack for Kubernetes**: Administration → Integrations → ADD → BROWSE → Chọn `vmware-mpforkubernetes-2.2.0-24050822.pak`
4. **Cấu hình Account Kubernetes**: ADD ACCOUNT → Kubernetes
   - Name: `HOL TKG`
   - Control Plane URL: `https://10.80.0.3:6443`
   - Collector Service: `cAdvisor - DaemonSet`
   - cAdvisor Port: `31194`
5. **Tạo Credential**: Client Certificate Auth → Lấy thông tin từ script `getKubeconfig.ps1`
6. **Kiểm tra dashboard**: Operations → Dashboards → Kubernetes → Kubernetes Infrastructure Inventory
7. **Xem Alerts**: Configurations → Alert Definitions → Filter: Kubernetes

---

### Module 3 - Advanced Capacity Management (30 phút, Trung cấp)

**Giới thiệu:**
Cấu hình Capacity Settings trong Aria Operations để quản lý và tối ưu tài nguyên infrastructure.

**Các khái niệm chính:**
- **Total Capacity**: Tổng dung lượng khả dụng
- **Overhead**: Tài nguyên cho hypervisor
- **HA**: Dung lượng dự phòng do vSphere HA
- **Buffer**: Dung lượng dự trữ sau HA
- **Demand vs Allocation Model**
- **Time Remaining / Capacity Remaining**
- **Conservative vs Aggressive Risk Level**

**Các bước thực hành:**
1. **Chỉnh sửa Policy**: Operations → Policy Definition → Edit Default Policy
2. **Cấu hình Risk Level**: Capacity → Risk Level Configurations → Set Conservative/Aggressive
3. **Cấu hình Business Hours**: Set 6:00 AM - 8:00 PM
4. **Allocation Model**: Set CPU ratio 3:1
5. **Capacity Buffer**: CPU Allocation 5%, CPU Demand 30%
6. **Criticality Thresholds**: Time Remaining, Capacity Remaining, Workload
7. **Kiểm tra Cluster Utilization**: Capacity → Assess → Chọn datacenter/cluster

---

### Module 4 - Integrating and Troubleshooting with Logs (45 phút, Nâng cao)

**Giới thiệu:**
Tích hợp Aria Operations for Logs với Aria Operations để quản lý log tập trung và xử lý sự cố.

**Mục tiêu:**
- Cài đặt Linux Agent cho Aria Operations for Logs
- Sử dụng logs trong Aria Operations để troubleshooting
- Sử dụng filter để xác định nguồn dữ liệu

**Các bước thực hành Linux Agent:**
1. Đăng nhập Aria Operations for Logs
2. Download Linux Agent package (DEB)
3. Chuyển file qua WinSCP đến Ubuntu VM (`ubuntu-xxxx.vcf.sddc.lab`)
4. SSH qua PuTTY → `sudo su -` → `dpkg -i vmware-log-insight-agent_*.deb`
5. Cấu hình `liagent.ini` bằng sed commands
6. Restart agent: `/etc/init.d/liagentd restart`
7. Cấu hình Agent Group trong Aria Operations for Logs

**Các bước thực hành Windows Agent & Troubleshooting:**
1. RDP vào Windows VM (`windows-xxxx.vcf.holo.lab`)
2. Download và cài Windows Agent
3. Cấu hình Agent Group cho Windows
4. Chạy script giả lập financial app: `hol_financial_app.cmd`
5. Trong Aria Operations: Troubleshoot → Chọn VM → Logs → Filter "Financial"
6. Xem chi tiết log events và sử dụng "LAUNCH OPERATIONS FOR LOGS"

---

### Module 5 - Configuring Costs to Match Your Business Needs (30 phút, Trung cấp)

**Giới thiệu:**
Cấu hình Cost Drivers và Pricing để theo dõi chi phí, tính toán và phân tích dữ liệu chi phí.

**Các bước thực hành:**
1. **Cấu hình Cost Drivers**: Operations → Cost Drivers → Server Hardware: Hyper-Converged
2. **Depreciation**: Set 3 năm, Straight Line method
3. **Manual Cost Calculation**: Cost → Analyze → Chọn Cluster Compute Resource
4. **Define Pricing Policy**: Cost → Define Pricing Policy → Enable Pricing Engine
   - Basic Charges: CPU 1.05x, Memory 1.35x, Storage 0.9x
   - Guest OS Rate: Linux $100/day, Windows $5/day
   - Tag Pricing: db/oracle $500/month, db/mssql $50/month
   - Overall Charges: $100 setup + $10/month
5. **Showback Dashboard**: Cost → Showback → Xem vSphere World cost breakdown
6. **Tùy chỉnh Cost Drivers**: Network ($90 → $250/10Gb NIC), Labor (Linux 0.08h/month, rate $40/h)
7. **Điều chỉnh Hardware Cost**: Giảm 15% (từ $154,927 → $131,687.95/server)

---

### Module 6 - Customizing Alerts and Leveraging Notifications (30 phút, Cơ bản)

**Giới thiệu:**
Tạo Symptom Definitions, Alert Definitions, Recommendations, Actions và Notifications.

**Các bước thực hành:**
1. **Tạo Symptom Definition**: Configurations → Symptom Definitions → ADD
   - Base Object: Virtual Machine
   - Metric: `CPU|USAGE` → Usage (%) > 80
   - Name: "High CPU", Critical severity, Wait Cycle 1, Cancel Cycle 2
2. **Tạo Alert Definition**: ADD → Name "High CPU Alert" → Virtual Machine
   - Add Symptom "High CPU" → Create Recommendation
3. **Tạo Recommendation với Action**: Power Off VM
4. **Gán Policy**: Chọn Default Policy → CREATE
5. **Test Alert**: PuTTY → `cat /dev/zero > /dev/null` (tạo CPU load)
6. **Kiểm tra Alert trong Aria Operations**: Sumary → Active Alerts
7. **Tự động hóa Action**: Tạo policy mới "HOL Test Policy" → Kích hoạt Automate
8. **Tạo Custom Group "Test VMs"**: Membership Criteria: `ubuntu-` trong object name
9. **Kiểm tra tự động Power Off VM** trong vCenter
10. **Cấu hình Email Notification**: Operations → Notifications → ADD
    - SMTP: mail.vcf.sddc.lab:25
    - Sender: vcf.ops@vcf.holo.lab
    - Recipient: hol.admin@vcf.holo.lab

---

### Module 7 - Creating Views for Better Visibility (15 phút, Cơ bản)

**Giới thiệu:**
Views là thành phần chính của Reports và Dashboards, giúp diễn giải dữ liệu (metrics, properties, policies, symptoms).

**Các bước thực hành:**
1. **Simple List View**: Inventory → vCenter → Details → Views → ADD → List
   - Name: "Demo - Simple List of VMs with Metrics and Properties"
   - Subject: Virtual Machine
   - Properties: Parent Cluster, Parent Host, Datastore(s)
   - Metrics: Number of vCPUs, Memory Total Capacity
2. **View với Variable Data**: Tạo List View mới
   - Metric: CPU Demand (%) × 2 (bản 2 dùng Maximum transformation)
   - CPU Ready (%) với Metric Correlation (correlate với CPU Demand)
   - Filter: Power State = Powered On
   - Time Range: Last 30 Days
3. **Trend View**: Chọn Trend type → Subject Virtual Machine → Chọn metrics trend
4. **Growth View**: Hiển thị tăng trưởng của VM theo thời gian
5. **Distribution View**: Phân phối dữ liệu
6. **Tạo Reports từ Views và Dashboards**

---

### Module 8 - Using Metrics and Metric Charts for Troubleshooting (15 phút, Cơ bản)

**Giới thiệu:**
Sử dụng Metrics và biểu đồ xếp chồng (Stacking Charts) để xử lý sự cố.

**Các bước thực hành:**
1. **Truy cập Metrics**: Chọn object → Metrics tab
2. **Quick Filter**: Gõ tên metric cần tìm
3. **Double-click** để tạo chart
4. **Stacking Charts**: Kết hợp nhiều metrics trên cùng biểu đồ để so sánh

---

### Module 9 - Advanced Troubleshooting Techniques (15 phút, Trung cấp)

**Giới thiệu:**
Sử dụng Troubleshooting Workbench để phân tích forensic thông tin: Events, Property Changes, Anomalous Metrics.

**Các bước thực hành:**
1. **Mở Workbench**: Operations → Troubleshoot
2. **Xem Alerts**: Danh sách các alert trên object
3. **Xem Metrics**: Tìm metrics từ "Log Insight" (Log Total Count)
4. **Xem Logs**: Filter và phân tích logs tích hợp từ Aria Operations for Logs
5. **Sử dụng Workbench** để correlate metrics, properties, events, và logs

---

### Module 10 - Save Time by Automating Remediation (15 phút, Cơ bản)

**Giới thiệu:**
Sử dụng Automation Central để tạo và lên lịch các job tự động hóa.

**Các bước thực hành:**
1. **Mở Automation Central**: Operations → Automation Central
2. **Tạo Job từ Rightsizing Report**: Chọn VM rightsizing recommendations
3. **Cấu hình Recurring Job**: Lên lịch chạy định kỳ
4. **Xem kết quả**: Recent Tasks → Kiểm tra automated actions

---

### Module 11 - Achieve Optimal Performance with Rightsizing (45 phút, Nâng cao)

**Giới thiệu:**
Phân tích Oversized và Undersized VMs, cấu hình Policy Settings để tối ưu hiệu suất.

**Các bước thực hành:**
1. **Xem Rightsizing Recommendations**: Operations → Rightsizing
2. **Phân loại VM**: Oversized vs Undersized
3. **Xem chi tiết**: Chọn từng VM để xem khuyến nghị cụ thể
4. **Cấu hình Policy Settings**:
   - Override capacity thresholds
   - Adjust allocation models
   - Customize rightsizing parameters

---

### Module 12 - Enabling Chargeback for Your Business (30 phút, Nâng cao)

**Giới thiệu:**
Thiết lập Rate Cards/Pricing và Chargeback để billing cho khách hàng dựa trên usage.

**Các bước thực hành:**
1. **Tạo Rate Card**: Operations → Cost → Pricing
2. **Cấu hình Pricing Policy**: Define pricing structure cho services
3. **Kích hoạt Chargeback**: Thiết lập billing cycles
4. **Xem Chargeback Reports**: Cost → Analyze → Chargeback

---

### Module 13 - Plan for Your Future Capacity Needs (30 phút, Trung cấp)

**Giới thiệu:**
Sử dụng What-If Scenarios để dự báo nhu cầu dung lượng tương lai.

**Các bước thực hành:**
1. **Capacity Planning**: Operations → Capacity → What-If Scenarios
2. **Tạo Scenario**: Thêm/sửa/xóa VMs, thay đổi configuration
3. **Phân tích kết quả**: Xem tác động lên capacity còn lại
4. **Tính toán Cost**: Kết hợp cost drivers với capacity planning

---

### Module 14 - Application Monitoring (45 phút, Trung cấp)

**Giới thiệu:**
Giám sát ứng dụng bằng Telegraf Agent do Aria Operations quản lý (Product-Managed).

**Các bước thực hành:**
1. **Đăng nhập Aria Operations**
2. **Install Telegraf Agent** trên OS ứng dụng
3. **Configure Service Discovery**: Tự động phát hiện services
4. **Custom Monitoring**: Định nghĩa metrics tùy chỉnh cho ứng dụng
5. **Xem dashboard application monitoring**

---

### Module 15 - Using VCF Diagnostics to Understand the Operational Health (30 phút, Trung cấp)

**Giới thiệu:**
Sử dụng VCF Diagnostics để đánh giá sức khỏe operational của Private Cloud.

**Các bước thực hành:**
1. **Đăng nhập Aria Operations**
2. **Hoàn thành prerequisites cho VCF Diagnostics**
3. **Xem Dashboard VCF Diagnostics**: Tổng quan health
4. **Phân tích kết quả**: Các chỉ số operational health

---

### Module 16 - Understand Licensing and Certificate Management (15 phút, Cơ bản)

**Giới thiệu:**
Quản lý License và Certificate trong Aria Operations.

**Các bước thực hành:**
1. **Licensing Management**: Administration → Licensing
2. **Xem License Usage**: Các license đang sử dụng
3. **Certificate Management**: Administration → Certificates
4. **Quản lý SSL certificates**: Xem và renew certificates

---

### Module 17 - Aria Operations Management Pack Builder Overview (15 phút, Cơ bản)

**Giới thiệu:**
Tổng quan về Management Pack Builder để tạo management packs tùy chỉnh.

**Các bước thực hành:**
1. **Đăng nhập Management Pack Builder**
2. **Làm quen với Interface**
3. **Import GitLab-Basic Management Pack**
4. **Thiết kế Management Pack**: Overview các bước design
5. **Đăng xuất**

---

### Module 18 - Managing vCenter Configuration Drift (15 phút, Cơ bản)

**Giới thiệu:**
Phát hiện và quản lý configuration drift trong vCenter thông qua mô phỏng tương tác.

**Các bước thực hành:**
1. **Interactive Simulation**: Hands-on Labs Interactive Simulation
2. **Phát hiện Configuration Drift**: So sánh cấu hình hiện tại với baseline
3. **Remediation**: Các bước khắc phục drift

---

## Tài liệu tham khảo

- [VMware Aria Operations Documentation](https://docs.vmware.com/en/VMware-Aria-Operations/index.html)
- [VMware Aria Operations: Journey to Success](https://www.vmware.com/products/aria-operations.html)
- [Self-Guided Workshop Video](https://via.vmw.com/HOL-2401-02-CMP-ELW)

## Thông tin Lab Captains

| Module | Lab Captain |
|--------|-------------|
| 1, 6, 14, 17 | Thomas Kopton, Lead Solution Architect, Germany |
| 2 | Christopher Lewis, Lead Solution Architect, UK |
| 3, 9 | Eirini Spanou, Senior Solutions Architect, UK |
| 4 | Bastian Beuggert, Lead Solution Architect, Switzerland |
| 5, 12 | Cosmin Trif, Staff Solution Architect, US |
| 7, 8, 13 | Ellen Meeus, Technical Adoption Manager, Belgium |
| 10 | William De Marigny, Staff NSX Technical Adoption Manager |
| 11 | Bastian Beuggert, Lead Solution Architect, Switzerland |

---

*Tài liệu được tổng hợp từ HOL-2501-02-VCF-L_5.2 Hands-On Labs Manual - VMware 2024*
