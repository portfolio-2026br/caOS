# Executar estes comandos APÓS a instalação do OS
# Ajustes finos feitos na conta de usuário e em configuração pós instalação

### Configurar parâmetros do kernel ############################################
# Isto corrige o problema que impede o boot com animação gráfica
rpm-ostree kargs --delete-if-present=console=tty0 --delete-if-present=console=ttyS0 \
    --append-if-missing=rhgb --append-if-missing=quiet
#
# Em caso de problemas de resolução no gdm #####################################
sudo cp ~/.config/monitors.xml /etc/xdg/monitors.xml

# Usar Yaru como tema ############################################
gsettings set org.gnome.desktop.interface icon-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru'
gsettings set org.gnome.desktop.wm.preferences theme 'Yaru'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'

# Ajustes gerais ###############################################################
gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/wallpapers/Muralha.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark "file:///usr/share/wallpapers/Muralha.jpg"

# Instalar pacotes flatpak selecionados durante a instalação ###################
flatpak preinstall -y

# Desabilitar parte do inferno multicast #######################################
# gvfs starts wsdd, which then opens port *. Pacote não pode ser removido.
gsettings set org.gnome.system.wsdd display-mode 'disabled'
