#!/usr/bin/env bash
set -euo pipefail

#=============================================================================
# install_ishare2_pnetlab6.sh
# Tự động cài iShare2 GUI + Nginx + WebDAV + Let's Encrypt SSL
# Dành cho Ubuntu 24.04 LTS – PNetLab 6 / EVE-NG
# Hỗ trợ giảng viên upload/download KVM images (qcow2, ova, ovf, vmdk...)
#=============================================================================

# --- Cấu hình (sửa các biến này trước khi chạy) ---
DOMAIN="${DOMAIN:-pnetlab.example.com}"          # Domain thật để lấy SSL Let's Encrypt
EMAIL="${EMAIL:-admin@example.com}"               # Email cho Let's Encrypt
ISHARE2_REPO="https://github.com/ishare2-org/ishare2-web-gui.git"
ISHARE2_DIR="/opt/ishare2/gui"
VENV_DIR="${ISHARE2_DIR}/venv"

# Thư mục chứa templates / firmware network devices (KVM)
TEMPLATES_DIR="/opt/templates"
SUBDIRS=("qcow2" "ova" "ovf" "vmdk" "iso" "firmware")

# Danh sách giảng viên (username:password)
declare -A INSTRUCTORS
INSTRUCTORS=(
    ["giangvien1"]="MatKhauMacDinh1@"
    ["giangvien2"]="MatKhauMacDinh2@"
)

# --- Màu sắc output ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()   { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Kiểm tra root ---
[[ $EUID -eq 0 ]] || err "Chạy script với quyền root: sudo bash $0"

# --- Hàm kiểm tra lệnh ---
check_cmd() { command -v "$1" &>/dev/null; }

# =========================================================================
# Bước 1: Cập nhật hệ thống & cài đặt gói cơ bản
# =========================================================================
info ">>> Bước 1: Cập nhật hệ thống và cài đặt gói cơ bản..."
apt update && apt upgrade -y
apt install -y \
    curl wget git unzip gpg software-properties-common \
    nginx certbot python3-certbot-nginx \
    apache2-utils                       # htpasswd cho WebDAV auth
info " [OK]"

# =========================================================================
# Bước 2: Cài đặt Python 3.13 từ deadsnakes PPA
# =========================================================================
info ">>> Bước 2: Cài đặt Python 3.13..."
if ! check_cmd python3.13; then
    add-apt-repository -y ppa:deadsnakes/ppa
    apt update
    apt install -y python3.13 python3.13-venv python3.13-dev
fi
PYTHON_BIN=$(command -v python3.13)
info " Python: $($PYTHON_BIN --version)"
info " [OK]"

# =========================================================================
# Bước 3: Cài đặt iShare2 CLI
# =========================================================================
info ">>> Bước 3: Cài đặt iShare2 CLI..."
if [ ! -f /usr/sbin/ishare2 ]; then
    curl -sL -o /usr/sbin/ishare2 \
        https://raw.githubusercontent.com/pnetlabrepo/ishare2/main/ishare2
    chmod +x /usr/sbin/ishare2
fi
info " [OK]"

# =========================================================================
# Bước 4: Clone & cài iShare2 GUI
# =========================================================================
info ">>> Bước 4: Cài đặt iShare2 GUI..."
if [ -d "$ISHARE2_DIR" ]; then
    warn "Thư mục $ISHARE2_DIR đã tồn tại, bỏ qua clone."
else
    git clone "$ISHARE2_REPO" "$ISHARE2_DIR"
fi
cd "$ISHARE2_DIR"

# Tạo virtual environment với Python 3.13
$PYTHON_BIN -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip setuptools wheel
pip install -r requirements.txt
deactivate
info " [OK]"

# =========================================================================
# Bước 5: Tạo cấu trúc thư mục templates
# =========================================================================
info ">>> Bước 5: Tạo thư mục chứa templates và firmware..."
mkdir -p "$TEMPLATES_DIR"
for sub in "${SUBDIRS[@]}"; do
    mkdir -p "${TEMPLATES_DIR}/${sub}"
done

# Set quyền: www-data sở hữu, giảng viên có quyền RW qua WebDAV
chown -R www-data:www-data "$TEMPLATES_DIR"
chmod -R 755 "$TEMPLATES_DIR"
info " [OK]"

# =========================================================================
# Bước 6: Tạo user giảng viên cho WebDAV authentication
# =========================================================================
info ">>> Bước 6: Tạo tài khoản giảng viên..."
WEBDAV_PASSWD="/etc/nginx/.htpasswd-webdav"
rm -f "$WEBDAV_PASSWD"
for user in "${!INSTRUCTORS[@]}"; do
    pass="${INSTRUCTORS[$user]}"
    echo "$pass" | htpasswd -i -B -C 10 "$WEBDAV_PASSWD" "$user"
    info "   User: $user"
