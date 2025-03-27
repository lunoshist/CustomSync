#!/usr/bin/env python3
"""
tests/run_tests.py - Framework de test unifié pour CustomSync

Ce script permet de tester différents aspects de l'application :
- Système de style
- Composants individuels
- Modules complets

Usage:
  python tests/run_tests.py               # Exécute tous les tests
  python tests/run_tests.py style         # Teste uniquement le système de style
  python tests/run_tests.py components    # Teste uniquement les composants
  python tests/run_tests.py component:Button # Teste un composant spécifique
"""

import os
import sys
import glob
import argparse
import importlib.util
from pathlib import Path
from enum import Enum, auto
import time

# Vérifier l'environnement Python
REQUIRED_PYTHON_VERSION = (3, 6)
if sys.version_info < REQUIRED_PYTHON_VERSION:
    print(f"❌ Python {REQUIRED_PYTHON_VERSION[0]}.{REQUIRED_PYTHON_VERSION[1]} ou supérieur est requis")
    sys.exit(1)

# Vérifier les dépendances
try:
    from PySide6.QtCore import QUrl, QTimer, QObject, Signal, Property, Slot, Qt
    from PySide6.QtGui import QGuiApplication
    from PySide6.QtQml import QQmlApplicationEngine, QQmlComponent
except ImportError:
    print("❌ PySide6 n'est pas installé. Veuillez l'installer avec 'pip install PySide6'")
    sys.exit(1)

# Classe pour gérer les résultats de test
class TestResult:
    class Status(Enum):
        PASS = auto()
        FAIL = auto()
        ERROR = auto()
        SKIP = auto()
    
    def __init__(self, name, status, message=""):
        self.name = name
        self.status = status
        self.message = message
        self.timestamp = time.time()
    
    def __str__(self):
        status_str = {
            self.Status.PASS: "✅ PASS",
            self.Status.FAIL: "❌ FAIL",
            self.Status.ERROR: "💥 ERROR",
            self.Status.SKIP: "⏭️ SKIP"
        }[self.status]
        
        return f"{status_str}: {self.name}" + (f" - {self.message}" if self.message else "")

# Classe pour collecter les résultats de test QML
class TestCollector(QObject):
    testCompleted = Signal(str, bool, str)
    allTestsCompleted = Signal()
    
    def __init__(self):
        super().__init__()
        self.results = []
    
    @Slot(str, bool, str)
    def recordTest(self, name, passed, message=""):
        status = TestResult.Status.PASS if passed else TestResult.Status.FAIL
        result = TestResult(name, status, message)
        self.results.append(result)
        self.testCompleted.emit(name, passed, message)

    @Slot()
    def testsCompleted(self):
        self.allTestsCompleted.emit()

# Configuration du projet
class ProjectConfig:
    def __init__(self):
        # Déterminer le répertoire du projet
        self.project_dir = Path(os.getcwd())
        self.tests_dir = self.project_dir / "tests"
        self.src_dir = self.project_dir / "src"
        self.style_dir = self.src_dir / "style"
        self.components_dir = self.src_dir / "components"
        
        # Créer les répertoires de test s'ils n'existent pas
        self.tests_style_dir = self.tests_dir / "style"
        self.tests_components_dir = self.tests_dir / "components"
        self.tests_data_dir = self.tests_dir / "data"
        
        for directory in [self.tests_dir, self.tests_style_dir, 
                         self.tests_components_dir, self.tests_data_dir]:
            directory.mkdir(exist_ok=True, parents=True)

    def validate(self):
        """Vérifie que la configuration du projet est valide."""
        if not self.src_dir.exists():
            print(f"❌ Le répertoire source {self.src_dir} n'existe pas.")
            return False
        
        if not self.style_dir.exists():
            print(f"❌ Le répertoire de style {self.style_dir} n'existe pas.")
            return False
        
        return True

