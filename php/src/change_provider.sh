#!/bin/bash

# Prompt the user to choose a provider
echo "Choose provider:"
echo "1. Xdebug"
echo "2. PCOV"
echo "3. Disable both"

# Read user input
read -p "Enter your choice (1/2/3): " choice

# Define the paths
XDEBUG_INI="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini"
XDEBUG_INI_DISABLED="/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE"
PCOV_INI="/usr/local/etc/php/conf.d/docker-php-ext-pcov.ini"
PCOV_INI_DISABLED="/usr/local/etc/php/conf.d/docker-php-ext-pcov.ini.DISABLE"
BLACKFIRE_INI="/usr/local/etc/php/conf.d/blackfire.ini"
BLACKFIRE_INI_DISABLED="/usr/local/etc/php/conf.d/blackfire.ini.DISABLE"

# Function to handle file operations
move_file() {
    local src=$1
    local dest=$2
    if [ -f "$src" ]; then
        sudo mv "$src" "$dest"
        echo "Moved $src to $dest"
    fi
}

# Execute commands based on user choice
case $choice in
    1)
        move_file "$PCOV_INI" "$PCOV_INI_DISABLED"
        move_file "$XDEBUG_INI_DISABLED" "$XDEBUG_INI"
        move_file "$BLACKFIRE_INI" "$BLACKFIRE_INI_DISABLED"
        ;;
    2)
        move_file "$XDEBUG_INI" "$XDEBUG_INI_DISABLED"
        move_file "$PCOV_INI_DISABLED" "$PCOV_INI"
        move_file "$BLACKFIRE_INI" "$BLACKFIRE_INI_DISABLED"
        ;;
    3)
        move_file "$BLACKFIRE_INI_DISABLED" "$BLACKFIRE_INI"
        move_file "$XDEBUG_INI" "$XDEBUG_INI_DISABLED"
        move_file "$PCOV_INI" "$PCOV_INI_DISABLED"
        ;;
    *)
        echo "Invalid choice. Please enter 1, 2, or 3."
        exit 1
        ;;
esac

echo "Configuration updated successfully."