done
chmod 640 "$WEBDAV_PASSWD"
chown root:www-data "$WEBDAV_PASSWD"
info " [OK]"

# =========================================================================
# Bước 7: Tạo Nginx config
# =========================================================================
info ">>> Bước 7: Tạo cấu hình Nginx..."

NGINX_CONF="/etc/nginx/sites-available/ishare2"
NGINX_ENABLED="/etc/nginx/sites-enabled/ishare2"

if [ -f /etc/nginx/sites-enabled/default ]; then
    rm -f /etc/nginx/sites-enabled/default
fi

# Tạo nginx config HTTP (dùng quoted heredoc để tránh bash expand nginx vars)
HTTP_BLOCK=$(cat <<'NGXEOF'
server {
    listen 80;
    server_name _;
    client_max_body_size 0;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }

    location /webdav {
        alias /opt/templates;
        client_max_body_size 0;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        auth_basic "PNetLab 6 - Templates Repository";
        auth_basic_user_file /etc/nginx/.htpasswd-webdav;
        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        create_full_put_path on;
        dav_access user:rw group:rw all:r;
        limit_except GET PROPFIND OPTIONS {
            auth_basic "Instructor Access Required";
            auth_basic_user_file /etc/nginx/.htpasswd-webdav;
        }
        types {
            application/x-qemu-disk qcow2 qcow;
            application/octet-stream ova ovf vmdk vdi;
            application/x-iso9660-image iso;
            application/gzip tgz tar.gz;
            application/x-tar tar;
            application/zip zip;
        }
    }

    location /static {
        alias /opt/ishare2/gui/web_app/src/static;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }
}
NGXEOF
)

# Tạo SSL server block nếu có domain thật
SSL_BLOCK=""
if [ "$DOMAIN" != "pnetlab.example.com" ] && [ -n "$DOMAIN" ]; then
    SSL_BLOCK=$(cat <<SSLNF
server {
    listen 443 ssl http2;
    server_name ${DOMAIN};
    client_max_body_size 0;

    ssl_certificate     /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}/privkey.pem;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;

    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
    }

    location /webdav {
        alias /opt/templates;
        client_max_body_size 0;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        auth_basic "PNetLab 6 - Templates Repository";
        auth_basic_user_file /etc/nginx/.htpasswd-webdav;
        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        create_full_put_path on;
        dav_access user:rw group:rw all:r;
        limit_except GET PROPFIND OPTIONS {
            auth_basic "Instructor Access Required";
            auth_basic_user_file /etc/nginx/.htpasswd-webdav;
        }
        types {
            application/x-qemu-disk qcow2 qcow;
            application/octet-stream ova ovf vmdk vdi;
            application/x-iso9660-image iso;
            application/gzip tgz tar.gz;
            application/x-tar tar;
            application/zip zip;
        }
    }

    location /static {
        alias /opt/ishare2/gui/web_app/src/static;
        expires 7d;
        add_header Cache-Control "public, immutable";
    }
}
SSLNF
)
    info ">>> Đã tạo cấu hình SSL cho domain: $DOMAIN"
else
    warn "DOMAIN chưa được cấu hình. Chỉ chạy HTTP."
    warn "  Chạy lại: DOMAIN=pnetlab.domain.com EMAIL=admin@domain.com bash $0"
fi

echo "${HTTP_BLOCK}"$'\n'"${SSL_BLOCK}" > "$NGINX_CONF"

ln -sf "$NGINX_CONF" "$NGINX_ENABLED"
nginx -t || err "Nginx configuration test FAILED!"
systemctl reload nginx
info " [OK]"

# =========================================================================
# Bước 8: Tạo systemd service cho iShare2 GUI
# =========================================================================
info ">>> Bước 8: Tạo systemd service cho iShare2 GUI..."
cat > /etc/systemd/system/ishare2.service <<'SVCEOF'
[Unit]
Description=iShare2 GUI – Image Manager for PNetLab/EVE-NG
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/ishare2/gui
Environment="PATH=/opt/ishare2/gui/venv/bin"
Environment="TEMPLATES_DIR=/opt/templates"
ExecStart=/opt/ishare2/gui/venv/bin/python /opt/ishare2/gui/main.py
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
SVCEOF

systemctl daemon-reload
systemctl enable ishare2
systemctl start ishare2
info " [OK]"

# =========================================================================
# Bước 9: Let's Encrypt SSL (nếu có domain thật)
# =========================================================================
if [ "$DOMAIN" != "pnetlab.example.com" ] && [ -n "$DOMAIN" ] && [ -n "$EMAIL" ]; then
    info ">>> Bước 9: Cấp SSL Let's Encrypt cho $DOMAIN..."
    certbot --nginx \
        --non-interactive \
        --agree-tos \
        --email "$EMAIL" \
        --domains "$DOMAIN" \
        --redirect \
        --keep-until-expiring
    info " [OK]"

    # Cron tự động gia hạn
    if ! crontab -l 2>/dev/null | grep -q certbot; then
        (crontab -l 2>/dev/null || true; echo "0 3 * * * /usr/bin/certbot renew --quiet --post-hook 'systemctl reload nginx'") | crontab -
        info "   Đã thêm cron renew SSL hàng ngày lúc 3h sáng."
    fi
