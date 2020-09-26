# !/usr/bin/sh

thread=4
natron_src='./'
qmake="qmake-qt4"

install_folder='/opt/Natron2'

# entorno para gcc 8.3
source /opt/rh/devtoolset-8/enable
#

cd $natron_src

pkill -9 Nitrogen
rm App/Nitrogen
rm $install_folder/bin/Nitrogen

# Compilar sass stylesheet
npm run d
# -----------------

# Compilacion
$qmake
make -j $thread
# -------------------

# copia Natron compilado a la carpeta de la instalacion de Natron
cp ./App/Nitrogen $install_folder/bin/Nitrogen
#

# copia stylesheet
cp ./Gui/Resources/Stylesheets/mainstyle.qss $install_folder/Resources/stylesheets/mainstyle.qss

# Natron desktop
cp ./Gui/Resources/Applications/Nitrogen $install_folder/Nitrogen
chmod 755 $install_folder/Nitrogen
cp ./Gui/Resources/Applications/Nitrogen.desktop /usr/share/applications/Nitrogen.desktop

# icono
mkdir $install_folder/Resources/Images
cp ./Gui/Resources/Images/nitrogen.png $install_folder/Resources/Images/nitrogen.png
