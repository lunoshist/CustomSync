#!/usr/bin/env python3

import os
import sys
import importlib
import subprocess
import json
import pkg_resources
from pathlib import Path

def print_section(title):
    print("\n" + "=" * 50)
    print(f" {title} ".center(50, "="))
    print("=" * 50)

def get_python_info():
    print_section("INFORMATIONS PYTHON")
    print(f"Version Python: {sys.version}")
    print(f"Chemin d'exécutable: {sys.executable}")
    print(f"Chemin d'importation: {sys.path}")

def get_qt_bindings():
    print_section("LIAISONS QT")
    qt_modules = []
    
    # Vérification de PySide6
    try:
        import PySide6
        print(f"PySide6 installé: {PySide6.__version__}")
        qt_modules.append(("PySide6", PySide6.__version__))
        
        # Vérifier quels sous-modules sont disponibles
        print("\nModules PySide6 disponibles:")
        pyside6_modules = [
            "QtCore", "QtGui", "QtWidgets", "QtQml", "QtQuick", 
            "QtQuickControls2", "QtQuickWidgets", "QtSvg", "QtSvgWidgets",
            "Qt3DCore", "Qt3DRender", "Qt3DInput", "Qt3DLogic", "Qt3DExtras",
            "QtMultimedia", "QtNetwork", "QtWebEngine", "QtWebEngineCore",
            "QtWebEngineWidgets", "QtWebChannel", "QtPositioning", "QtPrintSupport",
            "QtOpenGL", "QtOpenGLWidgets", "QtBluetooth", "QtSensors", "QtSerialPort", 
            "QtCharts", "QtDataVisualization", "QtConcurrent", "QtXml", "QtSql",
            "QtTest", "QtStateMachine", "QtQuickTemplates2", "Qt3DAnimation"
        ]
        
        for module_name in pyside6_modules:
            try:
                module = importlib.import_module(f"PySide6.{module_name}")
                print(f"  - {module_name} ✓")
            except ImportError:
                print(f"  - {module_name} ✗")
                
        from PySide6 import QtCore
        print(f"\nQt version: {QtCore.qVersion()}")
        print(f"Qt path: {QtCore.__file__}")
        
    except ImportError:
        print("PySide6 non installé")
    
    # Vérification de PyQt6
    try:
        import PyQt6
        print(f"\nPyQt6 installé")
        qt_modules.append(("PyQt6", "N/A"))  # PyQt6 n'expose pas facilement sa version
    except ImportError:
        print("\nPyQt6 non installé")
    
    # Vérification de PySide2
    try:
        import PySide2
        print(f"\nPySide2 installé: {PySide2.__version__}")
        qt_modules.append(("PySide2", PySide2.__version__))
    except ImportError:
        print("\nPySide2 non installé")
    
    # Vérification de PyQt5
    try:
        import PyQt5
        print(f"\nPyQt5 installé")
        qt_modules.append(("PyQt5", "N/A"))
    except ImportError:
        print("\nPyQt5 non installé")
        
    return qt_modules

def get_installed_packages():
    print_section("PAQUETS PYTHON INSTALLÉS")
    
    try:
        installed_packages = pkg_resources.working_set
        installed_packages_list = sorted(["%s==%s" % (i.key, i.version) for i in installed_packages])
        
        for package in installed_packages_list:
            print(package)
    except Exception as e:
        print(f"Erreur lors de la récupération des paquets installés: {e}")

def check_qml_import_paths():
    print_section("CHEMINS D'IMPORTATION QML")
    
    qt_modules = get_qt_bindings()
    
    if not qt_modules:
        print("Aucun module Qt trouvé, impossible de déterminer les chemins d'importation QML")
        return
    
    for binding, version in qt_modules:
        if binding == "PySide6":
            try:
                from PySide6.QtCore import QLibraryInfo
                print(f"Chemins d'importation QML pour PySide6:")
                try:
                    # Qt6
                    import_paths = QLibraryInfo.path(QLibraryInfo.LibraryPath.QmlImportsPath)
                    print(f"  - {import_paths}")
                except:
                    # Old method
                    try:
                        import_paths = QLibraryInfo.location(QLibraryInfo.LibraryLocation.QmlImportsPath)
                        print(f"  - {import_paths}")
                    except:
                        print("  - Impossible de déterminer les chemins d'importation QML")
            except Exception as e:
                print(f"Erreur lors de la récupération des chemins d'importation QML pour PySide6: {e}")
        
        # Vérifier d'autres liaisons si nécessaire

def check_project_structure():
    print_section("STRUCTURE DU PROJET")
    
    try:
        # Trouver le dossier du projet
        current_dir = Path.cwd()
        print(f"Dossier actuel: {current_dir}")
        
        # Liste des fichiers sources QML
        print("\nFichiers QML dans src/:")
        qml_files = []
        for root, dirs, files in os.walk(current_dir / "src"):
            for file in files:
                if file.endswith(".qml"):
                    qml_path = Path(root) / file
                    qml_files.append(qml_path)
                    print(f"  - {qml_path.relative_to(current_dir)}")
        
        # Vérifier les importations dans les fichiers QML
        print("\nAnalyse des importations dans les fichiers QML:")
        for qml_file in qml_files:
            try:
                imports = []
                with open(qml_file, 'r') as f:
                    for line in f:
                        if line.strip().startswith('import '):
                            imports.append(line.strip())
                
                if imports:
                    print(f"\n  {qml_file.relative_to(current_dir)}:")
                    for imp in imports:
                        print(f"    - {imp}")
            except Exception as e:
                print(f"  Erreur lors de l'analyse de {qml_file}: {e}")
        
    except Exception as e:
        print(f"Erreur lors de l'analyse de la structure du projet: {e}")

def main():
    print("AUDIT DE L'ENVIRONNEMENT QT")
    print(f"Date d'exécution: {subprocess.check_output(['date']).decode().strip()}")
    
    get_python_info()
    get_qt_bindings()
    get_installed_packages()
    check_qml_import_paths()
    check_project_structure()

if __name__ == "__main__":
    main()