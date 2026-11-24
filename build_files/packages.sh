echo "::group:: === Packages Install ==="
# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages
INCLUDED_PACKAGES=(
    gnome-extensions-app
    htop
    just
    yaru-icon-theme
    yaru-theme
)

# Install all Fedora packages
echo "Installing ${#INCLUDED_PACKAGES[@]} packages from Fedora repos..."
dnf -y install "${INCLUDED_PACKAGES[@]}"

curl -fsSLo /etc/yum.repos.d/brave-browser.repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
dnf -y install brave-origin

wget https://obdev.at/downloads/littlesnitch-linux/littlesnitch-1.1.1-1.x86_64.rpm -O /tmp/firewall.rpm
dnf -y install /tmp/firewall.rpm
echo "::endgroup::"

echo "::group:: === Remove ==="
# Remover:
# - Não necessários: CUPS, HPLIP, ...
# - Perigogos: samba, GNOME User Share, ...
# - Desnecessários: orca, yelp, ...
EXCLUDE_BASE=(
    cosign
    fedora-bookmarks
    fedora-chromium-config
    fedora-chromium-config-gnome
)
EXCLUDE_CUPS=(
    bluez-cups
    braille-printer-app
    c2esp
    cups-browsed
    cups-filters-driverless
    cups-filters
    cups
    dymo-cups-drivers
    gutenprint-cups
    hplip-common
    hplip-libs
    hplip
    libppd
    libsane-hpaio
    ptouch-driver
    splix
)
EXCLUDE_OUTROS=(
    fedora-third-party
    firefox
    firefox-langpacks
    gnome-software-rpm-ostree
    gnome-tour
    gnome-user-share
    httpd
    malcontent-control
    malcontent-ui-libs
    nvtop
    orca
    podman-docker
    samba-client
    totem-video-thumbnailer
    ublue-os-update-services
    virtualbox-guest-additions
    yelp
)
EXCLUDED_PACKAGES=( "${EXCLUDE_BASE[@]}" "${EXCLUDE_CUPS[@]}" "${EXCLUDE_OUTROS[@]}" )

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
