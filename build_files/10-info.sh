echo "::group:: === OS Info ==="

IMAGE_PRETTY_NAME="uBlue caOS"
HOME_URL="https://github.com/portfolio-2026br/caOS"
CODE_NAME="caOS"
VERSION="$(grep '^VERSION=' /usr/lib/os-release | cut -d '"' -f2 | cut -d ' ' -f1)"

sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"$CODE_NAME\"|" /usr/lib/os-release

if [[ -n "${SHA_HEAD_SHORT:-}" ]]; then
	echo "BUILD_ID=\"$SHA_HEAD_SHORT\"" >>/usr/lib/os-release
fi

# OS Release File
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"${IMAGE_PRETTY_NAME} (Silverblue: ${VERSION})\"|" /usr/lib/os-release
sed -i "s|^HOME_URL=.*|HOME_URL=\"$HOME_URL\"|" /usr/lib/os-release
# -> sed -i "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${IMAGE_PRETTY_NAME,}\"|" /usr/lib/os-release
sed -i "s|^DEFAULT_HOSTNAME=.*|DEFAULT_HOSTNAME=\"${CODE_NAME,}\"|" /usr/lib/os-release
sed -i "s|^VERSION_CODENAME=.*|VERSION_CODENAME=\"$CODE_NAME\"|" /usr/lib/os-release

# Added in systemd 249.
# https://www.freedesktop.org/software/systemd/man/latest/os-release.html#IMAGE_ID=
echo "IMAGE_ID=\"${CODE_NAME} $(date +%Y-%m-%d)\"" >>/usr/lib/os-release

echo "::endgroup::"
