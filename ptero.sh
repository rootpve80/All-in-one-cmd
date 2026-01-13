#!/bin/bash

# ================= COLORS =================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ================= FUNCTIONS =================
spinner() {
  local pid=$!
  local spin='-\|/'
  local i=0
  while kill -0 $pid 2>/dev/null; do
    i=$(( (i+1) %4 ))
    printf "\r${CYAN}[%c] Working...${NC}" "${spin:$i:1}"
    sleep .1
  done
  printf "\r"
}

root_check() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}❌ Run as root only!${NC}"
    exit 1
  fi
}

os_check() {
  if ! grep -Ei "ubuntu|debian" /etc/os-release >/dev/null; then
    echo -e "${RED}❌ Only Ubuntu/Debian supported${NC}"
    exit 1
  fi
}

net_check() {
  ping -c 1 google.com &>/dev/null || {
    echo -e "${RED}❌ No internet connection${NC}"
    exit 1
  }
}

header() {
  clear
  echo -e "${CYAN}"
  echo "╔══════════════════════════════════════════╗"
  echo "║      🚀 GG VPS PRO TOOLKIT               ║"
  echo "║      Author : GG                         ║"
  echo "╚══════════════════════════════════════════╝"
  echo -e "${NC}"
}

pause() {
  read -p "Press Enter to continue..."
}

# ================= PRE CHECKS =================
root_check
os_check
net_check

# ================= MENU LOOP =================
while true; do
  header
  echo -e "${GREEN}1.${NC} Install Pterodactyl Panel"
  echo -e "${GREEN}2.${NC} Install Wings"
  echo -e "${GREEN}3.${NC} Uninstall GG Tool"
  echo -e "${GREEN}4.${NC} Install Cloudflare Tunnel"
  echo -e "${GREEN}5.${NC} Tailscale Setup + Up"
  echo -e "${GREEN}6.${NC} Blueprint Installer"
  echo -e "${RED}0.${NC} Exit"
  echo ""
  read -p "👉 Select option: " opt

  case $opt in
    1)
      echo -e "${YELLOW}🚀 Installing Panel...${NC}"
      bash <(curl -s https://pterodactyl-installer.se) & spinner
      pause
      ;;
    2)
      echo -e "${YELLOW}🛠 Installing Wings...${NC}"
      bash <(curl -s https://pterodactyl-installer.se) & spinner
      pause
      ;;
    3)
      echo -e "${RED}⚠ Removing tool...${NC}"
      rm -f /usr/local/bin/gg-vps
      echo -e "${GREEN}✔ Tool removed${NC}"
      pause
      ;;
    4)
      echo -e "${BLUE}☁ Installing Cloudflare Tunnel...${NC}"
      curl -fsSL https://pkg.cloudflare.com/install.sh | bash & spinner
      apt install cloudflared -y
      pause
      ;;
    5)
      echo -e "${CYAN}🔐 Installing Tailscale...${NC}"
      curl -fsSL https://tailscale.com/install.sh | sh & spinner
      tailscale up
      pause
      ;;
    6)
      echo -e "${BLUE}📦 Installing Blueprint...${NC}"
      bash <(curl -s https://raw.githubusercontent.com/BlueprintFramework/framework/main/install.sh)
      pause
      ;;
    0)
      echo -e "${RED}👋 Bye!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}❌ Invalid option${NC}"
      sleep 1
      ;;
  esac
done
