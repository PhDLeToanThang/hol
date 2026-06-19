# Hand-on-Labs (HoL)

Tài liệu, topology, hướng dẫn tự thực hành cho môi trường phòng thí nghiệm khoa học máy tính & điện toán đám mây.

## Phiên bản

| Thành phần | Phiên bản |
|---|---|
| **Project HoL** | `4.0.0-main` |
| **PNetLab** | `6.0+` |
| **iShare2 CLI** | `>= 2.5` |
| **iShare2 GUI** | `>= 1.0` |
| **Apache Guacamole** | `1.6.0` |
| **Ubuntu** | `24.04 LTS (Noble)` — cũng hỗ trợ `22.04`, `20.04` |
| **Python** | `3.13` (từ deadsnakes PPA) |
| **Nginx + WebDAV** | repository templates firmware KVM |
| **SSL/TLS** | Let's Encrypt (Certbot) |

## Cấu trúc repository

```
hol/
├── s1_ubuntu_add-on_before_install_hol.sh    # Chuẩn bị Ubuntu (xrdp, desktop, tools)
├── s2_pod6_noble.sh                           # Nâng cấp PNetLab 6 core (Ubuntu 24.04)
├── s3_ishare2_cli_install.sh                  # Cài iShare2 CLI
├── s4_fixbug_xrdp.sh                          # Fix xrdp
├── s5_fixbug_switchL2L3.md                   # Hướng dẫn Cisco IOU/IOL
├── install_ishare2_pnetlab6.sh               # Cài iShare2 GUI + Nginx + WebDAV + SSL
├── create_portal_ishare2/                     # Script hỗ trợ iShare2 portal
│   ├── ishare2_gui_install.sh                 # Cài GUI (legacy)
│   ├── corrections.md                        # Sửa tên images
│   ├── CHANGELOG.md
│   └── HELP.md
├── ishare2_portal/                            # Source iShare2 Web GUI (FastAPI)
├── Labs-Y2K-Y3K/                              # Thiết kế hệ thống LaaS
└── isim/                                      # Gemini API notebook
```

## Cách dùng iShare2 CLI

```bash
# Tìm kiếm images
ishare2 search              # Tất cả
ishare2 search qemu         # Chỉ QEMU
ishare2 search bin          # Chỉ Dynamips (bin)
ishare2 search dynamips     # Chỉ Dynamips
ishare2 search esxi         # ESXi images
ishare2 search vmx          # vMX (JunOS)
ishare2 search nxos         # NX-OS
ishare2 search forti        # Fortinet
ishare2 search palo         # Palo Alto
ishare2 search Licensed     # Images có license

# Tải images
ishare2 pull qemu <number>
ishare2 pull bin <number>
ishare2 pull dynamips <number>
ishare2 pull bin all
ishare2 pull dynamips all

# Quản lý images đã cài
ishare2 installed all
ishare2 installed qemu
ishare2 installed bin
ishare2 installed docker

# Labs
ishare2 labs                # Danh sách labs
ishare2 labs <number>       # Chi tiết lab

# GUI
ishare2 gui install
ishare2 gui start
ishare2 gui stop

# Khác
ishare2 relicense           # Gia hạn license IOL
ishare2 upgrade             # Nâng cấp iShare2
ishare2 help
```

## WebDAV — Kho templates / firmware thiết bị mạng

Sau khi chạy `install_ishare2_pnetlab6.sh`, một WebDAV repository được tạo tại `/opt/templates/`:

| Thư mục | Loại file |
|---|---|
| `qcow2/` | Ảnh QEMU/KVM (qcw2, qcow) |
| `ova/` | OVA templates (cho vSphere) |
| `ovf/` | OVF templates |
| `vmdk/` | Ảnh disk VMware |
| `vdi/` | Ảnh disk VirtualBox |
| `iso/` | ISO cài đặt OS / firmware |
| `firmware/` | Firmware thiết bị (NSX, ESXi, vSphere, IOT, Cisco ASN, SDDC, SD-WAN...) |
| `addons/` | Addons cho PNetLab |

### Mount WebDAV trên client

```bash
# Linux
mount -t davfs http://<server-ip>:8080/ /mnt/templates

# Windows: Map network drive → \\<server-ip>\webdav
# macOS: Finder → Go → Connect to Server → http://<server-ip>:8080/
```

## Guacamole 1.6.0

Apache Guacamole `1.6.0` (phát hành 2025-06-22) được build từ source trong `s2_pod6_noble.sh`:

- **Cổng**: `http://<IP>:8080/guacamole/`
- **User mặc định**: `admin` / `pnetlab`
- **Tích hợp**: RDP (3389), VNC (5900), SSH
- Cấu hình tại `/etc/guacamole/guacamole.properties`

### Nâng cấp từ Guacamole cũ lên 1.6.0

```bash
# Backu cấu hình cũ
cp -r /etc/guacamole /etc/guacamole.bak

# Tải WAR mới
wget https://dlcdn.apache.org/guacamole/1.6.0/binary/guacamole-1.6.0.war \
    -O /var/lib/tomcat9/webapps/guacamole.war

# Build server mới
cd /tmp
wget https://dlcdn.apache.org/guacamole/1.6.0/source/guacamole-server-1.6.0.tar.gz
tar xzf guacamole-server-1.6.0.tar.gz
cd guacamole-server-1.6.0
./configure --prefix=/opt/guacamole/guacd --sysconfdir=/etc/guacamole
make -j$(nproc) && make install
systemctl restart guacd tomcat9
```

## Yêu cầu hệ thống

- **CPU**: 8+ cores (khuyến nghị 16+ cho nhiều lab đồng thời)
- **RAM**: 32 GB+ (khuyến nghị 64 GB+)
- **Disk**: NVMe U.2 ưu tiên, tối thiểu 500 GB
- **GPU**: Khuyến nghị NVIDIA Quadro/RTX cho AI/ML labs
- **Mạng**: 2+ NIC (1 cho quản trị, 1 cho lab)

## Tham khảo

- [iShare2 Web GUI](https://github.com/ishare2-org/ishare2-web-gui)
- [iShare2 CLI](https://github.com/pnetlabrepo/ishare2)
- [Apache Guacamole](https://guacamole.apache.org/)
- [PNetLab](https://www.pnetlab.com/)
- [EVE-NG](https://www.eve-ng.net/)
- [LabHub Community](https://labhub.eu.org/)
