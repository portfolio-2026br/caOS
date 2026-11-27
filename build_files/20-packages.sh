echo "::group:: === Install yq ==="
dnf -y install yq
echo "::endgroup::"

echo "::group:: === Packages Install ==="
# Copy the contents of system files as defined in YAML
INCLUDED_PACKAGES=( $(yq .install.packages.[] /ctx/packages.yaml) )
EXCLUDED_PACKAGES=( $(yq .remove.packages.[] /ctx/packages.yaml) )

# Install all Fedora packages
echo "Installing ${#INCLUDED_PACKAGES[@]} packages from Fedora repos..."
dnf -y install "${INCLUDED_PACKAGES[@]}"

curl -fsSLo /etc/yum.repos.d/brave-browser.repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf -y install brave-origin

# **RUN MANUAL-DEPENDABOT**    FALHA
# wget https://obdev.at/downloads/littlesnitch-linux/littlesnitch-1.1.1-1.x86_64.rpm -O /tmp/firewall.rpm
# dnf -y install /tmp/firewall.rpm
# >>> Scriptlet output:
# >>> System has not been booted with systemd as init system (PID 1). Can't operate.
# >>> Failed to connect to system scope bus via local transport: Host is down
# >>> Created symlink '/etc/systemd/system/multi-user.target.wants/littlesnitch.service' → '/usr/lib/systemd/system/littlesnitch.service'.
# >>> System has not been booted with systemd as init system (PID 1). Can't operate.
# >>> Failed to connect to system scope bus via local transport: Host is down

rpm --import https://packages.microsoft.com/keys/microsoft.asc

tee /etc/yum.repos.d/vscode.repo > /dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

dnf -y install code

echo "::endgroup::"

echo "::group:: === Remove ==="
# Remover:
# - Não necessários: CUPS, HPLIP, ...
# - Perigogos: samba, GNOME User Share, ...
# - Desnecessários: orca, yelp, ...

# Remove excluded packages if they are installed
if [[ "${#EXCLUDED_PACKAGES[@]}" -gt 0 ]]; then
    readarray -t INSTALLED_EXCLUDED < <(rpm -qa --queryformat='%{NAME}\n' "${EXCLUDED_PACKAGES[@]}" 2>/dev/null || true)
    if [[ "${#INSTALLED_EXCLUDED[@]}" -gt 0 ]]; then
        dnf -y remove "${INSTALLED_EXCLUDED[@]}"
    else
        echo "No excluded packages found to remove."
    fi
fi
echo "::endgroup::"
