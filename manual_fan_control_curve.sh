#!/bin/bash

fan_curve_path=/sys/class/drm/card1/device/gpu_od/fan_ctrl/fan_curve
append_to_grub() {
    local grub_config="/etc/default/grub"
    local temp_file=$(mktemp)

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

    sudo update-grub
}

set_fan_curve() {
    if [ ! -f "$fan_curve_path" ]; then
        echo "fan_curve file not found"
        exit 1
    fi

    # Set the fan curve here if you want something different
    echo '0 30 40' | sudo tee "$fan_curve_path"
    echo '1 40 50' | sudo tee "$fan_curve_path"
    echo '2 50 70' | sudo tee "$fan_curve_path"
    echo '3 60 85' | sudo tee "$fan_curve_path"
    echo '4 65 100' | sudo tee "$fan_curve_path"
}

# Append to GRUB and set the fan curve
append_to_grub
set_fan_curve

read -p "Do you want to commit the changes to the GPU? [y/N]: " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo 'c' | sudo tee "$fan_curve_path"
fi
