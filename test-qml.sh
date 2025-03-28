# test-qml.sh
#!/bin/bash


# Activer l'environnement virtuel
source customsync-env/bin/activate

# Création d'un script Python temporaire pour lancer le fichier QML
echo "On utilise Python directement pour lancer le fichier QML..."

# Vérifier si un fichier a été spécifié
if [ -z "$1" ]; then
    echo "Usage: $0 <fichier-qml>"
    exit 1
fi

# Obtenir le chemin absolu du répertoire courant
PROJECT_DIR=$(pwd)

# Créer un script Python temporaire pour lancer le fichier QML
echo "import sys
from pathlib import Path
from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()

# Ajouter les chemins d'importation
engine.addImportPath('$PROJECT_DIR')
engine.addImportPath('$PROJECT_DIR/src')
engine.addImportPath('.')

# Charger le fichier QML spécifié
file_path = Path('$1').resolve()
print(f'Chargement du fichier: {file_path}')

# Définir le dossier de travail au même niveau que le fichier QML
qml_dir = file_path.parent
print(f'Répertoire de travail QML: {qml_dir}')

engine.load(QUrl.fromLocalFile(str(file_path)))

if not engine.rootObjects():
    print('Erreur lors du chargement du fichier QML')
    sys.exit(-1)

print('Fichier QML chargé avec succès, démarrage de l\\'application...')
sys.exit(app.exec())
" > temp_launcher.py

# Exécuter le script Python
python temp_launcher.py
rm temp_launcher.py