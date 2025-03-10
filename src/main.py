import os
import sys
from pathlib import Path

# Import PySide6
from PySide6.QtCore import QUrl, Qt, QTimer, QObject
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

def detect_system_dark_theme():
    """Détecte si le thème système est sombre."""
    # Cette fonction est spécifique à la plateforme
    
    # Sur Linux, c'est plus complexe et dépend de l'environnement de bureau
    if sys.platform.startswith("linux"):
        try:
            import subprocess
            # Pour GNOME
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "color-scheme"],
                capture_output=True, text=True
            )
            if "dark" in result.stdout.lower():
                return True
            
            # Pour GNOME plus ancien ou autres environnements
            result = subprocess.run(
                ["gsettings", "get", "org.gnome.desktop.interface", "gtk-theme"],
                capture_output=True, text=True
            )
            return "dark" in result.stdout.lower()
        except:
            pass
    
    # Sur Windows
    elif sys.platform == "win32":
        try:
            import winreg
            registry = winreg.ConnectRegistry(None, winreg.HKEY_CURRENT_USER)
            key = winreg.OpenKey(registry, r"Software\Microsoft\Windows\CurrentVersion\Themes\Personalize")
            value, _ = winreg.QueryValueEx(key, "AppsUseLightTheme")
            return value == 0
        except:
            pass
    
    # Sur macOS
    elif sys.platform == "darwin":
        try:
            import subprocess
            result = subprocess.run(
                ["defaults", "read", "-g", "AppleInterfaceStyle"],
                capture_output=True, text=True
            )
            return "Dark" in result.stdout
        except:
            pass
    
    # Par défaut, retournons False (thème clair)
    return False

if __name__ == "__main__":
    # Définir les identifiants d'application pour QSettings
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("CustomSync")
    app.setOrganizationDomain("customsync.org")
    app.setApplicationName("CustomSync")
    
    # Obtenir le chemin absolu du répertoire source
    base_dir = Path(__file__).resolve().parent
    
    # Créer le moteur QML
    engine = QQmlApplicationEngine()
    
    # Ajouter le répertoire source au chemin d'importation QML
    engine.addImportPath(str(base_dir))
    
    # Vérifier si le fichier QML principal existe
    main_qml_path = os.path.join(base_dir, "screens", "main.qml")
    if not os.path.exists(main_qml_path):
        print(f"Erreur: Le fichier {main_qml_path} n'existe pas!")
        sys.exit(-1)
    
    # Charger le fichier QML
    engine.load(QUrl.fromLocalFile(main_qml_path))
    
    # Vérifier si le chargement a réussi
    if not engine.rootObjects():
        print("Erreur: Impossible de charger le fichier QML principal!")
        sys.exit(-1)
    
    # Fonction pour mettre à jour le thème système
    def update_system_theme():
        try:
            is_dark = detect_system_dark_theme()
            # print(f"Thème système détecté: {'sombre' if is_dark else 'clair'}")
            
            # Récupérer l'objet racine (ApplicationWindow)
            root_window = engine.rootObjects()[0]
            
            # Appeler la méthode exposée par main.qml
            if hasattr(root_window, "setSystemTheme"):
                root_window.setSystemTheme(is_dark)
                # print(f"Méthode setSystemTheme appelée avec {is_dark}")
            else:
                print("La méthode setSystemTheme n'est pas disponible sur l'objet racine")
        except Exception as e:
            print(f"Erreur lors de la mise à jour du thème: {e}")
            import traceback
            traceback.print_exc()
    
    # Mettre en place un timer pour vérifier périodiquement le thème système
    theme_timer = QTimer()
    theme_timer.timeout.connect(update_system_theme)
    theme_timer.start(5000)  # Vérifier toutes les 5 secondes
    
    # Appliquer le thème système initial après un court délai
    QTimer.singleShot(500, update_system_theme)
    
    sys.exit(app.exec())