#!/usr/bin/env bash
set -euo pipefail

#=============================================================================
# s2_pod6_noble.sh
# Nâng cấp PNetLab 6 core cho Ubuntu 24.04 LTS (Noble)
#   - Kernel tùy chỉnh pnetlab-uksm
#   - Guacamole 1.6.0
#   - Docker CE + QEMU + Dynamips + VPCS + Wireshark
#   - Python 3.13
#   - WebDAV repository cho templates/firmware
#=============================================================================

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

GREEN='\033[32m'; YELLOW='\033[1;33m'; RED='\033[31m'; NO_COLOR='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NO_COLOR} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NO_COLOR} $1"; }
err()   { echo -e "${RED}[ERROR]${NO_COLOR} $1"; exit 1; }

# --- Phát hiện Ubuntu version ---
UBUNTU_RELEASE=$(lsb_release -r -s 2>/dev/null || echo "unknown")
case "$UBUNTU_RELEASE" in
    24.04) CODENAME="noble"; REL_DIR="Noble" ;;
    22.04) CODENAME="jammy"; REL_DIR="Jammy" ;;
    20.04) CODENAME="focal"; REL_DIR="Focal" ;;
    *)     err "Yêu cầu Ubuntu 20.04 / 22.04 / 24.04. Hiện tại: $UBUNTU_RELEASE" ;;
esac
info "Ubuntu $UBUNTU_RELEASE ($CODENAME) — OK"

# --- Base URL cho packages ---
BASE_URL="${BASE_URL:-https://www.cloud.edu.vn/pnetlab6/${REL_DIR}}"
GUAC_VERSION="${GUAC_VERSION:-1.6.0}"

# =========================================================================
# Bước 0: Azure / GCP / Bare-metal tuning
# =========================================================================
azure_disk_tune() {
    ls -l /dev/disk/by-id/ 2>/dev/null | grep -q sdc || return 0
    info "Phát hiện disk Azure /dev/sdc, đang format & mount vào /opt..."
    fdisk /dev/sdc <<'FDISK' &>/dev/null
o
n
p
1


w
FDISK
    mke2fs -F /dev/sdc1
    grep -q '/dev/sdc1' /etc/fstab 2>/dev/null || \
        echo '/dev/sdc1  /opt  ext4  defaults,discard  0 0' >> /etc/fstab
    mount /opt 2>/dev/null || true
}

gcp_tune() {
    info "Phát hiện GCP, điều chỉnh network persistent..."
    cd /sys/class/net/
    for i in ens*; do
        echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$(cat $i/address)\", ATTR{type}==\"1\", KERNEL==\"ens*\", NAME=\"$i\""
    done > /etc/udev/rules.d/70-persistent-net.rules
    sed -i 's/NAME="ens.*/NAME="eth0"/' /etc/udev/rules.d/70-persistent-net.rules
    sed -i 's/ens4/eth0/' /etc/netplan/50-cloud-init.yaml 2>/dev/null || true
    sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
    apt-mark hold linux-image-gcp 2>/dev/null || true
    update-grub2
}

azure_kernel_tune() {
    info "Phát hiện Azure, điều chỉnh KVM nested..."
    echo "options kvm_intel nested=1 vmentry_l1d_flush=never" > /etc/modprobe.d/qemu-system-x86.conf
    sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
}

# =========================================================================
# Bước 1: System prep
# =========================================================================
info ">>> Bước 1: Chuẩn bị hệ thống..."
rm -f /var/lib/dpkg/lock* /var/cache/apt/archives/lock*
dpkg --configure -a 2>/dev/null || true

# Root SSH
sed -i 's/.*PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/.*DefaultTimeoutStopSec=.*/DefaultTimeoutStopSec=5s/' /etc/systemd/system.conf
systemctl restart ssh 2>/dev/null || true

# Resize logical volume (bare-metal / KVM)
RESIZE_REQUIRED=false
systemd-detect-virt -v > /tmp/hypervisor 2>/dev/null || true
if grep -qE 'kvm|none' /tmp/hypervisor 2>/dev/null; then
    RESIZE_REQUIRED=true
