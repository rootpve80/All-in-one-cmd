#!/bin/bash

# ===== COLORS =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

echo -e "${CYAN}"
echo "╔════════════════════════════════════╗"
echo "║        GG VPS TOOL MENU             ║"
echo "╚════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${GREEN}1.${NC} Install Pterodactyl Panel"
echo -e "${GREEN}2.${NC} Install Wings"
echo -e "${GREEN}3.${NC} Uninstall Tool"
echo -e "${GREEN}4.${NC} Install Cloudflare Tunnel"
echo -e "${GREEN}5.${NC} Tailscale Setup + Up"
echo -e "${GREEN}6.${NC} Blueprint Installer"
echo -e "${RED}0.${NC} Exit"
echo ""
read -p "👉 Choose an option: " choice

echo ""

case $choice in
  1)
    echo -e "${YELLOW}🚀 Installing Pterodactyl Panel...${NC}"
    bash <(curl -s https://pterodactyl-installer.se)
    ;;
    
  2)
    echo -e "${YELLOW}🛠 Installing Wings...${NC}"
    bash <(curl -s https://pterodactyl-installer.se)
    ;;
    
  3)
    echo -e "${RED}⚠ Uninstalling Tool...${NC}"
    rm -f /root/vps-tool.sh
    echo -e "${GREEN}✔ Tool removed successfully${NC}"
    ;;
    
  4)
    echo -e "${BLUE}☁ Installing Cloudflare Tunnel...${NC}"
    curl -fsSL https://pkg.cloudflare.com/install.sh | bash
    apt install cloudflared -y
    ;;
    
  5)
    echo -e "${CYAN}🔐 Installing Tailscale...${NC}"
    curl -fsSL https://tailscale.com/install.sh | sh
    tailscale up
    ;;
    
  6)
    echo -e "${BLUE}📦 Installing Blueprint...${NC}"
    bash <(curl -s https://raw.githubusercontent.com/BlueprintFramework/framework/main/install.sh)
    ;;
    
  0)
    echo -e "${RED}👋 Exit${NC}"
    exit 0
    ;;
    
  *)
    echo -e "${RED}❌ Invalid option!${NC}"
    ;;
esac