# Classe de base pour tous les testeurs
class Tester:
    def __init__(self, config):
        self.config = config
        self.results = []
    
    def run(self):
        """Méthode à implémenter par les sous-classes."""
        raise NotImplementedError("La méthode run() doit être implémentée par les sous-classes")
    
    def add_result(self, name, status, message=""):
        """Ajoute un résultat de test."""
        self.results.append(TestResult(name, status, message))
    
    def print_results(self):
        """Affiche les résultats des tests."""
        for result in self.results:
            print(result)
        
        # Statistiques
        total = len(self.results)
        if total == 0:
            print("⚠️ Aucun test n'a été exécuté.")
            return False
        
        passed = sum(1 for r in self.results if r.status == TestResult.Status.PASS)
        
        print(f"\nRésultats: {passed}/{total} tests réussis ({passed/total*100:.0f}%)")
        
        return passed == total

# Application QML partagée pour tous les tests
class SharedQmlApp:
    _instance = None
    
    @staticmethod
    def get_instance():
        if SharedQmlApp._instance is None:
            # Créer l'instance unique
            SharedQmlApp._instance = SharedQmlApp()
        return SharedQmlApp._instance
    
    def __init__(self):
        # Créer l'application Qt
        self.app = QGuiApplication.instance() or QGuiApplication(sys.argv)
        self.app.setOrganizationName("CustomSync")
        self.app.setOrganizationDomain("customsync.org")
        self.app.setApplicationName("CustomSync")
        
        # Créer le moteur QML
        self.engine = QQmlApplicationEngine()
    
    def run_test(self, test_file, collector=None):
        """Exécute un test QML et retourne True si le test a réussi."""
        # Réinitialiser le moteur
        self.engine = QQmlApplicationEngine()
        
        # Ajouter les chemins d'importation
        project_dir = Path(os.getcwd())
        self.engine.addImportPath(str(project_dir))
        
        # Si un collecteur est fourni, connecter les signaux
        if collector:
            # Le contexte n'est pas encore disponible, on doit attendre le chargement
            pass
        
        # Charger le fichier QML
        self.engine.load(QUrl.fromLocalFile(str(test_file)))
        
        # Vérifier si le chargement a réussi
        if not self.engine.rootObjects():
            print(f"❌ Le fichier QML {test_file} n'a pas pu être chargé.")
            return False
        
        # Si un collecteur est fourni, connecter les signaux
        if collector:
            root = self.engine.rootObjects()[0]
            root.testCompleted.connect(collector.recordTest)
            root.allTestsCompleted.connect(collector.testsCompleted)
            
            # Définir un timeout pour l'application
            QTimer.singleShot(5000, self.app.quit)
            
            # Traiter les événements jusqu'à ce que tous les tests soient terminés
            collector.allTestsCompleted.connect(self.app.quit)
        
        # Exécuter l'application
        self.app.exec()
        
        return True
    
    def cleanup(self):
        """Nettoie les ressources de l'application."""
        self.engine.deleteLater()
        # Ne pas quitter l'application, elle doit rester active pour les autres tests

