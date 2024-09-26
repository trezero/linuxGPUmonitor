# linuxGPUmonitor
NVIDIA SMI Monitor
A simple application that creates a launcher icon to monitor NVIDIA GPU usage in real-time on Ubuntu 22.04. This tool opens a terminal window displaying live GPU statistics using nvidia-smi, updated every second.

Features
Real-Time Monitoring: Displays up-to-date GPU usage, temperature, memory utilization, and more.
Custom Terminal Size: Opens the terminal window with a larger size to ensure all information is visible.
Launcher Icon: Adds an application icon to your applications menu and optionally to your favorites bar.
Easy Installation: Simple installer script that handles setup and updates.
Prerequisites
Ubuntu 22.04 or a compatible Linux distribution.
NVIDIA Drivers: Ensure that NVIDIA drivers are installed and nvidia-smi is available.
watch Command: Typically included in the procps package.
Installation
Clone the Repository

bash
Copy code
git clone https://github.com/yourusername/nvidia-smi-monitor.git
cd nvidia-smi-monitor
Make the Installer Executable

bash
Copy code
chmod +x install.sh
Run the Installer

bash
Copy code
./install.sh
The installer will check for necessary dependencies.
It will create a custom SVG icon and place it in the appropriate directory.
A script to launch the monitor with a custom terminal size will be installed.
An application launcher (.desktop file) will be created.
You'll be prompted to add the application to your favorites bar (GNOME-specific).
Usage
Launch the Application

Open the applications menu.
Search for NVIDIA SMI Monitor.
Click the icon to start monitoring.
Monitor GPU Usage

A terminal window will open, resized to display all output.
The nvidia-smi command runs with watch, updating every second.
Press Ctrl+C to exit the monitor.
Customization
Adjust Terminal Size
Modify Rows and Columns

Edit the script at ~/.local/bin/nvidia-smi-monitor.sh.
Locate the line: printf '\e[8;40;120t'
Change 40 (rows) and 120 (columns) to your desired size.
bash
Copy code
# Example: Set terminal to 50 rows and 140 columns
printf '\e[8;50;140t'
Change Update Interval
Modify Refresh Rate

In the same script, find the line: watch -n 1 nvidia-smi
Change 1 to the number of seconds you want between updates.
bash
Copy code
# Example: Update every 5 seconds
watch -n 5 nvidia-smi
Uninstallation
To completely remove the NVIDIA SMI Monitor application:

Remove Installed Files

bash
Copy code
rm "$HOME/.local/share/icons/nvidia-smi.svg"
rm "$HOME/.local/bin/nvidia-smi-monitor.sh"
rm "$HOME/.local/share/applications/nvidia-smi.desktop"
Remove from Favorites (Optional, GNOME-specific)

bash
Copy code
# Get current favorites
current_favorites=$(gsettings get org.gnome.shell favorite-apps)
# Remove the application from favorites
new_favorites=$(echo "$current_favorites" | sed "s/, 'nvidia-smi.desktop'//g" | sed "s/'nvidia-smi.desktop', //g")
# Update favorites
gsettings set org.gnome.shell favorite-apps "$new_favorites"
Troubleshooting
nvidia-smi Command Not Found

Ensure NVIDIA drivers are installed properly.
Run nvidia-smi in the terminal to verify.
Terminal Window Size Not Changing

The escape sequence may not be supported in all terminal emulators.
Try specifying the terminal emulator directly in the .desktop file with size options.
Icon Not Displaying

Refresh the icon cache:

bash
Copy code
gtk-update-icon-cache "$HOME/.local/share/icons"
Restart GNOME Shell (press Alt + F2, type r, and press Enter).

License
This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
NVIDIA Corporation: For providing the nvidia-smi tool.
Community Contributors: For inspiration and assistance in creating this application.
Contact
For questions or suggestions, please open an issue on the GitHub repository.