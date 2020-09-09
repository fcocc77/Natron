# !/usr/bin/sh

thread=4
natron_src='./'
qmake="qmake-qt4"

# entorno para gcc 8.3
source /opt/rh/devtoolset-8/enable
# -----------------

cd $natron_src

pkill -9 Nitrogen
rm App/Nitrogen
rm /opt/Natron2/bin/Natron

# Compilar sass stylesheet
npm run d
# -----------------

# Compilacion
$qmake
make -j $thread
# -------------------

# copia Natron compilado a la carpeta de la instalacion de Natron

cp ./App/Nitrogen /opt/Natron2/bin/Natron
/opt/Natron2/bin/Natron
# -------------------