# Testeur pour le système de style
class StyleTester(Tester):
    def __init__(self, config):
        super().__init__(config)
        
        # Modules de style à tester
        self.style_modules = [
            "ColorPalette", 
            "Typography", 
            "Spacing", 
            "Elevation", 
            "Radius", 
            "Animations", 
            "Theme"
        ]
    
    def validate_modules(self):
        """Vérifie que tous les modules de style existent."""
        print("\nVérification des modules de style:")
        
        all_modules_exist = True
        for module in self.style_modules:
            module_path = self.config.style_dir / f"{module}.qml"
            exists = module_path.exists()
            
            status = TestResult.Status.PASS if exists else TestResult.Status.FAIL
            self.add_result(f"Module {module} existe", status)
            
            print(f"  - {module}: {'✅' if exists else '❌'}")
            if not exists:
                all_modules_exist = False
        
        return all_modules_exist
    
    def create_test_file(self):
        """Crée un fichier QML pour tester les modules de style."""
        test_file = self.config.tests_dir / "temp_style_test.qml"
        
        test_content = """
import QtQuick 6.5
import "../src/style" as Style

Rectangle {
    id: testRoot
    width: 400
    height: 300
    color: "white"
    
    // Signal pour communiquer avec Python
    signal testCompleted(string name, bool passed, string message)
    signal allTestsCompleted()
    
    // Tests status
    property var testResults: ({})
    
    Timer {
        interval: 500  // Attendre 500ms pour être sûr que tout est chargé
        running: true
        onTriggered: {
            runTests();
        }
    }
    
    function runTests() {
        try {
            testColorPalette();
            testTypography();
            testSpacing();
            testElevation();
            testRadius();
            testAnimations();
            testTheme();
            
            // Tous les tests sont terminés
            testRoot.allTestsCompleted();
            
        } catch (e) {
            console.error("ERREUR DURANT LES TESTS:", e);
            testRoot.testCompleted("Tests Style", false, "Exception: " + e);
            testRoot.allTestsCompleted();
        }
    }
    
    function testColorPalette() {
        try {
            var bgColor = Style.ColorPalette.backgroundPrimary;
            var txtColor = Style.ColorPalette.textPrimary;
            var accent = Style.ColorPalette.accent;
            
            // Tester une fonction utilitaire
            var transparentColor = Style.ColorPalette.withOpacity(accent, 0.5);
            
            testRoot.testCompleted("ColorPalette", true, "");
            testResults["ColorPalette"] = true;
        } catch (e) {
            testRoot.testCompleted("ColorPalette", false, e.toString());
            testResults["ColorPalette"] = false;
        }
    }
    
    function testTypography() {
        try {
            var fontFamily = Style.Typography.fontFamily;
            var fontSize = Style.Typography.fontSizeBody;
            var fontWeight = Style.Typography.fontWeightRegular;
            
            testRoot.testCompleted("Typography", true, "");
            testResults["Typography"] = true;
        } catch (e) {
            testRoot.testCompleted("Typography", false, e.toString());
            testResults["Typography"] = false;
        }
    }
    
    function testSpacing() {
        try {
            var spacing = Style.Spacing.m;
            var unit = Style.Spacing.unit;
            
            // Tester une fonction utilitaire
            var value = Style.Spacing.multiply(2);
            if (value !== unit * 2) {
                throw new Error("Spacing.multiply returned unexpected value");
            }
            
            testRoot.testCompleted("Spacing", true, "");
            testResults["Spacing"] = true;
        } catch (e) {
            testRoot.testCompleted("Spacing", false, e.toString());
            testResults["Spacing"] = false;
        }
    }
    
    function testElevation() {
        try {
            var shadow = Style.Elevation.shadowMedium;
            if (!shadow.hasOwnProperty("horizontalOffset") || 
                !shadow.hasOwnProperty("verticalOffset") ||
                !shadow.hasOwnProperty("radius") ||
                !shadow.hasOwnProperty("samples") ||
                !shadow.hasOwnProperty("color")) {
                throw new Error("Elevation.shadowMedium missing required properties");
            }
            
            testRoot.testCompleted("Elevation", true, "");
            testResults["Elevation"] = true;
        } catch (e) {
            testRoot.testCompleted("Elevation", false, e.toString());
            testResults["Elevation"] = false;
        }
    }
    
    function testRadius() {
        try {
            var radius = Style.Radius.m;
            
            // Test de comparaison
            if (Style.Radius.s >= Style.Radius.m || Style.Radius.m >= Style.Radius.l) {
                throw new Error("Radius values are not in ascending order");
            }
            
            testRoot.testCompleted("Radius", true, "");
            testResults["Radius"] = true;
        } catch (e) {
            testRoot.testCompleted("Radius", false, e.toString());
            testResults["Radius"] = false;
        }
    }
    
    function testAnimations() {
        try {
            var duration = Style.Animations.durationStandard;
            var easing = Style.Animations.easeOut;
            
            // Test de comparaison
            if (Style.Animations.durationFast >= Style.Animations.durationStandard || 
                Style.Animations.durationStandard >= Style.Animations.durationEmphasis) {
                throw new Error("Duration values are not in ascending order");
            }
            
            testRoot.testCompleted("Animations", true, "");
            testResults["Animations"] = true;
        } catch (e) {
            testRoot.testCompleted("Animations", false, e.toString());
            testResults["Animations"] = false;
        }
    }
    
    function testTheme() {
        try {
            var isDark = Style.Theme.isDarkTheme;
            var colors = Style.Theme.colors;
            
            // Vérifier que colors a les propriétés essentielles
            if (!colors.hasOwnProperty("backgroundPrimary") || 
                !colors.hasOwnProperty("textPrimary") ||
                !colors.hasOwnProperty("accent")) {
                throw new Error("Theme.colors missing required properties");
            }
            
            testRoot.testCompleted("Theme", true, "");
            testResults["Theme"] = true;
        } catch (e) {
            testRoot.testCompleted("Theme", false, e.toString());
            testResults["Theme"] = false;
        }
    }
}
"""
        
        with open(test_file, "w") as f:
            f.write(test_content)
        
        return test_file
    
    def run(self):
        """Exécute les tests pour le système de style."""
        print("\n=== Tests du système de style ===")
        
        # Vérifier que tous les modules existent
        if not self.validate_modules():
            print("❌ Certains modules de style sont manquants.")
            return False
        
        # Créer le fichier de test
        test_file = self.create_test_file()
        
        try:
            # Obtenir l'instance partagée
            qml_app = SharedQmlApp.get_instance()
            
            # Créer le collecteur de tests
            collector = TestCollector()
            
            # Connecter les signaux
            collector.testCompleted.connect(lambda name, passed, msg: 
                print(f"  {'✅' if passed else '❌'} {name}{': ' + msg if msg and msg.strip() else ''}"))
            
            # Exécuter le test
            qml_app.run_test(test_file, collector)
            
            # Récupérer les résultats
            for result in collector.results:
                self.add_result(result.name, result.status, result.message)
            
        except Exception as e:
            print(f"❌ ERREUR: {e}")
            self.add_result("Tests style", TestResult.Status.ERROR, str(e))
            return False
        
        finally:
            # Nettoyer le fichier temporaire
            if test_file.exists():
                test_file.unlink()
        
        return self.print_results()

