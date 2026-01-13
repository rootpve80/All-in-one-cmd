#!/usr/bin/env bash
set -e

# ================== CONFIG ==================
TOOL_NAME="GG VPS Installer"
VERSION="v1.0.0"
LOG_FILE="/var/log/gg-installer.log"

# ================== COLORS ==================
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
GRAY="\033[0;37m"
NC="\033[0m"

# ================== UTILS ==================
log() {
  echo -e "$(date '+%F %T') : $1" >> "$LOG_FILE"
}

die() {
  echo -e "${RED}Error:${NC} $1"
  exit 1
}

spinner() {
  local pid=$!
  local spin='|/-\'
  while kill -0 $pid 2>/dev/null; do
    for i in {0..3}; do
      printf "\r${BLUE}[%c] Processing...${NC}" "${spin:$i:1}"
      sleep 0.1
    done
  done
  printf "\r"
}

# ================== CHECKS ==================
[[ $EUID -ne 0 ]] && die "Run as root"

grep -Ei "ubuntu|debian" /etc/os-release >/dev/null || die "Only Ubuntu/Debian supported"

ping -c1 1.1.1.1 &>/dev/null || die "No internet connection"

mkdir -p /var/log

# ================== UI ==================
clear
echo -e "${BLUE}
────────────────────────────────────────
  $TOOL_NAME
  Version: $VERSION
────────────────────────────────────────
${NC}"

# ================== MENU ==================
while true; do
  echo -e "${GRAY}1) Install Pterodactyl Panel"
  echo "2) Install Wings"
  echo "3) Install Cloudflare Tunnel"
  echo "4) Setup Tailscale"
  echo "5) Install Blueprint"
  echo "0) Exit${NC}"
  echo ""
  read -p "Select option: " opt
  echo ""

  case "$opt" in
    1)
      echo "Installing Pterodactyl Panel..."
      log "Installing Panel"
      bash <(curl -fsSL https://pterodactyl-installer.se) & spinner
      echo -e "${GREEN}Done.${NC}"
      ;;
    2)
      echo "Installing Wings..."
      log "Installing Wings"
      bash <(curl -fsSL https://pterodactyl-installer.se) & spinner
      echo -e "${GREEN}Done.${NC}"
      ;;
    3)
      echo "Installing Cloudflare Tunnel..."
      log "Installing Cloudflare"
      curl -fsSL https://pkg.cloudflare.com/install.sh | bash & spinner
      apt install -y cloudflared &>>"$LOG_FILE"
      echo -e "${GREEN}Done.${NC}"
      ;;
    4)
      echo "Installing Tailscale..."
      log "Installing Tailscale"
      curl -fsSL https://tailscale.com/install.sh | sh & spinner
      tailscale up
      echo -e "${GREEN}Connected.${NC}"
      ;;
    5)
      echo "Installing Blueprint..."
      log "Installing Blueprint"
      bash <(curl -fsSL https://raw.githubusercontent.com/BlueprintFramework/framework/main/install.sh)
      ;;
    0)
      echo -e "${GRAY}Exiting.${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option${NC}"
      ;;
  esac

  echo ""
  read -p "Press Enter to return to menu..."
  clear
done
