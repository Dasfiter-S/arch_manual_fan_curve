#!/bin/bash

# Function to append amdgpu.ppfeaturemask to GRUB_CMDLINE_LINUX_DEFAULT
append_to_grub() {
    local grub_config="/etc/default/grub"
    local temp_file=$(mktemp)

    # Ensure the script is run as root
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi

    # Append the parameter to GRUB_CMDLINE_LINUX_DEFAULT
    awk -v param="amdgpu.ppfeaturemask=0xffffffff" '
    /^GRUB_CMDLINE_LINUX_DEFAULT=/ {
        if ($0 !~ param) {
            sub(/"$/, " " param "\"", $0)
        }
    }
    { print }' "$grub_config" > "$temp_file" && mv "$temp_file" "$grub_config"

    # Update GRUB
    sudo update-grub
}

# Function to set the fan curve
set_fan_curve() {
    local fan_curve_path=$(find /sys -name fan_curve 2>/dev/null | grep gpu_od)

    # Check if the fan_curve file is found
    if [ -z "$fan_curve_path" ]; then
        echo "fan_curve file not found"
        exit 1
    fi

    # Set the fan curve
    echo '0 40 30' | sudo tee "$fan_curve_path"
    echo '1 50 50' | sudo tee "$fan_curve_path"
    echo '2 60 70' | sudo tee "$fan_curve_path"
    echo '3 70 85' | sudo tee "$fan_curve_path"
    echo '4 80 100' | sudo tee "$fan_curve_path"
}

# Append to GRUB and set the fan curve
append_to_grub
set_fan_curve

# Ask user for confirmation to commit changes
read -p "Do you want to commit the changes to the GPU? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    local fan_curve_path=$(find /sys -name fan_curve 2>/dev/null | grep gpu_od)
    echo 'c' | sudo tee "$fan_curve_path"
fi
