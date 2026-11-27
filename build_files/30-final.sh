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

echo "::group:: === Remove Undesired Files ==="
# Arquivos indesejados
rm /etc/yum.repos.d/negativo17-fedora-multimedia.repo
rm /etc/yum.repos.d/_copr_rok-cdemu.repo
rm /etc/yum.repos.d/_copr_ublue-os-akmods.repo

rm /etc/xdg/autostart/at-spi-dbus-bus.desktop
rm /etc/xdg/autostart/geoclue-demo-agent.desktop
rm /etc/xdg/autostart/ibus-mozc-launch-xwayland.desktop

echo "::endgroup::"

echo "::group:: === Services ==="
### Serviços ###################################################################
DISABLED=( $(yq .system.disabled.[] /ctx/systemd.yaml) )
MASKED=( $(yq .system.masked.[] /ctx/systemd.yaml) )

systemctl disable    "${DISABLED[@]}"
systemctl mask --now "${MASKED[@]}"

# Copiar arquivos de configuração em /etc
ORIGEM=( $(yq .etc[].arquivo /ctx/files.yaml) )
contador=0

for arquivo in "${ORIGEM[@]}"; do
    destino=$(yq .etc[$contador].destino /ctx/files.yaml)
    echo "Copiando etc/$arquivo para $destino$arquivo"
    mkdir -p "$destino"
    cp "ctx/files/etc/$arquivo" "$destino$arquivo"
    ((contador=contador+1))
done

# Copiar arquivos de configuração em /usr
ORIGEM=( $(yq .usr[].arquivo /ctx/files.yaml) )
contador=0

for arquivo in "${ORIGEM[@]}"; do
    destino=$(yq .usr[$contador].destino /ctx/files.yaml)
    echo "Copiando usr/$arquivo para $destino$arquivo"
    mkdir -p "$destino"
    cp "ctx/files/usr/$arquivo" "$destino$arquivo"
    ((contador=contador+1))
done

echo "::endgroup::"

echo "::group:: === Final Adjustments ==="
### Substitui referência HTTP -> HTTPS #########################################
sed -i 's/http:/https:/g' /usr/lib/NetworkManager/conf.d/20-connectivity-fedora.conf

### Ajusta permissões ##########################################################
chmod 440 /etc/sudoers

### Configurações de login #####################################################
authselect select local with-faillock without-nullok with-silent-lastlog --force

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
