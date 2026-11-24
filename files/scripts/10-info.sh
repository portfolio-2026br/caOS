echo "::group:: === OS Info ==="

# OS Release File
sed -i "s|^PRETTY_NAME=.*|PRETTY_NAME=\"${IMAGE_PRETTY_NAME} (Silverblue: ${OSTREE_VERSION})\"|" /usr/lib/os-release

echo "::endgroup::"