fi

# =========================================================================
# Bước 10: Cấu hình firewall
# =========================================================================
info ">>> Bước 10: Cấu hình firewall..."
if check_cmd ufw; then
    ufw --force enable
    ufw allow 22/tcp   comment 'SSH'
    ufw allow 80/tcp   comment 'HTTP'
    ufw allow 443/tcp  comment 'HTTPS'
    ufw reload
    info " Firewall rules applied."
fi
info " [OK]"

# =========================================================================
# Bước 11: Script quản lý user giảng viên
# =========================================================================
info ">>> Bước 11: Tạo script quản lý user instructors..."
cat > /usr/local/bin/instructor-manager <<'MGMT'
#!/usr/bin/env bash
# Quản lý tài khoản giảng viên cho WebDAV
# Usage: instructor-manager {add|del|list|passwd} <username>
set -euo pipefail

WEBDAV_PASSWD="/etc/nginx/.htpasswd-webdav"
[[ $EUID -eq 0 ]] || { echo "Cần quyền root." >&2; exit 1; }

case "${1:-help}" in
    add)
        [[ -n "${2:-}" ]] || { echo "Usage: $0 add <username>"; exit 1; }
        read -rsp "Password: " pass; echo
        [[ -n "$pass" ]] || { echo "Password không được để trống."; exit 1; }
        echo "$pass" | htpasswd -i -B -C 10 "$WEBDAV_PASSWD" "$2"
        echo "User $2 đã được thêm."
        ;;
    del)
        [[ -n "${2:-}" ]] || { echo "Usage: $0 del <username>"; exit 1; }
        htpasswd -D "$WEBDAV_PASSWD" "$2"
        echo "User $2 đã bị xóa."
        ;;
    list)
        [[ -f "$WEBDAV_PASSWD" ]] || { echo "Chưa có user nào."; exit 0; }
        cut -d: -f1 "$WEBDAV_PASSWD"
        ;;
    passwd)
        [[ -n "${2:-}" ]] || { echo "Usage: $0 passwd <username>"; exit 1; }
        read -rsp "New password: " pass; echo
        [[ -n "$pass" ]] || { echo "Password không được để trống."; exit 1; }
        echo "$pass" | htpasswd -i -B -C 10 "$WEBDAV_PASSWD" "$2"
        echo "Password cho $2 đã được đổi."
        ;;
    *)
        echo "Usage: $0 {add|del|list|passwd} [username]"
        exit 1
        ;;
esac
MGMT
chmod +x /usr/local/bin/instructor-manager
info " [OK]"

# =========================================================================
# Bước 12: Kết thúc – hiển thị thông tin
# =========================================================================
SERVER_IP=$(hostname -I | awk '{print $1}')
BASE_URL="${DOMAIN}" && [[ "$BASE_URL" == "pnetlab.example.com" || -z "$BASE_URL" ]] && BASE_URL="$SERVER_IP"
PROTO="http" && [[ "$DOMAIN" != "pnetlab.example.com" && -n "$DOMAIN" ]] && PROTO="https"

info "====================================================="
info "   CÀI ĐẶT HOÀN TẤT"
info "====================================================="
info ""
info "  iShare2 Web UI:"
info "    ${PROTO}://${BASE_URL}/"
info ""
info "  WebDAV (Upload templates/firmware):"
info "    ${PROTO}://${BASE_URL}/webdav/"
info ""
info "  Cách mount WebDAV trên client:"
info "    Linux:  mount -t davfs '${PROTO}://${BASE_URL}/webdav/' /mnt/templates"
info "    Win:    Mạng -> Map network drive -> \\\\${BASE_URL}\\webdav"
info "    macOS:  Finder -> Go -> Connect to Server -> ${PROTO}://${BASE_URL}/webdav/"
info ""
info "  Quản lý giảng viên:"
info "    /usr/local/bin/instructor-manager add <username>"
info "    /usr/local/bin/instructor-manager list"
info "    /usr/local/bin/instructor-manager passwd <username>"
info "    /usr/local/bin/instructor-manager del <username>"
info ""
info "  Thư mục templates: ${TEMPLATES_DIR}"
info "  iShare2 GUI:       ${ISHARE2_DIR}"
info ""
info "  Kiểm tra service: systemctl status ishare2"
info "  Logs:              journalctl -u ishare2 -f"
info ""
info "====================================================="
