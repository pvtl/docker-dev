#!/bin/bash

## This script makes it easy to switch between PHP debugging tools (PCOV, Xdebug, Blackfire)
## Ensures only the tool you want is enabled, and the others are disabled


# Define the paths
XDEBUG_INI="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
PCOV_INI="/usr/local/etc/php/conf.d/docker-php-ext-pcov.ini"
BLACKFIRE_INI="/usr/local/etc/php/conf.d/blackfire.ini"

# Function to handle file operations
move_file() {
    local src=$1
    local dest=$2
    if [ -f "$src" ]; then
        mv "$src" "$dest"
    fi
}

# Function to disable all providers
disable_all() {
    move_file "$XDEBUG_INI" "$XDEBUG_INI.DISABLED"
    move_file "$PCOV_INI" "$PCOV_INI.DISABLED"
    move_file "$BLACKFIRE_INI" "$BLACKFIRE_INI.DISABLED"
    echo "All PHP debugging tools have been disabled."
}

# Function to enable specific provider
enable_provider() {
    case $1 in
        xdebug)
            move_file "$XDEBUG_INI.DISABLED" "$XDEBUG_INI"
            move_file "$PCOV_INI" "$PCOV_INI.DISABLED"
            move_file "$BLACKFIRE_INI" "$BLACKFIRE_INI.DISABLED"
            echo "Xdebug has been enabled."
            ;;
        pcov)
            move_file "$XDEBUG_INI" "$XDEBUG_INI.DISABLED"
            move_file "$PCOV_INI.DISABLED" "$PCOV_INI"
            move_file "$BLACKFIRE_INI" "$BLACKFIRE_INI.DISABLED"
            echo "PCOV has been enabled."
            ;;
        blackfire)
            move_file "$XDEBUG_INI" "$XDEBUG_INI.DISABLED"
            move_file "$PCOV_INI" "$PCOV_INI.DISABLED"
            move_file "$BLACKFIRE_INI.DISABLED" "$BLACKFIRE_INI"
            echo "Blackfire has been enabled."
            ;;
    esac
}

# Handle command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --disable-all)
            disable_all
            exit 0
            ;;
        --enable)
            if [ -z "$2" ]; then
                echo "Error: --enable requires a provider argument (Xdebug, PCOV, or Blackfire)"
                exit 1
            fi
            enable_provider "$2"
            exit 0
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --disable-all          Disable all debugging tools"
            echo "  --enable PROVIDER      Enable specific provider (Xdebug, PCOV, Blackfire)"
            echo "  --help                 Show this help message"
            echo ""
            echo "If no options are provided, interactive mode will be used."
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
    shift
done

# If no arguments provided, run interactive mode
echo "Which PHP debugging tool would you like to use?"
echo ""
echo "0. None (disable all)"
echo "1. Xdebug"
echo "2. PCOV"
echo "3. Blackfire"

# Read user input
read -p "Enter your choice [0-3]: " choice

case $choice in
    0)
        # Disable all
        disable_all
        ;;
    1)
        # Enable Xdebug only
        enable_provider xdebug
        ;;
    2)
        # Enable PCOV only
        enable_provider pcov
        ;;
    3)
        # Enable Blackfire only
        enable_provider blackfire
        ;;
    *)
        echo "Unexpected choice. Nothing has been changed."
        exit 1
        ;;
esac
