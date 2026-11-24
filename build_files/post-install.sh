echo "::group:: === Extensions ==="
# Dash to Dock
mkdir -p /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
wget https://github.com/ubuntu/dash-to-dock/releases/download/extensions.gnome.org-v110/dash-to-dock@micxgx.gmail.com.zip -O /tmp/dash-to-dock@micxgx.gmail.com/.zip
unzip /tmp/dash-to-dock@micxgx.gmail.com/.zip -d /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/
glib-compile-schemas --strict /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas

# App Indicator
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

echo "::group:: === Cleanup ==="
# Remove tmp files and everything in dirs that make bootc unhappy
rm -rf /tmp/* || true
rm -rf /run/dnf || true
rm -rf /usr/etc
rm -rf /boot && mkdir /boot

# Preserve cache mounts
find /var/* -maxdepth 0 -type d \! -name cache \! -name log -exec rm -rf {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 -exec rm -rf {} \;

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
rm /etc/xdg/autostart/vmware-user.desktop
rm -rf /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/background-logo@fedorahosted.org
rm -rf /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/user-theme@gnome-shell-extensions.gcampax.github.com

echo "::endgroup::"

echo "::group:: === Aparência ==="
# Usar Yaru como tema (isto não funciona)
# -> gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
# -> gsettings set org.gnome.desktop.interface gtk-theme 'Yaru'
# -> gsettings set org.gnome.desktop.wm.preferences theme 'Yaru'

# -> gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
# -> gsettings set org.gnome.desktop.interface color-scheme prefer-dark
# -> gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/wallpapers/Muralha.jpg'
# -> gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/wallpapers/Muralha.jpg"

# gvfs starts wsdd, which then opens port *. Pacote não pode ser removido.
gsettings set org.gnome.system.wsdd display-mode 'disabled'

echo "::endgroup::"