echo "::group:: === Packages Install ==="
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

wget https://obdev.at/downloads/littlesnitch-linux/littlesnitch-1.1.1-1-x86_64.pkg.tar.zst -O /tmp/littlesnitch-x86_64.pkg.tar.zst

mkdir littlesnitch-pkg
tar -xf /tmp/littlesnitch-x86_64.pkg.tar.zst -C littlesnitch-pkg
cd littlesnitch-pkg

install -m 755 usr/bin/littlesnitch /usr/local/bin/littlesnitch

cp usr/lib/systemd/system/littlesnitch.service /etc/systemd/system/
sed -i 's|/usr/bin/littlesnitch|/usr/local/bin/littlesnitch|' /etc/systemd/system/littlesnitch.service

echo "::endgroup::"