fi
if [ "$RESIZE_REQUIRED" = true ]; then
    ROOTLV=$(mount | grep ' / ' | awk '{print $1}')
    if [ -n "$ROOTLV" ] && command -v lvextend &>/dev/null; then
        lvextend -l +100%FREE "$ROOTLV" 2>/dev/null || true
        resize2fs "$ROOTLV" 2>/dev/null || true
    fi
fi

# Tắt apport (tránh crash dump tốn disk)
systemctl disable apport 2>/dev/null || true

# Cloud disk tuning
dmidecode -t bios 2>/dev/null | grep -q Google && gcp_tune
uname -a | grep -q -- "-azure " && azure_kernel_tune
uname -a | grep -q -- "-azure " && azure_disk_tune

# Default password
echo "root:pnetlab" | chpasswd 2>/dev/null || true

info " [OK]"

# =========================================================================
# Bước 2: APT repositories & packages
# =========================================================================
info ">>> Bước 2: Cài đặt APT repositories & packages..."

# deadsnakes PPA cho Python 3.13
apt-get update -qq
apt-get install -y -qq software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa 2>/dev/null || true

# PHP PPA (Ondrej)
add-apt-repository -y ppa:ondrej/php 2>/dev/null || true

# Docker official GPG + repo
if ! command -v docker &>/dev/null; then
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
        > /etc/apt/sources.list.d/docker.list
fi

apt-get update -qq

# --- Cài đặt packages theo Ubuntu version ---
PKGS_BASE="curl wget git unzip ifupdown resolvconf ntpdate vim dos2unix bridge-utils build-essential \
    debconf-utils dialog dmidecode genisoimage iptables logrotate lsb-release lvm2 ntp rsync sshpass \
    cpulimit net-tools zip unzip gdisk p7zip-full"

PKGS_LIBS="libnet-pcap-perl libelf1 libpcap0.8 libsdl1.2debian libc6 libc6-i386 lib32gcc-s1 lib32z1 \
    libguestfs-tools cgroup-tools libyaml-0-2 libaio1 libasan8 libasound2 libepoxy0 libfdt1 libgbm1 \
    libglib2.0-0 libgnutls30 libibverbs1 libjpeg8 libncursesw6 libnettle8 libnuma1 libpixman-1-0 \
    libpmem1 libpng16-16t64 librdmacm1 libsasl2-2 libseccomp2 libslirp0 libspice-server1 libtinfo6 \
    libusb-1.0-0 libusbredirparser1 libvirglrenderer1 libcacard0 libbrlapi0.7 libvdeplug2 libnfs13 \
    libspice-client-glib-2.0-8"

PKGS_PHP="php8.3 php8.3-cli php8.3-gd php8.3-xml php8.3-mysql php8.3-sqlite3 php8.3-curl php8.3-mbstring php8.3-zip php8.3-imagick libapache2-mod-php8.3"

PKGS_QEMU="qemu-system-common qemu-system-data qemu-system-x86 seabios ipxe-qemu ipxe-qemu-256k-compat-efi-roms ovmf"

PKGS_GUAC="libcairo2 libcairo-gobject2 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 \
    libfreerdp-client2-2 libfreerdp-server2-2 libfreerdp-shadow-subsystem2-2 libfreerdp-shadow2-2 \
    libfreerdp2-2 winpr-utils libssh2-1 libtelnet2 libvncclient1 libvncserver1 libwebsockets16t64 \
    libpulse0 libpulse-mainloop-glib0 libvorbis0a libvorbisenc2 libvorbisfile3 libwebp7 libcairo-script-interpreter2 \
    libtool libuuid1 libossp-uuid16 default-jdk default-jdk-headless tomcat9 tomcat9-admin tomcat9-docs \
    libssl3t64 libssl-dev"

PKGS_EXTRA="python3 python3-pip python3-venv python3.13 python3.13-venv python3.13-dev \
    python3-pexpect php8.3-mysql ssmtp mailutils \
    nginx apache2-utils certbot python3-certbot-nginx mysql-server"

