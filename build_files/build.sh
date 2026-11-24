#!/bin/bash

set -ouex pipefail

# Ajusta as propriedades e os nomes relacionados à "Distro"
source /ctx/info.sh

# Instala e remove pacotes de acordo com as necessidades da "Distro"
source /ctx/packages.sh

# Ajustes finais necessários à "Distro"
source /ctx/post-install.sh