# Testeur pour les composants
class ComponentTester(Tester):
    def __init__(self, config, component_name=None):
        super().__init__(config)
        self.component_name = component_name
    
    def get_components_to_test(self):
        """Retourne la liste des composants à tester."""
        if self.component_name:
            # Tester un composant spécifique
            component_paths = list(self.config.components_dir.glob(f"**/{self.component_name}.qml"))
            if not component_paths:
                print(f"❌ Composant '{self.component_name}' introuvable.")
                return []
            return component_paths
        else:
            # Tester tous les composants principaux (pas les sous-composants)
            # On suppose que les composants principaux sont directement dans le répertoire components
            # et que les sous-composants sont dans des sous-répertoires
            return list(self.config.components_dir.glob("*.qml"))
    
    def create_test_for_component(self, component_path):
        """Crée un test pour un composant spécifique."""
        # Obtenir le nom du composant sans extension
        component_name = component_path.stem
        
        # Déterminer le chemin d'import relatif
        relative_path = component_path.relative_to(self.config.project_dir)
        import_path = str(relative_path.parent).replace('\\', '/')
        
        # Créer le fichier de test pour ce composant
        test_file = self.config.tests_dir / f"temp_{component_name}_test.qml"
        
        test_content = f"""
import QtQuick 6.5
import "../src/style" as Style
import "../{import_path}" 

Rectangle {{
    id: testRoot
    width: 400
    height: 300
    color: "white"
    
    // Signal pour communiquer avec Python
    signal testCompleted(string name, bool passed, string message)
    signal allTestsCompleted()
    
    Timer {{
        interval: 500
        running: true
        onTriggered: {{
            runTests();
        }}
    }}
    
    function runTests() {{
        try {{
            // Tester que le composant peut être créé
            var component = Qt.createComponent("../{relative_path}");
            
            if (component.status === Component.Ready) {{
                // Le composant a été chargé avec succès
                var object = component.createObject(testRoot);
                
                if (object) {{
                    // Le composant a été instancié avec succès
                    testRoot.testCompleted("{component_name}", true, "Composant chargé et instancié avec succès");
                    
                    // Nettoyer l'objet créé
                    object.destroy();
                }} else {{
                    testRoot.testCompleted("{component_name}", false, "Impossible d'instancier le composant: " + component.errorString());
                }}
            }} else {{
                testRoot.testCompleted("{component_name}", false, "Impossible de charger le composant: " + component.errorString());
            }}
            
        }} catch (e) {{
            testRoot.testCompleted("{component_name}", false, "Exception: " + e);
        }}
        
        // Tous les tests sont terminés
        testRoot.allTestsCompleted();
    }}
}}
"""
        
        with open(test_file, "w") as f:
            f.write(test_content)
        
        return test_file
    
    def run(self):
        """Exécute les tests pour les composants."""
        components = self.get_components_to_test()
        
        if not components:
            print("❌ Aucun composant à tester.")
            return False
        
        print(f"\n=== Tests de {len(components)} composants ===")
        
        all_successful = True
        
        # Obtenir l'instance partagée
        qml_app = SharedQmlApp.get_instance()
        
        for component_path in components:
            component_name = component_path.stem
            print(f"\nTest du composant: {component_name}")
            
            # Créer le fichier de test pour ce composant
            test_file = self.create_test_for_component(component_path)
            
            try:
                # Créer le collecteur de tests
                collector = TestCollector()
                
                # Connecter les signaux
                collector.testCompleted.connect(lambda name, passed, msg: 
                    print(f"  {'✅' if passed else '❌'} {name}{': ' + msg if msg else ''}"))
                
                # Exécuter le test
                qml_app.run_test(test_file, collector)
                
                # Récupérer les résultats
                for result in collector.results:
                    self.add_result(result.name, result.status, result.message)
                    if result.status != TestResult.Status.PASS:
                        all_successful = False
                
            except Exception as e:
                print(f"❌ ERREUR pour {component_name}: {e}")
                self.add_result(component_name, TestResult.Status.ERROR, str(e))
                all_successful = False
            
            finally:
                # Nettoyer le fichier temporaire
                if test_file.exists():
                    test_file.unlink()
        
        return self.print_results() and all_successful

def main():
    # Analyser les arguments
    parser = argparse.ArgumentParser(description="Framework de test pour CustomSync")
    parser.add_argument("target", nargs="?", default="all", 
                        help="Cible des tests (all, style, components, component:Name)")
    
    args = parser.parse_args()
    
    # Initialiser la configuration du projet
    config = ProjectConfig()
    
    if not config.validate():
        print("❌ La configuration du projet est invalide.")
        return 1
    
    success = True
    
    # Déterminer ce qu'il faut tester
    if args.target == "all" or args.target == "style":
        # Tester le système de style
        style_tester = StyleTester(config)
        style_success = style_tester.run()
        success = success and style_success
    
    if args.target == "all" or args.target == "components" or args.target.startswith("component:"):
        # Tester les composants
        component_name = None
        if args.target.startswith("component:"):
            component_name = args.target.split(":")[1]
        
        component_tester = ComponentTester(config, component_name)
        component_success = component_tester.run()
        success = success and component_success
    
    # Afficher le résultat global
    if success:
        print("\n✅ TOUS LES TESTS ONT RÉUSSI")
    else:
        print("\n❌ CERTAINS TESTS ONT ÉCHOUÉ")
    
    return 0 if success else 1

if __name__ == "__main__":
    sys.exit(main())