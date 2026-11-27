#!/bin/bash

set -ouex pipefail

# Ajusta as propriedades e os nomes relacionados à "Distro"
source /ctx/10-info.sh

# Instala e remove pacotes de acordo com as necessidades da "Distro"
source /ctx/20-packages.sh

# Ajustes finais necessários à "Distro"
source /ctx/30-final.sh
