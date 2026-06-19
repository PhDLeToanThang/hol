#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[32m'; RED='\033[31m'; NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

ISHARE2_BIN="/usr/sbin/ishare2"
ISHARE2_URL="https://raw.githubusercontent.com/pnetlabrepo/ishare2/main/ishare2"

[[ $EUID -eq 0 ]] || err "Chạy với quyền root: sudo bash $0"

if [ -f "$ISHARE2_BIN" ]; then
    CURRENT_VER=$("$ISHARE2_BIN" version 2>/dev/null || echo "unknown")
    info "iShare2 CLI đã cài: $CURRENT_VER"
    read -rp "Cập nhật lên phiên bản mới nhất? [y/N]: " yn
    [[ "$yn" =~ ^[Yy]$ ]] || { info "Bỏ qua."; exit 0; }
fi

info "Đang tải iShare2 CLI từ $ISHARE2_URL ..."
curl -sL -o "$ISHARE2_BIN" "$ISHARE2_URL" || err "Tải thất bại"
chmod +x "$ISHARE2_BIN"

info "Chạy iShare2 lần đầu (cài đặt dependencies)..."
"$ISHARE2_BIN" || true

info "iShare2 CLI: $("$ISHARE2_BIN" version 2>/dev/null)"
info "Hoàn tất. Gõ 'ishare2 help' để xem hướng dẫn."
