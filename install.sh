#!/bin/bash

# Strict error handling
set -euo pipefail
IFS=$'\n\t'

# Constants
readonly REPO_URL="https://github.com/herschel21/alacritty-configuration/archive/refs/heads/release-1.0.zip"
readonly TEMP_DIR="/tmp/alacritty_install_$(date +%s)"
readonly CONFIG_DIR="$HOME/.config/alacritty"
readonly ZIP_FILE="$TEMP_DIR/release-1.0.zip"
readonly BACKUP_DIR="$HOME/alacritty_backup/backup_$(date +%Y%m%d_%H%M%S)"
readonly LOG_FILE="$TEMP_DIR/install.log"

# Color constants
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly NC='\033[0m' # No Color

# Function to print messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Function to handle errors
error_exit() {
    log_error "$1"
    cleanup
    exit 1
}

# Function to cleanup temporary files
cleanup() {
    rm -rf "$TEMP_DIR"
}

# Ensure cleanup runs on exit
trap cleanup EXIT

# Function to check if a command exists
check_command() {
    if ! command -v "$1" &>/dev/null; then
        error_exit "Required command '$1' not found. Please install it first."
    fi
}

# Function to backup existing configuration
backup_config() {
    if [ -d "$CONFIG_DIR" ]; then
        log_info "Backing up existing Alacritty configuration..."
        mkdir -p "$BACKUP_DIR" || error_exit "Failed to create backup directory."
        mv "$CONFIG_DIR" "$BACKUP_DIR/" || error_exit "Failed to backup existing configuration."
        log_info "Backup created at $BACKUP_DIR"
    else
        log_info "No existing Alacritty configuration found. Skipping backup."
    fi
}

# Function to install Alacritty configuration
install_config() {
    log_info "Creating temporary directory..."
    mkdir -p "$TEMP_DIR" || error_exit "Failed to create temporary directory."
    
    log_info "Downloading configuration from GitHub..."
    curl -L "$REPO_URL" -o "$ZIP_FILE" || error_exit "Failed to download configuration."
    
    log_info "Extracting configuration files..."
    unzip -o "$ZIP_FILE" -d "$TEMP_DIR" || error_exit "Failed to unzip configuration."
    
    log_info "Installing configuration..."
    mkdir -p "$CONFIG_DIR" || error_exit "Failed to create config directory."
    cp -r "$TEMP_DIR/alacritty-configuration-release-1.0/alacritty/"* "$CONFIG_DIR/" || error_exit "Failed to copy configuration."
    
    log_info "Alacritty configuration successfully installed."
}

# Main installation process
main() {
    log_info "Starting Alacritty configuration installation..."
    backup_config
    install_config
    log_info "Installation completed successfully!"
}

# Execute main function
main "$@"

