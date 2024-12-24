#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

ensure_ssh_access() {
    if ! sudo ufw status | grep -q "22/tcp.*ALLOW"; then
        echo -e "${BOLD}${YELLOW}Ensuring SSH access is allowed...${NC}"
        sudo ufw allow 22/tcp
        echo -e "${BOLD}${GREEN}SSH access (port 22) has been allowed.${NC}"
    fi
}

check_ufw_status() {
    echo -e "${BOLD}${BLUE}Checking UFW status...${NC}"
    if sudo ufw status verbose; then
        echo -e "${BOLD}${GREEN}Successfully checked UFW status.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to check UFW status.${NC}"
    fi
}

enable_ufw() {
    echo -e "${BOLD}${GREEN}Enabling UFW...${NC}"
    ensure_ssh_access 
    if sudo ufw enable; then
        echo -e "${BOLD}${GREEN}Successfully enabled UFW.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to enable UFW.${NC}"
    fi
}

disable_ufw() {
    echo -e "${BOLD}${RED}Disabling UFW...${NC}"
    if sudo ufw disable; then
        echo -e "${BOLD}${GREEN}Successfully disabled UFW.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to disable UFW.${NC}"
    fi
}

allow_port() {
    port=$1
    # Prevent disabling SSH port
    if [ "$port" = "22" ]; then
        echo -e "${BOLD}${GREEN}SSH port 22 is protected and already allowed.${NC}"
        return
    fi
    
    echo -e "${BOLD}${YELLOW}Allowing port $port (TCP and UDP, IPv4 and IPv6)...${NC}"
    if sudo ufw allow $port/tcp && sudo ufw allow $port/udp; then
        echo -e "${BOLD}${GREEN}Successfully allowed port $port for TCP and UDP.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to allow port $port.${NC}"
    fi
}

deny_port() {
    port=$1
    if [ "$port" = "22" ]; then
        echo -e "${BOLD}${RED}Cannot deny SSH port 22. This port must remain open for security reasons.${NC}"
        return
    fi
    
    echo -e "${BOLD}${RED}Denying port $port (TCP and UDP, IPv4 and IPv6)...${NC}"
    if sudo ufw deny $port/tcp && sudo ufw deny $port/udp; then
        echo -e "${BOLD}${GREEN}Successfully denied port $port for TCP and UDP.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to deny port $port.${NC}"
    fi
}

allow_service() {
    service=$1
    echo -e "${BOLD}${GREEN}Allowing service $service...${NC}"
    if sudo ufw allow $service; then
        echo -e "${BOLD}${GREEN}Successfully allowed service $service.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to allow service $service.${NC}"
    fi
}

deny_service() {
    service=$1
    # Prevent blocking SSH service
    if [ "$service" = "ssh" ]; then
        echo -e "${BOLD}${RED}Cannot deny SSH service. This service must remain open for security reasons.${NC}"
        return
    fi
    
    echo -e "${BOLD}${RED}Denying service $service...${NC}"
    if sudo ufw deny $service; then
        echo -e "${BOLD}${GREEN}Successfully denied service $service.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to deny service $service.${NC}"
    fi
}

list_rules() {
    echo -e "${BOLD}${BLUE}Listing UFW rules...${NC}"
    if sudo ufw status numbered; then
        echo -e "${BOLD}${GREEN}Successfully listed UFW rules.${NC}"
    else
        echo -e "${BOLD}${RED}Failed to list UFW rules.${NC}"
    fi
}

show_menu() {
    clear
    echo -e "${BOLD}${BLUE}====================================${NC}"
    echo -e "${BOLD}${BLUE}    UFW Firewall Management Tool    ${NC}"
    echo -e "${BOLD}${BLUE}====================================${NC}"
    echo
    echo "1. Check UFW Status"
    echo "2. Enable UFW"
    echo "3. Disable UFW"
    echo "4. Allow Port (TCP and UDP, IPv4 and IPv6)"
    echo "5. Deny Port (TCP and UDP, IPv4 and IPv6)"
    echo "6. Allow Service"
    echo "7. Deny Service"
    echo "8. List Rules"
    echo "9. Exit"
    echo
    echo -n -e "${BOLD}${CYAN}Choose an option: ${NC}"
    read option
}

ensure_ssh_access

while true; do
    show_menu
    case $option in
        1) check_ufw_status ;;
        2) enable_ufw ;;
        3) disable_ufw ;;
        4) echo -n -e "${BOLD}${CYAN}Enter port number: ${NC}"; read port; allow_port $port ;;
        5) echo -n -e "${BOLD}${CYAN}Enter port number: ${NC}"; read port; deny_port $port ;;
        6) echo -n -e "${BOLD}${CYAN}Enter service name (e.g., ssh, http, etc.): ${NC}"; read service; allow_service $service ;;
        7) echo -n -e "${BOLD}${CYAN}Enter service name (e.g., ssh, http, etc.): ${NC}"; read service; deny_service $service ;;
        8) list_rules ;;
        9) echo -e "${BOLD}${GREEN}Thank you for using UFW Management Tool. Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${BOLD}${RED}Invalid option, please try again.${NC}" ;;
    esac
    echo -e "\nPress Enter to continue..."
    read -r
done