# Gộp & cài
apt-get install -y -qq $PKGS_BASE $PKGS_LIBS $PKGS_PHP $PKGS_QEMU $PKGS_GUAC $PKGS_EXTRA 2>/dev/null || {
    warn "Một số package không có sẵn, thử cài từng phần..."
    for pkg in $PKGS_BASE $PKGS_LIBS $PKGS_PHP $PKGS_QEMU $PKGS_GUAC $PKGS_EXTRA; do
        apt-get install -y -qq "$pkg" 2>/dev/null || warn "  Bỏ qua: $pkg"
    done
}

# Set PHP 8.3 làm mặc định
update-alternatives --set php /usr/bin/php8.3 2>/dev/null || true

# Xoá PHP cũ nếu có
apt-get purge -y -qq php7.2* php7.4* php8.0* php8.1* php8.2* 2>/dev/null || true

info " [OK]"

# =========================================================================
# Bước 3: Kernel pnetlab-uksm
# =========================================================================
info ">>> Bước 3: Cài kernel pnetlab-uksm..."
KERNEL_PKG="pnetlab_kernel.zip"
if ! dpkg-query -l | grep -q "linux-image.*pnetlab-uksm"; then
    wget -q --show-progress "${BASE_URL}/L/${KERNEL_PKG}" -O "/tmp/${KERNEL_PKG}" 2>/dev/null || {
        warn "Không tải được kernel từ $BASE_URL, giữ kernel hệ thống."
    }
    if [ -f "/tmp/${KERNEL_PKG}" ]; then
        unzip -o -q "/tmp/${KERNEL_PKG}" -d /tmp/pnetlab_kernel 2>/dev/null
        dpkg -i /tmp/pnetlab_kernel/*.deb 2>/dev/null || warn "Cài kernel thất bại, giữ kernel cũ."
    fi
fi
info " [OK]"

# =========================================================================
# Bước 4: Docker CE
# =========================================================================
info ">>> Bước 4: Cài Docker CE..."
if ! command -v docker &>/dev/null; then
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl enable --now docker
fi
info " Docker: $(docker --version 2>/dev/null || echo 'OK')"
info " [OK]"

# =========================================================================
# Bước 5: Guacamole 1.6.0
# =========================================================================
info ">>> Bước 5: Cài Guacamole ${GUAC_VERSION}..."

install_guacamole() {
    local VER="$1"
    local PREFIX="/opt/guacamole"
    mkdir -p "${PREFIX}"/{server,war,guacd}

    # ---- guacamole-server từ source ----
    if [ ! -f "${PREFIX}/guacd/sbin/guacd" ]; then
        apt-get install -y -qq build-essential libcairo2-dev libjpeg-turbo8-dev libpng-dev \
            libtool-bin libossp-uuid-dev libvncserver-dev libfreerdp-dev libssh2-1-dev \
            libtelnet-dev libwebsockets-dev libpulse-dev libvorbis-dev libwebp-dev \
            libssl-dev libpango1.0-dev libswscale-dev libavcodec-dev libavformat-dev \
            libavutil-dev 2>/dev/null

        cd /tmp
        wget -q "https://dlcdn.apache.org/guacamole/${VER}/source/guacamole-server-${VER}.tar.gz"
        tar xzf "guacamole-server-${VER}.tar.gz"
        cd "guacamole-server-${VER}"
        ./configure --prefix="${PREFIX}/guacd" --sysconfdir=/etc/guacamole
        make -j"$(nproc)" && make install
        ldconfig "${PREFIX}/guacd/lib"
        cd /tmp && rm -rf "guacamole-server-${VER}"*
    fi

    # ---- guacamole.war ----
    if [ ! -f "/var/lib/tomcat9/webapps/guacamole.war" ]; then
        wget -q "https://dlcdn.apache.org/guacamole/${VER}/binary/guacamole-${VER}.war" \
            -O "/var/lib/tomcat9/webapps/guacamole.war"
        chown tomcat:tomcat "/var/lib/tomcat9/webapps/guacamole.war"
    fi

    # ---- GUACAMOLE_HOME ----
    mkdir -p /etc/guacamole/{extensions,lib}
    cat > /etc/guacamole/guacamole.properties <<'GUACPROPS'
guacd-hostname: localhost
guacd-port: 4822
guacd-ssl: false
user-mapping: /etc/guacamole/user-mapping.xml
GUACPROPS

    # user-mapping mẫu
    if [ ! -f /etc/guacamole/user-mapping.xml ]; then
        cat > /etc/guacamole/user-mapping.xml <<'USRMAP'
<user-mapping>
    <authorize username="admin" password="pnetlab">
        <connection name="localhost-rdp">
            <protocol>rdp</protocol>
            <param name="hostname">127.0.0.1</param>
            <param name="port">3389</param>
        </connection>
        <connection name="localhost-vnc">
            <protocol>vnc</protocol>
            <param name="hostname">127.0.0.1</param>
            <param name="port">5900</param>
        </connection>
    </authorize>
</user-mapping>
USRMAP
    fi

    # systemd service cho guacd
    if [ ! -f /etc/systemd/system/guacd.service ]; then
        cat > /etc/systemd/system/guacd.service <<'GUACDSVC'
[Unit]
Description=Guacamole Proxy Daemon (guacd)
After=network.target

[Service]
Type=simple
ExecStart=/opt/guacamole/guacd/sbin/guacd -f -L info
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
GUACDSVC
    fi

    systemctl daemon-reload
    systemctl enable --now guacd tomcat9
}

# Kiểm tra Guacamelle đã tồn tại qua pnetlab package chưa
if dpkg-query -l | grep -q "pnetlab-guacamole"; then
    info "PNetLab Guacamole package đã cài, bỏ qua build từ source."
else
    install_guacamole "$GUAC_VERSION"
fi
info " [OK]"

# =========================================================================
# Bước 6: PNetLab packages (từ .zip trên server)
# =========================================================================
info ">>> Bước 6: Cài PNetLab packages..."
PNET_PACKAGES="PNET_SCHEMA PNET_VPCS PNET_DYNAMIPS PNET_QEMU PNET_DOCKER PNET_WIRESHARK PNET_PNETLAB"
TMPDIR=$(mktemp -d)
cd "$TMPDIR"

for pkg in $PNET_PACKAGES; do
    PKG_NAME=$(echo "$pkg" | sed 's/PNET_//' | tr '[:upper:]' '[:lower:]')
    # Kiểm tra đã cài chưa
    if dpkg-query -l 2>/dev/null | grep -qi "pnetlab-${PKG_NAME}"; then
        info "  $pkg đã cài, bỏ qua."
        continue
    fi
    info "  Đang tải $pkg..."
    wget -q --show-progress "${BASE_URL}/P/${pkg}.zip" -O "${pkg}.zip" 2>/dev/null || {
        warn "  Không tải được $pkg, bỏ qua."
        continue
    }
    unzip -o -q "${pkg}.zip" -d "${pkg}" 2>/dev/null
    dpkg -i "${pkg}"/*.deb 2>/dev/null || {
        warn "  Cài $pkg thất bại, thử apt --fix-broken..."
        apt-get install -f -y -qq
    }
done

# TPM (swtpm)
if ! dpkg-query -l | grep -q swtpm; then
    info "  Đang tải swtpm..."
    wget -q --show-progress "${BASE_URL}/T/swtpm-${REL_DIR}.zip" -O "swtpm.zip" 2>/dev/null || {
        warn "  swtpm không có cho $REL_DIR, thử Focal..."
        wget -q --show-progress "${BASE_URL%/${REL_DIR}}/Focal/T/swtpm-focal.zip" -O "swtpm.zip" 2>/dev/null || true
    }
    unzip -o -q "swtpm.zip" -d "swtpm" 2>/dev/null || true
    dpkg -i swtpm/*.deb 2>/dev/null || true
fi

cd / && rm -rf "$TMPDIR"

# Hostname & hosts
echo "pnetlab" > /etc/hostname
grep -q "pnetlab.example.com" /etc/hosts 2>/dev/null || \
    echo "127.0.2.1 pnetlab.example.com pnetlab" >> /etc/hosts

# Fix permission
if [ -f /opt/unetlab/wrappers/unl_wrapper ]; then
    /opt/unetlab/wrappers/unl_wrapper -a fixpermissions 2>/dev/null || true
fi

info " [OK]"

# =========================================================================
# Bước 7: WebDAV repository cho templates/firmware
# =========================================================================
info ">>> Bước 7: Thiết lập WebDAV repository cho templates..."

TEMPLATES_DIR="/opt/templates"
SUBDIRS=("qcow2" "ova" "ovf" "vmdk" "vdi" "iso" "firmware" "addons")
mkdir -p "$TEMPLATES_DIR"
for sub in "${SUBDIRS[@]}"; do mkdir -p "${TEMPLATES_DIR}/${sub}"; done
chown -R www-data:www-data "$TEMPLATES_DIR"
chmod -R 755 "$TEMPLATES_DIR"

# Nginx WebDAV config
if command -v nginx &>/dev/null && [ ! -f /etc/nginx/sites-enabled/webdav ]; then
    WEBDAV_PASSWD="/etc/nginx/.htpasswd-webdav"
    # Tạo user mặc định
    echo "pnetlab:pnetlab" | htpasswd -i -B -C 10 "$WEBDAV_PASSWD" "admin" 2>/dev/null || true

    cat > /etc/nginx/sites-available/webdav <<'WEBDAV'
server {
    listen 8080;
    server_name _;
    client_max_body_size 0;
    autoindex on;
    autoindex_exact_size off;
    autoindex_localtime on;

    location / {
        root /opt/templates;
        dav_methods PUT DELETE MKCOL COPY MOVE;
        dav_ext_methods PROPFIND OPTIONS;
        create_full_put_path on;
        dav_access user:rw group:rw all:r;
        auth_basic "PNetLab 6 Templates";
        auth_basic_user_file /etc/nginx/.htpasswd-webdav;

        types {
            application/x-qemu-disk qcow2 qcow;
            application/octet-stream ova ovf vmdk vdi vhd;
            application/x-iso9660-image iso;
            application/gzip tgz tar.gz;
            application/x-tar tar;
            application/zip zip;
        }
    }
}
WEBDAV
    ln -sf /etc/nginx/sites-available/webdav /etc/nginx/sites-enabled/
    nginx -t 2>/dev/null && systemctl reload nginx || warn "Nginx config test failed."
fi

info " WebDAV: http://<IP>:8080/ (admin:pnetlab)"
info " [OK]"

# =========================================================================
# Bước 8: Python 3.13 venv cho iShare2
# =========================================================================
info ">>> Bước 8: Thiết lập Python 3.13 venv cho iShare2..."
if command -v python3.13 &>/dev/null && [ ! -d /opt/ishare2/gui/venv ]; then
    mkdir -p /opt/ishare2/gui
    python3.13 -m venv /opt/ishare2/gui/venv
    /opt/ishare2/gui/venv/bin/pip install --upgrade pip setuptools wheel
fi
info " [OK]"

# =========================================================================
# Bước 9: Firewall
# =========================================================================
info ">>> Bước 9: Cấu hình firewall..."
if command -v ufw &>/dev/null; then
    ufw --force enable 2>/dev/null || true
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw allow 8080/tcp
    ufw allow 3389/tcp
    ufw reload 2>/dev/null || true
fi
info " [OK]"

# =========================================================================
# Bước 10: Dọn dẹp
# =========================================================================
info ">>> Bước 10: Dọn dẹp..."
apt-get autoremove -y -qq
apt-get autoclean -y -qq

info ""
info "====================================================="
info "   NÂNG CẤP PNETLAB 6 HOÀN TẤT"
info "====================================================="
info "  Ubuntu:     $UBUNTU_RELEASE ($CODENAME)"
info "  Guacamole:  $(dpkg-query -l 2>/dev/null | grep pnetlab-guacamole | awk '{print $3}') (hoặc $GUAC_VERSION build)"
info "  Python:     $(python3.13 --version 2>/dev/null || python3 --version)"
info "  Docker:     $(docker --version 2>/dev/null || echo 'N/A')"
info ""
info "  Web UI:     https://<IP>/"
info "  Guacamole:  http://<IP>:8080/guacamole/"
info "  WebDAV:     http://<IP>:8080/"
info "  SSH:        root / pnetlab"
info ""
info "  Khởi động lại: sudo reboot"
info "====================================================="
