#!/bin/bash

# 0. Info #
#################################
# Kali Linux setup
# Main goal: create commands and scripts for easy replication
#################################

# 1. Update #
#################################
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y xrdp

# Sets xrdp to run at startup
sudo systemctl enable xrdp
sudo systemctl restart xrdp
sudo ufw allow 3389/tcp
#################################

# 1.1 Update root #
#################################
# https://linuxconfig.org/how-to-reset-kali-linux-root-password
sudo su -c 'passwd root'
#################################

# 2. Optional #
#################################
# In /etc/ssh/sshd_config, set the following:
# PasswordAuthentication no
# Then reload the daemon
# systemctl restart ssh
#################################

# 3. Multi Login Setup #
#################################
# Setup multi login
sudo sed -i '/^test -x \/etc\/X11\/Xsession/ i\unset DBUS_SESSION_BUS_ADDRESS\nunset XDG_RUNTIME_DIR' /etc/xrdp/startwm.sh
#################################

# 4. Enable Auto Logins #
#################################
# Enable auto login
# First confirm that your Kali Linux is set to use GDM3 as a default display manager:
if grep -q "/usr/sbin/gdm3" /etc/X11/default-display-manager; then
  echo "GDM3 is the default display manager"
else
  echo "GDM3 is not the default display manager, please set it manually."
  exit 1
fi

# Edit /etc/gdm3/daemon.conf
sudo sed -i '/\[daemon\]/ a\AutomaticLoginEnable = true\nAutomaticLogin = root' /etc/gdm3/daemon.conf

# Edit /etc/pam.d/gdm-password
sudo sed -i 's/^auth\s*required\s*pam_succeed_if.so user != root quiet_success/#&/' /etc/pam.d/gdm-password
#################################

# 5. Prevent turning off/sleeping on idle or after closing Laptop Lid #
#################################
# https://www.dell.com/support/kbdoc/en-ca/000179566/how-to-disable-sleep-and-configure-lid-power-settings-for-ubuntu-or-red-hat-enterprise-linux-7
sudo sed -i 's/#HandleLidSwitchExternalPower=/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
#################################

# 6. Setup machine for TryHackMe Vpn #
#################################
# Setup tryhackme openvpn
sudo openvpn ~/Downloads/Antid0te.vpn

# Check if you're connected
curl 10.10.10.10/whoami
#################################

# 8. Manual Setups #
#################################
# Set power management to High performance
# Turn off screen dimming
# Set Automatic Suspend to Off
# Set power button behavior to "Nothing"
#################################

# 7. Reboot #
#################################
# Finally reboot
sudo reboot
#################################
