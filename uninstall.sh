#!/bin/bash

# Strict error handling
set -euo pipefail
IFS=$'\n\t'

# Constants
readonly CONFIG_DIR="$HOME/.config/alacritty"
readonly BACKUP_DIR="$HOME/alacritty_backup"
readonly LOG_FILE="/tmp/alacritty_uninstall_$(date +%s).log"

# Color constants
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Function to print messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE" >&2
}

# Function to remove configuration
remove_config() {
    if [ -d "$CONFIG_DIR" ]; then
        local backup_path="$BACKUP_DIR/backup_before_uninstall_$(date +%Y%m%d_%H%M%S)"
        log_info "Backing up configuration to $backup_path"
        mkdir -p "$backup_path"
        mv "$CONFIG_DIR" "$backup_path/" || log_warning "Failed to backup configuration."
        log_info "Configuration removed."
    else
        log_warning "No existing Alacritty configuration found."
    fi
}

# Main function
main() {
    log_info "Starting Alacritty uninstallation..."
    remove_config
    log_info "Uninstallation completed."
}

# Execute main function
main "$@"

