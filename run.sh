#!/bin/bash

# Define colors for the bootstrapper
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

clear
echo -e "${BLUE}==========================================${NC}"
echo -e "${CYAN}      Arch Dots Installation Wrapper      ${NC}"
echo -e "${BLUE}==========================================${NC}"
echo -e ""
echo -e "How would you like to proceed?"
echo -e "1) ${CYAN}Modern Python Installer${NC} (Requires Rich & Requests)"
echo -e "2) ${YELLOW}Classic Bash Installer${NC} (Zero dependencies)"
echo -e ""
read -p "Selection [1-2]: " choice

case $choice in
    1)
        echo -e "\n${BLUE}[*] Checking Python environment...${NC}"
        
        # Check if Python is installed
        if ! command -v python &> /dev/null; then
            echo -e "${RED}[!] Python is not installed. Falling back to Bash.${NC}"
            sleep 2
            bash ./setup.sh
            exit
        fi

        # Check/Install dependencies
        echo -e "${BLUE}[*] Ensuring Python dependencies (rich, requests) are present...${NC}"
        # We use pacman as it's cleaner on Arch, but fallback to pip if needed
        if ! python -c "import rich, requests" &> /dev/null; then
            echo -e "${YELLOW}[!] Dependencies missing. Installing...${NC}"
            sudo pacman -S --noconfirm python-rich python-requests || pip install rich requests
        fi

        echo -e "${BLUE}[*] Launching Python Installer...${NC}\n"
        python ./setup.py
        ;;
    
    2)
        echo -e "\n${YELLOW}[*] Launching Bash Installer...${NC}\n"
        chmod +x ./setup.sh
        ./setup.sh
        ;;

    *)
        echo -e "${RED}[!] Invalid selection. Exiting.${NC}"
        exit 1
        ;;
esac