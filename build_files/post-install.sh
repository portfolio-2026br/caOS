echo "::group:: === Extensions ==="
# Dash to Dock **RUN MANUAL-DEPENDABOT**
mkdir -p /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
wget https://github.com/ubuntu/dash-to-dock/releases/download/extensions.gnome.org-v110/dash-to-dock@micxgx.gmail.com.zip -O /tmp/dash-to-dock@micxgx.gmail.com.zip
unzip /tmp/dash-to-dock@micxgx.gmail.com.zip -d /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas

# App Indicator **RUN MANUAL-DEPENDABOT**
mkdir -p /usr/share/gnome-shell/extensions/BetterTrayIcons@nexaknight.com
wget https://github.com/nexaknight/BetterTrayIcons/releases/download/v3.5.1/BetterTrayIcons@nexaknight.com.zip -O /tmp/BetterTrayIcons@nexaknight.com.zip
unzip /tmp/BetterTrayIcons@nexaknight.com.zip -d /usr/share/gnome-shell/extensions/BetterTrayIcons@nexaknight.com
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/BetterTrayIcons@nexaknight.com/schemas

echo "::endgroup::"

echo "::group:: === Flatpak & Desktop Files ==="
#Add the Flathub Flatpak remote and remove the Fedora Flatpak remote
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Hide Desktop Files. Hidden removes mime associations
for file in htop; do
    if [[ -f "/usr/share/applications/$file.desktop" ]]; then
        sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/"$file".desktop
    fi
done

echo "::endgroup::"

echo "::group:: === Ajustes ==="
sed -i 's/http:/https:/g' /usr/lib/NetworkManager/conf.d/20-connectivity-fedora.conf

# Arquivos indesejados
rm /etc/yum.repos.d/negativo17-fedora-multimedia.repo
rm /etc/yum.repos.d/_copr_rok-cdemu.repo
rm /etc/yum.repos.d/_copr_ublue-os-akmods.repo

rm /etc/xdg/autostart/at-spi-dbus-bus.desktop
rm /etc/xdg/autostart/geoclue-demo-agent.desktop
rm /etc/xdg/autostart/ibus-mozc-launch-xwayland.desktop

echo "::endgroup::"

echo "::group:: === Final ==="
# Usar Yaru como tema (código comentado precisa ser executado manualmente)
# -> gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
# -> gsettings set org.gnome.desktop.interface gtk-theme 'Yaru'
# -> gsettings set org.gnome.desktop.wm.preferences theme 'Yaru'
# -> gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'

# -> gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
# -> gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# -> gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/wallpapers/Muralha.jpg'
# -> gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/wallpapers/Muralha.jpg"

# -> flatpak preinstall -y

# gvfs starts wsdd, which then opens port *. Pacote não pode ser removido.
# -> gsettings set org.gnome.system.wsdd display-mode 'disabled'

### Mask only what a machine will never use ####################################
# Serviços que eu não preciso
systemctl mask --now avahi-daemon.service avahi-daemon.socket # cups.service cups.socket cups.path

# Serviços sem utilidade para mim
systemctl mask --now geoclue ModemManager.service mdmonitor.service switcheroo-control passim.service
systemctl disable    serial-getty@ttyS0.service pcscd.service gssproxy.service mcelog.service

# Avaliar
# Check -> systemctl list-units --type=service --state=running --no-pager
# auto-cpufreq is an automatic CPU speed and power optimizer for Linux.
# mcelog.service failed
# mcelog: mcelog: ERROR: AMD Processor family 23: mcelog does not support this processor.  Please use the edac_mce_amd module instead.

### Ajusta permissões ##########################################################
chmod 440 /etc/sudoers

### Configurações de login #####################################################
authselect select local with-faillock without-nullok with-silent-lastlog --force

### Configurar parâmetros do kernel ############################################
# rpm-ostree kargs --delete-if-present=console=tty0 --delete-if-present=console=ttyS0 \
#     --append-if-missing=rhgb --append-if-missing=quiet
#
# Em caso de problemas de resolução
# sudo cp ~/.config/monitors.xml /etc/xdg/monitors.xml

echo "::endgroup::"

echo "::group:: === Cleanup ==="
# Remove tmp files and everything in dirs that make bootc unhappy
rm -rf /tmp/* || true
rm -rf /run/dnf || true
rm -rf /usr/etc
rm -rf /boot && mkdir /boot

# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache \! -name log \! -name tmp -exec rm -rf {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;

echo "::endgroup::"
