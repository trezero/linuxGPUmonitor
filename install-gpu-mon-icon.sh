#!/bin/bash

# Installer script for NVIDIA SMI Monitor application with custom terminal size
# Updated to handle previous installations

# Function to display messages
info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

warn() {
    echo -e "\e[33m[WARN]\e[0m $1"
}

error() {
    echo -e "\e[31m[ERROR]\e[0m $1"
}

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    error "'nvidia-smi' command not found. Please ensure NVIDIA drivers are installed."
    exit 1
fi

# Check if watch is available
if ! command -v watch &> /dev/null; then
    warn "'watch' command not found. Installing 'procps' package."
    sudo apt-get update
    sudo apt-get install -y procps
fi

# Variables
DESKTOP_FILE_NAME="nvidia-smi.desktop"
DESKTOP_FILE_PATH="$HOME/.local/share/applications/$DESKTOP_FILE_NAME"
ICON_PATH="$HOME/.local/share/icons/nvidia-smi.svg"
SCRIPT_PATH="$HOME/.local/bin/nvidia-smi-monitor.sh"

# Create the SVG icon (same as before)
info "Creating custom SVG icon..."
mkdir -p "$HOME/.local/share/icons"
cat << EOF > "$ICON_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<svg width="256" height="256" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg">
  <rect width="256" height="256" fill="#76B900"/>
  <text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="72" fill="#FFFFFF" font-family="Arial, Helvetica, sans-serif">SMI</text>
</svg>
EOF

# Create the script that resizes the terminal and runs the command
info "Creating the NVIDIA SMI Monitor script..."
mkdir -p "$HOME/.local/bin"
cat << 'EOF' > "$SCRIPT_PATH"
#!/bin/bash
# Resize the terminal window to 40 rows and 120 columns
printf '\e[8;40;120t'
# Run the command
watch -n 1 nvidia-smi
# Keep the terminal open after the command exits
exec bash
EOF

# Make the script executable
chmod +x "$SCRIPT_PATH"

# Create the .desktop file content
info "Creating $DESKTOP_FILE_PATH..."
mkdir -p "$HOME/.local/share/applications"
cat << EOF > "$DESKTOP_FILE_PATH"
[Desktop Entry]
Name=NVIDIA SMI Monitor
Comment=Monitor NVIDIA GPU usage
Exec=$SCRIPT_PATH
Icon=$ICON_PATH
Terminal=true
Type=Application
Categories=System;
EOF

# Make the .desktop file executable
chmod +x "$DESKTOP_FILE_PATH"

# Refresh icon cache
info "Refreshing icon cache..."
gtk-update-icon-cache "$HOME/.local/share/icons" &> /dev/null

# Update desktop database
info "Updating desktop database..."
update-desktop-database "$HOME/.local/share/applications" &> /dev/null

info "Installation complete. You can now find 'NVIDIA SMI Monitor' in your applications menu."

# Optional: Add to favorites (GNOME-specific)
read -p "Would you like to add 'NVIDIA SMI Monitor' to your favorites bar? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    # Get current favorites
    current_favorites=$(gsettings get org.gnome.shell favorite-apps)
    # Check if the app is already in favorites
    if [[ "$current_favorites" == *"$DESKTOP_FILE_NAME"* ]]; then
        warn "'NVIDIA SMI Monitor' is already in your favorites."
    else
        # Remove trailing bracket and add new app
        new_favorites="${current_favorites%]*}, '$DESKTOP_FILE_NAME']"
        # Update favorites
        gsettings set org.gnome.shell favorite-apps "$new_favorites"
        info "'NVIDIA SMI Monitor' has been added to your favorites."
    fi
fi

# Cleanup: Remove old versions of files if necessary
# (In this case, the script overwrites existing files, so no additional cleanup is needed)
